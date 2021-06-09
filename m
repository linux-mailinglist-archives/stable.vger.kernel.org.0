Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A86A73A0F2A
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 10:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232964AbhFIJAD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 05:00:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233622AbhFIJAC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Jun 2021 05:00:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A02B0610E6;
        Wed,  9 Jun 2021 08:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623229088;
        bh=sK9Hkf5J1++1X6tG2R2s62CkBocGG6m3+JuJNXA2bKo=;
        h=Subject:To:From:Date:From;
        b=wVTpvG75qvtGpDloOyLoLtzHCBgb/61RAkZ7b5FXgQwBTzonhPFhkti5vgf9xP1QM
         0p14cE2xNd/0Qi12sJGpWTPA1CEs0eKib9cFeM7P3+g8PIS/naYOlzYzuBpbFLbGYh
         rvoGVcvlMtq2sdzkZNn8K+pv8dba+Juu13WJr9tQ=
Subject: patch "usb: gadget: eem: fix wrong eem header operation" added to usb-linus
To:     linyyuan@codeaurora.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Jun 2021 10:58:05 +0200
Message-ID: <162322908540184@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: eem: fix wrong eem header operation

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 305f670846a31a261462577dd0b967c4fa796871 Mon Sep 17 00:00:00 2001
From: Linyu Yuan <linyyuan@codeaurora.com>
Date: Wed, 9 Jun 2021 07:35:47 +0800
Subject: usb: gadget: eem: fix wrong eem header operation

when skb_clone() or skb_copy_expand() fail,
it should pull skb with lengh indicated by header,
or not it will read network data and check it as header.

Cc: <stable@vger.kernel.org>
Signed-off-by: Linyu Yuan <linyyuan@codeaurora.com>
Link: https://lore.kernel.org/r/20210608233547.3767-1-linyyuan@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_eem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/function/f_eem.c b/drivers/usb/gadget/function/f_eem.c
index e6cb38439c41..2cd9942707b4 100644
--- a/drivers/usb/gadget/function/f_eem.c
+++ b/drivers/usb/gadget/function/f_eem.c
@@ -495,7 +495,7 @@ static int eem_unwrap(struct gether *port,
 			skb2 = skb_clone(skb, GFP_ATOMIC);
 			if (unlikely(!skb2)) {
 				DBG(cdev, "unable to unframe EEM packet\n");
-				continue;
+				goto next;
 			}
 			skb_trim(skb2, len - ETH_FCS_LEN);
 
@@ -505,7 +505,7 @@ static int eem_unwrap(struct gether *port,
 						GFP_ATOMIC);
 			if (unlikely(!skb3)) {
 				dev_kfree_skb_any(skb2);
-				continue;
+				goto next;
 			}
 			dev_kfree_skb_any(skb2);
 			skb_queue_tail(list, skb3);
-- 
2.32.0


