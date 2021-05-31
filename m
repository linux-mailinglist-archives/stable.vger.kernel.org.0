Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739D2396072
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232137AbhEaO1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:27:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233435AbhEaOZC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:25:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DABA61625;
        Mon, 31 May 2021 13:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468777;
        bh=1IYDyVXakbWlqPPxz3zhjImOYU2dRk9Db7ijwLOxpIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NP9fnwonYYrycWtgEnenBFoeHqcK3tVIP579c2Q8ieAAdGYDmFMTXLNcqFahAegjV
         SX6hJCTBw89osK6X6YRBw1jiXxu7S6GWalCTcg8q6MUX1ZdRWgwH48XLjm5Tz+YyUG
         uijO8h7kPV2QMlokw3TVKAWlIWvjWxQeiCxznjm0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aditya Pakki <pakki001@umn.edu>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 089/177] Revert "ALSA: sb: fix a missing check of snd_ctl_add"
Date:   Mon, 31 May 2021 15:14:06 +0200
Message-Id: <20210531130650.969801268@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 4b059ce1f4b368208c2310925f49be77f15e527b ]

This reverts commit beae77170c60aa786f3e4599c18ead2854d8694d.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It is safe to ignore this error as the
mixer element is optional, and the driver is very legacy.

Cc: Aditya Pakki <pakki001@umn.edu>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20210503115736.2104747-8-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/isa/sb/sb16_main.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/sound/isa/sb/sb16_main.c b/sound/isa/sb/sb16_main.c
index 0768bbf8fd71..679f9f48370f 100644
--- a/sound/isa/sb/sb16_main.c
+++ b/sound/isa/sb/sb16_main.c
@@ -864,14 +864,10 @@ int snd_sb16dsp_pcm(struct snd_sb *chip, int device)
 	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_PLAYBACK, &snd_sb16_playback_ops);
 	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &snd_sb16_capture_ops);
 
-	if (chip->dma16 >= 0 && chip->dma8 != chip->dma16) {
-		err = snd_ctl_add(card, snd_ctl_new1(
-					&snd_sb16_dma_control, chip));
-		if (err)
-			return err;
-	} else {
+	if (chip->dma16 >= 0 && chip->dma8 != chip->dma16)
+		snd_ctl_add(card, snd_ctl_new1(&snd_sb16_dma_control, chip));
+	else
 		pcm->info_flags = SNDRV_PCM_INFO_HALF_DUPLEX;
-	}
 
 	snd_pcm_lib_preallocate_pages_for_all(pcm, SNDRV_DMA_TYPE_DEV,
 					      card->dev,
-- 
2.30.2



