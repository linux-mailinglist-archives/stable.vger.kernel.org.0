Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 071B03D6109
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237481AbhGZP1k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:27:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:40574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236885AbhGZPZb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:25:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A946660F5B;
        Mon, 26 Jul 2021 16:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315560;
        bh=2y2ViINwvaGBM9RBMV8CAqe3gdoJej9Jud5Trp+2Iks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vJa9ckr6Ki/Br1D7fLPCIARIkx/nuJIhdCr6LA50LlcJPyaw02Z9aJP5TwjhqFHJy
         I2aQBfVKksGObp31vzzONpqvzSPNs4PjXF//pi+OXAJ6tx51xq4aWI5/gS27PdhgsE
         FN1g83diPUN/wmKnTTHWneb+KvgZPOUOPGPaMx3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Machek <pavel@denx.de>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 109/167] ALSA: usb-audio: Add missing proc text entry for BESPOKEN type
Date:   Mon, 26 Jul 2021 17:39:02 +0200
Message-Id: <20210726153843.052761147@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 64752a95b702817602d72f109ceaf5ec0780e283 upstream.

Recently we've added a new usb_mixer element type, USB_MIXER_BESPOKEN,
but it wasn't added in the table in snd_usb_mixer_dump_cval().  This
is no big problem since each bespoken type should have its own dump
method, but it still isn't disallowed to use the standard one, so we
should cover it as well.  Along with it, define the table with the
explicit array initializer for avoiding other pitfalls.

Fixes: 785b6f29a795 ("ALSA: usb-audio: scarlett2: Fix wrong resume call")
Reported-by: Pavel Machek <pavel@denx.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210714084836.1977-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -3274,7 +3274,15 @@ static void snd_usb_mixer_dump_cval(stru
 {
 	struct usb_mixer_elem_info *cval = mixer_elem_list_to_info(list);
 	static const char * const val_types[] = {
-		"BOOLEAN", "INV_BOOLEAN", "S8", "U8", "S16", "U16", "S32", "U32",
+		[USB_MIXER_BOOLEAN] = "BOOLEAN",
+		[USB_MIXER_INV_BOOLEAN] = "INV_BOOLEAN",
+		[USB_MIXER_S8] = "S8",
+		[USB_MIXER_U8] = "U8",
+		[USB_MIXER_S16] = "S16",
+		[USB_MIXER_U16] = "U16",
+		[USB_MIXER_S32] = "S32",
+		[USB_MIXER_U32] = "U32",
+		[USB_MIXER_BESPOKEN] = "BESPOKEN",
 	};
 	snd_iprintf(buffer, "    Info: id=%i, control=%i, cmask=0x%x, "
 			    "channels=%i, type=\"%s\"\n", cval->head.id,


