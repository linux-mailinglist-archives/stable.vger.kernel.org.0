Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61BED657D35
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233121AbiL1Pkj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:40:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233947AbiL1Pki (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:40:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2896B167DF
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:40:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9A2B6155B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:40:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C94ABC433D2;
        Wed, 28 Dec 2022 15:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242036;
        bh=550wISVG9axr0lZNqW0XQ3ZQH7N9ri55apbUMHrcx3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rc/GUUeLs/BIRDDy0StuFvgzUnQpW3oTiNju7UzYqumMC5yb+jlTUx88hnwU1MUk9
         HZ0Qvt4CDmARhqs3CGQdMjD0UK3H3rAdG+/0ixa3XLGgzG7AattyySpn0kD63kSHyx
         Dth/CtCtCvEx4/2fR4SAyPfiK6TiAIIshYwYkD54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Avraham Stern <avraham.stern@intel.com>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0318/1146] wifi: iwlwifi: mei: make sure ownership confirmed message is sent
Date:   Wed, 28 Dec 2022 15:30:57 +0100
Message-Id: <20221228144338.791497331@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

[ Upstream commit 5aa7ce31bd84c2f4f059200f06c537c920cbb458 ]

It is possible that CSME will try to take ownership while the driver
is stopping. In this case, if the CSME takes ownership message arrives
after the driver started unregistering, the iwl_mei_cache->ops is
already invalid, so the host will not answer with the ownership
confirmed message.
Similarly, if the take ownership message arrived after the mac was
stopped or when iwl_mvm_up() failed, setting rfkill will not trigger
sending the confirm message. As a result, CSME will not take
ownership, which will result in a disconnection.

Fix it by sending the ownership confirmed message immediately in such
cases.

Fixes: 2da4366f9e2c ("iwlwifi: mei: add the driver to allow cooperation with CSME")
Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20221030191011.b2a4c009e3e6.I7f931b7ee8b168e8ac88b11f23bff98b7ed3cb19@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/mei/iwl-mei.h  |  7 +++--
 drivers/net/wireless/intel/iwlwifi/mei/main.c | 30 ++++++++++++-------
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   |  2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  4 +--
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  2 +-
 5 files changed, 29 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mei/iwl-mei.h b/drivers/net/wireless/intel/iwlwifi/mei/iwl-mei.h
