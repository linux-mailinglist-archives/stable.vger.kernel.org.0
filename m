Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C73915EC84
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391132AbgBNR2T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:28:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:59900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390347AbgBNQIF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:08:05 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 601922187F;
        Fri, 14 Feb 2020 16:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696485;
        bh=jL6j0v0f9MVjx5AE0XIrGAimUcz+A06QyJSz/62WD3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p2jRsS3KqDSa/a5UplhgDjmL01sUOrwBuqbhM8sAwTftHBjh4mRA9ESi4F3z8V/rd
         CZctFaCk+Z6gpYi3Xp5c9OzAcP4yZ6bKifocYTC2wQgciACx6vHjoZKTyR9UYboZex
         QfgeJZgCOT454JnijMwXOq3cXtWqfMy6EIwYCWWo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Tsoy <alexander@tsoy.me>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 291/459] ALSA: usb-audio: Add boot quirk for MOTU M Series
Date:   Fri, 14 Feb 2020 10:59:01 -0500
Message-Id: <20200214160149.11681-291-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Tsoy <alexander@tsoy.me>

[ Upstream commit 73ac9f5e5b43a5dbadb61f27dae7a971f7ec0d22 ]

Add delay to make sure that audio urbs are not sent too early.
Otherwise the device hangs. Windows driver makes ~2s delay, so use
about the same time delay value.

snd_usb_apply_boot_quirk() is called 3 times for my MOTU M4, which
is an overkill. Thus a quirk that is called only once is implemented.

Also send two vendor-specific control messages before and after
the delay. This behaviour is blindly copied from the Windows driver.

Signed-off-by: Alexander Tsoy <alexander@tsoy.me>
Link: https://lore.kernel.org/r/20200112102358.18085-1-alexander@tsoy.me
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/card.c   |  4 ++++
 sound/usb/quirks.c | 38 ++++++++++++++++++++++++++++++++++++++
 sound/usb/quirks.h |  5 +++++
 3 files changed, 47 insertions(+)

diff --git a/sound/usb/card.c b/sound/usb/card.c
index db91dc76cc915..e6a618a239948 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -597,6 +597,10 @@ static int usb_audio_probe(struct usb_interface *intf,
 		}
 	}
 	if (! chip) {
+		err = snd_usb_apply_boot_quirk_once(dev, intf, quirk, id);
+		if (err < 0)
+			return err;
+
 		/* it's a fresh one.
 		 * now look for an empty slot and create a new card instance
 		 */
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 82184036437b5..0464df785f2ee 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1113,6 +1113,31 @@ static int snd_usb_motu_microbookii_boot_quirk(struct usb_device *dev)
 	return err;
 }
 
+static int snd_usb_motu_m_series_boot_quirk(struct usb_device *dev)
+{
+	int ret;
+
+	if (snd_usb_pipe_sanity_check(dev, usb_sndctrlpipe(dev, 0)))
+		return -EINVAL;
+	ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
+			      1, USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			      0x0, 0, NULL, 0, 1000);
+
+	if (ret < 0)
+		return ret;
+
+	msleep(2000);
+
+	ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
+			      1, USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			      0x20, 0, NULL, 0, 1000);
+
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
 /*
  * Setup quirks
  */
@@ -1297,6 +1322,19 @@ int snd_usb_apply_boot_quirk(struct usb_device *dev,
 	return 0;
 }
 
+int snd_usb_apply_boot_quirk_once(struct usb_device *dev,
+				  struct usb_interface *intf,
+				  const struct snd_usb_audio_quirk *quirk,
+				  unsigned int id)
+{
+	switch (id) {
+	case USB_ID(0x07fd, 0x0008): /* MOTU M Series */
+		return snd_usb_motu_m_series_boot_quirk(dev);
+	}
+
+	return 0;
+}
+
 /*
  * check if the device uses big-endian samples
  */
diff --git a/sound/usb/quirks.h b/sound/usb/quirks.h
index a80e0ddd07364..df0355843a4c1 100644
--- a/sound/usb/quirks.h
+++ b/sound/usb/quirks.h
@@ -20,6 +20,11 @@ int snd_usb_apply_boot_quirk(struct usb_device *dev,
 			     const struct snd_usb_audio_quirk *quirk,
 			     unsigned int usb_id);
 
+int snd_usb_apply_boot_quirk_once(struct usb_device *dev,
+				  struct usb_interface *intf,
+				  const struct snd_usb_audio_quirk *quirk,
+				  unsigned int usb_id);
+
 void snd_usb_set_format_quirk(struct snd_usb_substream *subs,
 			      struct audioformat *fmt);
 
-- 
2.20.1

