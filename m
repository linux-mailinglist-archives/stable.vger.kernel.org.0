Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A74D0145C54
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 20:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgAVTQB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 14:16:01 -0500
Received: from mail1.perex.cz ([77.48.224.245]:41548 "EHLO mail1.perex.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726004AbgAVTQB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 14:16:01 -0500
X-Greylist: delayed 471 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Jan 2020 14:16:00 EST
Received: from mail1.perex.cz (localhost [127.0.0.1])
        by smtp1.perex.cz (Perex's E-mail Delivery System) with ESMTP id 5E258A003F;
        Wed, 22 Jan 2020 20:08:07 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp1.perex.cz 5E258A003F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=perex.cz; s=default;
        t=1579720087; bh=Pku/X5mG5+VO72YN24QXDQhrqZ0TAyLk/3xAjxDFd4A=;
        h=From:To:Cc:Subject:Date:From;
        b=29CsJCaGQuL0+/wNYAYg5Moemil4Db5m3xfMh8G1xCdBe3bYRwZSlGeJUbb1IabuJ
         9n43y71BZ5VGqODTBRCRIsUmgkfWSeiNThR/llXiN6mDnucVc41XQyM/vzAq/mBE4F
         XeJVMx7XN4iiUFmuq+MtSs8i1FM7t+aZFgFMlo8Y=
Received: from p50.perex-int.cz (unknown [192.168.100.94])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: perex)
        by mail1.perex.cz (Perex's E-mail Delivery System) with ESMTPSA;
        Wed, 22 Jan 2020 20:07:59 +0100 (CET)
From:   Jaroslav Kysela <perex@perex.cz>
To:     ALSA development <alsa-devel@alsa-project.org>
Cc:     Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        Dragos Tarcatu <dragos_tarcatu@mentor.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Mark Brown <broonie@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] ASoC: topology: fix soc_tplg_fe_link_create() - link->dobj initialization order
Date:   Wed, 22 Jan 2020 20:07:52 +0100
Message-Id: <20200122190752.3081016-1-perex@perex.cz>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
2.24.1
