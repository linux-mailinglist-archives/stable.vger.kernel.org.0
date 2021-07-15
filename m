Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB5C3CA607
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237020AbhGOSpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:45:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:46704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231970AbhGOSpt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:45:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27E55613CA;
        Thu, 15 Jul 2021 18:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374575;
        bh=4LmJWgL/muoqZnm+hiqG7C9JHTI+SucHZIlgDvXTwww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J1tZeSGicWgQutt+KSXmO3DljxHsrDvz0Huda8yg3b37xEozo3Z4br5VwcyfPgkIP
         xz0FEOKfuEMQIj1HpfhFMu6v1RaS+h0Hd+TJnqShYhkSbk/y0AG9bktDJZUPkYWp0f
         7lC/N9rix/QDOhD1RgV3JJj9AMb9ZK5A8Ts3NGm0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 056/122] iwlwifi: pcie: free IML DMA memory allocation
Date:   Thu, 15 Jul 2021 20:38:23 +0200
Message-Id: <20210715182504.043487237@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182448.393443551@linuxfoundation.org>
References: <20210715182448.393443551@linuxfoundation.org>
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
index eab159205e48..f6b43cd87d5d 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
@@ -63,7 +63,6 @@ int iwl_pcie_ctxt_info_gen3_init(struct iwl_trans *trans,
 	struct iwl_prph_scratch *prph_scratch;
 	struct iwl_prph_scratch_ctrl_cfg *prph_sc_ctrl;
 	struct iwl_prph_info *prph_info;
-	void *iml_img;
 	u32 control_flags = 0;
 	int ret;
 	int cmdq_size = max_t(u32, IWL_CMD_QUEUE_SIZE,
@@ -162,14 +161,15 @@ int iwl_pcie_ctxt_info_gen3_init(struct iwl_trans *trans,
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
 
@@ -242,6 +242,11 @@ void iwl_pcie_ctxt_info_gen3_free(struct iwl_trans *trans)
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
index 9b5b96e34456..553164f06a6b 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -475,6 +475,8 @@ struct cont_rec {
  *	Context information addresses will be taken from here.
  *	This is driver's local copy for keeping track of size and
  *	count for allocating and freeing the memory.
+ * @iml: image loader image virtual address
+ * @iml_dma_addr: image loader image DMA address
  * @trans: pointer to the generic transport area
  * @scd_base_addr: scheduler sram base address in SRAM
  * @scd_bc_tbls: pointer to the byte count table of the scheduler
@@ -522,6 +524,7 @@ struct iwl_trans_pcie {
 	};
 	struct iwl_prph_info *prph_info;
 	struct iwl_prph_scratch *prph_scratch;
+	void *iml;
 	dma_addr_t ctxt_info_dma_addr;
 	dma_addr_t prph_info_dma_addr;
 	dma_addr_t prph_scratch_dma_addr;
-- 
2.30.2



