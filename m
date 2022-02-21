Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4F7B4BDF8E
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351798AbiBUJwc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:52:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351839AbiBUJu5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:50:57 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 373E53585D;
        Mon, 21 Feb 2022 01:22:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A9752CE0E8B;
        Mon, 21 Feb 2022 09:22:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C9DC340E9;
        Mon, 21 Feb 2022 09:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435363;
        bh=CR4l46/IqzhLQBb9TQNJLxDYZnoC4UCPekjfutuynBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oNisao6eBaHJFLIiFuzjxRcRrkgDjaCzq0E64uzaNxKTXkLUEBJaUfqyE7Hx2Os0O
         46Jl9f8gyOlhC5ybHYe2b/OXfjv5D9QyEiJ/LI/3M2XcyAU+MUq0CLdu0lXdTP/d6t
         FXh/v0F99gEsoLqPNJyMIoohFHklYLmhuCjWCgpA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.16 137/227] ALSA: memalloc: Fix dma_need_sync() checks
Date:   Mon, 21 Feb 2022 09:49:16 +0100
Message-Id: <20220221084939.401058573@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
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

commit 8e1741c658996a16bd096e077dae0da2460a997f upstream.

dma_need_sync() checks each DMA address.  Fix the incorrect usages
for non-contiguous and non-coherent page allocations.
Fortunately, there are no actual call sites that need manual syncs
yet.

Fixes: a25684a95646 ("ALSA: memalloc: Support for non-contiguous page allocation")
Fixes: 73325f60e2ed ("ALSA: memalloc: Support for non-coherent page allocation")
Cc: <stable@vger.kernel.org>
Reported-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Link: https://lore.kernel.org/r/20220210123344.8756-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/memalloc.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/sound/core/memalloc.c
+++ b/sound/core/memalloc.c
@@ -511,7 +511,8 @@ static void *snd_dma_noncontig_alloc(str
 				      DEFAULT_GFP, 0);
 	if (!sgt)
 		return NULL;
-	dmab->dev.need_sync = dma_need_sync(dmab->dev.dev, dmab->dev.dir);
+	dmab->dev.need_sync = dma_need_sync(dmab->dev.dev,
+					    sg_dma_address(sgt->sgl));
 	p = dma_vmap_noncontiguous(dmab->dev.dev, size, sgt);
 	if (p)
 		dmab->private_data = sgt;
@@ -625,9 +626,13 @@ static const struct snd_malloc_ops snd_d
  */
 static void *snd_dma_noncoherent_alloc(struct snd_dma_buffer *dmab, size_t size)
 {
-	dmab->dev.need_sync = dma_need_sync(dmab->dev.dev, dmab->dev.dir);
-	return dma_alloc_noncoherent(dmab->dev.dev, size, &dmab->addr,
-				     dmab->dev.dir, DEFAULT_GFP);
+	void *p;
+
+	p = dma_alloc_noncoherent(dmab->dev.dev, size, &dmab->addr,
+				  dmab->dev.dir, DEFAULT_GFP);
+	if (p)
+		dmab->dev.need_sync = dma_need_sync(dmab->dev.dev, dmab->addr);
+	return p;
 }
 
 static void snd_dma_noncoherent_free(struct snd_dma_buffer *dmab)


