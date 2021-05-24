Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D447C38ED2C
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233426AbhEXPep (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:34:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:50508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233495AbhEXPdi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:33:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EDD2613EE;
        Mon, 24 May 2021 15:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870286;
        bh=juXUqX3oQgJZbmuZs/lnioYXmjCRrwegEWdCvlnUyaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ELp7rvZHYxRFTlSTgxcwfTAq2TgHUaoOqpUN6fLWizNmnYP57c+mtxDMiNhl1aE+Q
         rruMd9cyj/rAMgvB0+lsvMQHw4OK9IJK05soj1Va0NtvVkskgBQDqPhtT2vP187tq/
         JuxGreYk010ucJCLkAvYcIFFd5Fr4cv2m53mwZ20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+6bb23a5d5548b93c94aa@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.4 05/31] ALSA: usb-audio: Validate MS endpoint descriptors
Date:   Mon, 24 May 2021 17:24:48 +0200
Message-Id: <20210524152323.092134248@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152322.919918360@linuxfoundation.org>
References: <20210524152322.919918360@linuxfoundation.org>
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
@@ -1865,8 +1865,12 @@ static int snd_usbmidi_get_ms_info(struc
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


