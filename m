Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C598468490
	for <lists+stable@lfdr.de>; Sat,  4 Dec 2021 12:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384819AbhLDLxW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Dec 2021 06:53:22 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:50436 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229551AbhLDLxF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Dec 2021 06:53:05 -0500
Received: from 91-156-5-105.elisa-laajakaista.fi ([91.156.5.105] helo=kveik.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <luca@coelho.fi>)
        id 1mtSrM-0017Qq-UN; Sat, 04 Dec 2021 13:05:42 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     stable@vger.kernel.org
Cc:     kvalo@codeaurora.org, luca@coelho.fi, mordechay.goodstein@intel.com
Date:   Sat,  4 Dec 2021 13:05:39 +0200
Message-Id: <20211204110539.852017-1-luca@coelho.fi>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <1638613822160117@kroah.com>
References: <1638613822160117@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on farmhouse.coelho.fi
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        TVD_RCVD_IP autolearn=ham autolearn_force=no version=3.4.6
Subject: [PATCH 5.4] iwlwifi: mvm: retry init flow if failed
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
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c  | 22 +++++++++++------
 drivers/net/wireless/intel/iwlwifi/iwl-drv.h  |  3 +++
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c | 24 ++++++++++++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  3 +++
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  3 +++
 5 files changed, 47 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index ff0519ea00a5..e68366f248fe 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1276,23 +1276,31 @@ _iwl_op_mode_start(struct iwl_drv *drv, struct iwlwifi_opmode_table *op)
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
index 2be30af7bdc3..9663db12b6f3 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.h
@@ -145,4 +145,7 @@ void iwl_drv_stop(struct iwl_drv *drv);
 #define IWL_EXPORT_SYMBOL(sym)
 #endif
 
+/* max retry for init flow */
+#define IWL_MAX_INIT_RETRY 2
+
 #endif /* __iwl_drv_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 081cbc9ec736..c942255aa1db 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -71,6 +71,7 @@
 #include <net/ieee80211_radiotap.h>
 #include <net/tcp.h>
 
+#include "iwl-drv.h"
 #include "iwl-op-mode.h"
 #include "iwl-io.h"
 #include "mvm.h"
@@ -1129,9 +1130,30 @@ static int iwl_mvm_mac_start(struct ieee80211_hw *hw)
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
index 5f1ecbb6fb71..b06a9da753ff 100644
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
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index a9aab6c690e8..5973eecbc037 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1288,6 +1288,9 @@ void iwl_mvm_nic_restart(struct iwl_mvm *mvm, bool fw_error)
 	 */
 	if (!mvm->fw_restart && fw_error) {
 		iwl_fw_error_collect(&mvm->fwrt);
+	} else if (test_bit(IWL_MVM_STATUS_STARTING,
+			    &mvm->status)) {
+		IWL_ERR(mvm, "Starting mac, retry will be triggered anyway\n");
 	} else if (test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status)) {
 		struct iwl_mvm_reprobe *reprobe;
 
-- 
2.33.1

