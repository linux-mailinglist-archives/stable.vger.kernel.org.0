Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 277F4499163
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379185AbiAXUKb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:10:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377239AbiAXUFL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:05:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F865C061A11;
        Mon, 24 Jan 2022 11:30:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD69AB8121A;
        Mon, 24 Jan 2022 19:30:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CBCDC340E5;
        Mon, 24 Jan 2022 19:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052637;
        bh=bI71+dy3SjHsHKJSLG3Irk1aXpUx+GZcgDpdDh66Suk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QEJESrdDd5ZgIwu+XX32/dUPnTwYI76YaubPZqEZEeROW5gaQ89YsON9ImTjsYdjY
         U0YW6pxQEOF+L0eBRDmctQoR2qx0lqhFtOcYEhQnXSPFQn82o1xGuAUeFXGtDzslbN
         nNkg9TuftotPFdcoH3ApCXPDjgwHW17ooPRcQofQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 124/320] ALSA: PCM: Add missing rwsem around snd_ctl_remove() calls
Date:   Mon, 24 Jan 2022 19:41:48 +0100
Message-Id: <20220124183957.897720160@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
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
index 9a72d641743d9..f8ce961c28d6e 100644
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



