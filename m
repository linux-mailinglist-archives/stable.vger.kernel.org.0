Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8279C30CC4F
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240009AbhBBTvT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:51:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:42424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233148AbhBBNwF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:52:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F132D64FB7;
        Tue,  2 Feb 2021 13:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273405;
        bh=NGwNgz8mPPOSdGhyBQ3m8HxCGvwgQi+/CgCTPTjE0kM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PErk0NJlOTQUBupPgkEv2a3au6bvyrmeMAByXEAt7vehPHnsog3nbRwZcQZxNwu17
         U8Czfl5KJP6mUlX5Gbb/sOe3rg5NoqGVsraMWu48tc0ZXmy4BFlLIhjsEHilYmkdB7
         MW4M1wlIz56D7ALlHuM/XZ/yFMd+USjYnd9kZ84U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ricardo Ribalda <ribalda@chromium.org>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Lukasz Majczak <lma@semihalf.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 094/142] ASoC: Intel: Skylake: skl-topology: Fix OOPs ib skl_tplg_complete
Date:   Tue,  2 Feb 2021 14:37:37 +0100
Message-Id: <20210202133001.591879592@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit c1c3ba1f78354a20222d291ed6fedd17b7a74fd7 ]

If dobj->control is not initialized we end up in an OOPs during
skl_tplg_complete:

[   26.553358] BUG: kernel NULL pointer dereference, address:
0000000000000078
[   26.561151] #PF: supervisor read access in kernel mode
[   26.566897] #PF: error_code(0x0000) - not-present page
[   26.572642] PGD 0 P4D 0
[   26.575479] Oops: 0000 [#1] PREEMPT SMP PTI
[   26.580158] CPU: 2 PID: 2082 Comm: udevd Tainted: G         C
5.4.81 #4
[   26.588232] Hardware name: HP Soraka/Soraka, BIOS
Google_Soraka.10431.106.0 12/03/2019
[   26.597082] RIP: 0010:skl_tplg_complete+0x70/0x144 [snd_soc_skl]

Fixes: 2d744ecf2b98 ("ASoC: Intel: Skylake: Automatic DMIC format configuration according to information from NHL")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Tested-by: Lukasz Majczak <lma@semihalf.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20210121171644.131059-1-ribalda@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/skylake/skl-topology.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/sound/soc/intel/skylake/skl-topology.c b/sound/soc/intel/skylake/skl-topology.c
index 40bee10b0c65a..d699e61eca3d0 100644
--- a/sound/soc/intel/skylake/skl-topology.c
+++ b/sound/soc/intel/skylake/skl-topology.c
@@ -3619,15 +3619,16 @@ static void skl_tplg_complete(struct snd_soc_component *component)
 
 	list_for_each_entry(dobj, &component->dobj_list, list) {
 		struct snd_kcontrol *kcontrol = dobj->control.kcontrol;
-		struct soc_enum *se =
-			(struct soc_enum *)kcontrol->private_value;
-		char **texts = dobj->control.dtexts;
+		struct soc_enum *se;
+		char **texts;
 		char chan_text[4];
 
-		if (dobj->type != SND_SOC_DOBJ_ENUM ||
-		    dobj->control.kcontrol->put !=
-		    skl_tplg_multi_config_set_dmic)
+		if (dobj->type != SND_SOC_DOBJ_ENUM || !kcontrol ||
+		    kcontrol->put != skl_tplg_multi_config_set_dmic)
 			continue;
+
+		se = (struct soc_enum *)kcontrol->private_value;
+		texts = dobj->control.dtexts;
 		sprintf(chan_text, "c%d", mach->mach_params.dmic_num);
 
 		for (i = 0; i < se->items; i++) {
-- 
2.27.0



