Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00F2138A295
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233651AbhETJnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:43:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:41964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233466AbhETJlU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:41:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0335613D3;
        Thu, 20 May 2021 09:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503122;
        bh=ZFZj7zqLlgJf2AYq0Iq3dodE5RPSnKnrhETGVLB6wEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BJZphS1XEQp6wXWk709JLWtmk9Z27tCnl6yqxbQQqWwQSqMrmTCAvhDfCuzu26iqK
         2dfH732bhCiKeWhZj+MbdQLsj3j8hm4UjIiz1hhqhL7AspOEnAYG/rjriuae8Uli8f
         CzyLa26Fc2x/kzSxZQERP7ezDXQ34tVrkmREjscQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Timo Gurr <timo.gurr@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 079/425] ALSA: usb-audio: Add dB range mapping for Sennheiser Communications Headset PC 8
Date:   Thu, 20 May 2021 11:17:28 +0200
Message-Id: <20210520092134.038827502@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Timo Gurr <timo.gurr@gmail.com>

commit ab2165e2e6ed17345ffa8ee88ca764e8788ebcd7 upstream.

The decibel volume range contains a negative maximum value resulting in
pipewire complaining about the device and effectivly having no sound
output. The wrong values also resulted in the headset sounding muted
already at a mixer level of about ~25%.

PipeWire BugLink: https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/1049

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=212897
Signed-off-by: Timo Gurr <timo.gurr@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210503110822.10222-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_maps.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -351,6 +351,13 @@ static struct usbmix_name_map bose_compa
 	{ 0 }	/* terminator */
 };
 
+/* Sennheiser Communications Headset [PC 8], the dB value is reported as -6 negative maximum  */
+static const struct usbmix_dB_map sennheiser_pc8_dB = {-9500, 0};
+static const struct usbmix_name_map sennheiser_pc8_map[] = {
+	{ 9, NULL, .dB = &sennheiser_pc8_dB },
+	{ 0 }   /* terminator */
+};
+
 /*
  * Dell usb dock with ALC4020 codec had a firmware problem where it got
  * screwed up when zero volume is passed; just skip it as a workaround
@@ -633,5 +640,10 @@ static struct usbmix_ctl_map uac3_badd_u
 		.id = UAC3_FUNCTION_SUBCLASS_SPEAKERPHONE,
 		.map = uac3_badd_speakerphone_map,
 	},
+	{
+		/* Sennheiser Communications Headset [PC 8] */
+		.id = USB_ID(0x1395, 0x0025),
+		.map = sennheiser_pc8_map,
+	},
 	{ 0 } /* terminator */
 };


