Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF7FF2FAA21
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 20:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437335AbhART1E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 14:27:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:34158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390444AbhARLiO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:38:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8429922BE9;
        Mon, 18 Jan 2021 11:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969822;
        bh=nzz9tYb5Aulv/p299I0ypp/e3Gp72O2TcZOIYdjJkj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2iTumPiGuB8W9CWpbuZoujnvIUrjL8/uXe6S8URnTLbSIHR4rcKVBYDCbSdGYielT
         zeDgCL5vSOTjyGiFZfk3/7yTmh8iKpoR/meA/4YRcOwQKF79KWEmCXc5OpkAOSZG/h
         imslyCMYoMTzeD+CsehjVn8OhDMHulXq+MnlkYg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 39/43] ALSA: firewire-tascam: Fix integer overflow in midi_port_work()
Date:   Mon, 18 Jan 2021 12:35:02 +0100
Message-Id: <20210118113336.832303924@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113334.966227881@linuxfoundation.org>
References: <20210118113334.966227881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit 9f65df9c589f249435255da37a5dd11f1bc86f4d upstream.

As snd_fw_async_midi_port.consume_bytes is unsigned int, and
NSEC_PER_SEC is 1000000000L, the second multiplication in

    port->consume_bytes * 8 * NSEC_PER_SEC / 31250

always overflows on 32-bit platforms, truncating the result.  Fix this
by precalculating "NSEC_PER_SEC / 31250", which is an integer constant.

Note that this assumes port->consume_bytes <= 16777.

Fixes: 531f471834227d03 ("ALSA: firewire-lib/firewire-tascam: localize async midi port")
Reviewed-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20210111130251.361335-3-geert+renesas@glider.be
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/firewire/tascam/tascam-transaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/firewire/tascam/tascam-transaction.c
+++ b/sound/firewire/tascam/tascam-transaction.c
@@ -210,7 +210,7 @@ static void midi_port_work(struct work_s
 
 	/* Set interval to next transaction. */
 	port->next_ktime = ktime_add_ns(ktime_get(),
-				port->consume_bytes * 8 * NSEC_PER_SEC / 31250);
+			port->consume_bytes * 8 * (NSEC_PER_SEC / 31250));
 
 	/* Start this transaction. */
 	port->idling = false;


