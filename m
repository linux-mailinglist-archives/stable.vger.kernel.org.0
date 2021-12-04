Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B180E468414
	for <lists+stable@lfdr.de>; Sat,  4 Dec 2021 11:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344243AbhLDKdw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Dec 2021 05:33:52 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51152 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343896AbhLDKdw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Dec 2021 05:33:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6795B80B08
        for <stable@vger.kernel.org>; Sat,  4 Dec 2021 10:30:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24CB0C341C0;
        Sat,  4 Dec 2021 10:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638613824;
        bh=tC7cUe1SkxyUa7BE0MvfVeyrlYifOpkre2T9da/7lhs=;
        h=Subject:To:Cc:From:Date:From;
        b=oSNe6Rpbo2rbuXhS/zzA/1n5HnCj7bOZZ4hWIXk2v9l0fOGGafL4K6pYQXJx91OSu
         /XZsYn2dUZBZjHDMAKCQ56nPSGcAOA5/bWhuAbfNMY3x1dQIFMpn1qqGmyfvqzgRIf
         bSG0jmiDQu55Dlfk5FuIaSQRn0ze0nNQofEMT95Q=
Subject: FAILED: patch "[PATCH] iwlwifi: mvm: retry init flow if failed" failed to apply to 5.10-stable tree
To:     mordechay.goodstein@intel.com, kvalo@codeaurora.org,
        luciano.coelho@intel.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 04 Dec 2021 11:30:22 +0100
Message-ID: <1638613822163102@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5283dd677e52af9db6fe6ad11b2f12220d519d0c Mon Sep 17 00:00:00 2001
From: Mordechay Goodstein <mordechay.goodstein@intel.com>
Date: Wed, 10 Nov 2021 15:01:59 +0200
Subject: [PATCH] iwlwifi: mvm: retry init flow if failed

In some very rare cases the init flow may fail.  In many cases, this is
recoverable, so we can retry.  Implement a loop to retry two more times
after the first attempt failed.

This can happen in two different situations, namely during probe and
during mac80211 start.  For the first case, a simple loop is enough.
For the second case, we need to add a flag to prevent mac80211 from
trying to restart it as well, leaving full control with the driver.

Cc: <stable@vger.kernel.org>
Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20211110150132.57514296ecab.I52a0411774b700bdc7dedb124d8b59bf99456eb2@changeid

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 36196e07b1a0..5cec467b995b 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1313,23 +1313,31 @@ _iwl_op_mode_start(struct iwl_drv *drv, struct iwlwifi_opmode_table *op)
 	const struct iwl_op_mode_ops *ops = op->ops;
 	struct dentry *dbgfs_dir = NULL;
 	struct iwl_op_mode *op_mode = NULL;
+	int retry, max_retry = !!iwlwifi_mod_params.fw_restart * IWL_MAX_INIT_RETRY;
+
+	for (retry = 0; retry <= max_retry; retry++) {
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-	drv->dbgfs_op_mode = debugfs_create_dir(op->name,
-						drv->dbgfs_drv);
-	dbgfs_dir = drv->dbgfs_op_mode;
+		drv->dbgfs_op_mode = debugfs_create_dir(op->name,
+							drv->dbgfs_drv);
+		dbgfs_dir = drv->dbgfs_op_mode;
 #endif
 
-	op_mode = ops->start(drv->trans, drv->trans->cfg, &drv->fw, dbgfs_dir);
+		op_mode = ops->start(drv->trans, drv->trans->cfg,
+				     &drv->fw, dbgfs_dir);
+
+		if (op_mode)
+			return op_mode;
+
+		IWL_ERR(drv, "retry init count %d\n", retry);
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-	if (!op_mode) {
 		debugfs_remove_recursive(drv->dbgfs_op_mode);
 		drv->dbgfs_op_mode = NULL;
-	}
 #endif
+	}
 
-	return op_mode;
+	return NULL;
 }
 
 static void _iwl_op_mode_stop(struct iwl_drv *drv)
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.h b/drivers/net/wireless/intel/iwlwifi/iwl-drv.h
index 2e2d60a58692..0fd009e6d685 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.h
@@ -89,4 +89,7 @@ void iwl_drv_stop(struct iwl_drv *drv);
 #define IWL_EXPORT_SYMBOL(sym)
 #endif
 
+/* max retry for init flow */
+#define IWL_MAX_INIT_RETRY 2
+
 #endif /* __iwl_drv_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 9fb9c7dad314..897e3b91ddb2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -16,6 +16,7 @@
 #include <net/ieee80211_radiotap.h>
 #include <net/tcp.h>
 
+#include "iwl-drv.h"
 #include "iwl-op-mode.h"
 #include "iwl-io.h"
 #include "mvm.h"
@@ -1117,9 +1118,30 @@ static int iwl_mvm_mac_start(struct ieee80211_hw *hw)
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	int ret;
+	int retry, max_retry = 0;
 
 	mutex_lock(&mvm->mutex);
-	ret = __iwl_mvm_mac_start(mvm);
+
+	/* we are starting the mac not in error flow, and restart is enabled */
+	if (!test_bit(IWL_MVM_STATUS_HW_RESTART_REQUESTED, &mvm->status) &&
+	    iwlwifi_mod_params.fw_restart) {
+		max_retry = IWL_MAX_INIT_RETRY;
+		/*
+		 * This will prevent mac80211 recovery flows to trigger during
+		 * init failures
+		 */
+		set_bit(IWL_MVM_STATUS_STARTING, &mvm->status);
+	}
+
+	for (retry = 0; retry <= max_retry; retry++) {
+		ret = __iwl_mvm_mac_start(mvm);
+		if (!ret)
+			break;
+
+		IWL_ERR(mvm, "mac start retry %d\n", retry);
+	}
+	clear_bit(IWL_MVM_STATUS_STARTING, &mvm->status);
+
 	mutex_unlock(&mvm->mutex);
 
 	return ret;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 2b1dcd60e00f..a72d85086fe3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1123,6 +1123,8 @@ struct iwl_mvm {
  * @IWL_MVM_STATUS_FIRMWARE_RUNNING: firmware is running
  * @IWL_MVM_STATUS_NEED_FLUSH_P2P: need to flush P2P bcast STA
  * @IWL_MVM_STATUS_IN_D3: in D3 (or at least about to go into it)
+ * @IWL_MVM_STATUS_STARTING: starting mac,
+ *	used to disable restart flow while in STARTING state
  */
 enum iwl_mvm_status {
 	IWL_MVM_STATUS_HW_RFKILL,
@@ -1134,6 +1136,7 @@ enum iwl_mvm_status {
 	IWL_MVM_STATUS_FIRMWARE_RUNNING,
 	IWL_MVM_STATUS_NEED_FLUSH_P2P,
 	IWL_MVM_STATUS_IN_D3,
+	IWL_MVM_STATUS_STARTING,
 };
 
 /* Keep track of completed init configuration */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 232ad531d612..ce7160670aa7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1600,6 +1600,9 @@ void iwl_mvm_nic_restart(struct iwl_mvm *mvm, bool fw_error)
 	 */
 	if (!mvm->fw_restart && fw_error) {
 		iwl_fw_error_collect(&mvm->fwrt, false);
+	} else if (test_bit(IWL_MVM_STATUS_STARTING,
+			    &mvm->status)) {
+		IWL_ERR(mvm, "Starting mac, retry will be triggered anyway\n");
 	} else if (test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status)) {
 		struct iwl_mvm_reprobe *reprobe;
 

