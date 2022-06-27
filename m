Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95B1955D2B7
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237503AbiF0Lnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237445AbiF0Lmw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:42:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C732DA;
        Mon, 27 Jun 2022 04:38:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10D4DB8112E;
        Mon, 27 Jun 2022 11:38:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68AC6C3411D;
        Mon, 27 Jun 2022 11:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329880;
        bh=UXmXFvzp1JGZ0YZ7fIZD//KA9WBYK5mJVt6L9x5iplM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FJTysfYTwgwSzoj2lkfCSs+hK0zAfXRkOGrdL9rO3AkkDnKparwgMKO9e7uVLr1Hz
         oGT2N3eYhoKE70J27kIkWn25hAUiQahYoYsRLHrBKkbNmR4Q8Q4R39/nBRMz3pqdjD
         uY24eQpV+UUY5EUwvY8g8HcyC8WruANN9T+OHnMg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.18 003/181] ALSA: memalloc: Drop x86-specific hack for WC allocations
Date:   Mon, 27 Jun 2022 13:19:36 +0200
Message-Id: <20220627111944.658448755@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 9882d63bea14c8b3ed2c9360b9ab9f0e2f64ae2b upstream.

The recent report for a crash on Haswell machines implied that the
x86-specific (rather hackish) implementation for write-cache memory
buffer allocation in ALSA core is buggy with the recent kernel in some
corner cases.  This patch drops the x86-specific implementation and
uses the standard dma_alloc_wc() & co generically for avoiding the bug
and also for simplification.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=216112
Cc: <stable@vger.kernel.org> # v5.18+
Link: https://lore.kernel.org/r/20220620073440.7514-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/memalloc.c | 23 +----------------------
 1 file changed, 1 insertion(+), 22 deletions(-)

diff --git a/sound/core/memalloc.c b/sound/core/memalloc.c
index 15dc7160ba34..8cfdaee77905 100644
--- a/sound/core/memalloc.c
+++ b/sound/core/memalloc.c
@@ -431,33 +431,17 @@ static const struct snd_malloc_ops snd_dma_iram_ops = {
  */
 static void *snd_dma_dev_alloc(struct snd_dma_buffer *dmab, size_t size)
 {
-	void *p;
-
-	p = dma_alloc_coherent(dmab->dev.dev, size, &dmab->addr, DEFAULT_GFP);
-#ifdef CONFIG_X86
-	if (p && dmab->dev.type == SNDRV_DMA_TYPE_DEV_WC)
-		set_memory_wc((unsigned long)p, PAGE_ALIGN(size) >> PAGE_SHIFT);
-#endif
-	return p;
+	return dma_alloc_coherent(dmab->dev.dev, size, &dmab->addr, DEFAULT_GFP);
 }
 
 static void snd_dma_dev_free(struct snd_dma_buffer *dmab)
 {
-#ifdef CONFIG_X86
-	if (dmab->dev.type == SNDRV_DMA_TYPE_DEV_WC)
-		set_memory_wb((unsigned long)dmab->area,
-			      PAGE_ALIGN(dmab->bytes) >> PAGE_SHIFT);
-#endif
 	dma_free_coherent(dmab->dev.dev, dmab->bytes, dmab->area, dmab->addr);
 }
 
 static int snd_dma_dev_mmap(struct snd_dma_buffer *dmab,
 			    struct vm_area_struct *area)
 {
-#ifdef CONFIG_X86
-	if (dmab->dev.type == SNDRV_DMA_TYPE_DEV_WC)
-		area->vm_page_prot = pgprot_writecombine(area->vm_page_prot);
-#endif
 	return dma_mmap_coherent(dmab->dev.dev, area,
 				 dmab->area, dmab->addr, dmab->bytes);
 }
@@ -471,10 +455,6 @@ static const struct snd_malloc_ops snd_dma_dev_ops = {
 /*
  * Write-combined pages
  */
-#ifdef CONFIG_X86
-/* On x86, share the same ops as the standard dev ops */
-#define snd_dma_wc_ops	snd_dma_dev_ops
-#else /* CONFIG_X86 */
 static void *snd_dma_wc_alloc(struct snd_dma_buffer *dmab, size_t size)
 {
 	return dma_alloc_wc(dmab->dev.dev, size, &dmab->addr, DEFAULT_GFP);
@@ -497,7 +477,6 @@ static const struct snd_malloc_ops snd_dma_wc_ops = {
 	.free = snd_dma_wc_free,
 	.mmap = snd_dma_wc_mmap,
 };
-#endif /* CONFIG_X86 */
 
 #ifdef CONFIG_SND_DMA_SGBUF
 static void *snd_dma_sg_fallback_alloc(struct snd_dma_buffer *dmab, size_t size);
-- 
2.36.1



