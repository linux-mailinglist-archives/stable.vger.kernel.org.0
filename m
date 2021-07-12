Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D41C3C506B
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241772AbhGLHct (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:32:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346545AbhGLHa6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:30:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13A9B6052B;
        Mon, 12 Jul 2021 07:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074889;
        bh=ar5e5zpbJf8fh4I7Sj54pdqoH/Wigbw4HGKYYihAZ0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XP0IcIG/i1z2GL4m0OZRKRvpgGYbjskuxPFQNQeUb7BmhSws0gPyVZ7M9mteOYEQ0
         fhpfrvKhMryZG9w8iLnA7rt79Pe4OTLN82lFqT97ruggZEHDa9yV0a+yAIACSLUPZz
         4paiCH8bQy+2f7h2adCmSBLDA6zjI6qv0ZpuK+hs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.13 004/800] ALSA: bebob: fix rx packet format for Yamaha GO44/GO46, Terratec Phase 24/x24
Date:   Mon, 12 Jul 2021 08:00:27 +0200
Message-Id: <20210712060913.702954526@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit 6b6c17fe6fa58900fa69dd000d5333b679e5e33e upstream.

Below devices reports zero as the number of channels for external output
plug with MIDI type:

 * Yamaha GO44/GO46
 * Terratec Phase 24/X24

As a result, rx packet format is invalid and they generate silent sound.
This is a regression added in v5.13.

This commit fixes the bug, addressed at a commit 1bd1b3be8655 ("ALSA:
bebob: perform sequence replay for media clock recovery").

Cc: <stable@vger.kernel.org>
Fixes: 5c6ea94f2b7c ("ALSA: bebob: detect the number of available MIDI ports")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20210618040447.113306-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/firewire/bebob/bebob_stream.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/sound/firewire/bebob/bebob_stream.c
+++ b/sound/firewire/bebob/bebob_stream.c
@@ -883,6 +883,11 @@ static int detect_midi_ports(struct snd_
 		err = avc_bridgeco_get_plug_ch_count(bebob->unit, addr, &ch_count);
 		if (err < 0)
 			break;
+		// Yamaha GO44, GO46, Terratec Phase 24, Phase x24 reports 0 for the number of
+		// channels in external output plug 3 (MIDI type) even if it has a pair of physical
+		// MIDI jacks. As a workaround, assume it as one.
+		if (ch_count == 0)
+			ch_count = 1;
 		*midi_ports += ch_count;
 	}
 
@@ -961,12 +966,12 @@ int snd_bebob_stream_discover(struct snd
 	if (err < 0)
 		goto end;
 
-	err = detect_midi_ports(bebob, bebob->rx_stream_formations, addr, AVC_BRIDGECO_PLUG_DIR_IN,
+	err = detect_midi_ports(bebob, bebob->tx_stream_formations, addr, AVC_BRIDGECO_PLUG_DIR_IN,
 				plugs[2], &bebob->midi_input_ports);
 	if (err < 0)
 		goto end;
 
-	err = detect_midi_ports(bebob, bebob->tx_stream_formations, addr, AVC_BRIDGECO_PLUG_DIR_OUT,
+	err = detect_midi_ports(bebob, bebob->rx_stream_formations, addr, AVC_BRIDGECO_PLUG_DIR_OUT,
 				plugs[3], &bebob->midi_output_ports);
 	if (err < 0)
 		goto end;


