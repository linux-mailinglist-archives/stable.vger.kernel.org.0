Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 326A1E76F7
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 17:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403881AbfJ1QsG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 12:48:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:51424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403866AbfJ1QsG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Oct 2019 12:48:06 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A9A8208C0;
        Mon, 28 Oct 2019 16:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572281283;
        bh=M/vgBm9QyeVgPFCR8Pk1ldyyhxtTFEkMqd0ZgoWzDdc=;
        h=Subject:To:From:Date:From;
        b=LFTNguLy76gnT10R7AwN/NSi6iJIMHiMTe8QdH7AcZr+CfM5FVi+Z/QRnRDR/U+u/
         9p04MxrMS9ODEmgnkJMi6tEFoSVszTQPFieYLWSJIBcvDzX9agCp1T4Mjd8Xa+AdYV
         a3e9GWI04Vw7g/vDN/yKitMhm1F3wT6y/YIL3Tvw=
Subject: patch "usb: xhci: fix Immediate Data Transfer endianness" added to usb-linus
To:     samuel@sholland.org, gregkh@linuxfoundation.org,
        mathias.nyman@linux.intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Oct 2019 17:47:52 +0100
Message-ID: <1572281272115162@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: xhci: fix Immediate Data Transfer endianness

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From bfa3dbb343f664573292afb9e44f9abeb81a19de Mon Sep 17 00:00:00 2001
From: Samuel Holland <samuel@sholland.org>
Date: Fri, 25 Oct 2019 17:30:28 +0300
Subject: usb: xhci: fix Immediate Data Transfer endianness

The arguments to queue_trb are always byteswapped to LE for placement in
the ring, but this should not happen in the case of immediate data; the
bytes copied out of transfer_buffer are already in the correct order.
Add a complementary byteswap so the bytes end up in the ring correctly.

This was observed on BE ppc64 with a "Texas Instruments TUSB73x0
SuperSpeed USB 3.0 xHCI Host Controller [104c:8241]" as a ch341
usb-serial adapter ("1a86:7523 QinHeng Electronics HL-340 USB-Serial
adapter") always transmitting the same character (generally NUL) over
the serial link regardless of the key pressed.

Cc: <stable@vger.kernel.org> # 5.2+
Fixes: 33e39350ebd2 ("usb: xhci: add Immediate Data Transfer support")
Signed-off-by: Samuel Holland <samuel@sholland.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/1572013829-14044-3-git-send-email-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-ring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 85ceb43e3405..e7aab31fd9a5 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -3330,6 +3330,7 @@ int xhci_queue_bulk_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
 			if (xhci_urb_suitable_for_idt(urb)) {
 				memcpy(&send_addr, urb->transfer_buffer,
 				       trb_buff_len);
+				le64_to_cpus(&send_addr);
 				field |= TRB_IDT;
 			}
 		}
@@ -3475,6 +3476,7 @@ int xhci_queue_ctrl_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
 		if (xhci_urb_suitable_for_idt(urb)) {
 			memcpy(&addr, urb->transfer_buffer,
 			       urb->transfer_buffer_length);
+			le64_to_cpus(&addr);
 			field |= TRB_IDT;
 		} else {
 			addr = (u64) urb->transfer_dma;
-- 
2.23.0


