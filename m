Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6602E1687
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728785AbgLWCTu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:19:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:45508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728758AbgLWCTs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9ED923137;
        Wed, 23 Dec 2020 02:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689964;
        bh=9WrxHlIPnNp2LgSPkoCOvqX+YYDkZfbRLXyupRqfVoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ON+31HCcd8OSqeBJ7ICLtOYHJO5RNK3z2tZNYO59jX04q4XrygRFpRbHdVi+1Ecao
         lsu1WGl00N12foCNTbDGEgnGnheIi3UMhvv5IfDpVLIOXTnxhmqxfHitJPN6uK2ixp
         sSSI/Q4JY6uPAFCCmb4KC4kAOmhJ8q+UhYKeRt2/ncy/C4KMOLWC8Cg6DHKDs60gu3
         lmSPC/XpocQpl+/EFGM+7dUoHyQ/6BrX8w8XTi0nhg2pANxBWeBC23VE5Ye+S1JO8l
         D4Vo7yakjSgwdJS+WV5bR32McszEMIWcyftP4ReFrsumISi367EcTbEpZuEpHEWzip
         sPhZEZfQ2YD8A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>,
        Keith Milner <kamilner@superlative.org>,
        Dylan Robinson <dylan_robinson@motu.com>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 055/130] ALSA: usb-audio: Handle discrete rates properly in hw constraints
Date:   Tue, 22 Dec 2020 21:16:58 -0500
Message-Id: <20201223021813.2791612-55-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit bc4e94aa8e72e79598e63a0b73febdcd8aeb541f ]

In the current code, when the device provides the discrete sample rate
tables with unusual sample rates, the driver tries to gather the whole
values from the audioformat entries and create a hw-constraint rule to
restrict with this single rate list.  This is rather inefficient and
may overlook the rates that are associated only with the certain
audioformat entries.

This patch improves the hw constraint setup by rewriting the existing
hw_rule_rate().  The discrete sample rates (identified by rate_table
and nr_rates of format entry) are checked in the existing
hw_rule_rate() instead of extra rules; in the case of discrete rates,
the function compares with each rate table entry and calculates the
min/max values from there.  For the contiguous rates, the behavior
doesn't change.

Along with it, snd_usb_pcm_check_knot() and snb_usb_substream
rate_list field become superfluous, thus those are dropped.

Tested-by: Keith Milner <kamilner@superlative.org>
Tested-by: Dylan Robinson <dylan_robinson@motu.com>
Link: https://lore.kernel.org/r/20201123085347.19667-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/card.h   |  1 -
 sound/usb/pcm.c    | 73 ++++++++++------------------------------------
 sound/usb/stream.c |  1 -
 3 files changed, 15 insertions(+), 60 deletions(-)

