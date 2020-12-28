Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4902E430F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405220AbgL1NzZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:55:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:57034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405213AbgL1NzX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:55:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F0352078D;
        Mon, 28 Dec 2020 13:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163682;
        bh=Y9hoCFoMDxo/rlkjSclVCBZB1V2luJRX7R9mD2GvbVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=erRuCi9UazWX5BNYXxT5deeZc4qKOgj4zCPtVs89YBQ0aWSe2QN3p2C239ks1tskB
         ZSsZ3zsvDTPeQuRzxWKOQ50t723dkOUeBoO9fiUdBSbNNNOENTHHDXQ3C31m+1VfGp
         /PdOJ8g+/rnDPl9LQSbYTX7CZRE+Hh8t72BQM5ag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+33ef0b6639a8d2d42b4c@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 340/453] ALSA: pcm: oss: Fix a few more UBSAN fixes
Date:   Mon, 28 Dec 2020 13:49:36 +0100
Message-Id: <20201228124953.580178883@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 11cb881bf075cea41092a20236ba708b18e1dbb2 upstream.

There are a few places that call round{up|down}_pow_of_two() with the
value zero, and this causes undefined behavior warnings.  Avoid
calling those macros if such a nonsense value is passed; it's a minor
optimization as well, as we handle it as either an error or a value to
be skipped, instead.

Reported-by: syzbot+33ef0b6639a8d2d42b4c@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201218161730.26596-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/core/oss/pcm_oss.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

--- a/sound/core/oss/pcm_oss.c
+++ b/sound/core/oss/pcm_oss.c
@@ -693,6 +693,8 @@ static int snd_pcm_oss_period_size(struc
 
 	oss_buffer_size = snd_pcm_plug_client_size(substream,
 						   snd_pcm_hw_param_value_max(slave_params, SNDRV_PCM_HW_PARAM_BUFFER_SIZE, NULL)) * oss_frame_size;
+	if (!oss_buffer_size)
+		return -EINVAL;
 	oss_buffer_size = rounddown_pow_of_two(oss_buffer_size);
 	if (atomic_read(&substream->mmap_count)) {
 		if (oss_buffer_size > runtime->oss.mmap_bytes)
@@ -728,17 +730,21 @@ static int snd_pcm_oss_period_size(struc
 
 	min_period_size = snd_pcm_plug_client_size(substream,
 						   snd_pcm_hw_param_value_min(slave_params, SNDRV_PCM_HW_PARAM_PERIOD_SIZE, NULL));
-	min_period_size *= oss_frame_size;
-	min_period_size = roundup_pow_of_two(min_period_size);
-	if (oss_period_size < min_period_size)
-		oss_period_size = min_period_size;
+	if (min_period_size) {
+		min_period_size *= oss_frame_size;
+		min_period_size = roundup_pow_of_two(min_period_size);
+		if (oss_period_size < min_period_size)
+			oss_period_size = min_period_size;
+	}
 
 	max_period_size = snd_pcm_plug_client_size(substream,
 						   snd_pcm_hw_param_value_max(slave_params, SNDRV_PCM_HW_PARAM_PERIOD_SIZE, NULL));
-	max_period_size *= oss_frame_size;
-	max_period_size = rounddown_pow_of_two(max_period_size);
-	if (oss_period_size > max_period_size)
-		oss_period_size = max_period_size;
+	if (max_period_size) {
+		max_period_size *= oss_frame_size;
+		max_period_size = rounddown_pow_of_two(max_period_size);
+		if (oss_period_size > max_period_size)
+			oss_period_size = max_period_size;
+	}
 
 	oss_periods = oss_buffer_size / oss_period_size;
 


