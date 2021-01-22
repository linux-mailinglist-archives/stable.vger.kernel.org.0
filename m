Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0068E300B9B
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 19:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729136AbhAVSmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 13:42:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:38386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728119AbhAVOVm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:21:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC13223B2F;
        Fri, 22 Jan 2021 14:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324927;
        bh=QTVrU5Uqlqq2w1dCrXothH4iFsRVc0nQc8i3xhrt/E8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VHd7BrIVjx4GC3s5fT5imgTbLgUBqFMbMqrdFgXX/zIWBcHuVDpeUiv3JHxYrlUlm
         APDh40e6V/fTL/9CwStpIxcm+zve0HGSd52lGlgZzoXMZaE43JB2LN/MZBNrf8g+Z8
         To0SV2kMYEQeuuSoOf2Y95KRWVKmUv83Z1YKaGwE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 31/50] ALSA: fireface: Fix integer overflow in transmit_midi_msg()
Date:   Fri, 22 Jan 2021 15:12:12 +0100
Message-Id: <20210122135736.455116723@linuxfoundation.org>
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
@@ -99,7 +99,7 @@ static void transmit_midi_msg(struct snd
 
 	/* Set interval to next transaction. */
 	ff->next_ktime[port] = ktime_add_ns(ktime_get(),
-					    len * 8 * NSEC_PER_SEC / 31250);
+					    len * 8 * (NSEC_PER_SEC / 31250));
 	ff->rx_bytes[port] = len;
 
 	/*


