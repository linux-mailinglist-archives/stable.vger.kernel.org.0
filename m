Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E789C26EE10
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgIRCZu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:25:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729353AbgIRCQI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:16:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D7F22399C;
        Fri, 18 Sep 2020 02:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395367;
        bh=rbY38R2MTUHiLfLudude9YVe8QTK+qxZFgcLZXsi02w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0X6wVneTwlo4VINF38pTrxdLnpFc+LbO8erfpgFIQQKWfGAZsdoQgfXDsbfJiVBYC
         2qjdOVDqvlGGEIjLItXNZpYkvwYNJbS4iMTtC0iGXzyN2T8v3XyY7krVWoAcedIrPP
         HAQQYBQA+7W5vikKYcERwFcC+QSUXE8WQkPyaWg0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andreas Steinmetz <ast@domdv.de>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.9 61/90] ALSA: usb-audio: Fix case when USB MIDI interface has more than one extra endpoint descriptor
Date:   Thu, 17 Sep 2020 22:14:26 -0400
Message-Id: <20200918021455.2067301-61-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021455.2067301-1-sashal@kernel.org>
References: <20200918021455.2067301-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Steinmetz <ast@domdv.de>

[ Upstream commit 5c6cd7021a05a02fcf37f360592d7c18d4d807fb ]

The Miditech MIDIFACE 16x16 (USB ID 1290:1749) has more than one extra
endpoint descriptor.

The first extra descriptor is: 0x06 0x30 0x00 0x00 0x00 0x00

As the code in snd_usbmidi_get_ms_info() looks only at the
first extra descriptor to find USB_DT_CS_ENDPOINT the device
as such is recognized but there is neither input nor output
configured.

The patch iterates through the extra descriptors to find the
proper one. With this patch the device is correctly configured.

Signed-off-by: Andreas Steinmetz <ast@domdv.de>
Link: https://lore.kernel.org/r/1c3b431a86f69e1d60745b6110cdb93c299f120b.camel@domdv.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/midi.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/sound/usb/midi.c b/sound/usb/midi.c
index 0676e7d485def..b8d4b5b3e54a1 100644
--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -1805,6 +1805,28 @@ static int snd_usbmidi_create_endpoints(struct snd_usb_midi *umidi,
 	return 0;
 }
 
+static struct usb_ms_endpoint_descriptor *find_usb_ms_endpoint_descriptor(
+					struct usb_host_endpoint *hostep)
+{
+	unsigned char *extra = hostep->extra;
+	int extralen = hostep->extralen;
+
+	while (extralen > 3) {
+		struct usb_ms_endpoint_descriptor *ms_ep =
+				(struct usb_ms_endpoint_descriptor *)extra;
+
+		if (ms_ep->bLength > 3 &&
+		    ms_ep->bDescriptorType == USB_DT_CS_ENDPOINT &&
+		    ms_ep->bDescriptorSubtype == UAC_MS_GENERAL)
+			return ms_ep;
+		if (!extra[0])
+			break;
+		extralen -= extra[0];
+		extra += extra[0];
+	}
+	return NULL;
+}
+
 /*
  * Returns MIDIStreaming device capabilities.
  */
@@ -1842,11 +1864,8 @@ static int snd_usbmidi_get_ms_info(struct snd_usb_midi *umidi,
 		ep = get_ep_desc(hostep);
 		if (!usb_endpoint_xfer_bulk(ep) && !usb_endpoint_xfer_int(ep))
 			continue;
-		ms_ep = (struct usb_ms_endpoint_descriptor *)hostep->extra;
-		if (hostep->extralen < 4 ||
-		    ms_ep->bLength < 4 ||
-		    ms_ep->bDescriptorType != USB_DT_CS_ENDPOINT ||
-		    ms_ep->bDescriptorSubtype != UAC_MS_GENERAL)
+		ms_ep = find_usb_ms_endpoint_descriptor(hostep);
+		if (!ms_ep)
 			continue;
 		if (usb_endpoint_dir_out(ep)) {
 			if (endpoints[epidx].out_ep) {
-- 
2.25.1

