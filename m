Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37DC0627F85
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237635AbiKNNAK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:00:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237642AbiKNNAJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:00:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915BA27FF8
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:00:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2EF1A6117F
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:00:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DEA2C433C1;
        Mon, 14 Nov 2022 13:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430807;
        bh=62ufeGsXePwp45gL/cQ4qlqy69IFaJTRaamkN4WhHpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vqEfWsxVVhxk0sULc/yGwuzZyojGZ8QMZ5kRV9Utclf3D+prV4jjEh1e7Kinphi87
         /+m2jqH2vOTCj2uvGMDfTqG8ebf+IPPMFlLvwuAFbboBKFg6zH5HX8qhE+tAY729fY
         RZP14Ckw6mtUrGtfsj7pS4AdsgJ392gCwcZJ0Fkc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 093/131] ALSA: usb-audio: Yet more regression for for the delayed card registration
Date:   Mon, 14 Nov 2022 13:46:02 +0100
Message-Id: <20221114124452.651498320@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
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
@@ -741,6 +741,18 @@ get_alias_quirk(struct usb_device *dev,
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
@@ -879,15 +891,9 @@ static int usb_audio_probe(struct usb_in
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
@@ -906,6 +912,11 @@ static int usb_audio_probe(struct usb_in
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


