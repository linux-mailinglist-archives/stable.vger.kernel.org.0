Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1ADA4ABBA0
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:39:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384617AbiBGL32 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:29:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383100AbiBGLVg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:21:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA904C03FEEE;
        Mon,  7 Feb 2022 03:21:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 859AEB8111C;
        Mon,  7 Feb 2022 11:21:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C50B9C004E1;
        Mon,  7 Feb 2022 11:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232877;
        bh=LD9q2F7C49Xrr8S/nNPWAaFaRh3oBr6qn1pjqP1/jyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z9wcY26QKFRyRDCowbyvYu4vp/CmLZCD3y1o004qTCBLm+R3BNKRuq7qQD+jHl7uN
         OOjtGFgkGe8ev1uqF66MrX0cVnZ2FfGQ56LMVvv9hdYdLFj8Wg23e6tTMbxq3qP7Ev
         EtfL0BFXCDhtTKeOleLmJmpqJXYj2sTJsWnIwo4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Sergeyev <sergeev917@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 07/74] ALSA: hda: Fix UAF of leds class devs at unbinding
Date:   Mon,  7 Feb 2022 12:06:05 +0100
Message-Id: <20220207103757.479750939@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.232676988@linuxfoundation.org>
References: <20220207103757.232676988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 549f8ffc7b2f7561bea7f90930b6c5104318e87b upstream.

The LED class devices that are created by HD-audio codec drivers are
registered via devm_led_classdev_register() and associated with the
HD-audio codec device.  Unfortunately, it turned out that the devres
release doesn't work for this case; namely, since the codec resource
release happens before the devm call chain, it triggers a NULL
dereference or a UAF for a stale set_brightness_delay callback.

For fixing the bug, this patch changes the LED class device register
and unregister in a manual manner without devres, keeping the
instances in hda_gen_spec.

Reported-by: Alexander Sergeyev <sergeev917@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220111195229.a77wrpjclqwrx4bx@localhost.localdomain
Link: https://lore.kernel.org/r/20220126145011.16728-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/hda_generic.c |   17 +++++++++++++++--
 sound/pci/hda/hda_generic.h |    3 +++
 2 files changed, 18 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -91,6 +91,12 @@ static void snd_hda_gen_spec_free(struct
 	free_kctls(spec);
 	snd_array_free(&spec->paths);
 	snd_array_free(&spec->loopback_list);
+#ifdef CONFIG_SND_HDA_GENERIC_LEDS
+	if (spec->led_cdevs[LED_AUDIO_MUTE])
+		led_classdev_unregister(spec->led_cdevs[LED_AUDIO_MUTE]);
+	if (spec->led_cdevs[LED_AUDIO_MICMUTE])
+		led_classdev_unregister(spec->led_cdevs[LED_AUDIO_MICMUTE]);
+#endif
 }
 
 /*
@@ -3911,7 +3917,10 @@ static int create_mute_led_cdev(struct h
 						enum led_brightness),
 				bool micmute)
 {
+	struct hda_gen_spec *spec = codec->spec;
 	struct led_classdev *cdev;
+	int idx = micmute ? LED_AUDIO_MICMUTE : LED_AUDIO_MUTE;
+	int err;
 
 	cdev = devm_kzalloc(&codec->core.dev, sizeof(*cdev), GFP_KERNEL);
 	if (!cdev)
@@ -3921,10 +3930,14 @@ static int create_mute_led_cdev(struct h
 	cdev->max_brightness = 1;
 	cdev->default_trigger = micmute ? "audio-micmute" : "audio-mute";
 	cdev->brightness_set_blocking = callback;
-	cdev->brightness = ledtrig_audio_get(micmute ? LED_AUDIO_MICMUTE : LED_AUDIO_MUTE);
+	cdev->brightness = ledtrig_audio_get(idx);
 	cdev->flags = LED_CORE_SUSPENDRESUME;
 
-	return devm_led_classdev_register(&codec->core.dev, cdev);
+	err = led_classdev_register(&codec->core.dev, cdev);
+	if (err < 0)
+		return err;
+	spec->led_cdevs[idx] = cdev;
+	return 0;
 }
 
 static void vmaster_update_mute_led(void *private_data, int enabled)
--- a/sound/pci/hda/hda_generic.h
+++ b/sound/pci/hda/hda_generic.h
@@ -305,6 +305,9 @@ struct hda_gen_spec {
 				   struct hda_jack_callback *cb);
 	void (*mic_autoswitch_hook)(struct hda_codec *codec,
 				    struct hda_jack_callback *cb);
+
+	/* leds */
+	struct led_classdev *led_cdevs[NUM_AUDIO_LEDS];
 };
 
 /* values for add_stereo_mix_input flag */


