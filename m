Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD0634988D5
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343519AbiAXSuu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:50:50 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48884 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245556AbiAXSuM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:50:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30DC9614CF;
        Mon, 24 Jan 2022 18:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF7BC340E5;
        Mon, 24 Jan 2022 18:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050211;
        bh=pEIEsDSrG3oWDQUzVwhFvwuMJ95sRq01nVXR4rmLB9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v7KYNRYAUMYZdRTogzo3P2mb3SKW/7tn1VZcr8COPmsgpEQcSoURG/+nvMI3aoBW6
         SaU+daEhlfJrz2yAXK+wXeGvF4NehQY/GXyZzZAWr/r+w9bByZqyOjN4gFsLvHRRxg
         aCfmzQ8c9WASMi3BohRKhbFyPYmvafbCQroxil7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 044/114] ALSA: PCM: Add missing rwsem around snd_ctl_remove() calls
Date:   Mon, 24 Jan 2022 19:42:19 +0100
Message-Id: <20220124183928.467243188@linuxfoundation.org>
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



