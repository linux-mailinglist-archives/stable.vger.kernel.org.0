Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0E103C5069
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241636AbhGLHcs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:32:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346932AbhGLHbQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:31:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF56560C40;
        Mon, 12 Jul 2021 07:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074907;
        bh=MkV4xyFkFGKisUtcj3Lgd8JIiq7gKD8kGfT3UnNWTDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2pbm9pUkf2EmvcT3CO10rk0oJzDVlmj5e7cPln2tcdqr1YJhq4zsEMfarLI3fBiAS
         dMsPssHVNFakWbdNz9rsQhNgraWWPxKRQD8WAwYqgFAbcr73wlbKb7ipQXN9MQIGQS
         mS7uBp7/6qXzzAOeCOdOzxFB6cvFp76GyXeUicxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Geoffrey D. Bennett" <g@b4.vu>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.13 008/800] ALSA: usb-audio: scarlett2: Fix wrong resume call
Date:   Mon, 12 Jul 2021 08:00:31 +0200
Message-Id: <20210712060914.302709667@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 785b6f29a795f109685f286b91e0250c206fbffb upstream.

The current way of the scarlett2 mixer code managing the
usb_mixer_elem_info object is wrong in two ways: it passes its
internal index to the head.id field, and the val_type field is
uninitialized.  This ended up with the wrong execution at the resume
because a bogus unit id is passed wrongly.  Also, in the later code
extensions, we'll have more mixer elements, and passing the index will
overflow the unit id size (of 256).

This patch corrects those issues.  It introduces a new value type,
USB_MIXER_BESPOKEN, which indicates a non-standard mixer element, and
use this type for all scarlett2 mixer elements, as well as
initializing the fixed unit id 0 for avoiding the overflow.

Tested-by: Geoffrey D. Bennett <g@b4.vu>
Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/49721219f45b7e175e729b0d9d9c142fd8f4342a.1624379707.git.g@b4.vu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/mixer.c               |    3 +++
 sound/usb/mixer.h               |    1 +
 sound/usb/mixer_scarlett_gen2.c |    7 ++++++-
 3 files changed, 10 insertions(+), 1 deletion(-)

--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -3606,6 +3606,9 @@ static int restore_mixer_value(struct us
 	struct usb_mixer_elem_info *cval = mixer_elem_list_to_info(list);
 	int c, err, idx;
 
+	if (cval->val_type == USB_MIXER_BESPOKEN)
+		return 0;
+
 	if (cval->cmask) {
 		idx = 0;
 		for (c = 0; c < MAX_CHANNELS; c++) {
--- a/sound/usb/mixer.h
+++ b/sound/usb/mixer.h
@@ -55,6 +55,7 @@ enum {
 	USB_MIXER_U16,
 	USB_MIXER_S32,
 	USB_MIXER_U32,
+	USB_MIXER_BESPOKEN,	/* non-standard type */
 };
 
 typedef void (*usb_mixer_elem_dump_func_t)(struct snd_info_buffer *buffer,
--- a/sound/usb/mixer_scarlett_gen2.c
+++ b/sound/usb/mixer_scarlett_gen2.c
@@ -949,10 +949,15 @@ static int scarlett2_add_new_ctl(struct
 	if (!elem)
 		return -ENOMEM;
 
+	/* We set USB_MIXER_BESPOKEN type, so that the core USB mixer code
+	 * ignores them for resume and other operations.
+	 * Also, the head.id field is set to 0, as we don't use this field.
+	 */
 	elem->head.mixer = mixer;
 	elem->control = index;
-	elem->head.id = index;
+	elem->head.id = 0;
 	elem->channels = channels;
+	elem->val_type = USB_MIXER_BESPOKEN;
 
 	kctl = snd_ctl_new1(ncontrol, elem);
 	if (!kctl) {


