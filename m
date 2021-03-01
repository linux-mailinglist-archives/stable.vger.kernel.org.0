Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDD5328A8E
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbhCASSf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:18:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:60800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238932AbhCASNx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:13:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BAF965169;
        Mon,  1 Mar 2021 17:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618444;
        bh=D4S7w++o0Usmeis1y1raiZKLuOPzXfWE5tlI2VKIF0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J1R8iQYAudBWY9WikZnNSZEa+Zlxjdh4yZI8A89V037z1yh1bWxHiH7rrtHsG1jxk
         QM+8/OideHiyTOxoGmMnrKTe0MTD4DNX1LytOLJ0UdLb5PUI+VBQmOJw0Zeh3eGYAI
         sZTvBrQGe8BuvOy+kSGi3tWi0BKAX8RTC1BPhwn0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 089/663] iwlwifi: mvm: send stored PPAG command instead of local
Date:   Mon,  1 Mar 2021 17:05:37 +0100
Message-Id: <20210301161146.129458344@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

[ Upstream commit 659844d391826bfc5c8b4d9a06869ed51d859c76 ]

Some change conflicts apparently cause a confusion between a local
variable being used to send the PPAG command and the introduction of a
union for this command.  Most parts of the local command were never
copied from the stored data, so the FW was getting garbage in the
tables instead of getting valid values.

Fix this by completely removing the local and using only the union
that we have stored in fwrt.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Fixes: f2134f66f40e ("iwlwifi: acpi: support ppag table command v2")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210210135352.d090e0301023.I7d57f4d7da9a3297734c51cf988199323c76916d@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 2d2fe45603c8b..34a44300a15eb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1027,7 +1027,6 @@ int iwl_mvm_ppag_send_cmd(struct iwl_mvm *mvm)
 {
 	u8 cmd_ver;
 	int i, j, ret, num_sub_bands, cmd_size;
-	union iwl_ppag_table_cmd ppag_table;
 	s8 *gain;
 
 	if (!fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_SET_PPAG)) {
@@ -1040,15 +1039,13 @@ int iwl_mvm_ppag_send_cmd(struct iwl_mvm *mvm)
 		return 0;
 	}
 
-	ppag_table.v1.enabled = mvm->fwrt.ppag_table.v1.enabled;
-
 	cmd_ver = iwl_fw_lookup_cmd_ver(mvm->fw, PHY_OPS_GROUP,
 					PER_PLATFORM_ANT_GAIN_CMD,
 					IWL_FW_CMD_VER_UNKNOWN);
 	if (cmd_ver == 1) {
 		num_sub_bands = IWL_NUM_SUB_BANDS;
 		gain = mvm->fwrt.ppag_table.v1.gain[0];
-		cmd_size = sizeof(ppag_table.v1);
+		cmd_size = sizeof(mvm->fwrt.ppag_table.v1);
 		if (mvm->fwrt.ppag_ver == 2) {
 			IWL_DEBUG_RADIO(mvm,
 					"PPAG table is v2 but FW supports v1, sending truncated table\n");
@@ -1056,7 +1053,7 @@ int iwl_mvm_ppag_send_cmd(struct iwl_mvm *mvm)
 	} else if (cmd_ver == 2) {
 		num_sub_bands = IWL_NUM_SUB_BANDS_V2;
 		gain = mvm->fwrt.ppag_table.v2.gain[0];
-		cmd_size = sizeof(ppag_table.v2);
+		cmd_size = sizeof(mvm->fwrt.ppag_table.v2);
 		if (mvm->fwrt.ppag_ver == 1) {
 			IWL_DEBUG_RADIO(mvm,
 					"PPAG table is v1 but FW supports v2, sending padded table\n");
@@ -1076,7 +1073,7 @@ int iwl_mvm_ppag_send_cmd(struct iwl_mvm *mvm)
 	IWL_DEBUG_RADIO(mvm, "Sending PER_PLATFORM_ANT_GAIN_CMD\n");
 	ret = iwl_mvm_send_cmd_pdu(mvm, WIDE_ID(PHY_OPS_GROUP,
 						PER_PLATFORM_ANT_GAIN_CMD),
-				   0, cmd_size, &ppag_table);
+				   0, cmd_size, &mvm->fwrt.ppag_table);
 	if (ret < 0)
 		IWL_ERR(mvm, "failed to send PER_PLATFORM_ANT_GAIN_CMD (%d)\n",
 			ret);
-- 
2.27.0



