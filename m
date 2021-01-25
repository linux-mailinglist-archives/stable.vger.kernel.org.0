Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F79D302AA5
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 19:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730373AbhAYSqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:46:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:33378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730040AbhAYSqR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:46:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8DD922D50;
        Mon, 25 Jan 2021 18:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600341;
        bh=VFkP2gIziUqineLiU+Q4C+E9DkN/fc1XLpIc4q9M6Ug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v8BkYFQvMeO3q2JtpUSFdKELwtycsV65t/3ndZsogUeKq3NLdbM4823RicM7PELJk
         xvJcVq+fFOG24LSQ/bd/+6qWRhwHR2c9hENMnTPM4pSXPTJER7s6VdYNqNjazLRb8g
         6Zy3Jn4cZrTHRiLBo8j/YxQVxNbdleycenQRx+p0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ross Zwisler <zwisler@google.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.4 64/86] xhci: make sure TRB is fully written before giving it to the controller
Date:   Mon, 25 Jan 2021 19:39:46 +0100
Message-Id: <20210125183203.751144616@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183201.024962206@linuxfoundation.org>
References: <20210125183201.024962206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 576667bad341516edc4e18eb85acb0a2b4c9c9d9 upstream.

Once the command ring doorbell is rung the xHC controller will parse all
command TRBs on the command ring that have the cycle bit set properly.

If the driver just started writing the next command TRB to the ring when
hardware finished the previous TRB, then HW might fetch an incomplete TRB
as long as its cycle bit set correctly.

A command TRB is 16 bytes (128 bits) long.
Driver writes the command TRB in four 32 bit chunks, with the chunk
containing the cycle bit last. This does however not guarantee that
chunks actually get written in that order.

This was detected in stress testing when canceling URBs with several
connected USB devices.
Two consecutive "Set TR Dequeue pointer" commands got queued right
after each other, and the second one was only partially written when
the controller parsed it, causing the dequeue pointer to be set
to bogus values. This was seen as error messages:

"Mismatch between completed Set TR Deq Ptr command & xHCI internal state"

Solution is to add a write memory barrier before writing the cycle bit.

Cc: <stable@vger.kernel.org>
Tested-by: Ross Zwisler <zwisler@google.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20210115161907.2875631-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-ring.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2918,6 +2918,8 @@ static void queue_trb(struct xhci_hcd *x
 	trb->field[0] = cpu_to_le32(field1);
 	trb->field[1] = cpu_to_le32(field2);
 	trb->field[2] = cpu_to_le32(field3);
+	/* make sure TRB is fully written before giving it to the controller */
+	wmb();
 	trb->field[3] = cpu_to_le32(field4);
 
 	trace_xhci_queue_trb(ring, trb);


