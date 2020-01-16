Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F327113FF03
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388954AbgAPXju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:39:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:59924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389646AbgAPX1s (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:27:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD1B0206D9;
        Thu, 16 Jan 2020 23:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217267;
        bh=/rnnCLUtsDSujem08bDuUV6hvzEqVGJfSuKukWLi4i0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zGjfxbpq7XAAGOtTfMHlJrQhprF7xD1urt0/KVuB1U9wVxVsqIRRFx4Sw0LmEdez7
         l9DKOYxuHhOMn36XimbDrpeQH6XuISNZSGtsGhzAO0xcB8N9/hSxr2ZD/kaErzAyEs
         wZEmsSb38ch5aPBJzxy2SAhtQVddmmMQAO6G+o7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.19 13/84] iwlwifi: pcie: fix memory leaks in iwl_pcie_ctxt_info_gen3_init
Date:   Fri, 17 Jan 2020 00:17:47 +0100
Message-Id: <20200116231715.177276544@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231713.087649517@linuxfoundation.org>
References: <20200116231713.087649517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

commit 0f4f199443faca715523b0659aa536251d8b978f upstream.

In iwl_pcie_ctxt_info_gen3_init there are cases that the allocated dma
memory is leaked in case of error.

DMA memories prph_scratch, prph_info, and ctxt_info_gen3 are allocated
and initialized to be later assigned to trans_pcie. But in any error case
before such assignment the allocated memories should be released.

First of such error cases happens when iwl_pcie_init_fw_sec fails.
Current implementation correctly releases prph_scratch. But in two
sunsequent error cases where dma_alloc_coherent may fail, such
releases are missing.

This commit adds release for prph_scratch when allocation for
prph_info fails, and adds releases for prph_scratch and prph_info when
allocation for ctxt_info_gen3 fails.

Fixes: 2ee824026288 ("iwlwifi: pcie: support context information for 22560 devices")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c |   36 ++++++++++-----
 1 file changed, 25 insertions(+), 11 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
@@ -102,13 +102,9 @@ int iwl_pcie_ctxt_info_gen3_init(struct
 
 	/* allocate ucode sections in dram and set addresses */
 	ret = iwl_pcie_init_fw_sec(trans, fw, &prph_scratch->dram);
-	if (ret) {
-		dma_free_coherent(trans->dev,
-				  sizeof(*prph_scratch),
-				  prph_scratch,
-				  trans_pcie->prph_scratch_dma_addr);
-		return ret;
-	}
+	if (ret)
+		goto err_free_prph_scratch;
+
 
 	/* Allocate prph information
 	 * currently we don't assign to the prph info anything, but it would get
@@ -116,16 +112,20 @@ int iwl_pcie_ctxt_info_gen3_init(struct
 	prph_info = dma_alloc_coherent(trans->dev, sizeof(*prph_info),
 				       &trans_pcie->prph_info_dma_addr,
 				       GFP_KERNEL);
-	if (!prph_info)
-		return -ENOMEM;
+	if (!prph_info) {
+		ret = -ENOMEM;
+		goto err_free_prph_scratch;
+	}
 
 	/* Allocate context info */
 	ctxt_info_gen3 = dma_alloc_coherent(trans->dev,
 					    sizeof(*ctxt_info_gen3),
 					    &trans_pcie->ctxt_info_dma_addr,
 					    GFP_KERNEL);
-	if (!ctxt_info_gen3)
-		return -ENOMEM;
+	if (!ctxt_info_gen3) {
+		ret = -ENOMEM;
+		goto err_free_prph_info;
+	}
 
 	ctxt_info_gen3->prph_info_base_addr =
 		cpu_to_le64(trans_pcie->prph_info_dma_addr);
@@ -176,6 +176,20 @@ int iwl_pcie_ctxt_info_gen3_init(struct
 	iwl_set_bit(trans, CSR_GP_CNTRL, CSR_AUTO_FUNC_INIT);
 
 	return 0;
+
+err_free_prph_info:
+	dma_free_coherent(trans->dev,
+			  sizeof(*prph_info),
+			prph_info,
+			trans_pcie->prph_info_dma_addr);
+
+err_free_prph_scratch:
+	dma_free_coherent(trans->dev,
+			  sizeof(*prph_scratch),
+			prph_scratch,
+			trans_pcie->prph_scratch_dma_addr);
+	return ret;
+
 }
 
 void iwl_pcie_ctxt_info_gen3_free(struct iwl_trans *trans)


