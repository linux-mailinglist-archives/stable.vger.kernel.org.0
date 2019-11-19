Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 740AE101921
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727432AbfKSGMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 01:12:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:35942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727239AbfKSFVN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:21:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AB3B22317;
        Tue, 19 Nov 2019 05:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574140873;
        bh=JmLPL/HEQWkgPTJclvHxmxL5U3PoN0BCo8F9NLWo16o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IUUyangO5VXU958PcmL/V/s0MdOge+KBSS+8FKSQxUSQUNOYHQkvgPoiyKJe0x5j7
         0k55T3G+agQClFca9kdc0MKVjq3OoR+sEWY0j6nn4bNXsaOvwPc0XQQBTMsw3uxF8C
         yDFhnNayuGbkezgvsmY8xT0YDkKjwQsmpPMIxfvM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Machek <pavel@denx.de>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.3 16/48] ALSA: usb-audio: Fix incorrect NULL check in create_yamaha_midi_quirk()
Date:   Tue, 19 Nov 2019 06:19:36 +0100
Message-Id: <20191119051001.053603583@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119050946.745015350@linuxfoundation.org>
References: <20191119050946.745015350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit cc9dbfa9707868fb0ca864c05e0c42d3f4d15cf2 upstream.

The commit 60849562a5db ("ALSA: usb-audio: Fix possible NULL
dereference at create_yamaha_midi_quirk()") added NULL checks in
create_yamaha_midi_quirk(), but there was an overlook.  The code
allows one of either injd or outjd is NULL, but the second if check
made returning -ENODEV if any of them is NULL.  Fix it in a proper
form.

Fixes: 60849562a5db ("ALSA: usb-audio: Fix possible NULL dereference at create_yamaha_midi_quirk()")
Reported-by: Pavel Machek <pavel@denx.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191113111259.24123-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/quirks.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -248,8 +248,8 @@ static int create_yamaha_midi_quirk(stru
 					NULL, USB_MS_MIDI_OUT_JACK);
 	if (!injd && !outjd)
 		return -ENODEV;
-	if (!(injd && snd_usb_validate_midi_desc(injd)) ||
-	    !(outjd && snd_usb_validate_midi_desc(outjd)))
+	if ((injd && !snd_usb_validate_midi_desc(injd)) ||
+	    (outjd && !snd_usb_validate_midi_desc(outjd)))
 		return -ENODEV;
 	if (injd && (injd->bLength < 5 ||
 		     (injd->bJackType != USB_MS_EMBEDDED &&


