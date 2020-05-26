Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8AB31D2DC0
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 13:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726051AbgENLBv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 07:01:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:33412 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725925AbgENLBu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 07:01:50 -0400
IronPort-SDR: sDlZTxE+WAO+RRG8WRI8E9BZP9vd6FORJ6t1H9xqKrm1num574WehPK4ljn9LUNJLDCTXTrMEP
 mb5jd6ZkLwyQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2020 04:01:50 -0700
IronPort-SDR: KJ109UDoTVMIQnYwHfluB37uTeJIkT/TnlE/T5+BvOCr05Rj4UGbR1yGmepNHMSN1M/8Brlz5c
 udW/yQcHv6Xw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,391,1583222400"; 
   d="scan'208";a="307071678"
Received: from mattu-haswell.fi.intel.com ([10.237.72.170])
  by FMSMGA003.fm.intel.com with ESMTP; 14 May 2020 04:01:48 -0700
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Sriharsha Allenki <sallenki@codeaurora.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 1/2] usb: xhci: Fix NULL pointer dereference when enqueuing trbs from urb sg list
Date:   Thu, 14 May 2020 14:04:31 +0300
Message-Id: <20200514110432.25564-2-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200514110432.25564-1-mathias.nyman@linux.intel.com>
References: <20200514110432.25564-1-mathias.nyman@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sriharsha Allenki <sallenki@codeaurora.org>

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
---
 drivers/usb/host/xhci-ring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 0fda0c0f4d31..2c255d0620b0 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -3433,8 +3433,8 @@ int xhci_queue_bulk_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
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
2.17.1

