Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4FA53FDC6B
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344183AbhIAMuv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:50:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:49840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344536AbhIAMsA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:48:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F478610A8;
        Wed,  1 Sep 2021 12:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630500020;
        bh=S9iJn1Hv/lkhDJlzG1PsR7eS5tjZs98s/7plS8XSqZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NB558FN2lwGgpgdKna5dtsL0LfQ+j1OAdA5HwSK2anm54+0Ax1UC+bJEppBVnt0AV
         j2wC5F/WJR22/GzYb2H3c/6ohdBjTZWQhBSi+mwGtnXgyNli9sE9AT+TWHZ+7xzNIv
         nLNJHRR5LhWyKu0sNfWGfNcgZxpfrPcVR+yQZsHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 073/113] iwlwifi: pnvm: accept multiple HW-type TLVs
Date:   Wed,  1 Sep 2021 14:28:28 +0200
Message-Id: <20210901122304.422679221@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 0f673c16c850250db386537a422c11d248fb123c ]

Some products (So) may have two different types of products
with different mac-type that are otherwise equivalent, and
have the same PNVM data, so the PNVM file will contain two
(or perhaps later more) HW-type TLVs. Accept the file and
use the data section that contains any matching entry.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210719140154.a6a86e903035.Ic0b1b75c45d386698859f251518e8a5144431938@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c | 25 +++++++++++++-------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
index 40f2109a097f..1a63cae6567e 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
@@ -37,6 +37,7 @@ static int iwl_pnvm_handle_section(struct iwl_trans *trans, const u8 *data,
 	u32 sha1 = 0;
 	u16 mac_type = 0, rf_id = 0;
 	u8 *pnvm_data = NULL, *tmp;
+	bool hw_match = false;
 	u32 size = 0;
 	int ret;
 
@@ -83,6 +84,9 @@ static int iwl_pnvm_handle_section(struct iwl_trans *trans, const u8 *data,
 				break;
 			}
 
+			if (hw_match)
+				break;
+
 			mac_type = le16_to_cpup((__le16 *)data);
 			rf_id = le16_to_cpup((__le16 *)(data + sizeof(__le16)));
 
@@ -90,15 +94,9 @@ static int iwl_pnvm_handle_section(struct iwl_trans *trans, const u8 *data,
 				     "Got IWL_UCODE_TLV_HW_TYPE mac_type 0x%0x rf_id 0x%0x\n",
 				     mac_type, rf_id);
 
-			if (mac_type != CSR_HW_REV_TYPE(trans->hw_rev) ||
-			    rf_id != CSR_HW_RFID_TYPE(trans->hw_rf_id)) {
-				IWL_DEBUG_FW(trans,
-					     "HW mismatch, skipping PNVM section, mac_type 0x%0x, rf_id 0x%0x.\n",
-					     CSR_HW_REV_TYPE(trans->hw_rev), trans->hw_rf_id);
-				ret = -ENOENT;
-				goto out;
-			}
-
+			if (mac_type == CSR_HW_REV_TYPE(trans->hw_rev) &&
+			    rf_id == CSR_HW_RFID_TYPE(trans->hw_rf_id))
+				hw_match = true;
 			break;
 		case IWL_UCODE_TLV_SEC_RT: {
 			struct iwl_pnvm_section *section = (void *)data;
@@ -149,6 +147,15 @@ static int iwl_pnvm_handle_section(struct iwl_trans *trans, const u8 *data,
 	}
 
 done:
+	if (!hw_match) {
+		IWL_DEBUG_FW(trans,
+			     "HW mismatch, skipping PNVM section (need mac_type 0x%x rf_id 0x%x)\n",
+			     CSR_HW_REV_TYPE(trans->hw_rev),
+			     CSR_HW_RFID_TYPE(trans->hw_rf_id));
+		ret = -ENOENT;
+		goto out;
+	}
+
 	if (!size) {
 		IWL_DEBUG_FW(trans, "Empty PNVM, skipping.\n");
 		ret = -ENOENT;
-- 
2.30.2



