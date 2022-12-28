Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB58657C9F
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233846AbiL1Pe2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:34:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233856AbiL1Pe1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:34:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD3F1649B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:34:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF7D2B81710
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:34:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 206B8C433EF;
        Wed, 28 Dec 2022 15:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241663;
        bh=3SoTL61kE5Bpg9br4zxMudE56UITQE72/CZf9FpPBYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DirpRTwKGSeM5YtSsnzSA8FL/RY55G3JZ3ja3hGHVxbIHjYcqF2KpNnjKnQosEmaZ
         urxVSYGdMD8Q6vfCIlL8qwDp+H2ijvhVyWiMz9gUdJ0YhzZRvAg5NdqeFvYOQRtND+
         rcjWfe5GXtYD4xcBb9kHjfX6fmxkO1MRkz6N1Y9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Avraham Stern <avraham.stern@intel.com>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0313/1073] wifi: iwlwifi: mei: avoid blocking sap messages handling due to rtnl lock
Date:   Wed, 28 Dec 2022 15:31:41 +0100
Message-Id: <20221228144336.509213862@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Avraham Stern <avraham.stern@intel.com>

[ Upstream commit d288067ede4b375e72daf7f9a98d937ede11a311 ]

The AMT_STATE sap message handler tries to take the rtnl lock.
This means that in case the rtnl lock is already taken, sap messages
will not be processed.
When an interface is brought up, the host requests ownership from
csme. However, since the rtnl lock is already held, if there is a
pending amt state message, the host will not be able to read the
ownership confirm message because the amt state message handler
is pending. As a result, the host fails to get ownership although
csme granted it.
Fix it by moving the part that needs the rtnl lock into a dedicated
worker, so handling sap messages can continue.

Fixes: 2da4366f9e2c ("iwlwifi: mei: add the driver to allow cooperation with CSME")
Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20221030191011.8599f2b4e9dd.I518f79e9099bf815c5f8d90235b4ce3250f59970@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mei/main.c | 57 ++++++++++++-------
 1 file changed, 37 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mei/main.c b/drivers/net/wireless/intel/iwlwifi/mei/main.c
index 64a637ef199c..c0142093c768 100644
--- a/drivers/net/wireless/intel/iwlwifi/mei/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/mei/main.c
@@ -152,6 +152,8 @@ struct iwl_mei_filters {
  * @csa_throttle_end_wk: used when &csa_throttled is true
  * @data_q_lock: protects the access to the data queues which are
  *	accessed without the mutex.
+ * @netdev_work: used to defer registering and unregistering of the netdev to
+ *	avoid taking the rtnl lock in the SAP messages handlers.
  * @sap_seq_no: the sequence number for the SAP messages
  * @seq_no: the sequence number for the SAP messages
  * @dbgfs_dir: the debugfs dir entry
@@ -172,6 +174,7 @@ struct iwl_mei {
 	bool device_down;
 	struct delayed_work csa_throttle_end_wk;
 	spinlock_t data_q_lock;
+	struct work_struct netdev_work;
 
 	atomic_t sap_seq_no;
 	atomic_t seq_no;
@@ -591,6 +594,33 @@ static rx_handler_result_t iwl_mei_rx_handler(struct sk_buff **pskb)
 	return res;
 }
 
+static void iwl_mei_netdev_work(struct work_struct *wk)
+{
+	struct iwl_mei *mei =
+		container_of(wk, struct iwl_mei, netdev_work);
+	struct net_device *netdev;
+
+	/*
+	 * First take rtnl and only then the mutex to avoid an ABBA
+	 * with iwl_mei_set_netdev()
+	 */
+	rtnl_lock();
+	mutex_lock(&iwl_mei_mutex);
+
+	netdev = rcu_dereference_protected(iwl_mei_cache.netdev,
+					   lockdep_is_held(&iwl_mei_mutex));
+	if (netdev) {
+		if (mei->amt_enabled)
+			netdev_rx_handler_register(netdev, iwl_mei_rx_handler,
+						   mei);
+		else
+			netdev_rx_handler_unregister(netdev);
+	}
+
+	mutex_unlock(&iwl_mei_mutex);
+	rtnl_unlock();
+}
+
 static void
 iwl_mei_handle_rx_start_ok(struct mei_cl_device *cldev,
 			   const struct iwl_sap_me_msg_start_ok *rsp,
@@ -743,38 +773,23 @@ static void iwl_mei_handle_amt_state(struct mei_cl_device *cldev,
 				     const struct iwl_sap_msg_dw *dw)
 {
 	struct iwl_mei *mei = mei_cldev_get_drvdata(cldev);
-	struct net_device *netdev;
 
-	/*
-	 * First take rtnl and only then the mutex to avoid an ABBA
-	 * with iwl_mei_set_netdev()
-	 */
-	rtnl_lock();
 	mutex_lock(&iwl_mei_mutex);
 
-	netdev = rcu_dereference_protected(iwl_mei_cache.netdev,
-					   lockdep_is_held(&iwl_mei_mutex));
-
 	if (mei->amt_enabled == !!le32_to_cpu(dw->val))
 		goto out;
 
 	mei->amt_enabled = dw->val;
 
-	if (mei->amt_enabled) {
-		if (netdev)
-			netdev_rx_handler_register(netdev, iwl_mei_rx_handler, mei);
-
+	if (mei->amt_enabled)
 		iwl_mei_set_init_conf(mei);
-	} else {
-		if (iwl_mei_cache.ops)
-			iwl_mei_cache.ops->rfkill(iwl_mei_cache.priv, false);
-		if (netdev)
-			netdev_rx_handler_unregister(netdev);
-	}
+	else if (iwl_mei_cache.ops)
+		iwl_mei_cache.ops->rfkill(iwl_mei_cache.priv, false, false);
+
+	schedule_work(&mei->netdev_work);
 
 out:
 	mutex_unlock(&iwl_mei_mutex);
-	rtnl_unlock();
 }
 
 static void iwl_mei_handle_nic_owner(struct mei_cl_device *cldev,
@@ -1827,6 +1842,7 @@ static int iwl_mei_probe(struct mei_cl_device *cldev,
 			  iwl_mei_csa_throttle_end_wk);
 	init_waitqueue_head(&mei->get_ownership_wq);
 	spin_lock_init(&mei->data_q_lock);
+	INIT_WORK(&mei->netdev_work, iwl_mei_netdev_work);
 
 	mei_cldev_set_drvdata(cldev, mei);
 	mei->cldev = cldev;
@@ -1989,6 +2005,7 @@ static void iwl_mei_remove(struct mei_cl_device *cldev)
 	 */
 	cancel_work_sync(&mei->send_csa_msg_wk);
 	cancel_delayed_work_sync(&mei->csa_throttle_end_wk);
+	cancel_work_sync(&mei->netdev_work);
 
 	/*
 	 * If someone waits for the ownership, let him know that we are going
-- 
2.35.1



