Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27B3E461DED
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348773AbhK2Sat (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:30:49 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33248 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353256AbhK2S2t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:28:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 693ACB815CC;
        Mon, 29 Nov 2021 18:25:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5F0C53FC7;
        Mon, 29 Nov 2021 18:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210329;
        bh=xmwMBhPWpZC7BLXttF7MhAbMwpJl0ZAyqEWEU1bnt00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nJQbO0EpKfxiO4Q7lxKfh1JdNfL/xVGSVxejggueT0zaFf6VDFsXTYZgua3LDu2Xs
         Ck0F7DFcp2l7OqUnKH2WX4cCSFhW13Jc57ht65JT1RIkb5XHYpNncnqakQ1hMgxsrQ
         FZJUnsXeTIBQmnHY7+gxFN/6ROd2TfVUQLo5hRsM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 50/92] ASoC: topology: Add missing rwsem around snd_ctl_remove() calls
Date:   Mon, 29 Nov 2021 19:18:19 +0100
Message-Id: <20211129181709.096560890@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
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
index c367609433bfc..21f859e56b700 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -2777,6 +2777,7 @@ EXPORT_SYMBOL_GPL(snd_soc_tplg_widget_remove_all);
 /* remove dynamic controls from the component driver */
 int snd_soc_tplg_component_remove(struct snd_soc_component *comp, u32 index)
 {
+	struct snd_card *card = comp->card->snd_card;
 	struct snd_soc_dobj *dobj, *next_dobj;
 	int pass = SOC_TPLG_PASS_END;
 
@@ -2784,6 +2785,7 @@ int snd_soc_tplg_component_remove(struct snd_soc_component *comp, u32 index)
 	while (pass >= SOC_TPLG_PASS_START) {
 
 		/* remove mixer controls */
+		down_write(&card->controls_rwsem);
 		list_for_each_entry_safe(dobj, next_dobj, &comp->dobj_list,
 			list) {
 
@@ -2827,6 +2829,7 @@ int snd_soc_tplg_component_remove(struct snd_soc_component *comp, u32 index)
 				break;
 			}
 		}
+		up_write(&card->controls_rwsem);
 		pass--;
 	}
 
-- 
2.33.0



