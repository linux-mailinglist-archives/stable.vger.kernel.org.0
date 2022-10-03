Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24F825F29ED
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiJCH2J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbiJCH1T (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:27:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A8B843618;
        Mon,  3 Oct 2022 00:19:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C94CB80E89;
        Mon,  3 Oct 2022 07:16:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA046C43148;
        Mon,  3 Oct 2022 07:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781408;
        bh=r9SMDNYMlc+TY4sI5YWGS0MJ2SeqlzjB8zbPnpwEWPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tYxFM0nGOKW38lnV0uzovxXsdCCtLwMiyD/L7mLn16GopMdcA2WzWOkBBD5N7syGG
         sp4ER4frzJ7hSR4/OR+gwzBeSYZOv0v7D6ZipLYl6iawRWvtqpemvOZ/aoPfX6TR6E
         PndQClD+Sz7bJnE553N6j/nKRUxXWf6E2g4w3iGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 01/83] ALSA: hda: Do disconnect jacks at codec unbind
Date:   Mon,  3 Oct 2022 09:10:26 +0200
Message-Id: <20221003070722.010820864@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
References: <20221003070721.971297651@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 37c4fd0db7c961145d9d1909ecab386fdf703c26 ]

The HD-audio codec driver remove may happen also at dynamically
unbinding during operation, hence it needs manual triggers of
snd_device_disconnect() calls, while it's missing for the jack objects
that are associated with the codec.

This patch adds the manual disconnection call for jacks when the
remove happens without card->shutdown (i.e. not under the full
removal).

Link: https://lore.kernel.org/r/20211117133040.20272-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: ead3d3c5b54f ("ALSA: hda: Fix hang at HD-audio codec unbinding due to refcount saturation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_bind.c |  2 ++
 sound/pci/hda/hda_jack.c | 11 +++++++++++
 sound/pci/hda/hda_jack.h |  1 +
 3 files changed, 14 insertions(+)

diff --git a/sound/pci/hda/hda_bind.c b/sound/pci/hda/hda_bind.c
index 7153bd53e189..c572fb5886d5 100644
--- a/sound/pci/hda/hda_bind.c
+++ b/sound/pci/hda/hda_bind.c
@@ -14,6 +14,7 @@
 #include <sound/core.h>
 #include <sound/hda_codec.h>
 #include "hda_local.h"
+#include "hda_jack.h"
 
 /*
  * find a matching codec id
@@ -158,6 +159,7 @@ static int hda_codec_driver_remove(struct device *dev)
 
 	refcount_dec(&codec->pcm_ref);
 	snd_hda_codec_disconnect_pcms(codec);
+	snd_hda_jack_tbl_disconnect(codec);
 	wait_event(codec->remove_sleep, !refcount_read(&codec->pcm_ref));
 	snd_power_sync_ref(codec->bus->card);
 
diff --git a/sound/pci/hda/hda_jack.c b/sound/pci/hda/hda_jack.c
index f29975e3e98d..7d7786df60ea 100644
--- a/sound/pci/hda/hda_jack.c
+++ b/sound/pci/hda/hda_jack.c
@@ -158,6 +158,17 @@ snd_hda_jack_tbl_new(struct hda_codec *codec, hda_nid_t nid, int dev_id)
 	return jack;
 }
 
+void snd_hda_jack_tbl_disconnect(struct hda_codec *codec)
+{
+	struct hda_jack_tbl *jack = codec->jacktbl.list;
+	int i;
+
+	for (i = 0; i < codec->jacktbl.used; i++, jack++) {
+		if (!codec->bus->shutdown && jack->jack)
+			snd_device_disconnect(codec->card, jack->jack);
+	}
+}
+
 void snd_hda_jack_tbl_clear(struct hda_codec *codec)
 {
 	struct hda_jack_tbl *jack = codec->jacktbl.list;
diff --git a/sound/pci/hda/hda_jack.h b/sound/pci/hda/hda_jack.h
index 2abf7aac243a..ff7d289c034b 100644
--- a/sound/pci/hda/hda_jack.h
+++ b/sound/pci/hda/hda_jack.h
@@ -69,6 +69,7 @@ struct hda_jack_tbl *
 snd_hda_jack_tbl_get_from_tag(struct hda_codec *codec,
 			      unsigned char tag, int dev_id);
 
+void snd_hda_jack_tbl_disconnect(struct hda_codec *codec);
 void snd_hda_jack_tbl_clear(struct hda_codec *codec);
 
 void snd_hda_jack_set_dirty_all(struct hda_codec *codec);
-- 
2.35.1



