Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D22FF5AEB7F
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241567AbiIFOUm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241676AbiIFOSl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:18:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF469646D;
        Tue,  6 Sep 2022 06:49:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51B8F61560;
        Tue,  6 Sep 2022 13:48:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B620C433D7;
        Tue,  6 Sep 2022 13:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662472087;
        bh=Rr569hUgXFWwrded8fCCRwY13H6i6sv/yyxd3lIoth8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uDsyxdSF2anWRDu+h84LtYjYqDrZk2oEHTP+U96lWO+JX3FemdAezP4RZHU8kxy9F
         aWqUjCO4xa63emRbheZKEFTlbQvSgLG3nTHIl2XEOKlHqn28rqkXnf0CZ9YMT3O390
         iQZ8IWstymW21scDqu/DwNCeDSs6ziwNPcX2oo9s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.19 144/155] ALSA: memalloc: Revive x86-specific WC page allocations again
Date:   Tue,  6 Sep 2022 15:31:32 +0200
Message-Id: <20220906132835.519491211@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit a8d302a0b77057568350fe0123e639d02dba0745 upstream.

We dropped the x86-specific hack for WC-page allocations with a hope
that the standard dma_alloc_wc() works nowadays.  Alas, it doesn't,
and we need to take back some workaround again, but in a different
form, as the previous one was broken for some platforms.

This patch re-introduces the x86-specific WC-page allocations, but it
uses rather the manual page allocations instead of
dma_alloc_coherent().  The use of dma_alloc_coherent() was also a
potential problem in the recent addition of the fallback allocation
for noncontig pages, and this patch eliminates both at once.

Fixes: 9882d63bea14 ("ALSA: memalloc: Drop x86-specific hack for WC allocations")
Cc: <stable@vger.kernel.org>
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=216363
Link: https://lore.kernel.org/r/20220821155911.10715-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/memalloc.c |   87 ++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 71 insertions(+), 16 deletions(-)

--- a/sound/core/memalloc.c
+++ b/sound/core/memalloc.c
@@ -20,6 +20,13 @@
 
 static const struct snd_malloc_ops *snd_dma_get_ops(struct snd_dma_buffer *dmab);
 
+#ifdef CONFIG_SND_DMA_SGBUF
+static void *do_alloc_fallback_pages(struct device *dev, size_t size,
+				     dma_addr_t *addr, bool wc);
+static void do_free_fallback_pages(void *p, size_t size, bool wc);
+static void *snd_dma_sg_fallback_alloc(struct snd_dma_buffer *dmab, size_t size);
+#endif
+
 /* a cast to gfp flag from the dev pointer; for CONTINUOUS and VMALLOC types */
 static inline gfp_t snd_mem_get_gfp_flags(const struct snd_dma_buffer *dmab,
 					  gfp_t default_gfp)
@@ -269,16 +276,21 @@ EXPORT_SYMBOL(snd_sgbuf_get_chunk_size);
 /*
  * Continuous pages allocator
  */
-static void *snd_dma_continuous_alloc(struct snd_dma_buffer *dmab, size_t size)
+static void *do_alloc_pages(size_t size, dma_addr_t *addr, gfp_t gfp)
 {
-	gfp_t gfp = snd_mem_get_gfp_flags(dmab, GFP_KERNEL);
 	void *p = alloc_pages_exact(size, gfp);
 
 	if (p)
-		dmab->addr = page_to_phys(virt_to_page(p));
+		*addr = page_to_phys(virt_to_page(p));
 	return p;
 }
 
