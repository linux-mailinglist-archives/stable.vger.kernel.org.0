Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0F0E32E85B
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbhCEM0X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:26:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:33508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231524AbhCEM0O (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:26:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F8FA6502E;
        Fri,  5 Mar 2021 12:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947174;
        bh=Z7A+qMFCXzuvZbaj79kFpNBoFD2J8zcyC1eZRUa6QRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2QiL3h5FRLJums9y1hnvIpGoZqFbMDQwLHeSSrmZ3FCIkK7IoKUKw1ykz6s5x4JUO
         6FQ4RmEMk8vXcM+cmkIQWFDKptPWBOXDYO+uF+duNJ191S/Q7olSwpxTd4eBg6Lj9f
         mU7aPqn/M2ziVZRp2mdgMkP1dE1AUq6564yIRSWo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olivia Mackintosh <livvy@base.nu>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 075/104] ALSA: usb-audio: Add DJM450 to Pioneer format quirk
Date:   Fri,  5 Mar 2021 13:21:20 +0100
Message-Id: <20210305120906.842812884@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.166929741@linuxfoundation.org>
References: <20210305120903.166929741@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olivia Mackintosh <livvy@base.nu>

[ Upstream commit 3b85f5fc75d564a9eb4171dcb6b8687b080cd4d5 ]

Like the DJM-750, ensure that the format control message is passed to
the device when opening a stream. It seems as though fmt->sync_ep is not
always set when this function is called hence the passing of the value
at the call site. If this can be fixed, fmt->sync_up should be used as
the wvalue.

There doesn't seem to be a "cpu_to_le24" type function defined hence for
the open code but I did see a similar thing done in Bluez lib. Perhaps
we can get these definitions defined in byteorder.h. See hci_cpu_to_le24
in include/net/bluetooth/hci.h:2543 for similar usage.

Signed-off-by: Olivia Mackintosh <livvy@base.nu>
Link: https://lore.kernel.org/r/20210202134225.3217-2-livvy@base.nu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index e196e364cef1..9ba4682ebc48 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1470,6 +1470,23 @@ static void set_format_emu_quirk(struct snd_usb_substream *subs,
 	subs->pkt_offset_adj = (emu_samplerate_id >= EMU_QUIRK_SR_176400HZ) ? 4 : 0;
 }
 
+static int pioneer_djm_set_format_quirk(struct snd_usb_substream *subs,
+					u16 windex)
+{
+	unsigned int cur_rate = subs->data_endpoint->cur_rate;
+	u8 sr[3];
+	// Convert to little endian
+	sr[0] = cur_rate & 0xff;
+	sr[1] = (cur_rate >> 8) & 0xff;
+	sr[2] = (cur_rate >> 16) & 0xff;
+	usb_set_interface(subs->dev, 0, 1);
+	// we should derive windex from fmt-sync_ep but it's not set
+	snd_usb_ctl_msg(subs->stream->chip->dev,
+		usb_rcvctrlpipe(subs->stream->chip->dev, 0),
+		0x01, 0x22, 0x0100, windex, &sr, 0x0003);
+	return 0;
+}
+
 void snd_usb_set_format_quirk(struct snd_usb_substream *subs,
 			      const struct audioformat *fmt)
 {
@@ -1483,6 +1500,9 @@ void snd_usb_set_format_quirk(struct snd_usb_substream *subs,
 	case USB_ID(0x534d, 0x2109): /* MacroSilicon MS2109 */
 		subs->stream_offset_adj = 2;
 		break;
+	case USB_ID(0x2b73, 0x0013): /* Pioneer DJM-450 */
+		pioneer_djm_set_format_quirk(subs, 0x0082);
+		break;
 	}
 }
 
-- 
2.30.1



