Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7729CE76FA
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 17:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403892AbfJ1QsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 12:48:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:51656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403879AbfJ1QsK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Oct 2019 12:48:10 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8EF6208C0;
        Mon, 28 Oct 2019 16:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572281289;
        bh=wkTmxMF7R8LEPgRdoDDjEJHPBsYF2QiUcXsqSEQWOTU=;
        h=Subject:To:From:Date:From;
        b=KJmKHNdPjIn+GXOaAcxE/2jzd2+YwsWKdFtWM4Fsxl/C8dnuto3jcQgzlxsdx20P1
         xiEV6L3d2h9WyEMeXIF5fHhlgxYdsYZEf6Uc7HBCKqw8KbPJF4Z8gfxAPYaBX/ayZi
         Wr2g6ORCmWih5t/ib99FgGNT0+YZc9zeaM1zqasU=
Subject: patch "usb: xhci: fix __le32/__le64 accessors in debugfs code" added to usb-linus
To:     ben.dooks@codethink.co.uk, gregkh@linuxfoundation.org,
        mathias.nyman@linux.intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Oct 2019 17:47:53 +0100
Message-ID: <1572281273119159@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: xhci: fix __le32/__le64 accessors in debugfs code

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From d5501d5c29a2e684640507cfee428178d6fd82ca Mon Sep 17 00:00:00 2001
From: "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>
Date: Fri, 25 Oct 2019 17:30:29 +0300
Subject: usb: xhci: fix __le32/__le64 accessors in debugfs code

It looks like some of the xhci debug code is passing u32 to functions
directly from __le32/__le64 fields.
Fix this by using le{32,64}_to_cpu() on these to fix the following
sparse warnings;

xhci-debugfs.c:205:62: warning: incorrect type in argument 1 (different base types)
xhci-debugfs.c:205:62:    expected unsigned int [usertype] field0
xhci-debugfs.c:205:62:    got restricted __le32
xhci-debugfs.c:206:62: warning: incorrect type in argument 2 (different base types)
xhci-debugfs.c:206:62:    expected unsigned int [usertype] field1
xhci-debugfs.c:206:62:    got restricted __le32
...

[Trim down commit message, sparse warnings were similar -Mathias]
Cc: <stable@vger.kernel.org> # 4.15+
Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/1572013829-14044-4-git-send-email-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-debugfs.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/host/xhci-debugfs.c b/drivers/usb/host/xhci-debugfs.c
index 7ba6afc7ef23..76c3f29562d2 100644
--- a/drivers/usb/host/xhci-debugfs.c
+++ b/drivers/usb/host/xhci-debugfs.c
@@ -202,10 +202,10 @@ static void xhci_ring_dump_segment(struct seq_file *s,
 		trb = &seg->trbs[i];
 		dma = seg->dma + i * sizeof(*trb);
 		seq_printf(s, "%pad: %s\n", &dma,
-			   xhci_decode_trb(trb->generic.field[0],
-					   trb->generic.field[1],
-					   trb->generic.field[2],
-					   trb->generic.field[3]));
+			   xhci_decode_trb(le32_to_cpu(trb->generic.field[0]),
+					   le32_to_cpu(trb->generic.field[1]),
+					   le32_to_cpu(trb->generic.field[2]),
+					   le32_to_cpu(trb->generic.field[3])));
 	}
 }
 
@@ -263,10 +263,10 @@ static int xhci_slot_context_show(struct seq_file *s, void *unused)
 	xhci = hcd_to_xhci(bus_to_hcd(dev->udev->bus));
 	slot_ctx = xhci_get_slot_ctx(xhci, dev->out_ctx);
 	seq_printf(s, "%pad: %s\n", &dev->out_ctx->dma,
-		   xhci_decode_slot_context(slot_ctx->dev_info,
-					    slot_ctx->dev_info2,
-					    slot_ctx->tt_info,
-					    slot_ctx->dev_state));
+		   xhci_decode_slot_context(le32_to_cpu(slot_ctx->dev_info),
+					    le32_to_cpu(slot_ctx->dev_info2),
+					    le32_to_cpu(slot_ctx->tt_info),
+					    le32_to_cpu(slot_ctx->dev_state)));
 
 	return 0;
 }
@@ -286,10 +286,10 @@ static int xhci_endpoint_context_show(struct seq_file *s, void *unused)
 		ep_ctx = xhci_get_ep_ctx(xhci, dev->out_ctx, dci);
 		dma = dev->out_ctx->dma + dci * CTX_SIZE(xhci->hcc_params);
 		seq_printf(s, "%pad: %s\n", &dma,
-			   xhci_decode_ep_context(ep_ctx->ep_info,
-						  ep_ctx->ep_info2,
-						  ep_ctx->deq,
-						  ep_ctx->tx_info));
+			   xhci_decode_ep_context(le32_to_cpu(ep_ctx->ep_info),
+						  le32_to_cpu(ep_ctx->ep_info2),
+						  le64_to_cpu(ep_ctx->deq),
+						  le32_to_cpu(ep_ctx->tx_info)));
 	}
 
 	return 0;
-- 
2.23.0


