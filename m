Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7137033B9BE
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbhCOOGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:06:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:47794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233190AbhCOOBs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E025C64EEE;
        Mon, 15 Mar 2021 14:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816908;
        bh=2X/boaDRY/ALEiqf8bsk4O1+AVCwb495o8No2lJS2Qs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lb98dc3cexsXHEAO30fjG7op9LKw2dH4bdmZQUCt3SKYxmBs4DDBvUx4MeVSSs4ke
         TJwnAzJVP2YZEXJ1/NV5ZNk2SPJrOlDEMEDiEHpgkH9lEcCNLS0TbqnB5zxIGJCwBl
         xKl6boYeruGLTLPJL3E6LMSF1y8ZuK5vFCad2Es0=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 182/290] ALSA: usb-audio: fix use after free in usb_audio_disconnect
Date:   Mon, 15 Mar 2021 14:54:35 +0100
Message-Id: <20210315135548.067241273@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
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
@@ -907,6 +907,9 @@ static void usb_audio_disconnect(struct
 		}
 	}
 
+	if (chip->quirk_type & QUIRK_SETUP_DISABLE_AUTOSUSPEND)
+		usb_enable_autosuspend(interface_to_usbdev(intf));
+
 	chip->num_interfaces--;
 	if (chip->num_interfaces <= 0) {
 		usb_chip[chip->index] = NULL;
@@ -915,9 +918,6 @@ static void usb_audio_disconnect(struct
 	} else {
 		mutex_unlock(&register_mutex);
 	}
-
-	if (chip->quirk_type & QUIRK_SETUP_DISABLE_AUTOSUSPEND)
-		usb_enable_autosuspend(interface_to_usbdev(intf));
 }
 
 /* lock the shutdown (disconnect) task and autoresume */


