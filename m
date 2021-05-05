Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3290374186
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234202AbhEEQi6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:38:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:53234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235081AbhEEQg5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:36:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F71761447;
        Wed,  5 May 2021 16:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232401;
        bh=+jyHgxAPc73OHt2eH+HMNJcBfYBff92VJHqGAg42OQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MTXzRbjm6KzFvZjLzzdByuXMs3c/IEgnzcL6dHHqxDzArSBpH3eMDFxEDxviPDAO/
         P481gRaCF1d9ywvVlRPGC3w6rvMYo6F+lwzT193uSIjjP8rnC4YaSjdW0ti70h4CRb
         S4GcOq7PZb9rnJ4cePlRCGSzR3QDENmwRbXthsjdQuFk5wREITvnX8Xv2u9v68V7sv
         Jx1Vu1DGuKRm63xp27kjx3m0Vexsu6d18SK7NuIAf24Fj+G0dP4Arc01X92Z/K2YiF
         B4q34leDSa0XW+AfYBeDeAOXRGt0OC1gZFqUp9lroJDUBRS2LLyWt0Jc+jVYbSjSld
         l8g8kFFGQDd2Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.12 082/116] ALSA: hda/hdmi: fix race in handling acomp ELD notification at resume
Date:   Wed,  5 May 2021 12:30:50 -0400
Message-Id: <20210505163125.3460440-82-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
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
index 5de3666a7101..4b2cc8cb55c4 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -2654,7 +2654,7 @@ static void generic_acomp_pin_eld_notify(void *audio_ptr, int port, int dev_id)
 	/* skip notification during system suspend (but not in runtime PM);
 	 * the state will be updated at resume
 	 */
-	if (snd_power_get_state(codec->card) != SNDRV_CTL_POWER_D0)
+	if (codec->core.dev.power.power_state.event == PM_EVENT_SUSPEND)
 		return;
 	/* ditto during suspend/resume process itself */
 	if (snd_hdac_is_in_pm(&codec->core))
@@ -2840,7 +2840,7 @@ static void intel_pin_eld_notify(void *audio_ptr, int port, int pipe)
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

