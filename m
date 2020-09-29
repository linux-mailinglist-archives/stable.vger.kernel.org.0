Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9C2027C4D8
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729432AbgI2LRG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:17:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:33298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729590AbgI2LQk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:16:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A66A421D41;
        Tue, 29 Sep 2020 11:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378196;
        bh=tuojgmS46utuo0qPVhvteAxqUcE65vAv9kEyAtWaweQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ljuuDR+IVBVdYWAypWgHCwWCi3KYDIHtpgh7mw8nf42u7zjj0Cxkj9gCr2l4jRNpY
         T4dbHbb5CRPIrJrY6EEGvUkaqh3J5IRD0F5OlW5fNd8S2D7e4e2nk2FAcoGT3K5CNq
         P9hMRsEFIq2FiWPtE7bGVTGYC3BQxfuf+0RzYTKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Steinmetz <ast@domdv.de>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 096/166] ALSA: usb-audio: Fix case when USB MIDI interface has more than one extra endpoint descriptor
Date:   Tue, 29 Sep 2020 13:00:08 +0200
Message-Id: <20200929105940.008314358@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 1bfae7a1c32f1..a3d1c0c1b4a67 100644
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



