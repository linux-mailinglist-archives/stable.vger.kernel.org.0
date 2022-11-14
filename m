Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B48B362807F
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237808AbiKNNGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:06:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237818AbiKNNGW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:06:22 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC68C2A950
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:06:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 36BD3CE0FFC
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:06:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D206C433D6;
        Mon, 14 Nov 2022 13:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431178;
        bh=3kjlWn0opxqGQEwYLrAACk4hg+gJ5KSU/7n20PdMRT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X+lGR5kahIJUtK5AVfUD4jQncy7NtUflZobG87COEDAHWJFbMfQ8hFHX/U85KiFcU
         VvLWxGv3VORBqKbPDn5lgPjn2pN1pcW1tRiUyw7U3heqNgQs0W+n6DxW/PWWEUGHrA
         JhsSZlPeUKPzUc+uTAkz6DdFW4uxgK6K+G0w+AH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.0 129/190] ALSA: usb-audio: Yet more regression for for the delayed card registration
Date:   Mon, 14 Nov 2022 13:45:53 +0100
Message-Id: <20221114124504.458069182@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit 971cb608d1c5d95533a43b549bb8ec9637f10043 upstream.

Although we tried to fix the regression for the recent changes with
the delayed card registration, it doesn't seem covering the all
cases; e.g. on Roland EDIROL M-100FX, where the generic quirk for
Roland devices is applied, it misses the card registration because the
detection of the last interface (apparently for MIDI) fails.

This patch is an attempt to recover from those failures by calling the
card register also at the error path for the secondary interfaces.
The card register condition is also extended to match with the old
check in the previous patch, too (i.e. the simple check of the
interface number) for catching the probe with errors.

Fixes: 39efc9c8a973 ("ALSA: usb-audio: Fix last interface check for registration")
Cc: <stable@vger.kernel.org>
Link: https://bugzilla.suse.com/show_bug.cgi?id=1205111
Link: https://lore.kernel.org/r/20221108065824.14418-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/card.c |   29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -742,6 +742,18 @@ get_alias_quirk(struct usb_device *dev,
 	return NULL;
 }
 
+/* register card if we reach to the last interface or to the specified
+ * one given via option
+ */
+static int try_to_register_card(struct snd_usb_audio *chip, int ifnum)
+{
+	if (check_delayed_register_option(chip) == ifnum ||
+	    chip->last_iface == ifnum ||
+	    usb_interface_claimed(usb_ifnum_to_if(chip->dev, chip->last_iface)))
+		return snd_card_register(chip->card);
+	return 0;
+}
+
 /*
  * probe the active usb device
  *
@@ -880,15 +892,9 @@ static int usb_audio_probe(struct usb_in
 		chip->need_delayed_register = false; /* clear again */
 	}
 
-	/* register card if we reach to the last interface or to the specified
-	 * one given via option
-	 */
-	if (check_delayed_register_option(chip) == ifnum ||
-	    usb_interface_claimed(usb_ifnum_to_if(dev, chip->last_iface))) {
-		err = snd_card_register(chip->card);
-		if (err < 0)
-			goto __error;
-	}
+	err = try_to_register_card(chip, ifnum);
+	if (err < 0)
+		goto __error_no_register;
 
 	if (chip->quirk_flags & QUIRK_FLAG_SHARE_MEDIA_DEVICE) {
 		/* don't want to fail when snd_media_device_create() fails */
@@ -907,6 +913,11 @@ static int usb_audio_probe(struct usb_in
 	return 0;
 
  __error:
+	/* in the case of error in secondary interface, still try to register */
+	if (chip)
+		try_to_register_card(chip, ifnum);
+
+ __error_no_register:
 	if (chip) {
 		/* chip->active is inside the chip->card object,
 		 * decrement before memory is possibly returned.


