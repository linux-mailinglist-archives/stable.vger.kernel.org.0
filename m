Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3046300C23
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 20:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729659AbhAVSkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 13:40:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:39050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728505AbhAVOTL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:19:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5341423A82;
        Fri, 22 Jan 2021 14:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324854;
        bh=nzz9tYb5Aulv/p299I0ypp/e3Gp72O2TcZOIYdjJkj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jHcnTCE8NKD7WGiMjlzwJmR3ga7wkcMOuvAEQcGnT+8BlYZVTdJbyNTE+eQiQapvl
         uwqQWrN/Lx3gZib/Xgx4cqXfx1/KEuUYAnI4mfmd0Y1FZwrGkp1m1zl/npa5/HYHNM
         qwpof2yetTAcJhbKfl1yEkSPaaygUShJaxmoTiVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 30/50] ALSA: firewire-tascam: Fix integer overflow in midi_port_work()
Date:   Fri, 22 Jan 2021 15:12:11 +0100
Message-Id: <20210122135736.415126781@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.176469491@linuxfoundation.org>
References: <20210122135735.176469491@linuxfoundation.org>
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


