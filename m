Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0DAE6AE94C
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbjCGRWs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:22:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbjCGRWY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:22:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E622386A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:17:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53EDA61505
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:17:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B867C433D2;
        Tue,  7 Mar 2023 17:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209469;
        bh=OkEdYZYJeKxMTb4WHS+73ZwIwCTd68/c70t3CD3EedM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sOqF588prvoXBfUQHWXln7V+NtDvLhXxi+htPgHpwjhMsR3QRgcyO3NCuF2RUWlm8
         fOG0IZ6aDeEb9Pn1Bm3mnNS1MD4kIeHZ0WB+h6h8khiu6nDhBcySU1wCqFlLc21cH1
         OvAi1WbgHZ26vufYKQgr8a9Dr6SaAj1B3yb8Dfeg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Gregory Greenman <gregory.greenman@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0230/1001] wifi: iwlwifi: mei: fix compilation errors in rfkill()
Date:   Tue,  7 Mar 2023 17:50:02 +0100
Message-Id: <20230307170031.838342143@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gregory Greenman <gregory.greenman@intel.com>

[ Upstream commit 9cbd5a8abca904441e36861e3a92961bec41d13f ]

The rfkill() callback was invoked with wrong parameters.
It was missed since MEI is defined now as depending on BROKEN.
Fix that.

Fixes: d288067ede4b ("wifi: iwlwifi: mei: avoid blocking sap messages handling due to rtnl lock")
Fixes: 5aa7ce31bd84 ("wifi: iwlwifi: mei: make sure ownership confirmed message is sent")
Fixes: 95170a46b7dd ("wifi: iwlwifi: mei: don't send SAP commands if AMT is disabled")
Link: https://lore.kernel.org/r/20230126222821.305122-2-gregory.greenman@intel.com
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mei/main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mei/main.c b/drivers/net/wireless/intel/iwlwifi/mei/main.c
index f9d11935ed97e..67dfb77fedf79 100644
--- a/drivers/net/wireless/intel/iwlwifi/mei/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/mei/main.c
@@ -788,7 +788,7 @@ static void iwl_mei_handle_amt_state(struct mei_cl_device *cldev,
 	if (mei->amt_enabled)
 		iwl_mei_set_init_conf(mei);
 	else if (iwl_mei_cache.ops)
-		iwl_mei_cache.ops->rfkill(iwl_mei_cache.priv, false, false);
+		iwl_mei_cache.ops->rfkill(iwl_mei_cache.priv, false);
 
 	schedule_work(&mei->netdev_work);
 
@@ -829,7 +829,7 @@ static void iwl_mei_handle_csme_taking_ownership(struct mei_cl_device *cldev,
 		 */
 		mei->csme_taking_ownership = true;
 
-		iwl_mei_cache.ops->rfkill(iwl_mei_cache.priv, true, true);
+		iwl_mei_cache.ops->rfkill(iwl_mei_cache.priv, true);
 	} else {
 		iwl_mei_send_sap_msg(cldev,
 				     SAP_MSG_NOTIF_CSME_OWNERSHIP_CONFIRMED);
@@ -1774,7 +1774,7 @@ int iwl_mei_register(void *priv, const struct iwl_mei_ops *ops)
 			if (mei->amt_enabled)
 				iwl_mei_send_sap_msg(mei->cldev,
 						     SAP_MSG_NOTIF_WIFIDR_UP);
-			ops->rfkill(priv, mei->link_prot_state, false);
+			ops->rfkill(priv, mei->link_prot_state);
 		}
 	}
 	ret = 0;
-- 
2.39.2



