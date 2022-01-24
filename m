Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 797A849A2F9
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2366044AbiAXXwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:52:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383930AbiAXXGH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:06:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D0BDC061A7F;
        Mon, 24 Jan 2022 13:17:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39E61B81233;
        Mon, 24 Jan 2022 21:16:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C29CC36AEB;
        Mon, 24 Jan 2022 21:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059018;
        bh=fLy9g1Dn9MLU9x6rBqmMs6F2pQoFUyKdCOxJNNtpLe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=064UNFFXX07h4wih0LBtYG0dkbBkG56HW8i8jgCQVkXExmrhpFzpMKP90zyRf3Nis
         k6UvIcFW4NNn65nk8jfNdb5ftXddsWah52b49iD8SaOF+i/xMdsyfFyc9hWFY/DU68
         /DGAYXvUo3qMH2qGB9ZNS7FOY7kaZreDh+efmZN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0445/1039] ALSA: jack: Add missing rwsem around snd_ctl_remove() calls
Date:   Mon, 24 Jan 2022 19:37:14 +0100
Message-Id: <20220124184140.255356036@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 06764dc931848c3a9bc01a63bbf76a605408bb54 ]

snd_ctl_remove() has to be called with card->controls_rwsem held (when
called after the card instantiation).  This patch add the missing
rwsem calls around it.

Fixes: 9058cbe1eed2 ("ALSA: jack: implement kctl creating for jack devices")
Link: https://lore.kernel.org/r/20211116071314.15065-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/jack.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/core/jack.c b/sound/core/jack.c
index 537df1e98f8ac..d1e3055f2b6a5 100644
--- a/sound/core/jack.c
+++ b/sound/core/jack.c
@@ -62,10 +62,13 @@ static int snd_jack_dev_free(struct snd_device *device)
 	struct snd_card *card = device->card;
 	struct snd_jack_kctl *jack_kctl, *tmp_jack_kctl;
 
+	down_write(&card->controls_rwsem);
 	list_for_each_entry_safe(jack_kctl, tmp_jack_kctl, &jack->kctl_list, list) {
 		list_del_init(&jack_kctl->list);
 		snd_ctl_remove(card, jack_kctl->kctl);
 	}
+	up_write(&card->controls_rwsem);
+
 	if (jack->private_free)
 		jack->private_free(jack);
 
-- 
2.34.1



