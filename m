Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78442498AEB
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344426AbiAXTHx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:07:53 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35822 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345431AbiAXTFv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:05:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 898C060915;
        Mon, 24 Jan 2022 19:05:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D29C340E8;
        Mon, 24 Jan 2022 19:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051150;
        bh=GI8rViXqs2bdhiSwCmv3aNUVUSabK0VoZcqOpoSJ5sQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DprSpOEfUqe0sWrAnSRpWK5Lo4kOmPcwOsJbn2axPHKKnUUYh7sOpmgshEM8HFuy4
         tcfubf/NqN+JYYX+q19Abg8FfugmiSuSx/VsIajztV6waro6mZvrPGYH5xuCGrZzgS
         E3qvipRKgUITwVjvok2o6evCNnuL3JJ7Ap/icR7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 069/186] ALSA: jack: Add missing rwsem around snd_ctl_remove() calls
Date:   Mon, 24 Jan 2022 19:42:24 +0100
Message-Id: <20220124183939.346173866@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
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
index 5ddf81f091fa9..36cfe1c54109d 100644
--- a/sound/core/jack.c
+++ b/sound/core/jack.c
@@ -68,10 +68,13 @@ static int snd_jack_dev_free(struct snd_device *device)
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



