Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4EC3DD3EA
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731374AbfJRWGV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:06:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:38290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731313AbfJRWGV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:06:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 815A5205F4;
        Fri, 18 Oct 2019 22:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436380;
        bh=lb4ZXVrqGMS7mr7BQYPkCC/xqK60O5g25rXq4144TzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p2lL8lDIbe7KlevXyciHx/ZCgYxGiNC9w+Dbtex+ZQaK9ARuinPyTmvS/No6zmIVa
         S/Zq0GJU5wPcy/y3YwsR4upD2W8PXZtjM1Ri1nttt60Q0PM0ATmOtnIMie8FLYWQ46
         0v8v/r6vC0y++RpZ1AJVFfV2iGGOW4/DSlOddL3w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Manuel Reinhardt <manuel.rhdt@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 033/100] ALSA: usb-audio: Add quirk for MOTU MicroBook II
Date:   Fri, 18 Oct 2019 18:04:18 -0400
Message-Id: <20191018220525.9042-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220525.9042-1-sashal@kernel.org>
References: <20191018220525.9042-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manuel Reinhardt <manuel.rhdt@gmail.com>

[ Upstream commit a634090a0f242caa8ebc91967b118995a80eb13b ]

Add an entry to the quirks-table to for usb-audio to recognize the
Microbook II (although it only exposes vendor interfaces). A simple boot
quirk is also implemented to set up the sample rate and  make sure that
no audio urbs are sent before the device is ready.

This patch only provides audio playback and capture at 96kHz sample
rate. Notice the following shortcomings:

- The sample rate is currently hardcoded to 96k although the device also
  supports 48k and 44.1k.

- The various mixer controls of the MicroBook are not made available.

- The keep-iface control should be on by default because the device
  shuts down whenever the altsetting is reset which is usually unwanted.
  (I don't know the best way to do this)

- The communication format used by the MicroBook for sample rate setting
  and also other setup has been reverse engineered by looking at the
  usbmon output while running the windows driver through virtualbox. In
  this patch the first byte of every message is set to \0 while in the
  observed communications the first byte acts as a "message-counter"
  increasing its value with every message sent. Leaving it at \0 does
  not seem to affect the device.

Signed-off-by: Manuel Reinhardt <manuel.rhdt@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/pcm.c          |   4 ++
 sound/usb/quirks-table.h |  65 +++++++++++++++++++++++++
 sound/usb/quirks.c       | 101 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 170 insertions(+)

diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index 13ea63c959d39..fc39454fb5f97 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -355,6 +355,10 @@ static int set_sync_ep_implicit_fb_quirk(struct snd_usb_substream *subs,
 		ep = 0x81;
 		ifnum = 1;
 		goto add_sync_ep_from_ifnum;
+	case USB_ID(0x07fd, 0x0004): /* MOTU MicroBook II */
+		ep = 0x84;
+		ifnum = 0;
+		goto add_sync_ep_from_ifnum;
 	}
 
 	if (attr == USB_ENDPOINT_SYNC_ASYNC &&
diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 57c6209a4ccb4..4ac3cbf79c580 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -3403,5 +3403,70 @@ AU0828_DEVICE(0x2040, 0x7270, "Hauppauge", "HVR-950Q"),
 		.ifnum = QUIRK_NO_INTERFACE
 	}
 },
+/* MOTU Microbook II */
+{
+	USB_DEVICE(0x07fd, 0x0004),
+	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
+		.vendor_name = "MOTU",
+		.product_name = "MicroBookII",
+		.ifnum = QUIRK_ANY_INTERFACE,
+		.type = QUIRK_COMPOSITE,
+		.data = (const struct snd_usb_audio_quirk[]) {
+			{
+				.ifnum = 0,
+				.type = QUIRK_AUDIO_STANDARD_MIXER,
+			},
+			{
+				.ifnum = 0,
+				.type = QUIRK_AUDIO_FIXED_ENDPOINT,
+				.data = &(const struct audioformat) {
+					.formats = SNDRV_PCM_FMTBIT_S24_3BE,
+					.channels = 6,
+					.iface = 0,
+					.altsetting = 1,
+					.altset_idx = 1,
+					.attributes = 0,
+					.endpoint = 0x84,
+					.rates = SNDRV_PCM_RATE_96000,
+					.ep_attr = USB_ENDPOINT_XFER_ISOC |
+						   USB_ENDPOINT_SYNC_ASYNC,
+					.rate_min = 96000,
+					.rate_max = 96000,
+					.nr_rates = 1,
+					.maxpacksize = 0x00d8,
+					.rate_table = (unsigned int[]) {
+						96000
+					}
+				}
+			},
+			{
+				.ifnum = 0,
+				.type = QUIRK_AUDIO_FIXED_ENDPOINT,
+				.data = &(const struct audioformat) {
+					.formats = SNDRV_PCM_FMTBIT_S24_3BE,
+					.channels = 8,
+					.iface = 0,
+					.altsetting = 1,
+					.altset_idx = 1,
+					.attributes = 0,
+					.endpoint = 0x03,
+					.rates = SNDRV_PCM_RATE_96000,
+					.ep_attr = USB_ENDPOINT_XFER_ISOC |
+						   USB_ENDPOINT_SYNC_ASYNC,
+					.rate_min = 96000,
+					.rate_max = 96000,
+					.nr_rates = 1,
+					.maxpacksize = 0x0120,
+					.rate_table = (unsigned int[]) {
+						96000
+					}
+				}
+			},
+			{
+				.ifnum = -1
+			}
+		}
+	}
+},
 
 #undef USB_DEVICE_VENDOR_SPEC
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 60d00091f64b2..da0287441eab4 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -881,6 +881,105 @@ static int snd_usb_axefx3_boot_quirk(struct usb_device *dev)
 	return 0;
 }
 
