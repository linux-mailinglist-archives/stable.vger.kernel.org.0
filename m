Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34BF02265F6
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732112AbgGTP7E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:59:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:59450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732108AbgGTP7D (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:59:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 115C7206E9;
        Mon, 20 Jul 2020 15:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260742;
        bh=MQ6tbnqQLrVWgUVo6iqCzEqCWQ+XT5u4KkPN+GfPNO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iLG1q9rfKOu5NF4KLcwrILBmzzTIVutFewkOiMbihNxl1dVGSXnBb5XqmaiVQKEnJ
         n42t52dN07gBMnLqSPU9WV/Juflq09AaAskUJUujrAZw2wYeNbYJjUvDIVh/XtiD0a
         k3pdXkWnJWBe7jphCfsN36QA60i+GeFHt9bZSSAo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Tsoy <alexander@tsoy.me>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 080/215] ALSA: usb-audio: Add support for MOTU MicroBook IIc
Date:   Mon, 20 Jul 2020 17:36:02 +0200
Message-Id: <20200720152824.017801716@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Tsoy <alexander@tsoy.me>

[ Upstream commit 2edb84e3047b93da2f2b234219cdc304df042d9e ]

MicroBook IIc operates in UAC2 mode by default. This patch addresses
several issues with it:

- MicroBook II and IIc shares the same USB ID. We can distinguish them
  by interface class.
- MaxPacketsOnly attribute is erroneously set in endpoint descriptors.
  As a result this card produces noise with all sample rates other than
  96 KHz. This also causes issues like IOMMU page faults and other
  problems with host controller.
- Sample rate changes takes more than 2 seconds for this device. Clock
  validity request returns false during that period, so the clock validity
  quirk is required.

Signed-off-by: Alexander Tsoy <alexander@tsoy.me>
Link: https://lore.kernel.org/r/20200229151815.14199-1-alexander@tsoy.me
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/clock.c        | 59 ++++++++++++++++++++++++++++++++--------
 sound/usb/pcm.c          |  7 ++++-
 sound/usb/quirks-table.h |  2 +-
 sound/usb/quirks.c       | 18 +++++++++++-
 4 files changed, 72 insertions(+), 14 deletions(-)

diff --git a/sound/usb/clock.c b/sound/usb/clock.c
index a48313dfa967a..b118cf97607f3 100644
--- a/sound/usb/clock.c
+++ b/sound/usb/clock.c
@@ -151,16 +151,15 @@ static int uac_clock_selector_set_val(struct snd_usb_audio *chip, int selector_i
 	return ret;
 }
 