index 67122cfa2292..5409699c9a1f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mei/iwl-mei.h
+++ b/drivers/net/wireless/intel/iwlwifi/mei/iwl-mei.h
@@ -446,9 +446,10 @@ void iwl_mei_host_associated(const struct iwl_mei_conn_info *conn_info,
 void iwl_mei_host_disassociated(void);
 
 /**
- * iwl_mei_device_down() - must be called when the device is down
+ * iwl_mei_device_state() - must be called when the device changes up/down state
+ * @up: true if the device is up, false otherwise.
  */
-void iwl_mei_device_down(void);
+void iwl_mei_device_state(bool up);
 
 #else
 
@@ -497,7 +498,7 @@ static inline void iwl_mei_host_associated(const struct iwl_mei_conn_info *conn_
 static inline void iwl_mei_host_disassociated(void)
 {}
 
-static inline void iwl_mei_device_down(void)
+static inline void iwl_mei_device_state(bool up)
 {}
 
 #endif /* CONFIG_IWLMEI */
diff --git a/drivers/net/wireless/intel/iwlwifi/mei/main.c b/drivers/net/wireless/intel/iwlwifi/mei/main.c
index 357f14626cf4..90646c54a3c5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mei/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/mei/main.c
@@ -147,6 +147,8 @@ struct iwl_mei_filters {
  *	to send CSME_OWNERSHIP_CONFIRMED when the driver completes its down
  *	flow.
  * @link_prot_state: true when we are in link protection PASSIVE
+ * @device_down: true if the device is down. Used to remember to send
+ *	CSME_OWNERSHIP_CONFIRMED when the driver is already down.
  * @csa_throttle_end_wk: used when &csa_throttled is true
  * @data_q_lock: protects the access to the data queues which are
  *	accessed without the mutex.
@@ -167,6 +169,7 @@ struct iwl_mei {
 	bool csa_throttled;
 	bool csme_taking_ownership;
 	bool link_prot_state;
+	bool device_down;
 	struct delayed_work csa_throttle_end_wk;
 	spinlock_t data_q_lock;
 
@@ -798,14 +801,18 @@ static void iwl_mei_handle_csme_taking_ownership(struct mei_cl_device *cldev,
 
 	mei->got_ownership = false;
 
-	/*
-	 * Remember to send CSME_OWNERSHIP_CONFIRMED when the wifi driver
-	 * is finished taking the device down.
-	 */
-	mei->csme_taking_ownership = true;
+	if (iwl_mei_cache.ops && !mei->device_down) {
+		/*
+		 * Remember to send CSME_OWNERSHIP_CONFIRMED when the wifi
+		 * driver is finished taking the device down.
+		 */
+		mei->csme_taking_ownership = true;
 
-	if (iwl_mei_cache.ops)
-		iwl_mei_cache.ops->rfkill(iwl_mei_cache.priv, true);
+		iwl_mei_cache.ops->rfkill(iwl_mei_cache.priv, true, true);
+	} else {
+		iwl_mei_send_sap_msg(cldev,
+				     SAP_MSG_NOTIF_CSME_OWNERSHIP_CONFIRMED);
+	}
 }
 
 static void iwl_mei_handle_nvm(struct mei_cl_device *cldev,
@@ -1616,7 +1623,7 @@ void iwl_mei_set_netdev(struct net_device *netdev)
 }
 EXPORT_SYMBOL_GPL(iwl_mei_set_netdev);
 
-void iwl_mei_device_down(void)
+void iwl_mei_device_state(bool up)
 {
 	struct iwl_mei *mei;
 
@@ -1630,7 +1637,9 @@ void iwl_mei_device_down(void)
 	if (!mei)
 		goto out;
 
-	if (!mei->csme_taking_ownership)
+	mei->device_down = !up;
+
+	if (up || !mei->csme_taking_ownership)
 		goto out;
 
 	iwl_mei_send_sap_msg(mei->cldev,
@@ -1639,7 +1648,7 @@ void iwl_mei_device_down(void)
 out:
 	mutex_unlock(&iwl_mei_mutex);
 }
-EXPORT_SYMBOL_GPL(iwl_mei_device_down);
+EXPORT_SYMBOL_GPL(iwl_mei_device_state);
 
 int iwl_mei_register(void *priv, const struct iwl_mei_ops *ops)
 {
@@ -1821,6 +1830,7 @@ static int iwl_mei_probe(struct mei_cl_device *cldev,
 
 	mei_cldev_set_drvdata(cldev, mei);
 	mei->cldev = cldev;
+	mei->device_down = true;
 
 	do {
 		ret = iwl_mei_alloc_shared_mem(cldev);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index f041e77af059..5de34edc51fe 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1665,6 +1665,8 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 			iwl_rfi_send_config_cmd(mvm, NULL);
 	}
 
+	iwl_mvm_mei_device_state(mvm, true);
+
 	IWL_DEBUG_INFO(mvm, "RT uCode started.\n");
 	return 0;
  error:
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 97cba526e465..1ccb3cad7cdc 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -2201,10 +2201,10 @@ static inline void iwl_mvm_mei_host_disassociated(struct iwl_mvm *mvm)
 		iwl_mei_host_disassociated();
 }
 
-static inline void iwl_mvm_mei_device_down(struct iwl_mvm *mvm)
+static inline void iwl_mvm_mei_device_state(struct iwl_mvm *mvm, bool up)
 {
 	if (mvm->mei_registered)
-		iwl_mei_device_down();
+		iwl_mei_device_state(up);
 }
 
 static inline void iwl_mvm_mei_set_sw_rfkill_state(struct iwl_mvm *mvm)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index d2d42cd48af2..5b8e9a06f6d4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1375,7 +1375,7 @@ void iwl_mvm_stop_device(struct iwl_mvm *mvm)
 	iwl_trans_stop_device(mvm->trans);
 	iwl_free_fw_paging(&mvm->fwrt);
 	iwl_fw_dump_conf_clear(&mvm->fwrt);
-	iwl_mvm_mei_device_down(mvm);
+	iwl_mvm_mei_device_state(mvm, false);
 }
 
 static void iwl_op_mode_mvm_stop(struct iwl_op_mode *op_mode)
-- 
2.35.1



