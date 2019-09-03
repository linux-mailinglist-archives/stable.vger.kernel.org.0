Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA87A6E8E
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730729AbfICQ0w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:26:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:47964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730725AbfICQ0v (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:26:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91511238C5;
        Tue,  3 Sep 2019 16:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528011;
        bh=IDegn3PA5hO68dkXxmfnYOmtBRQOB+r1GrT3sBEHpmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wCZXqinraaRzNmx7nhj7DvbnWaAMutnvb+qZUS0eV5h2E0Hsc2HLLMKWt23TskIPn
         Zz2xiTG8kLOBtnybQs0m439SxjnxXDys4hv9XvQKsmNx6WyOzdlJKSI/zabszKPwAU
         TZa3iFGuz3rOQtnqErw4vLM++qm4Wd5Nl/X+1d8Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ricardo Biehl Pasquali <pasqualirb@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 052/167] ALSA: pcm: Update hardware pointer before start capture
Date:   Tue,  3 Sep 2019 12:23:24 -0400
Message-Id: <20190903162519.7136-52-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricardo Biehl Pasquali <pasqualirb@gmail.com>

[ Upstream commit 64b6acf60b665fffd419c23886a1cbeeb253cfb4 ]

This ensures the transfer loop won't waste a run to read
the few frames (if any) between start and hw_ptr update.
It will wait for the next interrupt with wait_for_avail().

Signed-off-by: Ricardo Biehl Pasquali <pasqualirb@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/pcm_lib.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index 7f71c2449af5e..40013b26f6719 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -2172,6 +2172,10 @@ snd_pcm_sframes_t __snd_pcm_lib_xfer(struct snd_pcm_substream *substream,
 	if (err < 0)
 		goto _end_unlock;
 
+	runtime->twake = runtime->control->avail_min ? : 1;
+	if (runtime->status->state == SNDRV_PCM_STATE_RUNNING)
+		snd_pcm_update_hw_ptr(substream);
+
 	if (!is_playback &&
 	    runtime->status->state == SNDRV_PCM_STATE_PREPARED) {
 		if (size >= runtime->start_threshold) {
@@ -2185,10 +2189,8 @@ snd_pcm_sframes_t __snd_pcm_lib_xfer(struct snd_pcm_substream *substream,
 		}
 	}
 
-	runtime->twake = runtime->control->avail_min ? : 1;
-	if (runtime->status->state == SNDRV_PCM_STATE_RUNNING)
-		snd_pcm_update_hw_ptr(substream);
 	avail = snd_pcm_avail(substream);
+
 	while (size > 0) {
 		snd_pcm_uframes_t frames, appl_ptr, appl_ofs;
 		snd_pcm_uframes_t cont;
-- 
2.20.1

