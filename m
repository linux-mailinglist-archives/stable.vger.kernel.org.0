Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0136280C8
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237895AbiKNNJJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:09:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237899AbiKNNJI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:09:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B232286E1
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:09:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E83D61173
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:09:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF1AC43145;
        Mon, 14 Nov 2022 13:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431343;
        bh=PemF1ztsgcleE5o8XB94GCG8j63qHD4aUCC0hDkY8hg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u6sacdFriQJTznepEgM+BfU+lrTVOBoTBvRA7uPkL9aLWCDQYy6xq4XsY/BdwF+3W
         k9/GoN+dwK4S1eO2uCdhbxjE58wSjS8ouT2wq2fWpQvUAYngWjKpPjLYLpErInyWUJ
         lltK600bbidweVNopUkXosDvLuBSh/+a5OVO5I84=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.0 190/190] ALSA: memalloc: Try dma_alloc_noncontiguous() at first
Date:   Mon, 14 Nov 2022 13:46:54 +0100
Message-Id: <20221114124507.205540389@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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

commit 9d8e536d36e75e76614fe09ffab9a1df95b8b666 upstream.

The latest fix for the non-contiguous memalloc helper changed the
allocation method for a non-IOMMU system to use only the fallback
allocator.  This should have worked, but it caused a problem sometimes
when too many non-contiguous pages are allocated that can't be treated
by HD-audio controller.

As a quirk workaround, go back to the original strategy: use
dma_alloc_noncontiguous() at first, and apply the fallback only when
it fails, but only for non-IOMMU case.

We'll need a better fix in the fallback code as well, but this
workaround should paper over most cases.

Fixes: 9736a325137b ("ALSA: memalloc: Don't fall back for SG-buffer with IOMMU")
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/CAHk-=wgSH5ubdvt76gNwa004ooZAEJL_1Q-Fyw5M2FDdqL==dg@mail.gmail.com
Link: https://lore.kernel.org/r/20221112084718.3305-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/memalloc.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/sound/core/memalloc.c
+++ b/sound/core/memalloc.c
@@ -527,8 +527,10 @@ static void *snd_dma_noncontig_alloc(str
 	struct sg_table *sgt;
 	void *p;
 
+	sgt = dma_alloc_noncontiguous(dmab->dev.dev, size, dmab->dev.dir,
+				      DEFAULT_GFP, 0);
 #ifdef CONFIG_SND_DMA_SGBUF
-	if (!get_dma_ops(dmab->dev.dev)) {
+	if (!sgt && !get_dma_ops(dmab->dev.dev)) {
 		if (dmab->dev.type == SNDRV_DMA_TYPE_DEV_WC_SG)
 			dmab->dev.type = SNDRV_DMA_TYPE_DEV_WC_SG_FALLBACK;
 		else
@@ -536,9 +538,6 @@ static void *snd_dma_noncontig_alloc(str
 		return snd_dma_sg_fallback_alloc(dmab, size);
 	}
 #endif
-
-	sgt = dma_alloc_noncontiguous(dmab->dev.dev, size, dmab->dev.dir,
-				      DEFAULT_GFP, 0);
 	if (!sgt)
 		return NULL;
 


