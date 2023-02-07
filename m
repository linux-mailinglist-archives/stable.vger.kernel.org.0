Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F12368D769
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 13:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbjBGM7s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 07:59:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231951AbjBGM7b (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 07:59:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 834277DB1
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 04:59:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12D96613F8
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 12:59:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2600AC433D2;
        Tue,  7 Feb 2023 12:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774769;
        bh=Xt/ek+ApdoMht0lN8y1NS92ksDZrNPeDsXf05bhnX/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kgwc+LxnKXrSVF7H/mijpIxsmcPYdYi1HcddtIb0oHGj7p8hLN6SndbzD58YPZo/4
         25ENLHVvKn5EWvzDafUSU5s9NEUIFlgEKGTZczG4D7idOHXcjbmiLE/oTB6FkuCQbS
         u/uc7eAi0L9fV/9rotdNJWyztzWLLrNNxKJK4q+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 028/208] ALSA: memalloc: Workaround for Xen PV
Date:   Tue,  7 Feb 2023 13:54:42 +0100
Message-Id: <20230207125635.580228103@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 53466ebdec614f915c691809b0861acecb941e30 ]

We change recently the memalloc helper to use
dma_alloc_noncontiguous() and the fallback to get_pages().  Although
lots of issues with IOMMU (or non-IOMMU) have been addressed, but
there seems still a regression on Xen PV.  Interestingly, the only
proper way to work is use dma_alloc_coherent().  The use of
dma_alloc_coherent() for SG buffer was dropped as it's problematic on
IOMMU systems.  OTOH, Xen PV has a different way, and it's fine to use
the dma_alloc_coherent().

This patch is a workaround for Xen PV.  It consists of the following
changes:
- For Xen PV, use only the fallback allocation without
  dma_alloc_noncontiguous()
- In the fallback allocation, use dma_alloc_coherent();
  the DMA address from dma_alloc_coherent() is returned in get_addr
  ops
- The DMA addresses are stored in an array; the first entry stores the
  number of allocated pages in lower bits, which are referred at
  releasing pages again

Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Tested-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Fixes: a8d302a0b770 ("ALSA: memalloc: Revive x86-specific WC page allocations again")
Fixes: 9736a325137b ("ALSA: memalloc: Don't fall back for SG-buffer with IOMMU")
Link: https://lore.kernel.org/r/87tu256lqs.wl-tiwai@suse.de
Link: https://lore.kernel.org/r/20230125153104.5527-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/memalloc.c | 87 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 69 insertions(+), 18 deletions(-)

diff --git a/sound/core/memalloc.c b/sound/core/memalloc.c
index 7268304009ad..11ff1ee51345 100644
--- a/sound/core/memalloc.c
+++ b/sound/core/memalloc.c
@@ -542,16 +542,15 @@ static void *snd_dma_noncontig_alloc(struct snd_dma_buffer *dmab, size_t size)
 	struct sg_table *sgt;
 	void *p;
 
+#ifdef CONFIG_SND_DMA_SGBUF
+	if (cpu_feature_enabled(X86_FEATURE_XENPV))
+		return snd_dma_sg_fallback_alloc(dmab, size);
+#endif
 	sgt = dma_alloc_noncontiguous(dmab->dev.dev, size, dmab->dev.dir,
 				      DEFAULT_GFP, 0);
 #ifdef CONFIG_SND_DMA_SGBUF
-	if (!sgt && !get_dma_ops(dmab->dev.dev)) {
-		if (dmab->dev.type == SNDRV_DMA_TYPE_DEV_WC_SG)
-			dmab->dev.type = SNDRV_DMA_TYPE_DEV_WC_SG_FALLBACK;
-		else
-			dmab->dev.type = SNDRV_DMA_TYPE_DEV_SG_FALLBACK;
+	if (!sgt && !get_dma_ops(dmab->dev.dev))
 		return snd_dma_sg_fallback_alloc(dmab, size);
-	}
 #endif
 	if (!sgt)
 		return NULL;
