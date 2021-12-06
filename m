Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1018469B06
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345783AbhLFPMK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:12:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349345AbhLFPK3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:10:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8F7C08EA4D;
        Mon,  6 Dec 2021 07:04:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22EA8B8111F;
        Mon,  6 Dec 2021 15:04:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF35C341C1;
        Mon,  6 Dec 2021 15:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803067;
        bh=ZBAq8rhoouFJbG4qfRMRUuXRjBSasQnndDjFnrF/CJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mcTfT85ixNzU7E4aosIbhDECU7KM6RS2Ddb1Y9Lg3ObXrKwIrrigTSkwqLEvlfKYL
         fkVocQKHDNLtp8D8i4NrnqIOIhp8UUIeGO0a0R2A3jnCqejkvJfgATl6gKLKQ6TuHj
         rG+BgD9/uZB1ya4/qoc5XX50s7IKaJbz5LAiC31k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 017/106] ASoC: topology: Add missing rwsem around snd_ctl_remove() calls
Date:   Mon,  6 Dec 2021 15:55:25 +0100
Message-Id: <20211206145555.974928234@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145555.386095297@linuxfoundation.org>
References: <20211206145555.386095297@linuxfoundation.org>
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
index 50aa45525be5a..0fbe505026997 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -2585,6 +2585,7 @@ EXPORT_SYMBOL_GPL(snd_soc_tplg_widget_remove_all);
 /* remove dynamic controls from the component driver */
 int snd_soc_tplg_component_remove(struct snd_soc_component *comp, u32 index)
 {
+	struct snd_card *card = comp->card->snd_card;
 	struct snd_soc_dobj *dobj, *next_dobj;
 	int pass = SOC_TPLG_PASS_END;
 
@@ -2592,6 +2593,7 @@ int snd_soc_tplg_component_remove(struct snd_soc_component *comp, u32 index)
 	while (pass >= SOC_TPLG_PASS_START) {
 
 		/* remove mixer controls */
+		down_write(&card->controls_rwsem);
 		list_for_each_entry_safe(dobj, next_dobj, &comp->dobj_list,
 			list) {
 
@@ -2625,6 +2627,7 @@ int snd_soc_tplg_component_remove(struct snd_soc_component *comp, u32 index)
 				break;
 			}
 		}
+		up_write(&card->controls_rwsem);
 		pass--;
 	}
 
-- 
2.33.0



