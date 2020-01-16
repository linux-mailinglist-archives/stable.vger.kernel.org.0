Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8F8713F594
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388861AbgAPS5O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:57:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:38478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389080AbgAPRHH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:07:07 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26D1A205F4;
        Thu, 16 Jan 2020 17:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194427;
        bh=bogbFyIWYY0db2aF3q1qJ65vkmKxitFEOw8bigE2K2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tuGnI9+czYv1YxtcZIhxBfWZ7DHtTrQ9ehTc9NPg7xsXjqBqz7gloCuDHCPjX0MUT
         C7zqO37tfqZmZfeFGszhapJhCVtKTwiEWZyTIdTr2sWI47jewm76XTHd163+mAz4oV
         Zu/2iIFcb5j9nCg1+iEFbMTKolUOu5F/SSAGmXic=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 344/671] ALSA: aica: Fix a long-time build breakage
Date:   Thu, 16 Jan 2020 11:59:42 -0500
Message-Id: <20200116170509.12787-81-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 534420c6ff87d3052540f1fd346e0adcff440819 ]

The build of aica sound driver has been broken since the timer API
conversion and some code rewrite.  This patch fixes the breakage by
using the common substream field, as well as a bit cleaning up wrt the
timer handling in the code.

Fixes: d522bb6a105f ("ALSA: sh: aica: Convert timers to use timer_setup()")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/sh/aica.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/sound/sh/aica.c b/sound/sh/aica.c
index 2b26311405a4..ad3f71358486 100644
--- a/sound/sh/aica.c
+++ b/sound/sh/aica.c
@@ -303,7 +303,7 @@ static void aica_period_elapsed(struct timer_list *t)
 {
 	struct snd_card_aica *dreamcastcard = from_timer(dreamcastcard,
 							      t, timer);
-	struct snd_pcm_substream *substream = dreamcastcard->timer_substream;
+	struct snd_pcm_substream *substream = dreamcastcard->substream;
 	/*timer function - so cannot sleep */
 	int play_period;
 	struct snd_pcm_runtime *runtime;
@@ -335,13 +335,6 @@ static void spu_begin_dma(struct snd_pcm_substream *substream)
 	dreamcastcard = substream->pcm->private_data;
 	/*get the queue to do the work */
 	schedule_work(&(dreamcastcard->spu_dma_work));
-	/* Timer may already be running */
-	if (unlikely(dreamcastcard->timer_substream)) {
-		mod_timer(&dreamcastcard->timer, jiffies + 4);
-		return;
-	}
-	timer_setup(&dreamcastcard->timer, aica_period_elapsed, 0);
-	dreamcastcard->timer_substream = substream;
 	mod_timer(&dreamcastcard->timer, jiffies + 4);
 }
 
@@ -379,8 +372,8 @@ static int snd_aicapcm_pcm_close(struct snd_pcm_substream
 {
 	struct snd_card_aica *dreamcastcard = substream->pcm->private_data;
 	flush_work(&(dreamcastcard->spu_dma_work));
-	if (dreamcastcard->timer_substream)
-		del_timer(&dreamcastcard->timer);
+	del_timer(&dreamcastcard->timer);
+	dreamcastcard->substream = NULL;
 	kfree(dreamcastcard->channel);
 	spu_disable();
 	return 0;
@@ -615,6 +608,7 @@ static int snd_aica_probe(struct platform_device *devptr)
 	       "Yamaha AICA Super Intelligent Sound Processor for SEGA Dreamcast");
 	/* Prepare to use the queue */
 	INIT_WORK(&(dreamcastcard->spu_dma_work), run_spu_dma);
+	timer_setup(&dreamcastcard->timer, aica_period_elapsed, 0);
 	/* Load the PCM 'chip' */
 	err = snd_aicapcmchip(dreamcastcard, 0);
 	if (unlikely(err < 0))
-- 
2.20.1

