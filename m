Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBE939172
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 18:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730219AbfFGPlH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:41:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:50710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730198AbfFGPlG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:41:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBF1E2146F;
        Fri,  7 Jun 2019 15:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922066;
        bh=KNFfvqEjrqV1o0Cnpl7tCj8fpBBoVZfiCSerGYW3EP8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O2t58nrYG286vssbsdYphTLCIkiQbVC67luTG/tK7JLihYcw2O9Pr2aCatgrGfZlL
         IDuwwftkiiB2r9MiEEZRLgrV23DvGnUmCeDGen8QnQROaiu44/wvoEFAhXwRQKJ3Qe
         Ay3hdM8vE7EAU8XoQELqbznP6FIJetXQBQqJzlA4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Fabio Estevam <festevam@gmail.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.14 24/69] xhci: Use %zu for printing size_t type
Date:   Fri,  7 Jun 2019 17:39:05 +0200
Message-Id: <20190607153851.370994242@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153848.271562617@linuxfoundation.org>
References: <20190607153848.271562617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

commit c1a145a3ed9a40f3b6145feb97789e8eb49c5566 upstream.

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
 drivers/usb/host/xhci-ring.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -684,7 +684,7 @@ static void xhci_unmap_td_bounce_buffer(
 	len = sg_pcopy_from_buffer(urb->sg, urb->num_sgs, seg->bounce_buf,
 			     seg->bounce_len, seg->bounce_offs);
 	if (len != seg->bounce_len)
-		xhci_warn(xhci, "WARN Wrong bounce buffer read length: %ld != %d\n",
+		xhci_warn(xhci, "WARN Wrong bounce buffer read length: %zu != %d\n",
 				len, seg->bounce_len);
 	seg->bounce_len = 0;
 	seg->bounce_offs = 0;
@@ -3225,7 +3225,7 @@ static int xhci_align_td(struct xhci_hcd
 				   seg->bounce_buf, new_buff_len, enqd_len);
 		if (len != seg->bounce_len)
 			xhci_warn(xhci,
-				"WARN Wrong bounce buffer write length: %ld != %d\n",
+				"WARN Wrong bounce buffer write length: %zu != %d\n",
 				len, seg->bounce_len);
 		seg->bounce_dma = dma_map_single(dev, seg->bounce_buf,
 						 max_pkt, DMA_TO_DEVICE);


