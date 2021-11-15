Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 821C9451294
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346933AbhKOThp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:37:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:44640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244827AbhKOTRh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:17:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1556763427;
        Mon, 15 Nov 2021 18:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000658;
        bh=E9TGLs9oSovW9p3RtBn/5jKBgQduH2TL3SKteHMoLE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JAwWB+nhytmO+4rJXEXD1mQH90GDHtLyaW99N8cMG60XTH1cNTyKQeZj4TOGh0a8O
         I6tOtuOwnc1XUbLOOuGZ1ohq0OEjw2nQoUabnRZDahOresg4ixAGZ95sw+UuH1661A
         Uz96lEC6sX6l4s7ktTrnNHKPst9SN5EeuVwoBgTc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 741/849] ALSA: memalloc: Catch call with NULL snd_dma_buffer pointer
Date:   Mon, 15 Nov 2021 18:03:44 +0100
Message-Id: <20211115165445.318711597@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit dce9446192439eaac81c21f517325fb473735e53 ]

Although we've covered all calls with NULL dma buffer pointer, so far,
there may be still some else in the wild.  For catching such a case
more easily, add a WARN_ON_ONCE() in snd_dma_get_ops().

Fixes: 37af81c5998f ("ALSA: core: Abstract memory alloc helpers")
Link: https://lore.kernel.org/r/20211105102103.28148-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/memalloc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/core/memalloc.c b/sound/core/memalloc.c
index 05e3a2bcbea7d..fcb082b4e6bd3 100644
--- a/sound/core/memalloc.c
+++ b/sound/core/memalloc.c
@@ -403,6 +403,8 @@ static const struct snd_malloc_ops *dma_ops[] = {
 
 static const struct snd_malloc_ops *snd_dma_get_ops(struct snd_dma_buffer *dmab)
 {
+	if (WARN_ON_ONCE(!dmab))
+		return NULL;
 	if (WARN_ON_ONCE(dmab->dev.type <= SNDRV_DMA_TYPE_UNKNOWN ||
 			 dmab->dev.type >= ARRAY_SIZE(dma_ops)))
 		return NULL;
-- 
2.33.0



