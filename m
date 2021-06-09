Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E373A0EC8
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 10:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237144AbhFIIgd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 04:36:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:39040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232333AbhFIIgc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Jun 2021 04:36:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AFEA61377;
        Wed,  9 Jun 2021 08:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623227678;
        bh=2l42S56pOlB4B5eGvhG+7Obwuh1Nr1bw6c4osWc31PU=;
        h=Subject:To:From:Date:From;
        b=ZI4iDuSUiAbqyIeZVLuExngRh7YNu+qApmF+NQBhJZ3yiVqQemZULlLFj2x/Z+nYG
         maIwwNSZdBQhv93ccxTY9kV5dZXdP3fHHUTVjmGAZNpH84YoSjdAoSP3tJyut4AjCx
         tpE7LNwCnvClCGq8SktNN5dDSYGDH7kKi/Ez9D2o=
Subject: patch "usb: f_ncm: only first packet of aggregate needs to start timer" added to usb-linus
To:     maze@google.com, balbi@kernel.org, brookebasile@gmail.com,
        bryan.odonoghue@linaro.org, gregkh@linuxfoundation.org,
        lorenzo@google.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Jun 2021 10:34:28 +0200
Message-ID: <162322766823598@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: f_ncm: only first packet of aggregate needs to start timer

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 1958ff5ad2d4908b44a72bcf564dfe67c981e7fe Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
Date: Tue, 8 Jun 2021 01:54:38 -0700
Subject: usb: f_ncm: only first packet of aggregate needs to start timer
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The reasoning for this change is that if we already had
a packet pending, then we also already had a pending timer,
and as such there is no need to reschedule it.

This also prevents packets getting delayed 60 ms worst case
under a tiny packet every 290us transmit load, by keeping the
timeout always relative to the first queued up packet.
(300us delay * 16KB max aggregation / 80 byte packet =~ 60 ms)

As such the first packet is now at most delayed by 300us.

Under low transmit load, this will simply result in us sending
a shorter aggregate, as originally intended.

This patch has the benefit of greatly reducing (by ~10 factor
with 1500 byte frames aggregated into 16 kiB) the number of
(potentially pretty costly) updates to the hrtimer.

Cc: Brooke Basile <brookebasile@gmail.com>
Cc: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Cc: Felipe Balbi <balbi@kernel.org>
Cc: Lorenzo Colitti <lorenzo@google.com>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
Link: https://lore.kernel.org/r/20210608085438.813960-1-zenczykowski@gmail.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_ncm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/function/f_ncm.c b/drivers/usb/gadget/function/f_ncm.c
index 0d23c6c11a13..855127249f24 100644
--- a/drivers/usb/gadget/function/f_ncm.c
+++ b/drivers/usb/gadget/function/f_ncm.c
@@ -1101,11 +1101,11 @@ static struct sk_buff *ncm_wrap_ntb(struct gether *port,
 			ncm->ndp_dgram_count = 1;
 
 			/* Note: we skip opts->next_ndp_index */
-		}
 
-		/* Delay the timer. */
-		hrtimer_start(&ncm->task_timer, TX_TIMEOUT_NSECS,
-			      HRTIMER_MODE_REL_SOFT);
+			/* Start the timer. */
+			hrtimer_start(&ncm->task_timer, TX_TIMEOUT_NSECS,
+				      HRTIMER_MODE_REL_SOFT);
+		}
 
 		/* Add the datagram position entries */
 		ntb_ndp = skb_put_zero(ncm->skb_tx_ndp, dgram_idx_len);
-- 
2.32.0


