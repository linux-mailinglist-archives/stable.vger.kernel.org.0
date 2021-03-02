Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD8A932AED8
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236048AbhCCAGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:06:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:56624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1837235AbhCBHlJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 02:41:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9B4B64D74;
        Tue,  2 Mar 2021 07:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614670828;
        bh=uBOvxtJQr7zXhF3fBpICAT8ZaSuDltHapUWN+3scBJg=;
        h=Subject:To:From:Date:From;
        b=OLXgwEYIGRSkFzGyIKzfeA7Qn8njcUW1dDYNgZAY+6jlKmre63/pGDzLm9UiqlA3K
         ckueCiBNu3dOjN9vkZxepXkRNkr9iKrmEL39/hptCOPtJnsr9MpGGX+UcqTHiTnpfd
         s8ez6ZpiXR2CizexDGG6ONJVh3tpT/XTvvt7z7Ok=
Subject: patch "usb: gadget: f_uac2: always increase endpoint max_packet_size by one" added to usb-linus
To:     ruslan.bilovol@gmail.com, gregkh@linuxfoundation.org,
        peter.chen@freescale.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 02 Mar 2021 08:40:25 +0100
Message-ID: <1614670825215164@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: f_uac2: always increase endpoint max_packet_size by one

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 089a8b8c66349bc065ea9e865c68872e7cac8bf1 Mon Sep 17 00:00:00 2001
From: Ruslan Bilovol <ruslan.bilovol@gmail.com>
Date: Mon, 1 Mar 2021 13:49:31 +0200
Subject: usb: gadget: f_uac2: always increase endpoint max_packet_size by one
 audio slot

As per UAC2 Audio Data Formats spec (2.3.1.1 USB Packets),
if the sampling rate is a constant, the allowable variation
of number of audio slots per virtual frame is +/- 1 audio slot.

It means that endpoint should be able to accept/send +1 audio
slot.

Previous endpoint max_packet_size calculation code
was adding sometimes +1 audio slot due to DIV_ROUND_UP
behaviour which was rounding up to closest integer.
However this doesn't work if the numbers are divisible.

It had no any impact with Linux hosts which ignore
this issue, but in case of more strict Windows it
caused rejected enumeration

Thus always add +1 audio slot to endpoint's max packet size

Fixes: 913e4a90b6f9 ("usb: gadget: f_uac2: finalize wMaxPacketSize according to bandwidth")
Cc: Peter Chen <peter.chen@freescale.com>
Cc: <stable@vger.kernel.org> #v4.3+
Signed-off-by: Ruslan Bilovol <ruslan.bilovol@gmail.com>
Link: https://lore.kernel.org/r/1614599375-8803-2-git-send-email-ruslan.bilovol@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_uac2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/f_uac2.c b/drivers/usb/gadget/function/f_uac2.c
index 5d960b6603b6..6f03e944e0e3 100644
--- a/drivers/usb/gadget/function/f_uac2.c
+++ b/drivers/usb/gadget/function/f_uac2.c
@@ -478,7 +478,7 @@ static int set_ep_max_packet_size(const struct f_uac2_opts *uac2_opts,
 	}
 
 	max_size_bw = num_channels(chmask) * ssize *
-		DIV_ROUND_UP(srate, factor / (1 << (ep_desc->bInterval - 1)));
+		((srate / (factor / (1 << (ep_desc->bInterval - 1)))) + 1);
 	ep_desc->wMaxPacketSize = cpu_to_le16(min_t(u16, max_size_bw,
 						    max_size_ep));
 
-- 
2.30.1