+static void *snd_dma_continuous_alloc(struct snd_dma_buffer *dmab, size_t size)
+{
+	return do_alloc_pages(size, &dmab->addr,
+			      snd_mem_get_gfp_flags(dmab, GFP_KERNEL));
+}
+
 static void snd_dma_continuous_free(struct snd_dma_buffer *dmab)
 {
 	free_pages_exact(dmab->area, dmab->bytes);
@@ -455,6 +467,25 @@ static const struct snd_malloc_ops snd_d
 /*
  * Write-combined pages
  */
+/* x86-specific allocations */
+#ifdef CONFIG_SND_DMA_SGBUF
+static void *snd_dma_wc_alloc(struct snd_dma_buffer *dmab, size_t size)
+{
+	return do_alloc_fallback_pages(dmab->dev.dev, size, &dmab->addr, true);
+}
+
+static void snd_dma_wc_free(struct snd_dma_buffer *dmab)
+{
+	do_free_fallback_pages(dmab->area, dmab->bytes, true);
+}
+
+static int snd_dma_wc_mmap(struct snd_dma_buffer *dmab,
+			   struct vm_area_struct *area)
+{
+	area->vm_page_prot = pgprot_writecombine(area->vm_page_prot);
+	return snd_dma_continuous_mmap(dmab, area);
+}
+#else
 static void *snd_dma_wc_alloc(struct snd_dma_buffer *dmab, size_t size)
 {
 	return dma_alloc_wc(dmab->dev.dev, size, &dmab->addr, DEFAULT_GFP);
@@ -471,6 +502,7 @@ static int snd_dma_wc_mmap(struct snd_dm
 	return dma_mmap_wc(dmab->dev.dev, area,
 			   dmab->area, dmab->addr, dmab->bytes);
 }
+#endif /* CONFIG_SND_DMA_SGBUF */
 
 static const struct snd_malloc_ops snd_dma_wc_ops = {
 	.alloc = snd_dma_wc_alloc,
@@ -478,10 +510,6 @@ static const struct snd_malloc_ops snd_d
 	.mmap = snd_dma_wc_mmap,
 };
 
-#ifdef CONFIG_SND_DMA_SGBUF
-static void *snd_dma_sg_fallback_alloc(struct snd_dma_buffer *dmab, size_t size);
-#endif
-
 /*
  * Non-contiguous pages allocator
  */
@@ -661,6 +689,37 @@ static const struct snd_malloc_ops snd_d
 	.get_chunk_size = snd_dma_noncontig_get_chunk_size,
 };
 
+/* manual page allocations with wc setup */
+static void *do_alloc_fallback_pages(struct device *dev, size_t size,
+				     dma_addr_t *addr, bool wc)
+{
+	gfp_t gfp = GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN;
+	void *p;
+
+ again:
+	p = do_alloc_pages(size, addr, gfp);
+	if (!p || (*addr + size - 1) & ~dev->coherent_dma_mask) {
+		if (IS_ENABLED(CONFIG_ZONE_DMA32) && !(gfp & GFP_DMA32)) {
+			gfp |= GFP_DMA32;
+			goto again;
+		}
+		if (IS_ENABLED(CONFIG_ZONE_DMA) && !(gfp & GFP_DMA)) {
+			gfp = (gfp & ~GFP_DMA32) | GFP_DMA;
+			goto again;
+		}
+	}
+	if (p && wc)
+		set_memory_wc((unsigned long)(p), size >> PAGE_SHIFT);
+	return p;
+}
+
+static void do_free_fallback_pages(void *p, size_t size, bool wc)
+{
+	if (wc)
+		set_memory_wb((unsigned long)(p), size >> PAGE_SHIFT);
+	free_pages_exact(p, size);
+}
+
 /* Fallback SG-buffer allocations for x86 */
 struct snd_dma_sg_fallback {
 	size_t count;
@@ -671,14 +730,11 @@ struct snd_dma_sg_fallback {
 static void __snd_dma_sg_fallback_free(struct snd_dma_buffer *dmab,
 				       struct snd_dma_sg_fallback *sgbuf)
 {
+	bool wc = dmab->dev.type == SNDRV_DMA_TYPE_DEV_WC_SG_FALLBACK;
 	size_t i;
 
-	if (sgbuf->count && dmab->dev.type == SNDRV_DMA_TYPE_DEV_WC_SG_FALLBACK)
-		set_pages_array_wb(sgbuf->pages, sgbuf->count);
 	for (i = 0; i < sgbuf->count && sgbuf->pages[i]; i++)
-		dma_free_coherent(dmab->dev.dev, PAGE_SIZE,
-				  page_address(sgbuf->pages[i]),
-				  sgbuf->addrs[i]);
+		do_free_fallback_pages(page_address(sgbuf->pages[i]), PAGE_SIZE, wc);
 	kvfree(sgbuf->pages);
 	kvfree(sgbuf->addrs);
 	kfree(sgbuf);
@@ -690,6 +746,7 @@ static void *snd_dma_sg_fallback_alloc(s
 	struct page **pages;
 	size_t i, count;
 	void *p;
+	bool wc = dmab->dev.type == SNDRV_DMA_TYPE_DEV_WC_SG_FALLBACK;
 
 	sgbuf = kzalloc(sizeof(*sgbuf), GFP_KERNEL);
 	if (!sgbuf)
@@ -704,15 +761,13 @@ static void *snd_dma_sg_fallback_alloc(s
 		goto error;
 
 	for (i = 0; i < count; sgbuf->count++, i++) {
-		p = dma_alloc_coherent(dmab->dev.dev, PAGE_SIZE,
-				       &sgbuf->addrs[i], DEFAULT_GFP);
+		p = do_alloc_fallback_pages(dmab->dev.dev, PAGE_SIZE,
+					    &sgbuf->addrs[i], wc);
 		if (!p)
 			goto error;
 		sgbuf->pages[i] = virt_to_page(p);
 	}
 
-	if (dmab->dev.type == SNDRV_DMA_TYPE_DEV_WC_SG_FALLBACK)
-		set_pages_array_wc(pages, count);
 	p = vmap(pages, count, VM_MAP, PAGE_KERNEL);
 	if (!p)
 		goto error;


