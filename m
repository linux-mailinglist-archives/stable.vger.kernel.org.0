Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54DE85F95F8
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 02:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232670AbiJJA0Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 20:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232740AbiJJAWe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 20:22:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E47E2F589;
        Sun,  9 Oct 2022 16:56:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 724E260DC9;
        Sun,  9 Oct 2022 23:56:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3357CC433D7;
        Sun,  9 Oct 2022 23:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665359782;
        bh=tIuimC7hafq1PYHXrfdK///l+QMugqow2AdHIbSnkVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cj+PcQH8P/TlfqrHALwFl/vX8nZ/mlak6qGBXRWjwe858+DMu6tMUWS95SmTjp9Jz
         kiptyHqLIqBw238hi4fw8oy82A2kk5exUjvBm0ADPAZ/M/aVpvrAUoOoFVWMLderIz
         rIr5edMooRIuRcROGI96lvREyN6e9j8mkw7vx7lskznuVAzl8J3Ht/EerqlIQ/mJiM
         L/2g4U1POYWUDZtn/iJcSj3hbdt/Us1m00y5a9eruM71RKejaX0lPLXL/UhSAqx453
         jPR+phl0weD/B20Qhq5z+1cZdD77U49WFNwbk3kYMkcBQYwKX9vdvUiVoLiyWSELTl
         8Tmjm9fLkq/DA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Conner Knox <connerknoxpublic@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        perex@perex.cz, tiwai@suse.com, sdoregor@sdore.me,
        hahnjo@hahnjo.de, john-linux@pelago.org.uk, brendan@grieve.com.au,
        willovertonuk@gmail.com, giun7a@gmail.com, alexander@tsoy.me,
        cyrozap@gmail.com, gregkh@linuxfoundation.org,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 06/22] ALSA: usb-audio: Add quirk to enable Avid Mbox 3 support
Date:   Sun,  9 Oct 2022 19:55:24 -0400
Message-Id: <20221009235540.1231640-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009235540.1231640-1-sashal@kernel.org>
References: <20221009235540.1231640-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Conner Knox <connerknoxpublic@gmail.com>

[ Upstream commit b01104fc62b6194c852124f6c6df1c0a5c031fc1 ]

Add support for Avid Mbox3 USB audio interface at 48kHz

Signed-off-by: Conner Knox <connerknoxpublic@gmail.com>
Link: https://lore.kernel.org/r/20220818201433.16360-1-mbarriolinares@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks-table.h |  76 ++++++++++
 sound/usb/quirks.c       | 302 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 378 insertions(+)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 1ac91c46da3c..a7f065567190 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -3021,6 +3021,82 @@ AU0828_DEVICE(0x2040, 0x7270, "Hauppauge", "HVR-950Q"),
 		}
 	}
 },