-/*
- * Assume the clock is valid if clock source supports only one single sample
- * rate, the terminal is connected directly to it (there is no clock selector)
- * and clock type is internal. This is to deal with some Denon DJ controllers
- * that always reports that clock is invalid.
- */
 static bool uac_clock_source_is_valid_quirk(struct snd_usb_audio *chip,
 					    struct audioformat *fmt,
 					    int source_id)
 {
+	bool ret = false;
+	int count;
+	unsigned char data;
+	struct usb_device *dev = chip->dev;
+
 	if (fmt->protocol == UAC_VERSION_2) {
 		struct uac_clock_source_descriptor *cs_desc =
 			snd_usb_find_clock_source(chip->ctrl_intf, source_id);
@@ -168,13 +167,51 @@ static bool uac_clock_source_is_valid_quirk(struct snd_usb_audio *chip,
 		if (!cs_desc)
 			return false;
 
-		return (fmt->nr_rates == 1 &&
-			(fmt->clock & 0xff) == cs_desc->bClockID &&
-			(cs_desc->bmAttributes & 0x3) !=
-				UAC_CLOCK_SOURCE_TYPE_EXT);
+		/*
+		 * Assume the clock is valid if clock source supports only one
+		 * single sample rate, the terminal is connected directly to it
+		 * (there is no clock selector) and clock type is internal.
+		 * This is to deal with some Denon DJ controllers that always
+		 * reports that clock is invalid.
+		 */
+		if (fmt->nr_rates == 1 &&
+		    (fmt->clock & 0xff) == cs_desc->bClockID &&
+		    (cs_desc->bmAttributes & 0x3) !=
+				UAC_CLOCK_SOURCE_TYPE_EXT)
+			return true;
+	}
+
+	/*
+	 * MOTU MicroBook IIc
+	 * Sample rate changes takes more than 2 seconds for this device. Clock
+	 * validity request returns false during that period.
+	 */
+	if (chip->usb_id == USB_ID(0x07fd, 0x0004)) {
+		count = 0;
+
+		while ((!ret) && (count < 50)) {
+			int err;
+
+			msleep(100);
+
+			err = snd_usb_ctl_msg(dev, usb_rcvctrlpipe(dev, 0), UAC2_CS_CUR,
+					      USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_IN,
+					      UAC2_CS_CONTROL_CLOCK_VALID << 8,
+					      snd_usb_ctrl_intf(chip) | (source_id << 8),
+					      &data, sizeof(data));
+			if (err < 0) {
+				dev_warn(&dev->dev,
+					 "%s(): cannot get clock validity for id %d\n",
+					   __func__, source_id);
+				return false;
+			}
+
+			ret = !!data;
+			count++;
+		}
 	}
 
-	return false;
+	return ret;
 }
 
 static bool uac_clock_source_is_valid(struct snd_usb_audio *chip,
diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index d5706b8b68a1c..086244c707433 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -344,7 +344,12 @@ static int set_sync_ep_implicit_fb_quirk(struct snd_usb_substream *subs,
 		ep = 0x81;
 		ifnum = 1;
 		goto add_sync_ep_from_ifnum;
-	case USB_ID(0x07fd, 0x0004): /* MOTU MicroBook II */
+	case USB_ID(0x07fd, 0x0004): /* MOTU MicroBook II/IIc */
+		/* MicroBook IIc */
+		if (altsd->bInterfaceClass == USB_CLASS_AUDIO)
+			return 0;
+
+		/* MicroBook II */
 		ep = 0x84;
 		ifnum = 0;
 		goto add_sync_ep_from_ifnum;
diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 8d1805d9e5a78..5089f2de2f02d 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -3492,7 +3492,7 @@ AU0828_DEVICE(0x2040, 0x7270, "Hauppauge", "HVR-950Q"),
 },
 /* MOTU Microbook II */
 {
-	USB_DEVICE(0x07fd, 0x0004),
+	USB_DEVICE_VENDOR_SPEC(0x07fd, 0x0004),
 	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
 		.vendor_name = "MOTU",
 		.product_name = "MicroBookII",
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index bf5083a20b6d5..9d11ff742e5f5 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1316,7 +1316,15 @@ int snd_usb_apply_boot_quirk(struct usb_device *dev,
 	case USB_ID(0x2466, 0x8010): /* Fractal Audio Axe-Fx 3 */
 		return snd_usb_axefx3_boot_quirk(dev);
 	case USB_ID(0x07fd, 0x0004): /* MOTU MicroBook II */
-		return snd_usb_motu_microbookii_boot_quirk(dev);
+		/*
+		 * For some reason interface 3 with vendor-spec class is
+		 * detected on MicroBook IIc.
+		 */
+		if (get_iface_desc(intf->altsetting)->bInterfaceClass ==
+		    USB_CLASS_VENDOR_SPEC &&
+		    get_iface_desc(intf->altsetting)->bInterfaceNumber < 3)
+			return snd_usb_motu_microbookii_boot_quirk(dev);
+		break;
 	}
 
 	return 0;
@@ -1764,5 +1772,13 @@ void snd_usb_audioformat_attributes_quirk(struct snd_usb_audio *chip,
 		else
 			fp->ep_attr |= USB_ENDPOINT_SYNC_SYNC;
 		break;
+	case USB_ID(0x07fd, 0x0004):  /* MOTU MicroBook IIc */
+		/*
+		 * MaxPacketsOnly attribute is erroneously set in endpoint
+		 * descriptors. As a result this card produces noise with
+		 * all sample rates other than 96 KHz.
+		 */
+		fp->attributes &= ~UAC_EP_CS_ATTR_FILL_MAX;
+		break;
 	}
 }
-- 
2.25.1