@@ -718,19 +717,38 @@ static const struct snd_malloc_ops snd_dma_sg_wc_ops = {
 
 /* Fallback SG-buffer allocations for x86 */
 struct snd_dma_sg_fallback {
+	bool use_dma_alloc_coherent;
 	size_t count;
 	struct page **pages;
+	/* DMA address array; the first page contains #pages in ~PAGE_MASK */
+	dma_addr_t *addrs;
 };
 
 static void __snd_dma_sg_fallback_free(struct snd_dma_buffer *dmab,
 				       struct snd_dma_sg_fallback *sgbuf)
 {
-	bool wc = dmab->dev.type == SNDRV_DMA_TYPE_DEV_WC_SG_FALLBACK;
-	size_t i;
-
-	for (i = 0; i < sgbuf->count && sgbuf->pages[i]; i++)
-		do_free_pages(page_address(sgbuf->pages[i]), PAGE_SIZE, wc);
+	size_t i, size;
+
+	if (sgbuf->pages && sgbuf->addrs) {
+		i = 0;
+		while (i < sgbuf->count) {
+			if (!sgbuf->pages[i] || !sgbuf->addrs[i])
+				break;
+			size = sgbuf->addrs[i] & ~PAGE_MASK;
+			if (WARN_ON(!size))
+				break;
+			if (sgbuf->use_dma_alloc_coherent)
+				dma_free_coherent(dmab->dev.dev, size << PAGE_SHIFT,
+						  page_address(sgbuf->pages[i]),
+						  sgbuf->addrs[i] & PAGE_MASK);
+			else
+				do_free_pages(page_address(sgbuf->pages[i]),
+					      size << PAGE_SHIFT, false);
+			i += size;
+		}
+	}
 	kvfree(sgbuf->pages);
+	kvfree(sgbuf->addrs);
 	kfree(sgbuf);
 }
 
@@ -739,24 +757,36 @@ static void *snd_dma_sg_fallback_alloc(struct snd_dma_buffer *dmab, size_t size)
 	struct snd_dma_sg_fallback *sgbuf;
 	struct page **pagep, *curp;
 	size_t chunk, npages;
+	dma_addr_t *addrp;
 	dma_addr_t addr;
 	void *p;
-	bool wc = dmab->dev.type == SNDRV_DMA_TYPE_DEV_WC_SG_FALLBACK;
+
+	/* correct the type */
+	if (dmab->dev.type == SNDRV_DMA_TYPE_DEV_SG)
+		dmab->dev.type = SNDRV_DMA_TYPE_DEV_SG_FALLBACK;
+	else if (dmab->dev.type == SNDRV_DMA_TYPE_DEV_WC_SG)
+		dmab->dev.type = SNDRV_DMA_TYPE_DEV_WC_SG_FALLBACK;
 
 	sgbuf = kzalloc(sizeof(*sgbuf), GFP_KERNEL);
 	if (!sgbuf)
 		return NULL;
+	sgbuf->use_dma_alloc_coherent = cpu_feature_enabled(X86_FEATURE_XENPV);
 	size = PAGE_ALIGN(size);
 	sgbuf->count = size >> PAGE_SHIFT;
 	sgbuf->pages = kvcalloc(sgbuf->count, sizeof(*sgbuf->pages), GFP_KERNEL);
-	if (!sgbuf->pages)
+	sgbuf->addrs = kvcalloc(sgbuf->count, sizeof(*sgbuf->addrs), GFP_KERNEL);
+	if (!sgbuf->pages || !sgbuf->addrs)
 		goto error;
 
 	pagep = sgbuf->pages;
-	chunk = size;
+	addrp = sgbuf->addrs;
+	chunk = (PAGE_SIZE - 1) << PAGE_SHIFT; /* to fit in low bits in addrs */
 	while (size > 0) {
 		chunk = min(size, chunk);
-		p = do_alloc_pages(dmab->dev.dev, chunk, &addr, wc);
+		if (sgbuf->use_dma_alloc_coherent)
+			p = dma_alloc_coherent(dmab->dev.dev, chunk, &addr, DEFAULT_GFP);
+		else
+			p = do_alloc_pages(dmab->dev.dev, chunk, &addr, false);
 		if (!p) {
 			if (chunk <= PAGE_SIZE)
 				goto error;
@@ -768,17 +798,25 @@ static void *snd_dma_sg_fallback_alloc(struct snd_dma_buffer *dmab, size_t size)
 		size -= chunk;
 		/* fill pages */
 		npages = chunk >> PAGE_SHIFT;
+		*addrp = npages; /* store in lower bits */
 		curp = virt_to_page(p);
-		while (npages--)
+		while (npages--) {
 			*pagep++ = curp++;
+			*addrp++ |= addr;
+			addr += PAGE_SIZE;
+		}
 	}
 
 	p = vmap(sgbuf->pages, sgbuf->count, VM_MAP, PAGE_KERNEL);
 	if (!p)
 		goto error;
+
+	if (dmab->dev.type == SNDRV_DMA_TYPE_DEV_WC_SG_FALLBACK)
+		set_pages_array_wc(sgbuf->pages, sgbuf->count);
+
 	dmab->private_data = sgbuf;
 	/* store the first page address for convenience */
-	dmab->addr = snd_sgbuf_get_addr(dmab, 0);
+	dmab->addr = sgbuf->addrs[0] & PAGE_MASK;
 	return p;
 
  error:
@@ -788,10 +826,23 @@ static void *snd_dma_sg_fallback_alloc(struct snd_dma_buffer *dmab, size_t size)
 
 static void snd_dma_sg_fallback_free(struct snd_dma_buffer *dmab)
 {
+	struct snd_dma_sg_fallback *sgbuf = dmab->private_data;
+
+	if (dmab->dev.type == SNDRV_DMA_TYPE_DEV_WC_SG_FALLBACK)
+		set_pages_array_wb(sgbuf->pages, sgbuf->count);
 	vunmap(dmab->area);
 	__snd_dma_sg_fallback_free(dmab, dmab->private_data);
 }
 
+static dma_addr_t snd_dma_sg_fallback_get_addr(struct snd_dma_buffer *dmab,
+					       size_t offset)
+{
+	struct snd_dma_sg_fallback *sgbuf = dmab->private_data;
+	size_t index = offset >> PAGE_SHIFT;
+
+	return (sgbuf->addrs[index] & PAGE_MASK) | (offset & ~PAGE_MASK);
+}
+
 static int snd_dma_sg_fallback_mmap(struct snd_dma_buffer *dmab,
 				    struct vm_area_struct *area)
 {
@@ -806,8 +857,8 @@ static const struct snd_malloc_ops snd_dma_sg_fallback_ops = {
 	.alloc = snd_dma_sg_fallback_alloc,
 	.free = snd_dma_sg_fallback_free,
 	.mmap = snd_dma_sg_fallback_mmap,
+	.get_addr = snd_dma_sg_fallback_get_addr,
 	/* reuse vmalloc helpers */
-	.get_addr = snd_dma_vmalloc_get_addr,
 	.get_page = snd_dma_vmalloc_get_page,
 	.get_chunk_size = snd_dma_vmalloc_get_chunk_size,
 };
-- 
2.39.0



