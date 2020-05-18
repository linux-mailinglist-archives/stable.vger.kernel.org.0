Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED101D85B5
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731189AbgERSUg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:20:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:56032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731020AbgERRwk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:52:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83EA820715;
        Mon, 18 May 2020 17:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824359;
        bh=phJ9ZGQkjfyKNAFbaT+5Dx2rWHhlb29tJiBTXwWSpg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=osc+4U9iKvsdCTn4PEr0vxbOXc68HbSS99gRgGf801/Bor2yMWNU+RCRfUqE5RAWg
         w6XlrT9UW/Kk4Ch+TKJvuaQQXRs0878Rg07pyoHelzhDOz6bq4+d1EH5RC1AdJcfZk
         6q850FyMGRJDQT6zD3/XwrtuQyFYw3KESguWsYtQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sriharsha Allenki <sallenki@codeaurora.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.19 59/80] usb: xhci: Fix NULL pointer dereference when enqueuing trbs from urb sg list
Date:   Mon, 18 May 2020 19:37:17 +0200
Message-Id: <20200518173502.370566184@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.097837707@linuxfoundation.org>
References: <20200518173450.097837707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 drivers/usb/host/xhci-ring.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -3331,8 +3331,8 @@ int xhci_queue_bulk_tx(struct xhci_hcd *
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


