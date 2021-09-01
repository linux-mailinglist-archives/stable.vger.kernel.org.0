Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26EF93FDB5C
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345058AbhIAMlL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:41:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:42460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344446AbhIAMja (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:39:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88EF360232;
        Wed,  1 Sep 2021 12:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499710;
        bh=3FEbFjT3yU9J6PMogKjc+hEPRYy3y/390wSZa2VRkU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YTdhdi+PcdG9WlbsvpZCh197Llc/QS5N3VOv5nlor5IxzrArUtj1dH+WAfpzcUqWG
         JxB/4syo4le4tg3+/woCR8wIOXC089J/xVeBkCAuzE3a8xuj/kF/FYpIjIPe2KIi63
         huJPe7VNe8/fnMM6NaJE9dQUQ66sph9ncpSkh6k8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 054/103] iwlwifi: pnvm: accept multiple HW-type TLVs
Date:   Wed,  1 Sep 2021 14:28:04 +0200
Message-Id: <20210901122302.392692021@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
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
index 37ce4fe136c5..cdea741be6f6 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
@@ -38,6 +38,7 @@ static int iwl_pnvm_handle_section(struct iwl_trans *trans, const u8 *data,
 	u32 sha1 = 0;
 	u16 mac_type = 0, rf_id = 0;
 	u8 *pnvm_data = NULL, *tmp;
+	bool hw_match = false;
 	u32 size = 0;
 	int ret;
 
@@ -84,6 +85,9 @@ static int iwl_pnvm_handle_section(struct iwl_trans *trans, const u8 *data,
 				break;
 			}
 
+			if (hw_match)
+				break;
+
 			mac_type = le16_to_cpup((__le16 *)data);
 			rf_id = le16_to_cpup((__le16 *)(data + sizeof(__le16)));
 
@@ -91,15 +95,9 @@ static int iwl_pnvm_handle_section(struct iwl_trans *trans, const u8 *data,
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
@@ -150,6 +148,15 @@ static int iwl_pnvm_handle_section(struct iwl_trans *trans, const u8 *data,
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



