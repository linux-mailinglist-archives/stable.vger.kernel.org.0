Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E592B5051DC
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239528AbiDRMk1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240825AbiDRMjj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:39:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B117C0B;
        Mon, 18 Apr 2022 05:31:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD5C960FB6;
        Mon, 18 Apr 2022 12:31:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FA52C385A1;
        Mon, 18 Apr 2022 12:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285062;
        bh=Gx922/rWDZ/4F9PMVr+uq0fXu5sFKFg0M7O2OXkXBt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NCWYy7E3j6meNhVSLeQfgc1YqadQM7xoHrJfpU7RoA7u8OEFRoh0GEne44GKYN+nN
         bLN+UpFn51KAYT1+7VkHA/mu/2RHmFJCceYt6B+Xty4Kd/QxAhNKec0OulpEaKiUgX
         jY9f/iVtT0DCus/RiupqIOW/2jwfvsCivts1U1gI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 095/189] ALSA: usb-audio: Limit max buffer and period sizes per time
Date:   Mon, 18 Apr 2022 14:11:55 +0200
Message-Id: <20220418121203.201733682@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 24d0c9f0e7de95fe3e3e0067cbea1cd5d413244b ]

In the previous fix, we increased the max buffer bytes from 1MB to 4MB
so that we can use bigger buffers for the modern HiFi devices with
higher rates, more channels and wider formats.  OTOH, extending this
has a concern that too big buffer is allowed for the lower rates, less
channels and narrower formats; when an application tries to allocate
as big buffer as possible, it'll lead to unexpectedly too huge size.

Also, we had a problem about the inconsistent max buffer and period
bytes for the implicit feedback mode when both streams have different
channels.  This was fixed by the (relatively complex) patch to reduce
the max buffer and period bytes accordingly.

This is an alternative fix for those, a patch to kill two birds with
one stone (*): instead of increasing the max buffer bytes blindly and
applying the reduction per channels, we simply use the hw constraints
for the buffer and period "time".  Meanwhile the max buffer and period
bytes are set unlimited instead.

Since the inconsistency of buffer (and period) bytes comes from the
difference of the channels in the tied streams, as long as we care
only about the buffer (and period) time, it doesn't matter; the buffer
time is same for different channels, although we still allow higher
buffer size.  Similarly, this will allow more buffer bytes for HiFi
devices while it also keeps the reasonable size for the legacy
devices, too.

As of this patch, the max period and buffer time are set to 1 and 2
seconds, which should be large enough for all possible use cases.

(*) No animals were harmed in the making of this patch.

Fixes: 98c27add5d96 ("ALSA: usb-audio: Cap upper limits of buffer/period bytes for implicit fb")
Fixes: fee2ec8cceb3 ("ALSA: usb-audio: Increase max buffer size")
Link: https://lore.kernel.org/r/20220412130740.18933-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/pcm.c | 101 +++++++-----------------------------------------
 1 file changed, 14 insertions(+), 87 deletions(-)

diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index 866a82b69d8d..729e26f5ac4c 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -659,9 +659,6 @@ static int snd_usb_pcm_prepare(struct snd_pcm_substream *substream)
 #define hwc_debug(fmt, args...) do { } while(0)
 #endif
 
-#define MAX_BUFFER_BYTES	(4 * 1024 * 1024)
-#define MAX_PERIOD_BYTES	(512 * 1024)
-
 static const struct snd_pcm_hardware snd_usb_hardware =
 {
 	.info =			SNDRV_PCM_INFO_MMAP |
@@ -672,9 +669,9 @@ static const struct snd_pcm_hardware snd_usb_hardware =
 				SNDRV_PCM_INFO_PAUSE,
 	.channels_min =		1,
 	.channels_max =		256,
-	.buffer_bytes_max =	MAX_BUFFER_BYTES,
+	.buffer_bytes_max =	INT_MAX, /* limited by BUFFER_TIME later */
 	.period_bytes_min =	64,
-	.period_bytes_max =	MAX_PERIOD_BYTES,
+	.period_bytes_max =	INT_MAX, /* limited by PERIOD_TIME later */
 	.periods_min =		2,
 	.periods_max =		1024,
 };
@@ -974,78 +971,6 @@ static int hw_rule_periods_implicit_fb(struct snd_pcm_hw_params *params,
 				      ep->cur_buffer_periods);
 }
 
