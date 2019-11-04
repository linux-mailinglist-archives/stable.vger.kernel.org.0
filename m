Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02D66EEE3A
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389082AbfKDWIs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:08:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:41718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388158AbfKDWIr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:08:47 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 561ED214E0;
        Mon,  4 Nov 2019 22:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905326;
        bh=RF2KtCpXRQbrdWVBcadjdD4hBHy/4SVnpEHOGBeKPEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IN8Pq889BrSRKl+a6IhNf2QGZdRL/NmxpmAdpAnK2RfgSA336LUk65QBP7NO5c2XW
         tSFYT33m+9MBCB3QZvNAX3n3X27+CfW5rEyGntzZhQqQ0R44nBD6vND/mPpWbJJTQj
         eTPl79+TKIRYqUaC1LPelnBpweXPWYaKg0DiRcwk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Samuel Holland <samuel@sholland.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.3 108/163] usb: xhci: fix Immediate Data Transfer endianness
Date:   Mon,  4 Nov 2019 22:44:58 +0100
Message-Id: <20191104212147.993138919@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Holland <samuel@sholland.org>

commit bfa3dbb343f664573292afb9e44f9abeb81a19de upstream.

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
 drivers/usb/host/xhci-ring.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -3330,6 +3330,7 @@ int xhci_queue_bulk_tx(struct xhci_hcd *
 			if (xhci_urb_suitable_for_idt(urb)) {
 				memcpy(&send_addr, urb->transfer_buffer,
 				       trb_buff_len);
+				le64_to_cpus(&send_addr);
 				field |= TRB_IDT;
 			}
 		}
@@ -3475,6 +3476,7 @@ int xhci_queue_ctrl_tx(struct xhci_hcd *
 		if (xhci_urb_suitable_for_idt(urb)) {
 			memcpy(&addr, urb->transfer_buffer,
 			       urb->transfer_buffer_length);
+			le64_to_cpus(&addr);
 			field |= TRB_IDT;
 		} else {
 			addr = (u64) urb->transfer_dma;


