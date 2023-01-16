Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B23E766C518
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbjAPQBm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:01:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231931AbjAPQBV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:01:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5E110DA
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:01:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7F5FB81062
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:01:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C0F0C433EF;
        Mon, 16 Jan 2023 16:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884877;
        bh=AdGuGlY91n6XhXYPhCqj4AtSSr6BJKNwfdIJhNi92cM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=miT2HV6jslRVAkmOTI4Xu4Pzlle9J761ynhDmpfgipnM/AWP3Mh78xfDmGcxL0+2F
         ybQLu4lMfyGfbHn+W/UPCYwvQiAObzMth5TEXtun4Q6lItxKWd++plB70s8+b2odam
         BvbbvaX3gMbFRuhdEzjvIbZyMu/2pAeZDDzEVPrg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, coverity-bot <keescook@chromium.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 174/183] ALSA: usb-audio: Fix possible NULL pointer dereference in snd_usb_pcm_has_fixed_rate()
Date:   Mon, 16 Jan 2023 16:51:37 +0100
Message-Id: <20230116154810.655727238@linuxfoundation.org>
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

[ Upstream commit 92a9c0ad86d47ff4cce899012e355c400f02cfb8 ]

The subs function argument may be NULL, so do not use it before the NULL check.

Fixes: 291e9da91403 ("ALSA: usb-audio: Always initialize fixed_rate in snd_usb_find_implicit_fb_sync_format()")
Reported-by: coverity-bot <keescook@chromium.org>
Link: https://lore.kernel.org/alsa-devel/202301121424.4A79A485@keescook/
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20230113085311.623325-1-perex@perex.cz
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/pcm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index 29838000eee0..2c5765cbed2d 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -160,11 +160,12 @@ find_substream_format(struct snd_usb_substream *subs,
 bool snd_usb_pcm_has_fixed_rate(struct snd_usb_substream *subs)
 {
 	const struct audioformat *fp;
-	struct snd_usb_audio *chip = subs->stream->chip;
+	struct snd_usb_audio *chip;
 	int rate = -1;
 
 	if (!subs)
 		return false;
+	chip = subs->stream->chip;
 	if (!(chip->quirk_flags & QUIRK_FLAG_FIXED_RATE))
 		return false;
 	list_for_each_entry(fp, &subs->fmt_list, list) {
-- 
2.35.1



