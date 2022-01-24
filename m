Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAA744988DA
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245578AbiAXSvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:51:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48972 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242005AbiAXSuP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:50:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 258E0614EE;
        Mon, 24 Jan 2022 18:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E44C340EC;
        Mon, 24 Jan 2022 18:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050214;
        bh=u4rdTNfjLYwAFzUQETfWg9clXMBotXlWIY1suq3Pf0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eloj5W58uMgn3cktv3oEmNS/OY5acNiWJLdwLyimvooXnK+vyYdpUIqH4ue1Tx+Zv
         yZPiYcaGJ9BRQzbEEE7Rup5fjkCooJJXFnbG9sFXe9tU2EhC3m5x1oSX6oDhKVcP7/
         /aU1Pme6qn54UP/Qx0kqKz/JuQXvr50tc0Ke0h4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 045/114] ALSA: hda: Add missing rwsem around snd_ctl_remove() calls
Date:   Mon, 24 Jan 2022 19:42:20 +0100
Message-Id: <20220124183928.497524144@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183927.095545464@linuxfoundation.org>
References: <20220124183927.095545464@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 80bd64af75b4bb11c0329bc66c35da2ddfb66d88 ]

snd_ctl_remove() has to be called with card->controls_rwsem held (when
called after the card instantiation).  This patch add the missing
rwsem calls around it.

Fixes: d13bd412dce2 ("ALSA: hda - Manage kcontrol lists")
Link: https://lore.kernel.org/r/20211116071314.15065-3-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_codec.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index 4962a9d8a572b..7533f8860c57e 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -1608,8 +1608,11 @@ void snd_hda_ctls_clear(struct hda_codec *codec)
 {
 	int i;
 	struct hda_nid_item *items = codec->mixers.list;
+
+	down_write(&codec->card->controls_rwsem);
 	for (i = 0; i < codec->mixers.used; i++)
 		snd_ctl_remove(codec->card, items[i].kctl);
+	up_write(&codec->card->controls_rwsem);
 	snd_array_free(&codec->mixers);
 	snd_array_free(&codec->nids);
 }
-- 
2.34.1



