Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5941E3CDDE8
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244561AbhGSPBR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:01:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:52608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344166AbhGSO7a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:59:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26A0D61375;
        Mon, 19 Jul 2021 15:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709133;
        bh=kjGmUYlKIALHdH2NW/foryJJYrzDOhvO50awcgOngG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mPmgFH9RUOkz0zsPw9bb6DkSPA+81kEbupELHGPn9QnmmjBbyvJVpwAQHOo2iI5MD
         4Z/jWfITqY3H/kCUo4mCG9Fu7v9FN1N+Ud8UvvMkaQ55qoxolxrnQ2hCjwrGnvW2Ft
         U9T8XXdZYTTG2mkg7cuw6l3qEUABbEQ/28ITao4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 266/421] iwlwifi: pcie: free IML DMA memory allocation
Date:   Mon, 19 Jul 2021 16:51:17 +0200
Message-Id: <20210719144955.602752889@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 310f60f53a86eba680d9bc20a371e13b06a5f903 ]

In the case of gen3 devices with image loader (IML) support,
we were leaking the IML DMA allocation and never freeing it.
Fix that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210618105614.07e117dbedb7.I7bb9ebbe0617656986c2a598ea5e827b533bd3b9@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c  | 15 ++++++++++-----
 .../net/wireless/intel/iwlwifi/pcie/internal.h    |  3 +++
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
index a1cecf4a0e82..addf786fbcaf 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
@@ -63,7 +63,6 @@ int iwl_pcie_ctxt_info_gen3_init(struct iwl_trans *trans,
 	struct iwl_prph_scratch *prph_scratch;
 	struct iwl_prph_scratch_ctrl_cfg *prph_sc_ctrl;
 	struct iwl_prph_info *prph_info;
-	void *iml_img;
 	u32 control_flags = 0;
 	int ret;
 
@@ -157,14 +156,15 @@ int iwl_pcie_ctxt_info_gen3_init(struct iwl_trans *trans,
 	trans_pcie->prph_scratch = prph_scratch;
 
 	/* Allocate IML */
-	iml_img = dma_alloc_coherent(trans->dev, trans->iml_len,
-				     &trans_pcie->iml_dma_addr, GFP_KERNEL);
-	if (!iml_img) {
+	trans_pcie->iml = dma_alloc_coherent(trans->dev, trans->iml_len,
+					     &trans_pcie->iml_dma_addr,
+					     GFP_KERNEL);
+	if (!trans_pcie->iml) {
 		ret = -ENOMEM;
 		goto err_free_ctxt_info;
 	}
 
-	memcpy(iml_img, trans->iml, trans->iml_len);
+	memcpy(trans_pcie->iml, trans->iml, trans->iml_len);
 
 	iwl_enable_fw_load_int_ctx_info(trans);
 
@@ -212,6 +212,11 @@ void iwl_pcie_ctxt_info_gen3_free(struct iwl_trans *trans)
 	trans_pcie->ctxt_info_dma_addr = 0;
 	trans_pcie->ctxt_info_gen3 = NULL;
 
+	dma_free_coherent(trans->dev, trans->iml_len, trans_pcie->iml,
+			  trans_pcie->iml_dma_addr);
+	trans_pcie->iml_dma_addr = 0;
+	trans_pcie->iml = NULL;
+
 	iwl_pcie_ctxt_info_free_fw_img(trans);
 
 	dma_free_coherent(trans->dev, sizeof(*trans_pcie->prph_scratch),
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index e9d67ba3e56d..f581822b2a7d 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -447,6 +447,8 @@ struct iwl_self_init_dram {
  *	Context information addresses will be taken from here.
  *	This is driver's local copy for keeping track of size and
  *	count for allocating and freeing the memory.
+ * @iml: image loader image virtual address
+ * @iml_dma_addr: image loader image DMA address
  * @trans: pointer to the generic transport area
  * @scd_base_addr: scheduler sram base address in SRAM
  * @scd_bc_tbls: pointer to the byte count table of the scheduler
@@ -492,6 +494,7 @@ struct iwl_trans_pcie {
 	};
 	struct iwl_prph_info *prph_info;
 	struct iwl_prph_scratch *prph_scratch;
+	void *iml;
 	dma_addr_t ctxt_info_dma_addr;
 	dma_addr_t prph_info_dma_addr;
 	dma_addr_t prph_scratch_dma_addr;
-- 
2.30.2



