Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2F4B2F176B
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 15:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729544AbhAKOGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 09:06:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:50168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727994AbhAKND5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:03:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3612822527;
        Mon, 11 Jan 2021 13:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370221;
        bh=VedbmO/5/bZazH0fUPBlfrJlYbOrNDIrQEbwdNqIqQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GgO3vK8yDX6y2z1u8yT4KolfzFn5NkxuVjF3NF3t9KrOFvPWS8WfXZvU2vLci3FsW
         Fpo9Qw8wZEFs4M/ikSct1IvZv5Obza4iigqyB6Ig9hAjuxY7iTA6dhCQ2kgXO+shvI
         U3Sx/HiheQUcfNsqiEMuPix1Hd7d9oSjOM7nJBuQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+92e45ae45543f89e8c88@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.9 31/45] ALSA: usb-audio: Fix UBSAN warnings for MIDI jacks
Date:   Mon, 11 Jan 2021 14:01:09 +0100
Message-Id: <20210111130035.151846078@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130033.676306636@linuxfoundation.org>
References: <20210111130033.676306636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit c06ccf3ebb7503706ea49fd248e709287ef385a3 upstream.

The calculation of in_cables and out_cables bitmaps are done with the
bit shift by the value from the descriptor, which is an arbitrary
value, and can lead to UBSAN shift-out-of-bounds warnings.

Fix it by filtering the bad descriptor values with the check of the
upper bound 0x10 (the cable bitmaps are 16 bits).

Reported-by: syzbot+92e45ae45543f89e8c88@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201223174557.10249-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/midi.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -1867,6 +1867,8 @@ static int snd_usbmidi_get_ms_info(struc
 		ms_ep = find_usb_ms_endpoint_descriptor(hostep);
 		if (!ms_ep)
 			continue;
+		if (ms_ep->bNumEmbMIDIJack > 0x10)
+			continue;
 		if (usb_endpoint_dir_out(ep)) {
 			if (endpoints[epidx].out_ep) {
 				if (++epidx >= MIDI_MAX_ENDPOINTS) {
@@ -2119,6 +2121,8 @@ static int snd_usbmidi_detect_roland(str
 		    cs_desc[1] == USB_DT_CS_INTERFACE &&
 		    cs_desc[2] == 0xf1 &&
 		    cs_desc[3] == 0x02) {
+			if (cs_desc[4] > 0x10 || cs_desc[5] > 0x10)
+				continue;
 			endpoint->in_cables  = (1 << cs_desc[4]) - 1;
 			endpoint->out_cables = (1 << cs_desc[5]) - 1;
 			return snd_usbmidi_detect_endpoints(umidi, endpoint, 1);