-/* get the adjusted max buffer (or period) bytes that can fit with the
- * paired format for implicit fb
- */
-static unsigned int
-get_adjusted_max_bytes(struct snd_usb_substream *subs,
-		       struct snd_usb_substream *pair,
-		       struct snd_pcm_hw_params *params,
-		       unsigned int max_bytes,
-		       bool reverse_map)
-{
-	const struct audioformat *fp, *pp;
-	unsigned int rmax = 0, r;
-
-	list_for_each_entry(fp, &subs->fmt_list, list) {
-		if (!fp->implicit_fb)
-			continue;
-		if (!reverse_map &&
-		    !hw_check_valid_format(subs, params, fp))
-			continue;
-		list_for_each_entry(pp, &pair->fmt_list, list) {
-			if (pp->iface != fp->sync_iface ||
-			    pp->altsetting != fp->sync_altsetting ||
-			    pp->ep_idx != fp->sync_ep_idx)
-				continue;
-			if (reverse_map &&
-			    !hw_check_valid_format(pair, params, pp))
-				break;
-			if (!reverse_map && pp->channels > fp->channels)
-				r = max_bytes * fp->channels / pp->channels;
-			else if (reverse_map && pp->channels < fp->channels)
-				r = max_bytes * pp->channels / fp->channels;
-			else
-				r = max_bytes;
-			rmax = max(rmax, r);
-			break;
-		}
-	}
-	return rmax;
-}
-
-/* Reduce the period or buffer bytes depending on the paired substream;
- * when a paired configuration for implicit fb has a higher number of channels,
- * we need to reduce the max size accordingly, otherwise it may become unusable
- */
-static int hw_rule_bytes_implicit_fb(struct snd_pcm_hw_params *params,
-				     struct snd_pcm_hw_rule *rule)
-{
-	struct snd_usb_substream *subs = rule->private;
-	struct snd_usb_substream *pair;
-	struct snd_interval *it;
-	unsigned int max_bytes;
-	unsigned int rmax;
-
-	pair = &subs->stream->substream[!subs->direction];
-	if (!pair->ep_num)
-		return 0;
-
-	if (rule->var == SNDRV_PCM_HW_PARAM_PERIOD_BYTES)
-		max_bytes = MAX_PERIOD_BYTES;
-	else
-		max_bytes = MAX_BUFFER_BYTES;
-
-	rmax = get_adjusted_max_bytes(subs, pair, params, max_bytes, false);
-	if (!rmax)
-		rmax = get_adjusted_max_bytes(pair, subs, params, max_bytes, true);
-	if (!rmax)
-		return 0;
-
-	it = hw_param_interval(params, rule->var);
-	return apply_hw_params_minmax(it, 0, rmax);
-}
-
 /*
  * set up the runtime hardware information.
  */
@@ -1139,6 +1064,18 @@ static int setup_hw_info(struct snd_pcm_runtime *runtime, struct snd_usb_substre
 			return err;
 	}
 
+	/* set max period and buffer sizes for 1 and 2 seconds, respectively */
+	err = snd_pcm_hw_constraint_minmax(runtime,
+					   SNDRV_PCM_HW_PARAM_PERIOD_TIME,
+					   0, 1000000);
+	if (err < 0)
+		return err;
+	err = snd_pcm_hw_constraint_minmax(runtime,
+					   SNDRV_PCM_HW_PARAM_BUFFER_TIME,
+					   0, 2000000);
+	if (err < 0)
+		return err;
+
 	/* additional hw constraints for implicit fb */
 	err = snd_pcm_hw_rule_add(runtime, 0, SNDRV_PCM_HW_PARAM_FORMAT,
 				  hw_rule_format_implicit_fb, subs,
@@ -1160,16 +1097,6 @@ static int setup_hw_info(struct snd_pcm_runtime *runtime, struct snd_usb_substre
 				  SNDRV_PCM_HW_PARAM_PERIODS, -1);
 	if (err < 0)
 		return err;
-	err = snd_pcm_hw_rule_add(runtime, 0, SNDRV_PCM_HW_PARAM_BUFFER_BYTES,
-				  hw_rule_bytes_implicit_fb, subs,
-				  SNDRV_PCM_HW_PARAM_BUFFER_BYTES, -1);
-	if (err < 0)
-		return err;
-	err = snd_pcm_hw_rule_add(runtime, 0, SNDRV_PCM_HW_PARAM_PERIOD_BYTES,
-				  hw_rule_bytes_implicit_fb, subs,
-				  SNDRV_PCM_HW_PARAM_PERIOD_BYTES, -1);
-	if (err < 0)
-		return err;
 
 	return 0;
 }
-- 
2.35.1



