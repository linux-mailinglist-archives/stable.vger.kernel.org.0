Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC0B3ED59B
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239714AbhHPNM1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:12:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:57930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237030AbhHPNHq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:07:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E8636329F;
        Mon, 16 Aug 2021 13:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119211;
        bh=0wFex56x9zGW4ILxq/9Ivh/TBBYX0BFnfMEZ164d5Ag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2TcDd8DXCniKt+uqnXEKAQkZu7XdkMCoDwU+pwNc98MqlEeZR5IIBVrCTULL5Y7hN
         DSyj+pjtWLrK0RL3WXI70Ceiq2GG+o8MTt0jX6lLoC43dR2+12EqK70N1juCkGotkU
         CTcXm6mY0b3pBWnZmsSobIR2NXUuU1Q/tULmekJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 07/96] ASoC: uniphier: Fix reference to PCM buffer address
Date:   Mon, 16 Aug 2021 15:01:17 +0200
Message-Id: <20210816125435.179384032@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125434.948010115@linuxfoundation.org>
References: <20210816125434.948010115@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 827f3164aaa579eee6fd50c6654861d54f282a11 upstream.

Along with the transition to the managed PCM buffers, the driver now
accepts the dynamically allocated buffer, while it still kept the
reference to the old preallocated buffer address.  This patch corrects
to the right reference via runtime->dma_addr.

(Although this might have been already buggy before the cleanup with
the managed buffer, let's put Fixes tag to point that; it's a corner
case, after all.)

Fixes: d55894bc2763 ("ASoC: uniphier: Use managed buffer allocation")
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20210728112353.6675-5-tiwai@suse.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/uniphier/aio-dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/uniphier/aio-dma.c
+++ b/sound/soc/uniphier/aio-dma.c
@@ -198,7 +198,7 @@ static int uniphier_aiodma_mmap(struct s
 	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
 
 	return remap_pfn_range(vma, vma->vm_start,
-			       substream->dma_buffer.addr >> PAGE_SHIFT,
+			       substream->runtime->dma_addr >> PAGE_SHIFT,
 			       vma->vm_end - vma->vm_start, vma->vm_page_prot);
 }
 


