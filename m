Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1619E4BDF76
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352046AbiBUJws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:52:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351948AbiBUJu7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:50:59 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34B9635DC4;
        Mon, 21 Feb 2022 01:22:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 98485CE0E99;
        Mon, 21 Feb 2022 09:22:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84606C340E9;
        Mon, 21 Feb 2022 09:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435366;
        bh=xfTfLuBCLxsgTOACm1b1I3fjPekjhfu0XQvZqy8k79U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JmLk2liX8zhN01ktOv8l/sVSPUANJJyLJEKI8qUMdHv6fA9ddW0+oy7ZvL8tnwVGI
         zwQNm4JV0FORBjiD0l9yErD+M8DcByh6nIGQkJq1cNk3b43sd3OzG8v2e+m6+UE6od
         1B76DyZ1UPHUKQLQ27qI+m5w/SfFpZqLt/Vf93a8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.16 138/227] ALSA: memalloc: invalidate SG pages before sync
Date:   Mon, 21 Feb 2022 09:49:17 +0100
Message-Id: <20220221084939.433297721@linuxfoundation.org>
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

commit 3e16dc50d77dc3494275a241fac250c94bf45206 upstream.

It seems that calling invalidate_kernel_vmap_range() is more correct
to be called before dma_sync_*(), judging from the other thread:
  https://lore.kernel.org/all/20220111085958.GA22795@lst.de/
Although this won't matter much in practice, let's fix the call order
for consistency.

Fixes: a25684a95646 ("ALSA: memalloc: Support for non-contiguous page allocation")
Reported-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220210123344.8756-3-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/memalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/core/memalloc.c
+++ b/sound/core/memalloc.c
@@ -541,9 +541,9 @@ static void snd_dma_noncontig_sync(struc
 	if (mode == SNDRV_DMA_SYNC_CPU) {
 		if (dmab->dev.dir == DMA_TO_DEVICE)
 			return;
+		invalidate_kernel_vmap_range(dmab->area, dmab->bytes);
 		dma_sync_sgtable_for_cpu(dmab->dev.dev, dmab->private_data,
 					 dmab->dev.dir);
-		invalidate_kernel_vmap_range(dmab->area, dmab->bytes);
 	} else {
 		if (dmab->dev.dir == DMA_FROM_DEVICE)
 			return;


