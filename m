Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69ABA2FA951
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 19:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407559AbhARSxD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 13:53:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:36424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390635AbhARLkl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:40:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CACE22CA1;
        Mon, 18 Jan 2021 11:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970001;
        bh=fe5Qbq6uUhCfib0Im6gmrnmKkSXZEbtPy6sVuj3ZVmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UeB1AYiB/QSkr1/Og9JXrzndiPmFSpgihqRZA8cfMwQoie8tJNZp2vuoKAWgYgJ19
         RJHtNCRoN3cvTiT+gnTIDUb9DITS6wsS6Duv8b3CmT57ZxynmBJEMLzLKNM1swKi0n
         LkN6tQ5AqquUcgkbqhTB/RUf15xy6wfRNNlKWXMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 72/76] ALSA: fireface: Fix integer overflow in transmit_midi_msg()
Date:   Mon, 18 Jan 2021 12:35:12 +0100
Message-Id: <20210118113344.407621718@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113340.984217512@linuxfoundation.org>
References: <20210118113340.984217512@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit e7c22eeaff8565d9a8374f320238c251ca31480b upstream.

As snd_ff.rx_bytes[] is unsigned int, and NSEC_PER_SEC is 1000000000L,
the second multiplication in

    ff->rx_bytes[port] * 8 * NSEC_PER_SEC / 31250

always overflows on 32-bit platforms, truncating the result.  Fix this
by precalculating "NSEC_PER_SEC / 31250", which is an integer constant.

Note that this assumes ff->rx_bytes[port] <= 16777.

Fixes: 19174295788de77d ("ALSA: fireface: add transaction support")
Reviewed-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20210111130251.361335-2-geert+renesas@glider.be
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/firewire/fireface/ff-transaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/firewire/fireface/ff-transaction.c
+++ b/sound/firewire/fireface/ff-transaction.c
@@ -88,7 +88,7 @@ static void transmit_midi_msg(struct snd
 
 	/* Set interval to next transaction. */
 	ff->next_ktime[port] = ktime_add_ns(ktime_get(),
-				ff->rx_bytes[port] * 8 * NSEC_PER_SEC / 31250);
+			ff->rx_bytes[port] * 8 * (NSEC_PER_SEC / 31250));
 
 	if (quad_count == 1)
 		tcode = TCODE_WRITE_QUADLET_REQUEST;


