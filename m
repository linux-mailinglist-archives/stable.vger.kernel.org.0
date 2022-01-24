Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E92499513
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392184AbiAXUuf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:50:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358714AbiAXUm7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:42:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77791C019B17;
        Mon, 24 Jan 2022 11:53:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17C7A60B56;
        Mon, 24 Jan 2022 19:53:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E3AC340E5;
        Mon, 24 Jan 2022 19:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053988;
        bh=zfKn7wh8I2H8T5QJWZmD5y1h6MOrm2419lqsY1J2kOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fJ8NX6+AagUndKNoXu5DdxdPD5H9JAacMiTlmeAXADt6sOZAafDjkfuA6gfFqo0U7
         OZZITNLoSP97K5H3tDYUTuTYGQ3C7iWk6zIuYRpxtr15y3lNCe3JXoBO53GMhzhN4C
         BawuE3xKt3WEeLgtJ06sYfoZFyzumdXnsqVoVlb0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 241/563] ALSA: hda: Add missing rwsem around snd_ctl_remove() calls
Date:   Mon, 24 Jan 2022 19:40:06 +0100
Message-Id: <20220124184032.765181648@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
index 6dece719be669..39281106477eb 100644
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



