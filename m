Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8A366AEB18
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbjCGRkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:40:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbjCGRjz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:39:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E679DE22
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:36:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85047B8199E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:36:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6552C433D2;
        Tue,  7 Mar 2023 17:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210564;
        bh=v5rJVvDbHQR54MKFa57MwrziVRiIGWiZn0XDocf0irs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FcrsCHRfVL2glLQu3PxWLFCggEGDa3p6Yu7vBhhFYFJDPhhpdeNLlRzKVuwH8pcyQ
         NDqEIX8esp/AdXLCKGtQ6goOxrkTYpZizupnwauO0mriQQnmf8WwLBmg3In3lsnglo
         y790wHJ4Vp+8k0y/2MzE1xJ1ZUZksD34nJa05GtY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Christoph Hellwig <hch@lst.de>,
        Sibi Sankar <quic_sibis@quicinc.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0581/1001] Revert "remoteproc: qcom_q6v5_mss: map/unmap metadata region before/after use"
Date:   Tue,  7 Mar 2023 17:55:53 +0100
Message-Id: <20230307170046.680896946@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit a899d542b687c9b04ccbd9eefabc829ba5fef791 ]

This reverts commit fc156629b23a21181e473e60341e3a78af25a1d4.

This commit manages to do three API violations at once:

 - dereference the return value of dma_alloc_attrs with the
   DMA_ATTR_NO_KERNEL_MAPPING mapping, which is clearly forbidden and
   will do the wrong thing on various dma mapping implementations.  The
   fact that dma-direct uses a struct page as a cookie is an undocumented
   implementation detail
 - include dma-map-ops.h and use pgprot_dmacoherent despite a clear
   comment documenting that this is not acceptable
 - use of the VM_DMA_COHERENT for something that is not the dma-mapping
   code
 - use of VM_FLUSH_RESET_PERMS for vmap, while it is only supported for
   vmalloc

Acked-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sibi Sankar <quic_sibis@quicinc.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230117085840.32356-6-quic_sibis@quicinc.com
Stable-dep-of: 57f72170a2b2 ("remoteproc: qcom_q6v5_mss: Use a carveout to authenticate modem headers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_mss.c | 38 +++++-------------------------
 1 file changed, 6 insertions(+), 32 deletions(-)

diff --git a/drivers/remoteproc/qcom_q6v5_mss.c b/drivers/remoteproc/qcom_q6v5_mss.c
index fddb63cffee07..a8b141db4de63 100644
--- a/drivers/remoteproc/qcom_q6v5_mss.c
+++ b/drivers/remoteproc/qcom_q6v5_mss.c
@@ -10,7 +10,6 @@
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/devcoredump.h>
-#include <linux/dma-map-ops.h>
 #include <linux/dma-mapping.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
@@ -933,52 +932,27 @@ static void q6v5proc_halt_axi_port(struct q6v5 *qproc,
 static int q6v5_mpss_init_image(struct q6v5 *qproc, const struct firmware *fw,
 				const char *fw_name)
 {
-	unsigned long dma_attrs = DMA_ATTR_FORCE_CONTIGUOUS | DMA_ATTR_NO_KERNEL_MAPPING;
-	unsigned long flags = VM_DMA_COHERENT | VM_FLUSH_RESET_PERMS;
-	struct page **pages;
-	struct page *page;
+	unsigned long dma_attrs = DMA_ATTR_FORCE_CONTIGUOUS;
 	dma_addr_t phys;
 	void *metadata;
 	int mdata_perm;
 	int xferop_ret;
 	size_t size;
-	void *vaddr;
-	int count;
+	void *ptr;
 	int ret;
-	int i;
 
 	metadata = qcom_mdt_read_metadata(fw, &size, fw_name, qproc->dev);
 	if (IS_ERR(metadata))
 		return PTR_ERR(metadata);
 
-	page = dma_alloc_attrs(qproc->dev, size, &phys, GFP_KERNEL, dma_attrs);
-	if (!page) {
+	ptr = dma_alloc_attrs(qproc->dev, size, &phys, GFP_KERNEL, dma_attrs);
+	if (!ptr) {
 		kfree(metadata);
 		dev_err(qproc->dev, "failed to allocate mdt buffer\n");
 		return -ENOMEM;
 	}
 
-	count = PAGE_ALIGN(size) >> PAGE_SHIFT;
-	pages = kmalloc_array(count, sizeof(struct page *), GFP_KERNEL);
-	if (!pages) {
-		ret = -ENOMEM;
-		goto free_dma_attrs;
-	}
-
-	for (i = 0; i < count; i++)
-		pages[i] = nth_page(page, i);
-
-	vaddr = vmap(pages, count, flags, pgprot_dmacoherent(PAGE_KERNEL));
-	kfree(pages);
-	if (!vaddr) {
-		dev_err(qproc->dev, "unable to map memory region: %pa+%zx\n", &phys, size);
-		ret = -EBUSY;
-		goto free_dma_attrs;
-	}
-
-	memcpy(vaddr, metadata, size);
-
-	vunmap(vaddr);
+	memcpy(ptr, metadata, size);
 
 	/* Hypervisor mapping to access metadata by modem */
 	mdata_perm = BIT(QCOM_SCM_VMID_HLOS);
@@ -1008,7 +982,7 @@ static int q6v5_mpss_init_image(struct q6v5 *qproc, const struct firmware *fw,
 			 "mdt buffer not reclaimed system may become unstable\n");
 
 free_dma_attrs:
-	dma_free_attrs(qproc->dev, size, page, phys, dma_attrs);
+	dma_free_attrs(qproc->dev, size, ptr, phys, dma_attrs);
 	kfree(metadata);
 
 	return ret < 0 ? ret : 0;
-- 
2.39.2



