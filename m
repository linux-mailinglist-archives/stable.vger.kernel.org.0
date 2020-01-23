Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC25414681D
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 13:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgAWMgW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 07:36:22 -0500
Received: from foss.arm.com ([217.140.110.172]:38976 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726170AbgAWMgV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 07:36:21 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DCC2CFEC;
        Thu, 23 Jan 2020 04:36:18 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5D24B3F6C4;
        Thu, 23 Jan 2020 04:36:18 -0800 (PST)
Date:   Thu, 23 Jan 2020 12:36:16 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Jaroslav Kysela <perex@perex.cz>
Cc:     alsa-devel@alsa-project.org,
        ALSA development <alsa-devel@alsa-project.org>,
        Dragos Tarcatu <dragos_tarcatu@mentor.com>,
        Mark Brown <broonie@kernel.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        <stable@vger.kernel.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: Applied "ASoC: topology: fix soc_tplg_fe_link_create() - link->dobj initialization order" to the asoc tree
In-Reply-To: <20200122190752.3081016-1-perex@perex.cz>
Message-Id: <applied-20200122190752.3081016-1-perex@perex.cz>
X-Patchwork-Hint: ignore
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch

   ASoC: topology: fix soc_tplg_fe_link_create() - link->dobj initialization order

has been applied to the asoc tree at

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-5.5

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent to Linus during
the next merge window (or sooner if it is a bug fix), however if
problems are discovered then the patch may be dropped or reverted.  

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

Thanks,
Mark

From 8ce1cbd6ce0b1bda0c980c64fee4c1e1378355f1 Mon Sep 17 00:00:00 2001
From: Jaroslav Kysela <perex@perex.cz>
Date: Wed, 22 Jan 2020 20:07:52 +0100
Subject: [PATCH] ASoC: topology: fix soc_tplg_fe_link_create() - link->dobj
 initialization order

The code which checks the return value for snd_soc_add_dai_link() call
in soc_tplg_fe_link_create() moved the snd_soc_add_dai_link() call before
link->dobj members initialization.

While it does not affect the latest kernels, the old soc-core.c code
in the stable kernels is affected. The snd_soc_add_dai_link() function uses
the link->dobj.type member to check, if the link structure is valid.

Reorder the link->dobj initialization to make things work again.
It's harmless for the recent code (and the structure should be properly
initialized before other calls anyway).

The problem is in stable linux-5.4.y since version 5.4.11 when the
upstream commit 76d270364932 was applied.

Fixes: 76d270364932 ("ASoC: topology: Check return value for snd_soc_add_dai_link()")
Cc: Dragos Tarcatu <dragos_tarcatu@mentor.com>
Cc: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20200122190752.3081016-1-perex@perex.cz
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 sound/soc/soc-topology.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/sound/soc/soc-topology.c b/sound/soc/soc-topology.c
index 92e4f4d08bfa..4e1fe623c390 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -1906,6 +1906,10 @@ static int soc_tplg_fe_link_create(struct soc_tplg *tplg,
 	link->num_codecs = 1;
 	link->num_platforms = 1;
 
+	link->dobj.index = tplg->index;
+	link->dobj.ops = tplg->ops;
+	link->dobj.type = SND_SOC_DOBJ_DAI_LINK;
+
 	if (strlen(pcm->pcm_name)) {
 		link->name = kstrdup(pcm->pcm_name, GFP_KERNEL);
 		link->stream_name = kstrdup(pcm->pcm_name, GFP_KERNEL);
@@ -1942,9 +1946,6 @@ static int soc_tplg_fe_link_create(struct soc_tplg *tplg,
 		goto err;
 	}
 
-	link->dobj.index = tplg->index;
-	link->dobj.ops = tplg->ops;
-	link->dobj.type = SND_SOC_DOBJ_DAI_LINK;
 	list_add(&link->dobj.list, &tplg->comp->dobj_list);
 
 	return 0;
-- 
2.20.1

