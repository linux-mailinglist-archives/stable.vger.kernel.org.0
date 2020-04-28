Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4ACC1BCAB8
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730241AbgD1SfY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:35:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:52500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730234AbgD1SfX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:35:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E062208E0;
        Tue, 28 Apr 2020 18:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098922;
        bh=1zjx6B/zHWaYLfTGlalgE7UlEkUoFnPE6U4rhlDiw7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mYT28G7+TLTqtkyk0iC06/wp5ErmquBbTU47EIS+MZwtjm1YUYPopO29Dh8KVF0MB
         I+ygqR0qcYoVKhIfBAKNKtF5Dk8+IVF5iKwPvY+Vu6wzeN4R3FmP5hNKqDSjmiPP9t
         6aZ+9jItZPW6cZ4SQqpXlns+Vtlxm0ESiMPttML0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.6 129/167] iwlwifi: fix WGDS check when WRDS is disabled
Date:   Tue, 28 Apr 2020 20:25:05 +0200
Message-Id: <20200428182241.701291334@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

commit 1edd56e69dca9098e63d8d5815aeb83eeeb10a79 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c |    9 +++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c  |   25 +++++++++++--------------
 2 files changed, 18 insertions(+), 16 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
@@ -296,9 +296,14 @@ int iwl_sar_select_profile(struct iwl_fw
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
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -698,6 +698,7 @@ int iwl_mvm_sar_select_profile(struct iw
 		struct iwl_dev_tx_power_cmd_v4 v4;
 	} cmd;
 
+	int ret;
 	u16 len = 0;
 
 	cmd.v5.v3.set_mode = cpu_to_le32(IWL_TX_POWER_MODE_SET_CHAINS);
@@ -712,9 +713,14 @@ int iwl_mvm_sar_select_profile(struct iw
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
@@ -1005,16 +1011,7 @@ static int iwl_mvm_sar_init(struct iwl_m
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
@@ -1236,7 +1233,7 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 	ret = iwl_mvm_sar_init(mvm);
 	if (ret == 0) {
 		ret = iwl_mvm_sar_geo_init(mvm);
-	} else if (ret > 0 && !iwl_sar_get_wgds_table(&mvm->fwrt)) {
+	} else if (ret == -ENOENT && !iwl_sar_get_wgds_table(&mvm->fwrt)) {
 		/*
 		 * If basic SAR is not available, we check for WGDS,
 		 * which should *not* be available either.  If it is