+/* DIGIDESIGN MBOX 3 */
+{
+	USB_DEVICE(0x0dba, 0x5000),
+	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
+		.vendor_name = "Digidesign",
+		.product_name = "Mbox 3",
+		.ifnum = QUIRK_ANY_INTERFACE,
+		.type = QUIRK_COMPOSITE,
+		.data = (const struct snd_usb_audio_quirk[]) {
+			{
+				.ifnum = 0,
+				.type = QUIRK_IGNORE_INTERFACE
+			},
+			{
+				.ifnum = 1,
+				.type = QUIRK_IGNORE_INTERFACE
+			},
+			{
+				.ifnum = 2,
+				.type = QUIRK_AUDIO_FIXED_ENDPOINT,
+				.data = &(const struct audioformat) {
+					.formats = SNDRV_PCM_FMTBIT_S24_3LE,
+					.channels = 4,
+					.iface = 2,
+					.altsetting = 1,
+					.altset_idx = 1,
+					.attributes = 0x00,
+					.endpoint = 0x01,
+					.ep_attr = USB_ENDPOINT_XFER_ISOC |
+						USB_ENDPOINT_SYNC_ASYNC,
+					.rates = SNDRV_PCM_RATE_48000,
+					.rate_min = 48000,
+					.rate_max = 48000,
+					.nr_rates = 1,
+					.rate_table = (unsigned int[]) {
+						48000
+					}
+				}
+			},
+			{
+				.ifnum = 3,
+				.type = QUIRK_AUDIO_FIXED_ENDPOINT,
+				.data = &(const struct audioformat) {
+					.formats = SNDRV_PCM_FMTBIT_S24_3LE,
+					.channels = 4,
+					.iface = 3,
+					.altsetting = 1,
+					.altset_idx = 1,
+					.endpoint = 0x81,
+					.attributes = 0x00,
+					.ep_attr = USB_ENDPOINT_XFER_ISOC |
+						USB_ENDPOINT_SYNC_ASYNC,
+					.maxpacksize = 0x009c,
+					.rates = SNDRV_PCM_RATE_48000,
+					.rate_min = 48000,
+					.rate_max = 48000,
+					.nr_rates = 1,
+					.rate_table = (unsigned int[]) {
+						48000
+					}
+				}
+			},
+			{
+				.ifnum = 4,
+				.type = QUIRK_MIDI_FIXED_ENDPOINT,
+				.data = &(const struct snd_usb_midi_endpoint_info) {
+					.out_cables = 0x0001,
+					.in_cables  = 0x0001
+				}
+			},
+			{
+				.ifnum = -1
+			}
+		}
+	}
+},
 {
 	/* Tascam US122 MKII - playback-only support */
 	USB_DEVICE_VENDOR_SPEC(0x0644, 0x8021),
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 41f5d8242478..b571a9c9c319 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1024,6 +1024,304 @@ static int snd_usb_axefx3_boot_quirk(struct usb_device *dev)
 	return 0;
 }
 
