Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A50B1469C1C
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245230AbhLFPU5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:20:57 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50598 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356485AbhLFPSA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:18:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB6A7B81118;
        Mon,  6 Dec 2021 15:14:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1395C341C1;
        Mon,  6 Dec 2021 15:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803669;
        bh=No5nGlbdVWn6S/6CT5wauubRW/OJi95ReWUqCjlVrTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1f2c6SvPp90aBrC967iPfpdbQnwgrMCJJc6mXnZDU1JPk+lkQtXg+V7i8ZHTQEzNT
         1Whp1VgwZBAC5z2r9bAptkHq97q1iOuYNe2DPgoNt3PnV18gCmZ36Nm/xy4Dtjf4zI
         9Wx15nrUkIHTLmWwzSedbhD5DNgn0STPLwiVaBBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.4 67/70] iwlwifi: mvm: retry init flow if failed
Date:   Mon,  6 Dec 2021 15:57:11 +0100
Message-Id: <20211206145554.243717739@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145551.909846023@linuxfoundation.org>
References: <20211206145551.909846023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

commit 5283dd677e52af9db6fe6ad11b2f12220d519d0c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c      |   22 +++++++++++++-------
 drivers/net/wireless/intel/iwlwifi/iwl-drv.h      |    3 ++
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |   24 +++++++++++++++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      |    3 ++
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c      |    3 ++
 5 files changed, 47 insertions(+), 8 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1276,23 +1276,31 @@ _iwl_op_mode_start(struct iwl_drv *drv,
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
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.h
@@ -145,4 +145,7 @@ void iwl_drv_stop(struct iwl_drv *drv);
 #define IWL_EXPORT_SYMBOL(sym)
 #endif
 
+/* max retry for init flow */
+#define IWL_MAX_INIT_RETRY 2
+
 #endif /* __iwl_drv_h__ */
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -71,6 +71,7 @@
 #include <net/ieee80211_radiotap.h>
 #include <net/tcp.h>
 
+#include "iwl-drv.h"
 #include "iwl-op-mode.h"
 #include "iwl-io.h"
 #include "mvm.h"
@@ -1129,9 +1130,30 @@ static int iwl_mvm_mac_start(struct ieee
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
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1167,6 +1167,8 @@ struct iwl_mvm {
  * @IWL_MVM_STATUS_ROC_AUX_RUNNING: AUX remain-on-channel is running
  * @IWL_MVM_STATUS_FIRMWARE_RUNNING: firmware is running
  * @IWL_MVM_STATUS_NEED_FLUSH_P2P: need to flush P2P bcast STA
+ * @IWL_MVM_STATUS_STARTING: starting mac,
+ *	used to disable restart flow while in STARTING state
  */
 enum iwl_mvm_status {
 	IWL_MVM_STATUS_HW_RFKILL,
@@ -1177,6 +1179,7 @@ enum iwl_mvm_status {
 	IWL_MVM_STATUS_ROC_AUX_RUNNING,
 	IWL_MVM_STATUS_FIRMWARE_RUNNING,
 	IWL_MVM_STATUS_NEED_FLUSH_P2P,
+	IWL_MVM_STATUS_STARTING,
 };
 
 /* Keep track of completed init configuration */
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1288,6 +1288,9 @@ void iwl_mvm_nic_restart(struct iwl_mvm
 	 */
 	if (!mvm->fw_restart && fw_error) {
 		iwl_fw_error_collect(&mvm->fwrt);
+	} else if (test_bit(IWL_MVM_STATUS_STARTING,
+			    &mvm->status)) {
+		IWL_ERR(mvm, "Starting mac, retry will be triggered anyway\n");
 	} else if (test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status)) {
 		struct iwl_mvm_reprobe *reprobe;
 


