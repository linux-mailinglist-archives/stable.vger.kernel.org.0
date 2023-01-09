Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B132F662821
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 15:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbjAIOL6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 09:11:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234288AbjAIOLv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 09:11:51 -0500
Received: from mail1.perex.cz (mail1.perex.cz [77.48.224.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C5E563C7
        for <stable@vger.kernel.org>; Mon,  9 Jan 2023 06:11:49 -0800 (PST)
Received: from mail1.perex.cz (localhost [127.0.0.1])
        by smtp1.perex.cz (Perex's E-mail Delivery System) with ESMTP id 377A2A0040;
        Mon,  9 Jan 2023 15:11:46 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp1.perex.cz 377A2A0040
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=perex.cz; s=default;
        t=1673273506; bh=bdJQw3RjHRvPBAzXLjM89tBZKg2o+zofSE/cDoto0WU=;
        h=From:To:Cc:Subject:Date:From;
        b=V7edFy/yPIjYulHgOUsPgjvAKpum3D5VbQQeB0NZU3BIMdKzY2iLUbyGHEe8kMwrF
         lrbTQTQ4bkf5SC7ZGFCCFoYD5KpIHGCCpCcqgnjVFB7PXrtOCD6fuJ48lzAnVmyiHj
         0264FaTPNsmbwUKH/W18BHKmW+6lrhkqTZXMqfb0=
Received: from p1gen2.perex-int.cz (unknown [192.168.100.98])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: perex)
        by mail1.perex.cz (Perex's E-mail Delivery System) with ESMTPSA;
        Mon,  9 Jan 2023 15:11:41 +0100 (CET)
From:   Jaroslav Kysela <perex@perex.cz>
To:     ALSA development <alsa-devel@alsa-project.org>
Cc:     Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        Dan Carpenter <error27@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] ALSA: usb-audio: Always initialize fixed_rate in snd_usb_find_implicit_fb_sync_format()
Date:   Mon,  9 Jan 2023 15:11:33 +0100
Message-Id: <20230109141133.335543-1-perex@perex.cz>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Handle the fallback code path, too.

Fixes: fd28941cff1c ("ALSA: usb-audio: Add new quirk FIXED_RATE for JBL Quantum810 Wireless")
BugLink: https://lore.kernel.org/alsa-devel/Y7frf3N%2FxzvESEsN@kili/
Reported-by: Dan Carpenter <error27@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
---
 sound/usb/implicit.c | 3 ++-
 sound/usb/pcm.c      | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/usb/implicit.c b/sound/usb/implicit.c
index 41ac7185b42b..4727043fd745 100644
--- a/sound/usb/implicit.c
+++ b/sound/usb/implicit.c
@@ -471,7 +471,7 @@ snd_usb_find_implicit_fb_sync_format(struct snd_usb_audio *chip,
 	subs = find_matching_substream(chip, stream, target->sync_ep,
 				       target->fmt_type);
 	if (!subs)
-		return sync_fmt;
+		goto end;
 
 	high_score = 0;
 	list_for_each_entry(fp, &subs->fmt_list, list) {
@@ -485,6 +485,7 @@ snd_usb_find_implicit_fb_sync_format(struct snd_usb_audio *chip,
 		}
 	}
 
+ end:
 	if (fixed_rate)
 		*fixed_rate = snd_usb_pcm_has_fixed_rate(subs);
 	return sync_fmt;
diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index 99a66d0ef5b2..d2c652aa1385 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -163,6 +163,8 @@ bool snd_usb_pcm_has_fixed_rate(struct snd_usb_substream *subs)
 	struct snd_usb_audio *chip = subs->stream->chip;
 	int rate = -1;
 
+	if (!subs)
+		return false;
 	if (!(chip->quirk_flags & QUIRK_FLAG_FIXED_RATE))
 		return false;
 	list_for_each_entry(fp, &subs->fmt_list, list) {
-- 
2.39.0
