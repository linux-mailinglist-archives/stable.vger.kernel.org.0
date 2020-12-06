Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF2972D03CC
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbgLFLkZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:40:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:37526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728532AbgLFLkZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 06:40:25 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hector Martin <marcan@marcan.st>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 28/32] ALSA: usb-audio: US16x08: fix value count for level meters
Date:   Sun,  6 Dec 2020 12:17:28 +0100
Message-Id: <20201206111557.116817666@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201206111555.787862631@linuxfoundation.org>
References: <20201206111555.787862631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hector Martin <marcan@marcan.st>

commit 402d5840b0d40a2a26c8651165d29b534abb6d36 upstream.

The level meter control returns 34 integers of info. This fixes:

snd-usb-audio 3-1:1.0: control 2:0:0:Level Meter:0: access overflow

Fixes: d2bb390a2081 ("ALSA: usb-audio: Tascam US-16x08 DSP mixer quirk")
Cc: stable@vger.kernel.org
Signed-off-by: Hector Martin <marcan@marcan.st>
Link: https://lore.kernel.org/r/20201127132635.18947-1-marcan@marcan.st
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/mixer_us16x08.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/mixer_us16x08.c
+++ b/sound/usb/mixer_us16x08.c
@@ -617,7 +617,7 @@ static int snd_us16x08_eq_put(struct snd
 static int snd_us16x08_meter_info(struct snd_kcontrol *kcontrol,
 	struct snd_ctl_elem_info *uinfo)
 {
-	uinfo->count = 1;
+	uinfo->count = 34;
 	uinfo->type = SNDRV_CTL_ELEM_TYPE_INTEGER;
 	uinfo->value.integer.max = 0x7FFF;
 	uinfo->value.integer.min = 0;


