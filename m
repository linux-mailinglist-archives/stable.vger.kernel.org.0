Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C24B844B7EF
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344787AbhKIWjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:39:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:59348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345113AbhKIWhR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:37:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D002F6105A;
        Tue,  9 Nov 2021 22:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496566;
        bh=A8grbP04A6YB3RAO8z6CJcLZPEYRULMRDWYYr3pr1YM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gQtg/xmPTnQNl7MMbaqxDau6q6WjiSawQQlGsL6SSdq0dyRuv8BuBEVwA7Db7W6kN
         Z+4sBgk3tROvBbcDw9vYSQbKCDAqTT0wrb9z72jjppUPtPwbJ2HSlGZj8X0hARRury
         INupunnNpVJKgrjktQYrfB3WGipj440QyjhGHE1OnNnNEKa68xa/oaDakqsYWbpNm6
         p7SlhtpRaXhUJrs/RMGuEReHRmhlUffBZspqIwI2GHExKtBRDPYDyGGaKf7l3p9HS3
         XJyjt4vnueyqWfokLMDFgblTS5Ab5QWCvoIU6TQA2gIX03o+BwnAZhuFnAl6I/LD34
         6xTsKbfj1Ig/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 13/30] ASoC: SOF: Intel: hda-dai: fix potential locking issue
Date:   Tue,  9 Nov 2021 17:22:07 -0500
Message-Id: <20211109222224.1235388-13-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222224.1235388-1-sashal@kernel.org>
References: <20211109222224.1235388-1-sashal@kernel.org>
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
index 3f645200d3a5c..b3cdd10c83ae1 100644
--- a/sound/soc/sof/intel/hda-dai.c
+++ b/sound/soc/sof/intel/hda-dai.c
@@ -67,6 +67,7 @@ static struct hdac_ext_stream *
 		return NULL;
 	}
 
+	spin_lock_irq(&bus->reg_lock);
 	list_for_each_entry(stream, &bus->stream_list, list) {
 		struct hdac_ext_stream *hstream =
 			stream_to_hdac_ext_stream(stream);
@@ -106,12 +107,12 @@ static struct hdac_ext_stream *
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

