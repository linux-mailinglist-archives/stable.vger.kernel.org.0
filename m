Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19D061F2E61
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733246AbgFIAlC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:41:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:60468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729180AbgFHXMr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:12:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1887420E65;
        Mon,  8 Jun 2020 23:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657966;
        bh=wb3bT3ZYUu0opB4Sn5HPjXgouam0S+ZF2bId0wVta+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wtWywUXmM2NiZt48Ln46U2f/fhjip8jVepxP5vImY/4DArdRk1k1SJF3lvmv6DBxD
         V9I+omb27dzPGL0xet0ZWHO7k0Pcx6z/iJMKUXsLFnTMnxZliyv4o3r0bXyw4+uYdO
         exnTeWVmq/0x3HKbPjrtfODdNy7UI9XKQp0yCUVM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sriharsha Allenki <sallenki@codeaurora.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 030/606] usb: xhci: Fix NULL pointer dereference when enqueuing trbs from urb sg list
Date:   Mon,  8 Jun 2020 19:02:35 -0400
Message-Id: <20200608231211.3363633-30-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sriharsha Allenki <sallenki@codeaurora.org>

commit 3c6f8cb92c9178fc0c66b580ea3df1fa3ac1155a upstream.

On platforms with IOMMU enabled, multiple SGs can be coalesced into one
by the IOMMU driver. In that case the SG list processing as part of the
completion of a urb on a bulk endpoint can result into a NULL pointer
dereference with the below stack dump.

<6> Unable to handle kernel NULL pointer dereference at virtual address 0000000c
<6> pgd = c0004000
<6> [0000000c] *pgd=00000000
<6> Internal error: Oops: 5 [#1] PREEMPT SMP ARM
<2> PC is at xhci_queue_bulk_tx+0x454/0x80c
<2> LR is at xhci_queue_bulk_tx+0x44c/0x80c
<2> pc : [<c08907c4>]    lr : [<c08907bc>]    psr: 000000d3
<2> sp : ca337c80  ip : 00000000  fp : ffffffff
<2> r10: 00000000  r9 : 50037000  r8 : 00004000
<2> r7 : 00000000  r6 : 00004000  r5 : 00000000  r4 : 00000000
<2> r3 : 00000000  r2 : 00000082  r1 : c2c1a200  r0 : 00000000
<2> Flags: nzcv  IRQs off  FIQs off  Mode SVC_32  ISA ARM  Segment none
<2> Control: 10c0383d  Table: b412c06a  DAC: 00000051
<6> Process usb-storage (pid: 5961, stack limit = 0xca336210)
<snip>
<2> [<c08907c4>] (xhci_queue_bulk_tx)
<2> [<c0881b3c>] (xhci_urb_enqueue)
<2> [<c0831068>] (usb_hcd_submit_urb)
<2> [<c08350b4>] (usb_sg_wait)
<2> [<c089f384>] (usb_stor_bulk_transfer_sglist)
<2> [<c089f2c0>] (usb_stor_bulk_srb)
<2> [<c089fe38>] (usb_stor_Bulk_transport)
<2> [<c089f468>] (usb_stor_invoke_transport)
<2> [<c08a11b4>] (usb_stor_control_thread)
<2> [<c014a534>] (kthread)

The above NULL pointer dereference is the result of block_len and the
sent_len set to zero after the first SG of the list when IOMMU driver
is enabled. Because of this the loop of processing the SGs has run
more than num_sgs which resulted in a sg_next on the last SG of the
list which has SG_END set.

Fix this by check for the sg before any attributes of the sg are
accessed.

[modified reason for null pointer dereference in commit message subject -Mathias]
Fixes: f9c589e142d04 ("xhci: TD-fragment, align the unsplittable case with a bounce buffer")
Cc: stable@vger.kernel.org
Signed-off-by: Sriharsha Allenki <sallenki@codeaurora.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20200514110432.25564-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-ring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 2fbc00c0a6e8..49f3f3ce7737 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -3425,8 +3425,8 @@ int xhci_queue_bulk_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
 			/* New sg entry */
 			--num_sgs;
 			sent_len -= block_len;
-			if (num_sgs != 0) {
-				sg = sg_next(sg);
+			sg = sg_next(sg);
+			if (num_sgs != 0 && sg) {
 				block_len = sg_dma_len(sg);
 				addr = (u64) sg_dma_address(sg);
 				addr += sent_len;
-- 
2.25.1