diff --git a/sound/usb/card.h b/sound/usb/card.h
index d8ec5caf464de..d619e5e77a305 100644
--- a/sound/usb/card.h
+++ b/sound/usb/card.h
@@ -153,7 +153,6 @@ struct snd_usb_substream {
 	u64 formats;			/* format bitmasks (all or'ed) */
 	unsigned int num_formats;		/* number of supported audio formats (list) */
 	struct list_head fmt_list;	/* format list */
-	struct snd_pcm_hw_constraint_list rate_list;	/* limited rates */
 	spinlock_t lock;
 
 	int last_frame_number;          /* stored frame number */
diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index 1a5e555002b2b..49ad4e7bb70b5 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -1034,27 +1034,31 @@ static int hw_rule_rate(struct snd_pcm_hw_params *params,
 	struct snd_usb_substream *subs = rule->private;
 	struct audioformat *fp;
 	struct snd_interval *it = hw_param_interval(params, SNDRV_PCM_HW_PARAM_RATE);
-	unsigned int rmin, rmax;
+	unsigned int rmin, rmax, r;
 	int changed;
+	int i;
 
 	hwc_debug("hw_rule_rate: (%d,%d)\n", it->min, it->max);
-	changed = 0;
-	rmin = rmax = 0;
+	rmin = UINT_MAX;
+	rmax = 0;
 	list_for_each_entry(fp, &subs->fmt_list, list) {
 		if (!hw_check_valid_format(subs, params, fp))
 			continue;
-		if (changed++) {
-			if (rmin > fp->rate_min)
-				rmin = fp->rate_min;
-			if (rmax < fp->rate_max)
-				rmax = fp->rate_max;
+		if (fp->rate_table && fp->nr_rates) {
+			for (i = 0; i < fp->nr_rates; i++) {
+				r = fp->rate_table[i];
+				if (!snd_interval_test(it, r))
+					continue;
+				rmin = min(rmin, r);
+				rmax = max(rmax, r);
+			}
 		} else {
-			rmin = fp->rate_min;
-			rmax = fp->rate_max;
+			rmin = min(rmin, fp->rate_min);
+			rmax = max(rmax, fp->rate_max);
 		}
 	}
 
-	if (!changed) {
+	if (rmin > rmax) {
 		hwc_debug("  --> get empty\n");
 		it->empty = 1;
 		return -EINVAL;
@@ -1200,50 +1204,6 @@ static int hw_rule_period_time(struct snd_pcm_hw_params *params,
 	return changed;
 }
 
-/*
- *  If the device supports unusual bit rates, does the request meet these?
- */
-static int snd_usb_pcm_check_knot(struct snd_pcm_runtime *runtime,
-				  struct snd_usb_substream *subs)
-{
-	struct audioformat *fp;
-	int *rate_list;
-	int count = 0, needs_knot = 0;
-	int err;
-
-	kfree(subs->rate_list.list);
-	subs->rate_list.list = NULL;
-
-	list_for_each_entry(fp, &subs->fmt_list, list) {
-		if (fp->rates & SNDRV_PCM_RATE_CONTINUOUS)
-			return 0;
-		count += fp->nr_rates;
-		if (fp->rates & SNDRV_PCM_RATE_KNOT)
-			needs_knot = 1;
-	}
-	if (!needs_knot)
-		return 0;
-
-	subs->rate_list.list = rate_list =
-		kmalloc_array(count, sizeof(int), GFP_KERNEL);
-	if (!subs->rate_list.list)
-		return -ENOMEM;
-	subs->rate_list.count = count;
-	subs->rate_list.mask = 0;
-	count = 0;
-	list_for_each_entry(fp, &subs->fmt_list, list) {
-		int i;
-		for (i = 0; i < fp->nr_rates; i++)
-			rate_list[count++] = fp->rate_table[i];
-	}
-	err = snd_pcm_hw_constraint_list(runtime, 0, SNDRV_PCM_HW_PARAM_RATE,
-					 &subs->rate_list);
-	if (err < 0)
-		return err;
-
-	return 0;
-}
-
 
 /*
  * set up the runtime hardware information.
@@ -1333,9 +1293,6 @@ static int setup_hw_info(struct snd_pcm_runtime *runtime, struct snd_usb_substre
 		if (err < 0)
 			return err;
 	}
-	err = snd_usb_pcm_check_knot(runtime, subs);
-	if (err < 0)
-		return err;
 
 	return snd_usb_autoresume(subs->stream->chip);
 }
diff --git a/sound/usb/stream.c b/sound/usb/stream.c
index d01edd5da6cf8..49c1b8a208582 100644
--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -47,7 +47,6 @@ static void free_substream(struct snd_usb_substream *subs)
 		return; /* not initialized */
 	list_for_each_entry_safe(fp, n, &subs->fmt_list, list)
 		audioformat_free(fp);
-	kfree(subs->rate_list.list);
 	kfree(subs->str_pd);
 	snd_media_stream_delete(subs);
 }
-- 
2.27.0

