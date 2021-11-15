Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA12451E4A
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354388AbhKPAfj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:35:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:45408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344784AbhKOTZ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B380636C7;
        Mon, 15 Nov 2021 19:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003064;
        bh=6uyj2ksn8jh958jNOjQMXDZ3WJRB1H63zstpoGPXMNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CaDuGjHl3J1FmOV3kPlkJ0H0YDWiAM3Y6/upHRT5kiIhu0dz5cLHV01V8h1aW8xDZ
         B5awAibZc363Ew8eGbEdjrE1Iw3iqzqEnCtTtOWthk1d3pXbvrQVvPQKhpegCrReJg
         tDI49oH6PzxOzGOlVNvqChdT+cDtcGEiK9osaZv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 797/917] ALSA: memalloc: Catch call with NULL snd_dma_buffer pointer
Date:   Mon, 15 Nov 2021 18:04:52 +0100
Message-Id: <20211115165455.998603907@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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
index 0b8a1c3eae1b4..2d842982576bb 100644
--- a/sound/core/memalloc.c
+++ b/sound/core/memalloc.c
@@ -494,6 +494,8 @@ static const struct snd_malloc_ops *dma_ops[] = {
 
 static const struct snd_malloc_ops *snd_dma_get_ops(struct snd_dma_buffer *dmab)
 {
+	if (WARN_ON_ONCE(!dmab))
+		return NULL;
 	if (WARN_ON_ONCE(dmab->dev.type <= SNDRV_DMA_TYPE_UNKNOWN ||
 			 dmab->dev.type >= ARRAY_SIZE(dma_ops)))
 		return NULL;
-- 
2.33.0



