Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFBED328EE9
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238787AbhCATk2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:40:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:50864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241664AbhCATcz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:32:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17C2A65175;
        Mon,  1 Mar 2021 17:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618458;
        bh=5ygZ6FyAJ1USmTKIKruYMs6mh9pzQDZ+fFXuClVAgNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mT3fmVqnX/5WF8n0s+Alk0z5c2+tsewVcyUcu84Cox8iThHLWMvm3Xwb8HLjdWVpW
         GEPfVVjh/eIjKqN+oX2wl6rPsKVzlfd0yNVykn3lFURLXlGgrPtyYzh0WgxubLtzQs
         UhvYC6UWpV0Ula/DLfWmB96RUlHiIJ0kRR+iL2Q0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 093/663] iwlwifi: pnvm: set the PNVM again if it was already loaded
Date:   Mon,  1 Mar 2021 17:05:41 +0100
Message-Id: <20210301161146.332430072@linuxfoundation.org>
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

[ Upstream commit 4a81598f0f39cffbf1c29c4a184063d513661c4a ]

When the interface goes up, we have already loaded the PNVM during
init, so we don't load it anymore.  But we still need to set the PNVM
values in the context so that the FW can load it again.

Call set_pnvm when the PNVM is already loaded and change the
trans_pcie implementation to accept a second call to set_pnvm when we
have already allocated and, in this case, only set the values without
allocating again.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Fixes: 6972592850c0 ("iwlwifi: read and parse PNVM file")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210210172142.622546a3566f.I659a8b9aa944d213c4ba446e142d74f3f6db9c64@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c  |  7 ++++++-
 .../intel/iwlwifi/pcie/ctxt-info-gen3.c       | 21 +++++++++++--------
 2 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
index 895a907acdf0f..1e16f83b402b8 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
@@ -227,6 +227,7 @@ int iwl_pnvm_load(struct iwl_trans *trans,
 	struct iwl_notification_wait pnvm_wait;
 	static const u16 ntf_cmds[] = { WIDE_ID(REGULATORY_AND_NVM_GROUP,
 						PNVM_INIT_COMPLETE_NTFY) };
+	int ret;
 
 	/* if the SKU_ID is empty, there's nothing to do */
 	if (!trans->sku_id[0] && !trans->sku_id[1] && !trans->sku_id[2])
@@ -236,7 +237,6 @@ int iwl_pnvm_load(struct iwl_trans *trans,
 	if (!trans->pnvm_loaded) {
 		const struct firmware *pnvm;
 		char pnvm_name[64];
-		int ret;
 
 		/*
 		 * The prefix unfortunately includes a hyphen at the end, so
@@ -264,6 +264,11 @@ int iwl_pnvm_load(struct iwl_trans *trans,
 
 			release_firmware(pnvm);
 		}
+	} else {
+		/* if we already loaded, we need to set it again */
+		ret = iwl_trans_set_pnvm(trans, NULL, 0);
+		if (ret)
+			return ret;
 	}
 
 	iwl_init_notification_wait(notif_wait, &pnvm_wait,
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
index 2d43899fbdd7a..81ef4fc8d7831 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
@@ -345,17 +345,20 @@ int iwl_trans_pcie_ctx_info_gen3_set_pnvm(struct iwl_trans *trans,
 	if (trans->trans_cfg->device_family < IWL_DEVICE_FAMILY_AX210)
 		return 0;
 
-	ret = iwl_pcie_ctxt_info_alloc_dma(trans, data, len,
-					   &trans_pcie->pnvm_dram);
-	if (ret < 0) {
-		IWL_DEBUG_FW(trans, "Failed to allocate PNVM DMA %d.\n",
-			     ret);
-		return ret;
+	/* only allocate the DRAM if not allocated yet */
+	if (!trans->pnvm_loaded) {
+		if (WARN_ON(prph_sc_ctrl->pnvm_cfg.pnvm_size))
+			return -EBUSY;
+
+		ret = iwl_pcie_ctxt_info_alloc_dma(trans, data, len,
+						   &trans_pcie->pnvm_dram);
+		if (ret < 0) {
+			IWL_DEBUG_FW(trans, "Failed to allocate PNVM DMA %d.\n",
+				     ret);
+			return ret;
+		}
 	}
 
-	if (WARN_ON(prph_sc_ctrl->pnvm_cfg.pnvm_size))
-		return -EBUSY;
-
 	prph_sc_ctrl->pnvm_cfg.pnvm_base_addr =
 		cpu_to_le64(trans_pcie->pnvm_dram.physical);
 	prph_sc_ctrl->pnvm_cfg.pnvm_size =
-- 
2.27.0



