Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0606E461E6B
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353618AbhK2Sf4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:35:56 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38660 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378883AbhK2Sdy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:33:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10D08B815D5;
        Mon, 29 Nov 2021 18:30:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A3E5C53FAD;
        Mon, 29 Nov 2021 18:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210634;
        bh=zixNzzC1qaOd265BmQALbj6b4g0lK33VIM7jawuNE0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZQZm71pvHuoRf3qfnUyUmwDdFWVzimBbWlVTC8OpyR+JvQjZYYui2Q5K44NY73S69
         FTc97HInKRmSZi1BzwWB87mU8Hlyop/6MNlmdiTHJfGR3zPvRl0P/JyUAPhF968ypE
         CfpVJRXIoaBKY5JAwvpfM2Fw7VnNhbV8hkUS3qz0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 050/121] ASoC: topology: Add missing rwsem around snd_ctl_remove() calls
Date:   Mon, 29 Nov 2021 19:18:01 +0100
Message-Id: <20211129181713.340451825@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
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
index 1030e11017b27..4d24ac255d253 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -2873,6 +2873,7 @@ EXPORT_SYMBOL_GPL(snd_soc_tplg_widget_remove_all);
 /* remove dynamic controls from the component driver */
 int snd_soc_tplg_component_remove(struct snd_soc_component *comp, u32 index)
 {
+	struct snd_card *card = comp->card->snd_card;
 	struct snd_soc_dobj *dobj, *next_dobj;
 	int pass = SOC_TPLG_PASS_END;
 
@@ -2880,6 +2881,7 @@ int snd_soc_tplg_component_remove(struct snd_soc_component *comp, u32 index)
 	while (pass >= SOC_TPLG_PASS_START) {
 
 		/* remove mixer controls */
+		down_write(&card->controls_rwsem);
 		list_for_each_entry_safe(dobj, next_dobj, &comp->dobj_list,
 			list) {
 
@@ -2923,6 +2925,7 @@ int snd_soc_tplg_component_remove(struct snd_soc_component *comp, u32 index)
 				break;
 			}
 		}
+		up_write(&card->controls_rwsem);
 		pass--;
 	}
 
-- 
2.33.0



