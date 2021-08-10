Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 699B93E8152
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236221AbhHJR6g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:58:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:55478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237080AbhHJR4g (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:56:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E702610CC;
        Tue, 10 Aug 2021 17:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617506;
        bh=LhevaPbSOWKNVze6HPaYFtDGUY+O3AQEDigxjY6v5cg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cz5eSkjHrteiw6EPjBun93ldtfR+oymx9UhnHcbumdgptssu6dhSRzcJ3hQDzMJ7V
         7YXhDfi+em58qCr36bqY0kucE7V7NJbYghdbZL82mou87MfOIbKjN1Is6iEOxXQtRo
         9cBDE9oJWOaUdRmruDut/RjOlpBo06HghQShJ8vU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.13 088/175] ALSA: usb-audio: Avoid unnecessary or invalid connector selection at resume
Date:   Tue, 10 Aug 2021 19:29:56 +0200
Message-Id: <20210810173003.842326036@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 8dde723fcde4479f256441da03793e37181d9f21 upstream.

The recent fix for the resume on Lenovo machines seems causing a
regression on others.  It's because the change always triggers the
connector selection no matter which widget node type is.

This patch addresses the regression by setting the resume callback
selectively only for the connector widget.

Fixes: 44609fc01f28 ("ALSA: usb-audio: Check connector value on resume")
Cc: <stable@vger.kernel.org>
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=213897
Link: https://lore.kernel.org/r/20210729185126.24432-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer.c |   35 ++++++++++++++++++++---------------
 1 file changed, 20 insertions(+), 15 deletions(-)

--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1816,6 +1816,15 @@ static void get_connector_control_name(s
 		strlcat(name, " - Output Jack", name_size);
 }
 
+/* get connector value to "wake up" the USB audio */
+static int connector_mixer_resume(struct usb_mixer_elem_list *list)
+{
+	struct usb_mixer_elem_info *cval = mixer_elem_list_to_info(list);
+
+	get_connector_value(cval, NULL, NULL);
+	return 0;
+}
+
 /* Build a mixer control for a UAC connector control (jack-detect) */
 static void build_connector_control(struct usb_mixer_interface *mixer,
 				    const struct usbmix_name_map *imap,
@@ -1833,6 +1842,10 @@ static void build_connector_control(stru
 	if (!cval)
 		return;
 	snd_usb_mixer_elem_init_std(&cval->head, mixer, term->id);
+
+	/* set up a specific resume callback */
+	cval->head.resume = connector_mixer_resume;
+
 	/*
 	 * UAC2: The first byte from reading the UAC2_TE_CONNECTOR control returns the
 	 * number of channels connected.
@@ -3642,23 +3655,15 @@ static int restore_mixer_value(struct us
 	return 0;
 }
 
-static int default_mixer_resume(struct usb_mixer_elem_list *list)
-{
-	struct usb_mixer_elem_info *cval = mixer_elem_list_to_info(list);
-
-	/* get connector value to "wake up" the USB audio */
-	if (cval->val_type == USB_MIXER_BOOLEAN && cval->channels == 1)
-		get_connector_value(cval, NULL, NULL);
-
-	return 0;
-}
-
 static int default_mixer_reset_resume(struct usb_mixer_elem_list *list)
 {
-	int err = default_mixer_resume(list);
+	int err;
 
-	if (err < 0)
-		return err;
+	if (list->resume) {
+		err = list->resume(list);
+		if (err < 0)
+			return err;
+	}
 	return restore_mixer_value(list);
 }
 
@@ -3697,7 +3702,7 @@ void snd_usb_mixer_elem_init_std(struct
 	list->id = unitid;
 	list->dump = snd_usb_mixer_dump_cval;
 #ifdef CONFIG_PM
-	list->resume = default_mixer_resume;
+	list->resume = NULL;
 	list->reset_resume = default_mixer_reset_resume;
 #endif
 }


