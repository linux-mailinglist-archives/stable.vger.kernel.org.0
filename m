Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2522614B79F
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729160AbgA1OQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:16:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:39062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730236AbgA1OQD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:16:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FFE12468E;
        Tue, 28 Jan 2020 14:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220962;
        bh=8WqQeYXdv994NDxEeRcOODSCB/ugc9gN/IVH9Pbf19A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f7tCoqYfNlm2igXvn1+OECm+WtA4exjYTmrqhy/ZBtroeCkUdJ6SsEJo96d/rnOzc
         rMqjM3+32+qqwWOSZ+esjawOISPfdV7KKwJwz6JLToslrvsg7VB1duruQYNtDnvG62
         ab1CXVvMES7375f7eVLsAjxZs8zt1WxaW+LoGYcQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Huaman <nicolas@herochao.de>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 008/271] ALSA: usb-audio: update quirk for B&W PX to remove microphone
Date:   Tue, 28 Jan 2020 15:02:37 +0100
Message-Id: <20200128135853.009032099@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Huaman <nicolas@herochao.de>

[ Upstream commit c369c8db15d51fa175d2ba85928f79d16af6b562 ]

A quirk in snd-usb-audio was added to automate setting sample rate to
4800k and remove the previously exposed nonfunctional microphone for
the Bowers & Wilkins PX:
commit 240a8af929c7c57dcde28682725b29cf8474e8e5
https://lore.kernel.org/patchwork/patch/919689/

However the headphones where updated shortly after that to remove the
unintentional microphone functionality. I guess because of this the
headphones now crash when connecting them via USB while the quirk is
active. Dmesg:

snd-usb-audio: probe of 2-3:1.0 failed with error -22
usb 2-3: 2:1: cannot get min/max values for control 2 (id 2)

This patch removes the microfone and allows the headphones to connect
and work out of the box. It is based on the current mainline kernel
 and successfully applied an tested on my machine (4.18.10.arch1-1).

Fixes: 240a8af929c7 ("ALSA: usb-audio: Add a quirck for B&W PX headphones")
Signed-off-by: Nicolas Huaman <nicolas@herochao.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks-table.h | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index d32727c74a168..c892b4d1e733f 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -3293,19 +3293,14 @@ AU0828_DEVICE(0x2040, 0x7270, "Hauppauge", "HVR-950Q"),
 				.ifnum = 0,
 				.type = QUIRK_AUDIO_STANDARD_MIXER,
 			},
-			/* Capture */
-			{
-				.ifnum = 1,
-				.type = QUIRK_IGNORE_INTERFACE,
-			},
 			/* Playback */
 			{
-				.ifnum = 2,
+				.ifnum = 1,
 				.type = QUIRK_AUDIO_FIXED_ENDPOINT,
 				.data = &(const struct audioformat) {
 					.formats = SNDRV_PCM_FMTBIT_S16_LE,
 					.channels = 2,
-					.iface = 2,
+					.iface = 1,
 					.altsetting = 1,
 					.altset_idx = 1,
 					.attributes = UAC_EP_CS_ATTR_FILL_MAX |
-- 
2.20.1