+
+#define MICROBOOK_BUF_SIZE 128
+
+static int snd_usb_motu_microbookii_communicate(struct usb_device *dev, u8 *buf,
+						int buf_size, int *length)
+{
+	int err, actual_length;
+
+	err = usb_interrupt_msg(dev, usb_sndintpipe(dev, 0x01), buf, *length,
+				&actual_length, 1000);
+	if (err < 0)
+		return err;
+
+	print_hex_dump(KERN_DEBUG, "MicroBookII snd: ", DUMP_PREFIX_NONE, 16, 1,
+		       buf, actual_length, false);
+
+	memset(buf, 0, buf_size);
+
+	err = usb_interrupt_msg(dev, usb_rcvintpipe(dev, 0x82), buf, buf_size,
+				&actual_length, 1000);
+	if (err < 0)
+		return err;
+
+	print_hex_dump(KERN_DEBUG, "MicroBookII rcv: ", DUMP_PREFIX_NONE, 16, 1,
+		       buf, actual_length, false);
+
+	*length = actual_length;
+	return 0;
+}
+
+static int snd_usb_motu_microbookii_boot_quirk(struct usb_device *dev)
+{
+	int err, actual_length, poll_attempts = 0;
+	static const u8 set_samplerate_seq[] = { 0x00, 0x00, 0x00, 0x00,
+						 0x00, 0x00, 0x0b, 0x14,
+						 0x00, 0x00, 0x00, 0x01 };
+	static const u8 poll_ready_seq[] = { 0x00, 0x04, 0x00, 0x00,
+					     0x00, 0x00, 0x0b, 0x18 };
+	u8 *buf = kzalloc(MICROBOOK_BUF_SIZE, GFP_KERNEL);
+
+	if (!buf)
+		return -ENOMEM;
+
+	dev_info(&dev->dev, "Waiting for MOTU Microbook II to boot up...\n");
+
+	/* First we tell the device which sample rate to use. */
+	memcpy(buf, set_samplerate_seq, sizeof(set_samplerate_seq));
+	actual_length = sizeof(set_samplerate_seq);
+	err = snd_usb_motu_microbookii_communicate(dev, buf, MICROBOOK_BUF_SIZE,
+						   &actual_length);
+
+	if (err < 0) {
+		dev_err(&dev->dev,
+			"failed setting the sample rate for Motu MicroBook II: %d\n",
+			err);
+		goto free_buf;
+	}
+
+	/* Then we poll every 100 ms until the device informs of its readiness. */
+	while (true) {
+		if (++poll_attempts > 100) {
+			dev_err(&dev->dev,
+				"failed booting Motu MicroBook II: timeout\n");
+			err = -ENODEV;
+			goto free_buf;
+		}
+
+		memset(buf, 0, MICROBOOK_BUF_SIZE);
+		memcpy(buf, poll_ready_seq, sizeof(poll_ready_seq));
+
+		actual_length = sizeof(poll_ready_seq);
+		err = snd_usb_motu_microbookii_communicate(
+			dev, buf, MICROBOOK_BUF_SIZE, &actual_length);
+		if (err < 0) {
+			dev_err(&dev->dev,
+				"failed booting Motu MicroBook II: communication error %d\n",
+				err);
+			goto free_buf;
+		}
+
+		/* the device signals its readiness through a message of the
+		 * form
+		 *           XX 06 00 00 00 00 0b 18  00 00 00 01
+		 * If the device is not yet ready to accept audio data, the
+		 * last byte of that sequence is 00.
+		 */
+		if (actual_length == 12 && buf[actual_length - 1] == 1)
+			break;
+
+		msleep(100);
+	}
+
+	dev_info(&dev->dev, "MOTU MicroBook II ready\n");
+
+free_buf:
+	kfree(buf);
+	return err;
+}
+
 /*
  * Setup quirks
  */
@@ -1058,6 +1157,8 @@ int snd_usb_apply_boot_quirk(struct usb_device *dev,
 		return snd_usb_gamecon780_boot_quirk(dev);
 	case USB_ID(0x2466, 0x8010): /* Fractal Audio Axe-Fx 3 */
 		return snd_usb_axefx3_boot_quirk(dev);
+	case USB_ID(0x07fd, 0x0004): /* MOTU MicroBook II */
+		return snd_usb_motu_microbookii_boot_quirk(dev);
 	}
 
 	return 0;
-- 
2.20.1

