Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97D1F38ED9F
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbhEXPkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:40:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:56096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233787AbhEXPiQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:38:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D6936141F;
        Mon, 24 May 2021 15:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870396;
        bh=Nw8V2DfsiF3lunap2Awy8h9mfGQg0ElLDoFn4mNSw8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z1WeHUA5XEC9bmZ3SCrNarzAfNbJZIcxBDDg6F3JA+Nrdef+EjhJq7cRWXFJiekn+
         22FOoqlBJfsjwxOIOu+S5fo4B3Y8g0VXbMHG5vF94IJnlKk/jsoTEOFVD5iuZfW4r5
         FRNNHSnG8VIK74S8ipW1jRWERgEPYTys7kKgovWY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+6bb23a5d5548b93c94aa@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 07/37] ALSA: usb-audio: Validate MS endpoint descriptors
Date:   Mon, 24 May 2021 17:25:11 +0200
Message-Id: <20210524152324.439740582@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152324.199089755@linuxfoundation.org>
References: <20210524152324.199089755@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit e84749a78dc82bc545f12ce009e3dbcc2c5a8a91 upstream.

snd_usbmidi_get_ms_info() may access beyond the border when a
malformed descriptor is passed.  This patch adds the sanity checks of
the given MS endpoint descriptors, and skips invalid ones.

Reported-by: syzbot+6bb23a5d5548b93c94aa@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210510150659.17710-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/midi.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -1867,8 +1867,12 @@ static int snd_usbmidi_get_ms_info(struc
 		ms_ep = find_usb_ms_endpoint_descriptor(hostep);
 		if (!ms_ep)
 			continue;
+		if (ms_ep->bLength <= sizeof(*ms_ep))
+			continue;
 		if (ms_ep->bNumEmbMIDIJack > 0x10)
 			continue;
+		if (ms_ep->bLength < sizeof(*ms_ep) + ms_ep->bNumEmbMIDIJack)
+			continue;
 		if (usb_endpoint_dir_out(ep)) {
 			if (endpoints[epidx].out_ep) {
 				if (++epidx >= MIDI_MAX_ENDPOINTS) {


