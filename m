Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 606CA498A33
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343828AbiAXTB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:01:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345300AbiAXTAB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:00:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FCBBC061776;
        Mon, 24 Jan 2022 10:56:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2A0661555;
        Mon, 24 Jan 2022 18:56:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89B05C340E8;
        Mon, 24 Jan 2022 18:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050616;
        bh=yRZ5PLm8YrBcENjVOphL8zjDmRVYXJ/aiF4IzO9WfI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YzU+piB0eZbtED4xYg5byd6VnSFEH9+zhoGjJj2pnIUqhcvMZhcCiBONkvsXBh4Eu
         +0999KEAv4QIuwuiIEqdplz6AfWQWmmenkllemvcR1WGt5EBLHZs+MNThbqfdkxbXR
         EIEUynKnsOCddTh0Pj4pH9EkBY9xvu/AXGh8U4kg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 059/157] ALSA: hda: Add missing rwsem around snd_ctl_remove() calls
Date:   Mon, 24 Jan 2022 19:42:29 +0100
Message-Id: <20220124183934.655747009@linuxfoundation.org>
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
index 4e67614f15f8e..8976da3e1e288 100644
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



