Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C150B33B9B8
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234963AbhCOOGg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:06:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:36788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233403AbhCOOBi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96A1264E83;
        Mon, 15 Mar 2021 14:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816871;
        bh=vCs1U2AmFboxs0iFffCrRcjuElUJSTmBrNiv0m68wJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y8LPKTvyCdDw2Ipz//63mhwlVbAPJgcuaVRQykm7npwXZ6DUQ5mnWCPGfYq5CfMdT
         UPs62y08FWEuxF1LiY60rNcv+fBNB0ar5XpmUtBTFxBFwEbONYIedwjn/p8WZleBG/
         a9qsY7MGWOm9Ssn593hOgEyQAxooMq8jHVjsFmGo=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.11 175/306] ALSA: usb-audio: fix use after free in usb_audio_disconnect
Date:   Mon, 15 Mar 2021 14:53:58 +0100
Message-Id: <20210315135513.530255442@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Pavel Skripkin <paskripkin@gmail.com>

commit c5aa956eaeb05fe87e33433d7fd9f5e4d23c7416 upstream.

The problem was in wrong "if" placement. chip->quirk_type is freed
in snd_card_free_when_closed(), but inside if statement it's accesed.

Fixes: 9799110825db ("ALSA: usb-audio: Disable USB autosuspend properly in setup_disable_autosuspend()")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/16da19126ff461e5e64a9aec648cce28fb8ed73e.1615242183.git.paskripkin@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/card.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -908,6 +908,9 @@ static void usb_audio_disconnect(struct
 		}
 	}
 
+	if (chip->quirk_type & QUIRK_SETUP_DISABLE_AUTOSUSPEND)
+		usb_enable_autosuspend(interface_to_usbdev(intf));
+
 	chip->num_interfaces--;
 	if (chip->num_interfaces <= 0) {
 		usb_chip[chip->index] = NULL;
@@ -916,9 +919,6 @@ static void usb_audio_disconnect(struct
 	} else {
 		mutex_unlock(&register_mutex);
 	}
-
-	if (chip->quirk_type & QUIRK_SETUP_DISABLE_AUTOSUSPEND)
-		usb_enable_autosuspend(interface_to_usbdev(intf));
 }
 
 /* lock the shutdown (disconnect) task and autoresume */


