Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A87B374429
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236041AbhEEQzm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:55:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:58938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230128AbhEEQw6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:52:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFBFC61445;
        Wed,  5 May 2021 16:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232692;
        bh=l6UOsSfIwMVHstmtkJIX4n+JtKICvV4bJ/QTOVkiPiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=epFjPiUSGAZc5ZuNMyT69RIF0DxemogtE+f87wbjlNVPcbD6PFowl/G3cBrW38N1m
         opj37OmZxobufndmQZdJGWnh215udYoO5cbELt1+ceSHSeqaYeUvSKyo1Y4pVEPGit
         H+RJAUmwpajldc2gnbcBYnsi/4magKzqh7kSoiATnTQxVpeYa/Ff8gQdi6LU2FaBeC
         j2G0zriPWugWUL+HhDeAh0CpJw7Z5FR+Wg+lwFYOBahHaeSwR6ZcVzjyk9I/TbYSHg
         TUDIHcI6sbwkbtBhLAU3uOYsoQr7xRJqK0v7NNd///uEP0ybpZPif/ezV9l9Aq/pCz
         OAnWVJfrVZ4lw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 57/85] ALSA: hda/hdmi: fix race in handling acomp ELD notification at resume
Date:   Wed,  5 May 2021 12:36:20 -0400
Message-Id: <20210505163648.3462507-57-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163648.3462507-1-sashal@kernel.org>
References: <20210505163648.3462507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit 0c37e2eb6b83e375e8a654d01598292d5591fc65 ]

When snd-hda-codec-hdmi is used with ASoC HDA controller like SOF (acomp
used for ELD notifications), display connection change done during suspend,
can be lost due to following sequence of events:

  1. system in S3 suspend
  2. DP/HDMI receiver connected
  3. system resumed
  4. HDA controller resumed, but card->deferred_resume_work not complete
  5. acomp eld_notify callback
  6. eld_notify ignored as power state is not CTL_POWER_D0
  7. HDA resume deferred work completed, power state set to CTL_POWER_D0

This results in losing the notification, and the jack state reported to
user-space is not correct.

The check on step 6 was added in commit 8ae743e82f0b ("ALSA: hda - Skip
ELD notification during system suspend"). It would seem with the deferred
resume logic in ASoC core, this check is not safe.

Fix the issue by modifying the check to use "dev.power.power_state.event"
instead of ALSA specific card power state variable.

BugLink: https://github.com/thesofproject/linux/issues/2825
Suggested-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20210416131157.1881366-1-kai.vehmanen@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_hdmi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 8c6f10cbced3..6d2a4dfcfe43 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -2653,7 +2653,7 @@ static void generic_acomp_pin_eld_notify(void *audio_ptr, int port, int dev_id)
 	/* skip notification during system suspend (but not in runtime PM);
 	 * the state will be updated at resume
 	 */
-	if (snd_power_get_state(codec->card) != SNDRV_CTL_POWER_D0)
+	if (codec->core.dev.power.power_state.event == PM_EVENT_SUSPEND)
 		return;
 	/* ditto during suspend/resume process itself */
 	if (snd_hdac_is_in_pm(&codec->core))
@@ -2839,7 +2839,7 @@ static void intel_pin_eld_notify(void *audio_ptr, int port, int pipe)
 	/* skip notification during system suspend (but not in runtime PM);
 	 * the state will be updated at resume
 	 */
-	if (snd_power_get_state(codec->card) != SNDRV_CTL_POWER_D0)
+	if (codec->core.dev.power.power_state.event == PM_EVENT_SUSPEND)
 		return;
 	/* ditto during suspend/resume process itself */
 	if (snd_hdac_is_in_pm(&codec->core))
-- 
2.30.2

