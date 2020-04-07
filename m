Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E24D01A0B4D
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 12:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728914AbgDGKZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 06:25:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:35804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728911AbgDGKZS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 06:25:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0508D2074F;
        Tue,  7 Apr 2020 10:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586255117;
        bh=hHJhgpsWRpualoY12/XLaw4edCex+4GAUYWIyfeAsjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gC2LJSFyqH3etd6zVgcwC4/pjfgss0eLgd5KufWF2eSDkNeIPLqmgaCcmZRjKOqL5
         KEZwZT7RIczob31jENkhuxgEUk0BAsVWqXNI/UebxPM0GqUgjODYhJXT4QU17CNTx8
         cGrfd+trSELQomgw8zocoDlG+6JdqK+7d0c2P4uE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 5.5 37/46] iwlwifi: dbg: dont abort if sending DBGC_SUSPEND_RESUME fails
Date:   Tue,  7 Apr 2020 12:22:08 +0200
Message-Id: <20200407101503.423514591@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200407101459.502593074@linuxfoundation.org>
References: <20200407101459.502593074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

commit 699b760bd29edba736590fffef7654cb079c753e upstream.

If the firmware is in a bad state or not initialized fully, sending
the DBGC_SUSPEND_RESUME command fails but we can still collect logs.

Instead of aborting the entire dump process, simply ignore the error.
By removing the last callpoint that was checking the return value, we
can also convert the function to return void.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Fixes: 576058330f2d ("iwlwifi: dbg: support debug recording suspend resume command")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20200306151129.dcec37b2efd4.I8dcd190431d110a6a0e88095ce93591ccfb3d78d@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c |   15 +++++----------
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h |    6 +++---
 2 files changed, 8 insertions(+), 13 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -2491,10 +2491,7 @@ static void iwl_fw_dbg_collect_sync(stru
 		goto out;
 	}
 
-	if (iwl_fw_dbg_stop_restart_recording(fwrt, &params, true)) {
-		IWL_ERR(fwrt, "Failed to stop DBGC recording, aborting dump\n");
-		goto out;
-	}
+	iwl_fw_dbg_stop_restart_recording(fwrt, &params, true);
 
 	IWL_DEBUG_FW_INFO(fwrt, "WRT: Data collection start\n");
 	if (iwl_trans_dbg_ini_valid(fwrt->trans))
@@ -2659,14 +2656,14 @@ static int iwl_fw_dbg_restart_recording(
 	return 0;
 }
 
-int iwl_fw_dbg_stop_restart_recording(struct iwl_fw_runtime *fwrt,
-				      struct iwl_fw_dbg_params *params,
-				      bool stop)
+void iwl_fw_dbg_stop_restart_recording(struct iwl_fw_runtime *fwrt,
+				       struct iwl_fw_dbg_params *params,
+				       bool stop)
 {
 	int ret = 0;
 
 	if (test_bit(STATUS_FW_ERROR, &fwrt->trans->status))
-		return 0;
+		return;
 
 	if (fw_has_capa(&fwrt->fw->ucode_capa,
 			IWL_UCODE_TLV_CAPA_DBG_SUSPEND_RESUME_CMD_SUPP))
@@ -2683,7 +2680,5 @@ int iwl_fw_dbg_stop_restart_recording(st
 			iwl_fw_set_dbg_rec_on(fwrt);
 	}
 #endif
-
-	return ret;
 }
 IWL_EXPORT_SYMBOL(iwl_fw_dbg_stop_restart_recording);
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -239,9 +239,9 @@ _iwl_fw_dbg_trigger_simple_stop(struct i
 	_iwl_fw_dbg_trigger_simple_stop((fwrt), (wdev),		\
 					iwl_fw_dbg_get_trigger((fwrt)->fw,\
 							       (trig)))
-int iwl_fw_dbg_stop_restart_recording(struct iwl_fw_runtime *fwrt,
-				      struct iwl_fw_dbg_params *params,
-				      bool stop);
+void iwl_fw_dbg_stop_restart_recording(struct iwl_fw_runtime *fwrt,
+				       struct iwl_fw_dbg_params *params,
+				       bool stop);
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 static inline void iwl_fw_set_dbg_rec_on(struct iwl_fw_runtime *fwrt)


