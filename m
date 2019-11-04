Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5EBEEE3B
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390302AbfKDWIw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:08:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:41786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388158AbfKDWIv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:08:51 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 859C6214D8;
        Mon,  4 Nov 2019 22:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905330;
        bh=o/Ex+1vv7SaDW4yyZ1WvsYR1s5YLNJ0IQxV7tuCOcYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dOL8jtqOXh3fbS0aUJX/6997+RzEVbdwZCSlCCedwizYQbqLLpExIHi9oDM9hrX5+
         4pp7jFaOR0EieAdUc/WKESKePKi5fAIG3OuMX1KWdffw3Olb/IJpvT0XJ+v1qhOD37
         j/TpjRuq5XFhSNN+iRP1oFMfI1gxPceOx59UaSGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Dooks <ben.dooks@codethink.co.uk>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.3 109/163] usb: xhci: fix __le32/__le64 accessors in debugfs code
Date:   Mon,  4 Nov 2019 22:44:59 +0100
Message-Id: <20191104212148.146334499@linuxfoundation.org>
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

From: Ben Dooks (Codethink) <ben.dooks@codethink.co.uk>

commit d5501d5c29a2e684640507cfee428178d6fd82ca upstream.

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
 drivers/usb/host/xhci-debugfs.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/drivers/usb/host/xhci-debugfs.c
+++ b/drivers/usb/host/xhci-debugfs.c
@@ -202,10 +202,10 @@ static void xhci_ring_dump_segment(struc
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
 
@@ -263,10 +263,10 @@ static int xhci_slot_context_show(struct
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
@@ -286,10 +286,10 @@ static int xhci_endpoint_context_show(st
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


