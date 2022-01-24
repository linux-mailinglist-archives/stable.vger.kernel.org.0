Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 868064989EB
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344080AbiAXS7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:59:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55964 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344602AbiAXS4z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:56:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42870614D4;
        Mon, 24 Jan 2022 18:56:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2F2C340E5;
        Mon, 24 Jan 2022 18:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050612;
        bh=pEIEsDSrG3oWDQUzVwhFvwuMJ95sRq01nVXR4rmLB9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JZdTfJa6oW/VyNQCK8qoNFvszG39n5RRXGJHaE+kKG5F7yeznlwECGiWwwEv0Ugz2
         hYTWNmnH177oBKdFhfbi1XlIeXl6uHKZtAj3W7DgWXspvNe48YH/7LiQptvhCpBmTo
         ClXcSDaE369meknX+bcOxUeVo0UT48P60JSJ4nWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 058/157] ALSA: PCM: Add missing rwsem around snd_ctl_remove() calls
Date:   Mon, 24 Jan 2022 19:42:28 +0100
Message-Id: <20220124183934.626355735@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183932.787526760@linuxfoundation.org>
References: <20220124183932.787526760@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 5471e9762e1af4b7df057a96bfd46cc250979b88 ]

snd_ctl_remove() has to be called with card->controls_rwsem held (when
called after the card instantiation).  This patch add the missing
rwsem calls around it.

Fixes: a8ff48cb7083 ("ALSA: pcm: Free chmap at PCM free callback, too")
Link: https://lore.kernel.org/r/20211116071314.15065-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/pcm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/core/pcm.c b/sound/core/pcm.c
index cdff5f9764808..6ae28dcd79945 100644
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -857,7 +857,11 @@ EXPORT_SYMBOL(snd_pcm_new_internal);
 static void free_chmap(struct snd_pcm_str *pstr)
 {
 	if (pstr->chmap_kctl) {
-		snd_ctl_remove(pstr->pcm->card, pstr->chmap_kctl);
+		struct snd_card *card = pstr->pcm->card;
+
+		down_write(&card->controls_rwsem);
+		snd_ctl_remove(card, pstr->chmap_kctl);
+		up_write(&card->controls_rwsem);
 		pstr->chmap_kctl = NULL;
 	}
 }
-- 
2.34.1



