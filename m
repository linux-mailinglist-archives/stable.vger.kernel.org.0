Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38F6E46244D
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbhK2WR1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:17:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232448AbhK2WQw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:16:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7F8C12A759;
        Mon, 29 Nov 2021 10:23:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54DAFB8159D;
        Mon, 29 Nov 2021 18:23:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79894C53FCD;
        Mon, 29 Nov 2021 18:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210195;
        bh=9dF7jlh1AwsVRl+DUvdVOvrd+VJrWzHEHssPYtQ3kM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xvg3VWrD7P9HsnJu2Jh3ZlpTblOKECQ7pXypA70vPbkW557SIHj5yrooQ2Sd/jfEO
         aZaEka5VALMN9+ZJxUEt/id9cNuM2uVtJAakXNJtdnr4/tmvsvyElkSyN7b7KbHWgK
         WcWLdq9cMlf8tBt/tDuJx2jZG+B/QVCQHARlhcuQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 41/69] ASoC: topology: Add missing rwsem around snd_ctl_remove() calls
Date:   Mon, 29 Nov 2021 19:18:23 +0100
Message-Id: <20211129181705.009532428@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181703.670197996@linuxfoundation.org>
References: <20211129181703.670197996@linuxfoundation.org>
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
index 2c6598e07dde3..ccf6dd9411975 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -2565,6 +2565,7 @@ EXPORT_SYMBOL_GPL(snd_soc_tplg_widget_remove_all);
 /* remove dynamic controls from the component driver */
 int snd_soc_tplg_component_remove(struct snd_soc_component *comp, u32 index)
 {
+	struct snd_card *card = comp->card->snd_card;
 	struct snd_soc_dobj *dobj, *next_dobj;
 	int pass = SOC_TPLG_PASS_END;
 
@@ -2572,6 +2573,7 @@ int snd_soc_tplg_component_remove(struct snd_soc_component *comp, u32 index)
 	while (pass >= SOC_TPLG_PASS_START) {
 
 		/* remove mixer controls */
+		down_write(&card->controls_rwsem);
 		list_for_each_entry_safe(dobj, next_dobj, &comp->dobj_list,
 			list) {
 
@@ -2605,6 +2607,7 @@ int snd_soc_tplg_component_remove(struct snd_soc_component *comp, u32 index)
 				break;
 			}
 		}
+		up_write(&card->controls_rwsem);
 		pass--;
 	}
 
-- 
2.33.0



