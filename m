Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48B6153D2C4
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 22:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241726AbiFCUXJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 16:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240755AbiFCUXJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 16:23:09 -0400
X-Greylist: delayed 484 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 03 Jun 2022 13:23:07 PDT
Received: from mail.tpi.com (mail.tpi.com [50.126.108.186])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 998B743AE6;
        Fri,  3 Jun 2022 13:23:07 -0700 (PDT)
Received: from sushi.tpi.com (sushi.tpi.com [10.0.0.212])
        by mail.tpi.com (Postfix) with ESMTPA id 55DBD47EC7EC;
        Fri,  3 Jun 2022 13:15:01 -0700 (PDT)
From:   Dean Gehnert <deang@tpi.com>
To:     linux-kernel@vger.kernel.org
Cc:     Dean Gehnert <deang@tpi.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, alsa-devel@alsa-project.org,
        stable@vger.kernel.org
Subject: [PATCH] ASoC: topology: Avoid card NULL deref in snd_soc_tplg_component_remove()
Date:   Fri,  3 Jun 2022 13:14:25 -0700
Message-Id: <20220603201425.2590-1-deang@tpi.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Don't deference card in comp->card->snd_card before checking for NULL card.

During the unloading of ASoC kernel modules, there is a kernel oops in
snd_soc_tplg_component_remove() that happens because comp->card is set to
NULL in soc_cleanup_component().

Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Fixes: 7e567b5ae063 ("ASoC: topology: Add missing rwsem around snd_ctl_remove() calls")
Signed-off-by: Dean Gehnert <deang@tpi.com>
---
 sound/soc/soc-topology.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/sound/soc/soc-topology.c b/sound/soc/soc-topology.c
index 3f9d314fba16..cf0efe1147c2 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -2613,15 +2613,18 @@ EXPORT_SYMBOL_GPL(snd_soc_tplg_component_load);
 /* remove dynamic controls from the component driver */
 int snd_soc_tplg_component_remove(struct snd_soc_component *comp)
 {
-	struct snd_card *card = comp->card->snd_card;
+	struct snd_card *card;
 	struct snd_soc_dobj *dobj, *next_dobj;
 	int pass;
 
 	/* process the header types from end to start */
 	for (pass = SOC_TPLG_PASS_END; pass >= SOC_TPLG_PASS_START; pass--) {
 
+		card = (comp->card) ? comp->card->snd_card : NULL;
+
 		/* remove mixer controls */
-		down_write(&card->controls_rwsem);
+		if (card)
+			down_write(&card->controls_rwsem);
 		list_for_each_entry_safe(dobj, next_dobj, &comp->dobj_list,
 			list) {
 
@@ -2660,7 +2663,8 @@ int snd_soc_tplg_component_remove(struct snd_soc_component *comp)
 				break;
 			}
 		}
-		up_write(&card->controls_rwsem);
+		if (card)
+			up_write(&card->controls_rwsem);
 	}
 
 	/* let caller know if FW can be freed when no objects are left */
-- 
2.17.1

