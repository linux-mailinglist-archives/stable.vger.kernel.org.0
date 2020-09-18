Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3B7526F29C
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbgIRDAM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 23:00:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:53822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727591AbgIRCFk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:05:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20A2023718;
        Fri, 18 Sep 2020 02:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394739;
        bh=qbSMNsJ2gHPCZ2bjnEYHCu6psAz7c1BEHIounyRdkQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kIihJ/q6cQxj6qR/S4l9OBcFzgFs30eV47Xmn4puG9tUPXXcWjbFyxFQEkU/pZF+i
         Jcwyv5UKLHyBbVVWd7NP5Xvj899SKmpL3MZ2ik9Op6rrmofHzdi1XVoFjljqqDhNQk
         L+VyF3YKLOuZTRLRxMkz9LcOGM3HIVo13d6guQfI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andreas Steinmetz <ast@domdv.de>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 220/330] ALSA: usb-audio: Fix case when USB MIDI interface has more than one extra endpoint descriptor
Date:   Thu, 17 Sep 2020 21:59:20 -0400
Message-Id: <20200918020110.2063155-220-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
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
index 0cb4142b05f64..bc9068b616bb9 100644
--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -1827,6 +1827,28 @@ static int snd_usbmidi_create_endpoints(struct snd_usb_midi *umidi,
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
@@ -1864,11 +1886,8 @@ static int snd_usbmidi_get_ms_info(struct snd_usb_midi *umidi,
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

