Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03564657D68
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233240AbiL1Pm4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:42:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233559AbiL1Pmy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:42:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90BBC164BD
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:42:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F449B81719
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:42:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8558BC433EF;
        Wed, 28 Dec 2022 15:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242169;
        bh=fP9iVhai8b7ksel24MKxTL75UvR6QyulKdhlKWD2uco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EZrkf+tD1vouySU2XF4YlpqntLTAqcujGDQ4j9ERQ3XBd6DEpDuRj0roBuPDPDicW
         MdOZO79+q3ACodemxo8glQ1oeFYDYLX9GYnV2JGdmFdjxbzPj7KjqyBPzLUabs7ekK
         LtobJwEIR71MYXi9TFztdivAoL0ekCaueR7oSCz0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0337/1146] ALSA: memalloc: Allocate more contiguous pages for fallback case
Date:   Wed, 28 Dec 2022 15:31:16 +0100
Message-Id: <20221228144339.313002188@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit cc26516374065a34e10c9a8bf3e940e42cd96e2a ]

Currently the fallback SG allocation tries to allocate each single
page, and this tends to result in the reverse order of memory
addresses when large space is available at boot, as the kernel takes a
free page from the top to the bottom in the zone.  The end result
looks as if non-contiguous (although it actually is).  What's worse is
that it leads to an overflow of BDL entries for HD-audio.

For avoiding such a problem, this patch modifies the allocation code
slightly; now it tries to allocate the larger contiguous chunks as
much as possible, then reduces to the smaller chunks only if the
allocation failed -- a similar strategy as the existing
snd_dma_alloc_pages_fallback() function.

Along with the trick, drop the unused address array from
snd_dma_sg_fallback object.  It was needed in the past when
dma_alloc_coherent() was used, but with the standard page allocator,
it became superfluous and never referred.

Fixes: a8d302a0b770 ("ALSA: memalloc: Revive x86-specific WC page allocations again")
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20221114141658.29620-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/memalloc.c | 44 ++++++++++++++++++++++++++-----------------
 1 file changed, 27 insertions(+), 17 deletions(-)

diff --git a/sound/core/memalloc.c b/sound/core/memalloc.c
index ba095558b6d1..7268304009ad 100644
--- a/sound/core/memalloc.c
+++ b/sound/core/memalloc.c
@@ -720,7 +720,6 @@ static const struct snd_malloc_ops snd_dma_sg_wc_ops = {
 struct snd_dma_sg_fallback {
 	size_t count;
 	struct page **pages;
-	dma_addr_t *addrs;
 };
 
 static void __snd_dma_sg_fallback_free(struct snd_dma_buffer *dmab,
@@ -732,38 +731,49 @@ static void __snd_dma_sg_fallback_free(struct snd_dma_buffer *dmab,
 	for (i = 0; i < sgbuf->count && sgbuf->pages[i]; i++)
 		do_free_pages(page_address(sgbuf->pages[i]), PAGE_SIZE, wc);
 	kvfree(sgbuf->pages);
-	kvfree(sgbuf->addrs);
 	kfree(sgbuf);
 }
 
 static void *snd_dma_sg_fallback_alloc(struct snd_dma_buffer *dmab, size_t size)
 {
 	struct snd_dma_sg_fallback *sgbuf;
-	struct page **pages;
-	size_t i, count;
+	struct page **pagep, *curp;
+	size_t chunk, npages;
+	dma_addr_t addr;
 	void *p;
 	bool wc = dmab->dev.type == SNDRV_DMA_TYPE_DEV_WC_SG_FALLBACK;
 
 	sgbuf = kzalloc(sizeof(*sgbuf), GFP_KERNEL);
 	if (!sgbuf)
 		return NULL;
-	count = PAGE_ALIGN(size) >> PAGE_SHIFT;
-	pages = kvcalloc(count, sizeof(*pages), GFP_KERNEL);
-	if (!pages)
-		goto error;
-	sgbuf->pages = pages;
-	sgbuf->addrs = kvcalloc(count, sizeof(*sgbuf->addrs), GFP_KERNEL);
-	if (!sgbuf->addrs)
+	size = PAGE_ALIGN(size);
+	sgbuf->count = size >> PAGE_SHIFT;
+	sgbuf->pages = kvcalloc(sgbuf->count, sizeof(*sgbuf->pages), GFP_KERNEL);
+	if (!sgbuf->pages)
 		goto error;
 
-	for (i = 0; i < count; sgbuf->count++, i++) {
-		p = do_alloc_pages(dmab->dev.dev, PAGE_SIZE, &sgbuf->addrs[i], wc);
-		if (!p)
-			goto error;
-		sgbuf->pages[i] = virt_to_page(p);
+	pagep = sgbuf->pages;
+	chunk = size;
+	while (size > 0) {
+		chunk = min(size, chunk);
+		p = do_alloc_pages(dmab->dev.dev, chunk, &addr, wc);
+		if (!p) {
+			if (chunk <= PAGE_SIZE)
+				goto error;
+			chunk >>= 1;
+			chunk = PAGE_SIZE << get_order(chunk);
+			continue;
+		}
+
+		size -= chunk;
+		/* fill pages */
+		npages = chunk >> PAGE_SHIFT;
+		curp = virt_to_page(p);
+		while (npages--)
+			*pagep++ = curp++;
 	}
 
-	p = vmap(pages, count, VM_MAP, PAGE_KERNEL);
+	p = vmap(sgbuf->pages, sgbuf->count, VM_MAP, PAGE_KERNEL);
 	if (!p)
 		goto error;
 	dmab->private_data = sgbuf;
-- 
2.35.1



