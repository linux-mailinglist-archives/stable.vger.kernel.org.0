Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03534267F9
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 18:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729576AbfEVQTx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 12:19:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728638AbfEVQTx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 12:19:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1424720868;
        Wed, 22 May 2019 16:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558541992;
        bh=+NvtzibOYvONJsxC0WDi0BFWGBpqvoDbd9GjJ588PZQ=;
        h=Subject:To:From:Date:From;
        b=N1dJskULeNL3RZIwDZymJRJWDygkkCF5Bn3oW+RL0NNXoO4/KaQOnwUC0WSebBqv1
         ehEU5RCKG2NaeJE8mix8Ppbpx0yHuvk/cp1wTKNmbszs1QLkM+hKn1d0mu6eVPHrFq
         QgY/zmtjYgARXI3zV3GwtxkxHTWdotnY3Jm5ASmQ=
Subject: patch "xhci: Use %zu for printing size_t type" added to usb-linus
To:     festevam@gmail.com, gregkh@linuxfoundation.org, lkp@intel.com,
        mathias.nyman@linux.intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 22 May 2019 18:19:50 +0200
Message-ID: <15585419901224@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    xhci: Use %zu for printing size_t type

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From c1a145a3ed9a40f3b6145feb97789e8eb49c5566 Mon Sep 17 00:00:00 2001
From: Fabio Estevam <festevam@gmail.com>
Date: Wed, 22 May 2019 10:35:29 -0300
Subject: xhci: Use %zu for printing size_t type

Commit 597c56e372da ("xhci: update bounce buffer with correct sg num")
caused the following build warnings:

drivers/usb/host/xhci-ring.c:676:19: warning: format '%ld' expects argument of type 'long int', but argument 3 has type 'size_t {aka unsigned int}' [-Wformat=]

Use %zu for printing size_t type in order to fix the warnings.

Fixes: 597c56e372da ("xhci: update bounce buffer with correct sg num")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Cc: stable <stable@vger.kernel.org>
Acked-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-ring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 88392aa65722..feffceb31e8a 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -673,7 +673,7 @@ static void xhci_unmap_td_bounce_buffer(struct xhci_hcd *xhci,
 	len = sg_pcopy_from_buffer(urb->sg, urb->num_sgs, seg->bounce_buf,
 			     seg->bounce_len, seg->bounce_offs);
 	if (len != seg->bounce_len)
-		xhci_warn(xhci, "WARN Wrong bounce buffer read length: %ld != %d\n",
+		xhci_warn(xhci, "WARN Wrong bounce buffer read length: %zu != %d\n",
 				len, seg->bounce_len);
 	seg->bounce_len = 0;
 	seg->bounce_offs = 0;
@@ -3166,7 +3166,7 @@ static int xhci_align_td(struct xhci_hcd *xhci, struct urb *urb, u32 enqd_len,
 				   seg->bounce_buf, new_buff_len, enqd_len);
 		if (len != seg->bounce_len)
 			xhci_warn(xhci,
-				"WARN Wrong bounce buffer write length: %ld != %d\n",
+				"WARN Wrong bounce buffer write length: %zu != %d\n",
 				len, seg->bounce_len);
 		seg->bounce_dma = dma_map_single(dev, seg->bounce_buf,
 						 max_pkt, DMA_TO_DEVICE);
-- 
2.21.0


