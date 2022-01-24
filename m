Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A01F49A95E
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1322503AbiAYDV4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:21:56 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53278 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356849AbiAXU2c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:28:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EBEE6150E;
        Mon, 24 Jan 2022 20:28:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748BEC340E5;
        Mon, 24 Jan 2022 20:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056111;
        bh=60cLQvpCN4PqXns9qUE1a06rKf2YK4MYdVLXKQLv6t8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s57ZaHOyLyvZHl+aEfTaE/fwWqYVG1PaNnwrrVIh7P1Rqqkm/1TRHgUqAAY+8nhci
         GRaMNjuZYJinxatyMwcjoCUOwwyRjpCTbmJT2JMV+W7Rh+Q2+l7XxhShLpM1wLzdhO
         wt8OBvNx1L3d5kfQGH3G/gK0ugJzN24Expxz0PLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 375/846] ALSA: PCM: Add missing rwsem around snd_ctl_remove() calls
Date:   Mon, 24 Jan 2022 19:38:12 +0100
Message-Id: <20220124184113.868119759@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
index 6fd3677685d70..ba4a987ed1c62 100644
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -810,7 +810,11 @@ EXPORT_SYMBOL(snd_pcm_new_internal);
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



