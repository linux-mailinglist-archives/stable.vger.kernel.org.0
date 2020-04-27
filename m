Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3AD1BA953
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 17:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728135AbgD0Pxh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Apr 2020 11:53:37 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:38213 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727905AbgD0Pxg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Apr 2020 11:53:36 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id A1508194037F;
        Mon, 27 Apr 2020 11:53:35 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 27 Apr 2020 11:53:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=EMIGNf
        VK5f2/+ociDoOMkcObcNXJgIVakYT6k+Nvj6A=; b=x1FLfKQgT1oA6ScfgY6yA3
        001YDX+kFU3rzxmft3LAyHlRfa/joqH6Kp7wBlUp+HakrBS5MQtgZjZFM/8n2FKi
        xBRMuSlRx+tnmEMVB89TbR4VVIA6A6lJKXt3C73/ne7FqQZmx2ENgJIshnqvNgUR
        x1aDHeYWiAWo9lpz8rZc+SPgNsyo0a9S2+YkMKJ0lZurelEAQAYxtJETkUfvbHcr
        F9Bo/trFKcE9kqxliKtJk+L0NgS5yyeLnGRYRskeZfapP7mZZjnOo9eXCHeOvx4V
        7zuncld5CMTfEfHVQG7X2afedqyfHeaSWoRQ6mx48b0FZ93pNEXB6ucWD1NFRb2A
        ==
X-ME-Sender: <xms:__-mXvloFZK4PMH_31dhB99wSORIWbgYgIJj2dg2i5hz-_4lHUmqxw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrheelgdelvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:__-mXjLIRQUha4FWS-QDOjHzfCX1n4MqpPyyjbquaRjfpOIbfsl_pg>
    <xmx:__-mXhFKd8RiokLabyKLbBv073gSPFSEaATtiHdKlSIAbP9JCSBOuw>
    <xmx:__-mXiD5LLcvk8s1-qViPUwq_Zg9EI7LzQcM6gfvTFTJJ3Q101Z6-Q>
    <xmx:__-mXtIQf9sxHqrbVItgnSymWkcRoPFEmovvvcmXqqrwbfmmCMvM2A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id BF58E3280060;
        Mon, 27 Apr 2020 11:53:34 -0400 (EDT)
Subject: FAILED: patch "[PATCH] iwlwifi: fix WGDS check when WRDS is disabled" failed to apply to 5.4-stable tree
To:     luciano.coelho@intel.com, kvalo@codeaurora.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 Apr 2020 17:53:31 +0200
Message-ID: <158800281139103@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1edd56e69dca9098e63d8d5815aeb83eeeb10a79 Mon Sep 17 00:00:00 2001
From: Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 17 Apr 2020 13:37:11 +0300
Subject: [PATCH] iwlwifi: fix WGDS check when WRDS is disabled

In the reference BIOS implementation, WRDS can be disabled without
disabling WGDS.  And this happens in most cases where WRDS is
disabled, causing the WGDS without WRDS check and issue an error.

To avoid this issue, we change the check so that we only considered it
an error if the WRDS entry doesn't exist.  If the entry (or the
selected profile is disabled for any other reason), we just silently
ignore WGDS.

Cc: stable@vger.kernel.org # 4.14+
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=205513
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20200417133700.72ad25c3998b.I875d935cefd595ed7f640ddcfc7bc802627d2b7f@changeid

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
index ba2aff3af0fe..e3a33388be70 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
@@ -296,9 +296,14 @@ int iwl_sar_select_profile(struct iwl_fw_runtime *fwrt,
 		if (!prof->enabled) {
 			IWL_DEBUG_RADIO(fwrt, "SAR profile %d is disabled.\n",
 					profs[i]);
-			/* if one of the profiles is disabled, we fail all */
-			return -ENOENT;
+			/*
+			 * if one of the profiles is disabled, we
+			 * ignore all of them and return 1 to
+			 * differentiate disabled from other failures.
+			 */
+			return 1;
 		}
+
 		IWL_DEBUG_INFO(fwrt,
 			       "SAR EWRD: chain %d profile index %d\n",
 			       i, profs[i]);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index a4038f289ab3..e67c452fa92c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -727,6 +727,7 @@ int iwl_mvm_sar_select_profile(struct iwl_mvm *mvm, int prof_a, int prof_b)
 		struct iwl_dev_tx_power_cmd_v4 v4;
 	} cmd;
 
+	int ret;
 	u16 len = 0;
 
 	cmd.v5.v3.set_mode = cpu_to_le32(IWL_TX_POWER_MODE_SET_CHAINS);
@@ -741,9 +742,14 @@ int iwl_mvm_sar_select_profile(struct iwl_mvm *mvm, int prof_a, int prof_b)
 		len = sizeof(cmd.v4.v3);
 
 
-	if (iwl_sar_select_profile(&mvm->fwrt, cmd.v5.v3.per_chain_restriction,
-				   prof_a, prof_b))
-		return -ENOENT;
+	ret = iwl_sar_select_profile(&mvm->fwrt,
+				     cmd.v5.v3.per_chain_restriction,
+				     prof_a, prof_b);
+
+	/* return on error or if the profile is disabled (positive number) */
+	if (ret)
+		return ret;
+
 	IWL_DEBUG_RADIO(mvm, "Sending REDUCE_TX_POWER_CMD per chain\n");
 	return iwl_mvm_send_cmd_pdu(mvm, REDUCE_TX_POWER_CMD, 0, len, &cmd);
 }
@@ -1034,16 +1040,7 @@ static int iwl_mvm_sar_init(struct iwl_mvm *mvm)
 				"EWRD SAR BIOS table invalid or unavailable. (%d)\n",
 				ret);
 
-	ret = iwl_mvm_sar_select_profile(mvm, 1, 1);
-	/*
-	 * If we don't have profile 0 from BIOS, just skip it.  This
-	 * means that SAR Geo will not be enabled either, even if we
-	 * have other valid profiles.
-	 */
-	if (ret == -ENOENT)
-		return 1;
-
-	return ret;
+	return iwl_mvm_sar_select_profile(mvm, 1, 1);
 }
 
 static int iwl_mvm_load_rt_fw(struct iwl_mvm *mvm)
@@ -1272,7 +1269,7 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 	ret = iwl_mvm_sar_init(mvm);
 	if (ret == 0) {
 		ret = iwl_mvm_sar_geo_init(mvm);
-	} else if (ret > 0 && !iwl_sar_get_wgds_table(&mvm->fwrt)) {
+	} else if (ret == -ENOENT && !iwl_sar_get_wgds_table(&mvm->fwrt)) {
 		/*
 		 * If basic SAR is not available, we check for WGDS,
 		 * which should *not* be available either.  If it is

