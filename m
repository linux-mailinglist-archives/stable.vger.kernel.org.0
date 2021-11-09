Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3219F44B5AC
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245720AbhKIWWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:22:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:41760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245747AbhKIWUw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:20:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7258761279;
        Tue,  9 Nov 2021 22:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496273;
        bh=3JAE28fSKA6qnrcEMQx9bPFgXNxbVen5lGwA92srAMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oe5uDqn7b10fYzTZ/oBDwNi5M6Zdf+yPnpbcfxVw4iR4S6xjW1leC4rNJP3F51Uzf
         DeDcBEUKotSRlyKLJsc75dqEgskuPBnslKaNdewcqN5+vwm2TwkLrOlA+4kVZI25IX
         4RrZtWMLGcX3V1FGku4eX7ppt+sELTob8XGxH7UGbROh5EVzm/7sngNAjPzd2JaCeg
         BTk8yQpzOZVfcLZi97oyhTii7/t/GyMDDQPH9TiJzTH7Ti83AE+kENVAT03v+Wu1Xw
         bkKTzfT12jkSNtY1jBDsx+KuKBUUxwu0zGSl/luv0LQorWvsasIo7turxeKi8x/hOm
         mKCDj0HdH4o2g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 36/82] ASoC: SOF: Intel: hda-dai: fix potential locking issue
Date:   Tue,  9 Nov 2021 17:15:54 -0500
Message-Id: <20211109221641.1233217-36-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221641.1233217-1-sashal@kernel.org>
References: <20211109221641.1233217-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit a20f3b10de61add5e14b6ce4df982f4df2a4cbbc ]

The initial hdac_stream code was adapted a third time with the same
locking issues. Move the spin_lock outside the loops and make sure the
fields are protected on read/write.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Acked-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20210924192417.169243-5-pierre-louis.bossart@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-dai.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/sound/soc/sof/intel/hda-dai.c b/sound/soc/sof/intel/hda-dai.c
index c1f9f0f584647..6704dbcd101cd 100644
--- a/sound/soc/sof/intel/hda-dai.c
+++ b/sound/soc/sof/intel/hda-dai.c
@@ -68,6 +68,7 @@ static struct hdac_ext_stream *
 		return NULL;
 	}
 
+	spin_lock_irq(&bus->reg_lock);
 	list_for_each_entry(stream, &bus->stream_list, list) {
 		struct hdac_ext_stream *hstream =
 			stream_to_hdac_ext_stream(stream);
@@ -107,12 +108,12 @@ static struct hdac_ext_stream *
 		 * is updated in snd_hdac_ext_stream_decouple().
 		 */
 		if (!res->decoupled)
-			snd_hdac_ext_stream_decouple(bus, res, true);
-		spin_lock_irq(&bus->reg_lock);
+			snd_hdac_ext_stream_decouple_locked(bus, res, true);
+
 		res->link_locked = 1;
 		res->link_substream = substream;
-		spin_unlock_irq(&bus->reg_lock);
 	}
+	spin_unlock_irq(&bus->reg_lock);
 
 	return res;
 }
-- 
2.33.0

