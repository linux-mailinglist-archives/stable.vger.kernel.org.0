Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A6C472718
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235699AbhLMJ6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:58:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41598 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237407AbhLMJzo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:55:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC692B80E23;
        Mon, 13 Dec 2021 09:55:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B2D5C34600;
        Mon, 13 Dec 2021 09:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389341;
        bh=nZULYzr+I9ZBDLmax1pe4YX3kNbyD0jEs3DKzJC9gu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RUL9y3OWfQvz/nKIDHbKsUj+0qaMyS2hC6s7oVRM5YktHO2pEF2T60RnYkW8IaF2H
         +yvJ9jl0UwZAbb+WeqJrVOz7Q8gFEoKQAAEzFrfn0Upk2DpRWx258WJ3UDbDaox4jV
         Afq4R0Q4FseCNsMfm8HqHGo9+SuSR9a2b2ySa8a0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+bb348e9f9a954d42746f@syzkaller.appspotmail.com,
        Bixuan Cui <cuibixuan@linux.alibaba.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 067/171] ALSA: pcm: oss: Fix negative period/buffer sizes
Date:   Mon, 13 Dec 2021 10:29:42 +0100
Message-Id: <20211213092947.330992093@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 9d2479c960875ca1239bcb899f386970c13d9cfe upstream.

The period size calculation in OSS layer may receive a negative value
as an error, but the code there assumes only the positive values and
handle them with size_t.  Due to that, a too big value may be passed
to the lower layers.

This patch changes the code to handle with ssize_t and adds the proper
error checks appropriately.

Reported-by: syzbot+bb348e9f9a954d42746f@syzkaller.appspotmail.com
Reported-by: Bixuan Cui <cuibixuan@linux.alibaba.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1638270978-42412-1-git-send-email-cuibixuan@linux.alibaba.com
Link: https://lore.kernel.org/r/20211201073606.11660-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/oss/pcm_oss.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

--- a/sound/core/oss/pcm_oss.c
+++ b/sound/core/oss/pcm_oss.c
@@ -147,7 +147,7 @@ snd_pcm_hw_param_value_min(const struct
  *
  * Return the maximum value for field PAR.
  */
-static unsigned int
+static int
 snd_pcm_hw_param_value_max(const struct snd_pcm_hw_params *params,
 			   snd_pcm_hw_param_t var, int *dir)
 {
@@ -682,18 +682,24 @@ static int snd_pcm_oss_period_size(struc
 				   struct snd_pcm_hw_params *oss_params,
 				   struct snd_pcm_hw_params *slave_params)
 {
-	size_t s;
-	size_t oss_buffer_size, oss_period_size, oss_periods;
-	size_t min_period_size, max_period_size;
+	ssize_t s;
+	ssize_t oss_buffer_size;
+	ssize_t oss_period_size, oss_periods;
+	ssize_t min_period_size, max_period_size;
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	size_t oss_frame_size;
 
 	oss_frame_size = snd_pcm_format_physical_width(params_format(oss_params)) *
 			 params_channels(oss_params) / 8;
 
+	oss_buffer_size = snd_pcm_hw_param_value_max(slave_params,
+						     SNDRV_PCM_HW_PARAM_BUFFER_SIZE,
+						     NULL);
+	if (oss_buffer_size <= 0)
+		return -EINVAL;
 	oss_buffer_size = snd_pcm_plug_client_size(substream,
-						   snd_pcm_hw_param_value_max(slave_params, SNDRV_PCM_HW_PARAM_BUFFER_SIZE, NULL)) * oss_frame_size;
-	if (!oss_buffer_size)
+						   oss_buffer_size * oss_frame_size);
+	if (oss_buffer_size <= 0)
 		return -EINVAL;
 	oss_buffer_size = rounddown_pow_of_two(oss_buffer_size);
 	if (atomic_read(&substream->mmap_count)) {
@@ -730,7 +736,7 @@ static int snd_pcm_oss_period_size(struc
 
 	min_period_size = snd_pcm_plug_client_size(substream,
 						   snd_pcm_hw_param_value_min(slave_params, SNDRV_PCM_HW_PARAM_PERIOD_SIZE, NULL));
-	if (min_period_size) {
+	if (min_period_size > 0) {
 		min_period_size *= oss_frame_size;
 		min_period_size = roundup_pow_of_two(min_period_size);
 		if (oss_period_size < min_period_size)
@@ -739,7 +745,7 @@ static int snd_pcm_oss_period_size(struc
 
 	max_period_size = snd_pcm_plug_client_size(substream,
 						   snd_pcm_hw_param_value_max(slave_params, SNDRV_PCM_HW_PARAM_PERIOD_SIZE, NULL));
-	if (max_period_size) {
+	if (max_period_size > 0) {
 		max_period_size *= oss_frame_size;
 		max_period_size = rounddown_pow_of_two(max_period_size);
 		if (oss_period_size > max_period_size)
@@ -752,7 +758,7 @@ static int snd_pcm_oss_period_size(struc
 		oss_periods = substream->oss.setup.periods;
 
 	s = snd_pcm_hw_param_value_max(slave_params, SNDRV_PCM_HW_PARAM_PERIODS, NULL);
-	if (runtime->oss.maxfrags && s > runtime->oss.maxfrags)
+	if (s > 0 && runtime->oss.maxfrags && s > runtime->oss.maxfrags)
 		s = runtime->oss.maxfrags;
 	if (oss_periods > s)
 		oss_periods = s;


