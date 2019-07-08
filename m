Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90E03622E5
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389556AbfGHPaT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:30:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:59226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389550AbfGHPaS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:30:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19B3920645;
        Mon,  8 Jul 2019 15:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599817;
        bh=cYmtbt2v6RfDc7FjULI93abk3YL+Uslmq20nfWzd5mE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MNcy+UhcIikDSYhnbHOhUj7A8stBHaEGRJh9MpyVrfd9CKxHTVsHdEUhzFsGcfrF/
         m8lGWfevKOIm4Ky2QhEd5DGPj9MyHclxj4hTop9QJuVOasBZ8BIDU0yYe1PjXlDp89
         ZWs1Q4cnDNJCxSIDV3pvERRFSs9RkbF973evpmLU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 45/90] ALSA: firewire-lib/fireworks: fix miss detection of received MIDI messages
Date:   Mon,  8 Jul 2019 17:13:12 +0200
Message-Id: <20190708150524.827844585@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150521.829733162@linuxfoundation.org>
References: <20190708150521.829733162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit 7fbd1753b64eafe21cf842348a40a691d0dee440 upstream.

In IEC 61883-6, 8 MIDI data streams are multiplexed into single
MIDI conformant data channel. The index of stream is calculated by
modulo 8 of the value of data block counter.

In fireworks, the value of data block counter in CIP header has a quirk
with firmware version v5.0.0, v5.7.3 and v5.8.0. This brings ALSA
IEC 61883-1/6 packet streaming engine to miss detection of MIDI
messages.

This commit fixes the miss detection to modify the value of data block
counter for the modulo calculation.

For maintainers, this bug exists since a commit 18f5ed365d3f ("ALSA:
fireworks/firewire-lib: add support for recent firmware quirk") in Linux
kernel v4.2. There're many changes since the commit.  This fix can be
backported to Linux kernel v4.4 or later. I tagged a base commit to the
backport for your convenience.

Besides, my work for Linux kernel v5.3 brings heavy code refactoring and
some structure members are renamed in 'sound/firewire/amdtp-stream.h'.
The content of this patch brings conflict when merging -rc tree with
this patch and the latest tree. I request maintainers to solve the
conflict to replace 'tx_first_dbc' with 'ctx_data.tx.first_dbc'.

Fixes: df075feefbd3 ("ALSA: firewire-lib: complete AM824 data block processing layer")
Cc: <stable@vger.kernel.org> # v4.4+
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/firewire/amdtp-am824.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/firewire/amdtp-am824.c
+++ b/sound/firewire/amdtp-am824.c
@@ -321,7 +321,7 @@ static void read_midi_messages(struct am
 	u8 *b;
 
 	for (f = 0; f < frames; f++) {
-		port = (s->data_block_counter + f) % 8;
+		port = (8 - s->tx_first_dbc + s->data_block_counter + f) % 8;
 		b = (u8 *)&buffer[p->midi_position];
 
 		len = b[0] - 0x80;


