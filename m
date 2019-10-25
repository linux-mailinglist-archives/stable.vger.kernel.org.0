Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE02E4F0A
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 16:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407848AbfJYO22 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 10:28:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:10575 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730064AbfJYO22 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Oct 2019 10:28:28 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Oct 2019 07:28:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,228,1569308400"; 
   d="scan'208";a="192554848"
Received: from mattu-haswell.fi.intel.com ([10.237.72.170])
  by orsmga008.jf.intel.com with ESMTP; 25 Oct 2019 07:28:25 -0700
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>, Samuel Holland <samuel@sholland.org>,
        "# 5 . 2+" <stable@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 2/3] usb: xhci: fix Immediate Data Transfer endianness
Date:   Fri, 25 Oct 2019 17:30:28 +0300
Message-Id: <1572013829-14044-3-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1572013829-14044-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1572013829-14044-1-git-send-email-mathias.nyman@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Holland <samuel@sholland.org>

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
2.7.4

