Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87F972F1450
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732257AbhAKNS2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:18:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:36406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732743AbhAKNSD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:18:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4062722A83;
        Mon, 11 Jan 2021 13:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610371067;
        bh=vhFLJ8HdTM02dwPJ00wgNSQScS2zmm2Uyf30gja4WeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XmipQh32MPlm1UbV4LagojwF7ALW5jCynW0Azz4OUCI7MuE9sBcPgd6Er2vNtx0PG
         LcQeCD9j/MC6Fr5wH1xZqp5H2cYoV+W4vE4bcKlI0cgUwCWciZFkQs7Vx7CAVvRcWj
         V9lZ0U73/+E49WlvZV1Pnnz3ZxPbhwi/51Cu9AWY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+92e45ae45543f89e8c88@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 097/145] ALSA: usb-audio: Fix UBSAN warnings for MIDI jacks
Date:   Mon, 11 Jan 2021 14:02:01 +0100
Message-Id: <20210111130053.196216910@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
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
@@ -1889,6 +1889,8 @@ static int snd_usbmidi_get_ms_info(struc
 		ms_ep = find_usb_ms_endpoint_descriptor(hostep);
 		if (!ms_ep)
 			continue;
+		if (ms_ep->bNumEmbMIDIJack > 0x10)
+			continue;
 		if (usb_endpoint_dir_out(ep)) {
 			if (endpoints[epidx].out_ep) {
 				if (++epidx >= MIDI_MAX_ENDPOINTS) {
@@ -2141,6 +2143,8 @@ static int snd_usbmidi_detect_roland(str
 		    cs_desc[1] == USB_DT_CS_INTERFACE &&
 		    cs_desc[2] == 0xf1 &&
 		    cs_desc[3] == 0x02) {
+			if (cs_desc[4] > 0x10 || cs_desc[5] > 0x10)
+				continue;
 			endpoint->in_cables  = (1 << cs_desc[4]) - 1;
 			endpoint->out_cables = (1 << cs_desc[5]) - 1;
 			return snd_usbmidi_detect_endpoints(umidi, endpoint, 1);


