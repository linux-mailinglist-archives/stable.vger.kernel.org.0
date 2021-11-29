Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5571E461EFD
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379882AbhK2Sm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:42:26 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:55362 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379887AbhK2SkY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:40:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E13B1CE16BA;
        Mon, 29 Nov 2021 18:37:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E093C53FCD;
        Mon, 29 Nov 2021 18:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211022;
        bh=57DK+2iSP0PZZqyRKfWrRdxAYR9g29a+VKXEgoOGjts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v82k5t2GP2OnTtmyJFTSFlHpljHTYafVPVeknaHyYmVhUQEtx2N4Onbdy2cpACF7C
         5rEJamZvF0faG25SSmkudPoj48G2KS0fEgN/XUpAUSxzEmaIojwdwyBswSVdrnvzEX
         81WV+YoGI8C404d1PHR33Ti9bubJJtXQTXqqlUSQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 076/179] ASoC: topology: Add missing rwsem around snd_ctl_remove() calls
Date:   Mon, 29 Nov 2021 19:17:50 +0100
Message-Id: <20211129181721.455378929@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 7e567b5ae06315ef2d70666b149962e2bb4b97af ]

snd_ctl_remove() has to be called with card->controls_rwsem held (when
called after the card instantiation).  This patch add the missing
rwsem calls around it.

Fixes: 8a9782346dcc ("ASoC: topology: Add topology core")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20211116071812.18109-1-tiwai@suse.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-topology.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/soc-topology.c b/sound/soc/soc-topology.c
index f6e5ac3e03140..7459956d62b99 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -2674,6 +2674,7 @@ EXPORT_SYMBOL_GPL(snd_soc_tplg_component_load);
 /* remove dynamic controls from the component driver */
 int snd_soc_tplg_component_remove(struct snd_soc_component *comp)
 {
+	struct snd_card *card = comp->card->snd_card;
 	struct snd_soc_dobj *dobj, *next_dobj;
 	int pass = SOC_TPLG_PASS_END;
 
@@ -2681,6 +2682,7 @@ int snd_soc_tplg_component_remove(struct snd_soc_component *comp)
 	while (pass >= SOC_TPLG_PASS_START) {
 
 		/* remove mixer controls */
+		down_write(&card->controls_rwsem);
 		list_for_each_entry_safe(dobj, next_dobj, &comp->dobj_list,
 			list) {
 
@@ -2719,6 +2721,7 @@ int snd_soc_tplg_component_remove(struct snd_soc_component *comp)
 				break;
 			}
 		}
+		up_write(&card->controls_rwsem);
 		pass--;
 	}
 
-- 
2.33.0