+static void mbox3_setup_48_24_magic(struct usb_device *dev)
+{
+	/* The Mbox 3 is "little endian" */
+	/* max volume is: 0x0000. */
+	/* min volume is: 0x0080 (shown in little endian form) */
+
+
+	/* Load 48000Hz rate into buffer */
+	u8 com_buff[4] = {0x80, 0xbb, 0x00, 0x00};
+
+	/* Set 48000Hz sample rate */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			0x01, 0x21, 0x0100, 0x0001, &com_buff, 4);  //Is this really needed?
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			0x01, 0x21, 0x0100, 0x8101, &com_buff, 4);
+
+	/* Deactivate Tuner */
+	/* on  = 0x01*/
+	/* off = 0x00*/
+	com_buff[0] = 0x00;
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+		0x01, 0x21, 0x0003, 0x2001, &com_buff, 1);
+
+	/* Set clock source to Internal (as opposed to S/PDIF) */
+	com_buff[0] = 0x01;
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x0100, 0x8001, &com_buff, 1);
+
+	/* Mute the hardware loopbacks to start the device in a known state. */
+	com_buff[0] = 0x00;
+	com_buff[1] = 0x80;
+	/* Analogue input 1 left channel: */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x0110, 0x4001, &com_buff, 2);
+	/* Analogue input 1 right channel: */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x0111, 0x4001, &com_buff, 2);
+	/* Analogue input 2 left channel: */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x0114, 0x4001, &com_buff, 2);
+	/* Analogue input 2 right channel: */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x0115, 0x4001, &com_buff, 2);
+	/* Analogue input 3 left channel: */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x0118, 0x4001, &com_buff, 2);
+	/* Analogue input 3 right channel: */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x0119, 0x4001, &com_buff, 2);
+	/* Analogue input 4 left channel: */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x011c, 0x4001, &com_buff, 2);
+	/* Analogue input 4 right channel: */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x011d, 0x4001, &com_buff, 2);
+
+	/* Set software sends to output */
+	com_buff[0] = 0x00;
+	com_buff[1] = 0x00;
+	/* Analogue software return 1 left channel: */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x0100, 0x4001, &com_buff, 2);
+	com_buff[0] = 0x00;
+	com_buff[1] = 0x80;
+	/* Analogue software return 1 right channel: */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x0101, 0x4001, &com_buff, 2);
+	com_buff[0] = 0x00;
+	com_buff[1] = 0x80;
+	/* Analogue software return 2 left channel: */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x0104, 0x4001, &com_buff, 2);
+	com_buff[0] = 0x00;
+	com_buff[1] = 0x00;
+	/* Analogue software return 2 right channel: */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x0105, 0x4001, &com_buff, 2);
+
+	com_buff[0] = 0x00;
+	com_buff[1] = 0x80;
+	/* Analogue software return 3 left channel: */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x0108, 0x4001, &com_buff, 2);
+	/* Analogue software return 3 right channel: */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x0109, 0x4001, &com_buff, 2);
+	/* Analogue software return 4 left channel: */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x010c, 0x4001, &com_buff, 2);
+	/* Analogue software return 4 right channel: */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x010d, 0x4001, &com_buff, 2);
+
+	/* Return to muting sends */
+	com_buff[0] = 0x00;
+	com_buff[1] = 0x80;
+	/* Analogue fx return left channel: */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x0120, 0x4001, &com_buff, 2);
+	/* Analogue fx return right channel: */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x0121, 0x4001, &com_buff, 2);
+
+	/* Analogue software input 1 fx send: */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x0100, 0x4201, &com_buff, 2);
+	/* Analogue software input 2 fx send: */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x0101, 0x4201, &com_buff, 2);
+	/* Analogue software input 3 fx send: */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x0102, 0x4201, &com_buff, 2);
+	/* Analogue software input 4 fx send: */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x0103, 0x4201, &com_buff, 2);
+	/* Analogue input 1 fx send: */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x0104, 0x4201, &com_buff, 2);
+	/* Analogue input 2 fx send: */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x0105, 0x4201, &com_buff, 2);
+	/* Analogue input 3 fx send: */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x0106, 0x4201, &com_buff, 2);
+	/* Analogue input 4 fx send: */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x0107, 0x4201, &com_buff, 2);
+
+	/* Toggle allowing host control */
+	com_buff[0] = 0x02;
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			3, 0x21, 0x0000, 0x2001, &com_buff, 1);
+
+	/* Do not dim fx returns */
+	com_buff[0] = 0x00;
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			3, 0x21, 0x0002, 0x2001, &com_buff, 1);
+
+	/* Do not set fx returns to mono */
+	com_buff[0] = 0x00;
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			3, 0x21, 0x0001, 0x2001, &com_buff, 1);
+
+	/* Mute the S/PDIF hardware loopback
+	 * same odd volume logic here as above
+	 */
+	com_buff[0] = 0x00;
+	com_buff[1] = 0x80;
+	/* S/PDIF hardware input 1 left channel */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x0112, 0x4001, &com_buff, 2);
+	/* S/PDIF hardware input 1 right channel */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x0113, 0x4001, &com_buff, 2);
+	/* S/PDIF hardware input 2 left channel */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x0116, 0x4001, &com_buff, 2);
+	/* S/PDIF hardware input 2 right channel */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x0117, 0x4001, &com_buff, 2);
+	/* S/PDIF hardware input 3 left channel */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x011a, 0x4001, &com_buff, 2);
+	/* S/PDIF hardware input 3 right channel */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x011b, 0x4001, &com_buff, 2);
+	/* S/PDIF hardware input 4 left channel */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x011e, 0x4001, &com_buff, 2);
+	/* S/PDIF hardware input 4 right channel */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x011f, 0x4001, &com_buff, 2);
+	/* S/PDIF software return 1 left channel */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x0102, 0x4001, &com_buff, 2);
+	/* S/PDIF software return 1 right channel */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x0103, 0x4001, &com_buff, 2);
+	/* S/PDIF software return 2 left channel */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x0106, 0x4001, &com_buff, 2);
+	/* S/PDIF software return 2 right channel */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x0107, 0x4001, &com_buff, 2);
+
+	com_buff[0] = 0x00;
+	com_buff[1] = 0x00;
+	/* S/PDIF software return 3 left channel */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x010a, 0x4001, &com_buff, 2);
+
+	com_buff[0] = 0x00;
+	com_buff[1] = 0x80;
+	/* S/PDIF software return 3 right channel */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x010b, 0x4001, &com_buff, 2);
+	/* S/PDIF software return 4 left channel */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x010e, 0x4001, &com_buff, 2);
+
+	com_buff[0] = 0x00;
+	com_buff[1] = 0x00;
+	/* S/PDIF software return 4 right channel */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x010f, 0x4001, &com_buff, 2);
+
+	com_buff[0] = 0x00;
+	com_buff[1] = 0x80;
+	/* S/PDIF fx returns left channel */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x0122, 0x4001, &com_buff, 2);
+	/* S/PDIF fx returns right channel */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x0123, 0x4001, &com_buff, 2);
+
+	/* Set the dropdown "Effect" to the first option */
+	/* Room1  = 0x00 */
+	/* Room2  = 0x01 */
+	/* Room3  = 0x02 */
+	/* Hall 1 = 0x03 */
+	/* Hall 2 = 0x04 */
+	/* Plate  = 0x05 */
+	/* Delay  = 0x06 */
+	/* Echo   = 0x07 */
+	com_buff[0] = 0x00;
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x0200, 0x4301, &com_buff, 1);	/* max is 0xff */
+	/* min is 0x00 */
+
+
+	/* Set the effect duration to 0 */
+	/* max is 0xffff */
+	/* min is 0x0000 */
+	com_buff[0] = 0x00;
+	com_buff[1] = 0x00;
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x0400, 0x4301, &com_buff, 2);
+
+	/* Set the effect volume and feedback to 0 */
+	/* max is 0xff */
+	/* min is 0x00 */
+	com_buff[0] = 0x00;
+	/* feedback: */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x0500, 0x4301, &com_buff, 1);
+	/* volume: */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			1, 0x21, 0x0300, 0x4301, &com_buff, 1);
+
+	/* Set soft button hold duration */
+	/* 0x03 = 250ms */
+	/* 0x05 = 500ms DEFAULT */
+	/* 0x08 = 750ms */
+	/* 0x0a = 1sec */
+	com_buff[0] = 0x05;
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			3, 0x21, 0x0005, 0x2001, &com_buff, 1);
+
+	/* Use dim LEDs for button of state */
+	com_buff[0] = 0x00;
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			3, 0x21, 0x0004, 0x2001, &com_buff, 1);
+}
+
+#define MBOX3_DESCRIPTOR_SIZE	464
+
+static int snd_usb_mbox3_boot_quirk(struct usb_device *dev)
+{
+	struct usb_host_config *config = dev->actconfig;
+	int err;
+	int descriptor_size;
+
+	descriptor_size = le16_to_cpu(get_cfg_desc(config)->wTotalLength);
+
+	if (descriptor_size != MBOX3_DESCRIPTOR_SIZE) {
+		dev_err(&dev->dev, "Invalid descriptor size=%d.\n", descriptor_size);
+		return -ENODEV;
+	}
+
+	dev_dbg(&dev->dev, "device initialised!\n");
+
+	err = usb_get_descriptor(dev, USB_DT_DEVICE, 0,
+		&dev->descriptor, sizeof(dev->descriptor));
+	config = dev->actconfig;
+	if (err < 0)
+		dev_dbg(&dev->dev, "error usb_get_descriptor: %d\n", err);
+
+	err = usb_reset_configuration(dev);
+	if (err < 0)
+		dev_dbg(&dev->dev, "error usb_reset_configuration: %d\n", err);
+	dev_dbg(&dev->dev, "mbox3_boot: new boot length = %d\n",
+		le16_to_cpu(get_cfg_desc(config)->wTotalLength));
+
+	mbox3_setup_48_24_magic(dev);
+	dev_info(&dev->dev, "Digidesign Mbox 3: 24bit 48kHz");
+
+	return 0; /* Successful boot */
+}
 
 #define MICROBOOK_BUF_SIZE 128
 
@@ -1344,6 +1642,10 @@ int snd_usb_apply_boot_quirk(struct usb_device *dev,
 	case USB_ID(0x0dba, 0x3000):
 		/* Digidesign Mbox 2 */
 		return snd_usb_mbox2_boot_quirk(dev);
+	case USB_ID(0x0dba, 0x5000):
+		/* Digidesign Mbox 3 */
+		return snd_usb_mbox3_boot_quirk(dev);
+
 
 	case USB_ID(0x1235, 0x0010): /* Focusrite Novation Saffire 6 USB */
 	case USB_ID(0x1235, 0x0018): /* Focusrite Novation Twitch */
-- 
2.35.1

