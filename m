Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD71C66C489
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbjAPP4D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:56:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231727AbjAPPzl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:55:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F3D51E2A1
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:55:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D00506102A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:55:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4125C433EF;
        Mon, 16 Jan 2023 15:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884537;
        bh=C7D+L/Aswv/ncZBysd07g1s05bMUgtu93GNK/ZXvdww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CB0lKLE0z4qZd5EFZa9USrkJuEOPoUKTrYjE6+u7HRQqqnn6KY7sax+iKfgt2VWQ/
         n4a3WN9bYaSOqbhVG029O9EKWnhdnyAmLQwezfWWV/PSruqYOBJtoYA5LasdwBZNTX
         CF7CTAZ0xUaHT/3r7SO+18I1ZhhKJDcTEXLV++mc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <error27@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 004/183] ALSA: usb-audio: Always initialize fixed_rate in snd_usb_find_implicit_fb_sync_format()
Date:   Mon, 16 Jan 2023 16:48:47 +0100
Message-Id: <20230116154803.533929683@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jaroslav Kysela <perex@perex.cz>

commit 291e9da91403e0e628d7692b5ed505100e7b7706 upstream.

Handle the fallback code path, too.

Fixes: fd28941cff1c ("ALSA: usb-audio: Add new quirk FIXED_RATE for JBL Quantum810 Wireless")
BugLink: https://lore.kernel.org/alsa-devel/Y7frf3N%2FxzvESEsN@kili/
Reported-by: Dan Carpenter <error27@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20230109141133.335543-1-perex@perex.cz
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/implicit.c |    3 ++-
 sound/usb/pcm.c      |    2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/sound/usb/implicit.c
+++ b/sound/usb/implicit.c
@@ -471,7 +471,7 @@ snd_usb_find_implicit_fb_sync_format(str
 	subs = find_matching_substream(chip, stream, target->sync_ep,
 				       target->fmt_type);
 	if (!subs)
-		return sync_fmt;
+		goto end;
 
 	high_score = 0;
 	list_for_each_entry(fp, &subs->fmt_list, list) {
@@ -485,6 +485,7 @@ snd_usb_find_implicit_fb_sync_format(str
 		}
 	}
 
+ end:
 	if (fixed_rate)
 		*fixed_rate = snd_usb_pcm_has_fixed_rate(subs);
 	return sync_fmt;
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -163,6 +163,8 @@ bool snd_usb_pcm_has_fixed_rate(struct s
 	struct snd_usb_audio *chip = subs->stream->chip;
 	int rate = -1;
 
+	if (!subs)
+		return false;
 	if (!(chip->quirk_flags & QUIRK_FLAG_FIXED_RATE))
 		return false;
 	list_for_each_entry(fp, &subs->fmt_list, list) {


