Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54ED949912A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355022AbiAXUJf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:09:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377240AbiAXUFL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:05:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C3B2C08E803;
        Mon, 24 Jan 2022 11:30:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D835BB8121B;
        Mon, 24 Jan 2022 19:30:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A99C340E5;
        Mon, 24 Jan 2022 19:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052640;
        bh=1hDgkUT07j19aBXT2Go+t8wv9L8LkMKR1sBjhqc3N+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BwMcz/yoYwUWyH328nkwD+ufLwE/mpI/7hhweH8Yyai+8r5//Guhzixq5sk6FdEwN
         7Hl5v8a2XBj9EzF68Y0Sj0cp5FMcFIXE5rM6FscU9ifA8gw0rZAUdMt9Enr+4gRaZ9
         wL3TppVgR/vA7VEfe6/FQgjbUBvpw1vUmNjUt1kw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 125/320] ALSA: hda: Add missing rwsem around snd_ctl_remove() calls
Date:   Mon, 24 Jan 2022 19:41:49 +0100
Message-Id: <20220124183957.929170787@linuxfoundation.org>
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
index 326f95ce5ceb1..c8847de8388f0 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -1721,8 +1721,11 @@ void snd_hda_ctls_clear(struct hda_codec *codec)
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



