Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93949390EE
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730558AbfFGPpA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:45:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:56570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731154AbfFGPo4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:44:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51CE021473;
        Fri,  7 Jun 2019 15:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922295;
        bh=3UoyJAqKaAkq7YW0l6AYCcYWIc28Br0dzzQmyNze5os=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AZiqiVKAyjFukte831fTtjUlKkhIVnxGBcwdlPMeYoVdYGkgxQPRy3/lhHCu9pv6v
         HrBVL9Mlzai3jdu2Kcl8rBUKO6JUMLIYmokCuQy0XBqwTtL3k/o2OHWG/B0HjVd1NF
         snNAYM4jQg6GY6nJeenEBWfVJ3iy0/x5LSEjNf/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Fabio Estevam <festevam@gmail.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.19 04/73] xhci: Use %zu for printing size_t type
Date:   Fri,  7 Jun 2019 17:38:51 +0200
Message-Id: <20190607153849.194005166@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153848.669070800@linuxfoundation.org>
References: <20190607153848.669070800@linuxfoundation.org>
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
@@ -673,7 +673,7 @@ static void xhci_unmap_td_bounce_buffer(
 	len = sg_pcopy_from_buffer(urb->sg, urb->num_sgs, seg->bounce_buf,
 			     seg->bounce_len, seg->bounce_offs);
 	if (len != seg->bounce_len)
-		xhci_warn(xhci, "WARN Wrong bounce buffer read length: %ld != %d\n",
+		xhci_warn(xhci, "WARN Wrong bounce buffer read length: %zu != %d\n",
 				len, seg->bounce_len);
 	seg->bounce_len = 0;
 	seg->bounce_offs = 0;
@@ -3143,7 +3143,7 @@ static int xhci_align_td(struct xhci_hcd
 				   seg->bounce_buf, new_buff_len, enqd_len);
 		if (len != seg->bounce_len)
 			xhci_warn(xhci,
-				"WARN Wrong bounce buffer write length: %ld != %d\n",
+				"WARN Wrong bounce buffer write length: %zu != %d\n",
 				len, seg->bounce_len);
 		seg->bounce_dma = dma_map_single(dev, seg->bounce_buf,
 						 max_pkt, DMA_TO_DEVICE);


