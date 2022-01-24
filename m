Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E8B4993A1
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386033AbiAXUe5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:34:57 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35208 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384001AbiAXU2h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:28:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5637EB8119E;
        Mon, 24 Jan 2022 20:28:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E79C340E5;
        Mon, 24 Jan 2022 20:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056114;
        bh=Md4ZH5I6rM15jQTYj4f4nWYyhIsKhAhF5qdEF3guwUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=euRQ3hnDFtaiGd4JawNGRIbpvAXZFkyUSHQDqmJkjwOh5c/vy9Veau01tF4xNclOp
         XSewu//ybOBrmL3OfZXfxEVS8frMCQdc/xfpD4fAWMbrXVGte7El6z8+YSzoBF/tne
         yaNCSxMRJm9lVK6WdO+ELBB02aCNf/12yg/i+JQE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 376/846] ALSA: hda: Add missing rwsem around snd_ctl_remove() calls
Date:   Mon, 24 Jan 2022 19:38:13 +0100
Message-Id: <20220124184113.898915453@linuxfoundation.org>
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
index 0c4a337c9fc0d..eda70814369bd 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -1727,8 +1727,11 @@ void snd_hda_ctls_clear(struct hda_codec *codec)
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



