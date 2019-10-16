Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F568D9FFD
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390526AbfJPWGs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:06:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:51950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406717AbfJPV6X (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:58:23 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51FC021A49;
        Wed, 16 Oct 2019 21:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263103;
        bh=kbqYrKp9K7Y0yVz+0W0CU40rQnMwPb3hoPbkR185Xq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w9uZxNTBsWF9kFon7hF7B8iJVK7BAN6zLd6VRPVtg1N9pfaMJiD4RqF9p8GcIUCQv
         2d+fzP6ImIpz60XJ6ZasU4jeablFV6kkccOIl3/CUqDvjal9MSGOdlLG7EBpKTyr83
         1Am3pahKqDFpzoa05and6X0ZxFsc4S0F2TAI/Wgo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.3 007/112] xhci: Fix false warning message about wrong bounce buffer write length
Date:   Wed, 16 Oct 2019 14:49:59 -0700
Message-Id: <20191016214845.950987317@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
References: <20191016214844.038848564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit c03101ff4f74bb30679c1a03d551ecbef1024bf6 upstream.

The check printing out the "WARN Wrong bounce buffer write length:"
uses incorrect values when comparing bytes written from scatterlist
to bounce buffer. Actual copied lengths are fine.

The used seg->bounce_len will be set to equal new_buf_len a few lines later
in the code, but is incorrect when doing the comparison.

The patch which added this false warning was backported to 4.8+ kernels
so this should be backported as far as well.

Cc: <stable@vger.kernel.org> # v4.8+
Fixes: 597c56e372da ("xhci: update bounce buffer with correct sg num")
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/1570190373-30684-2-git-send-email-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-ring.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -3202,10 +3202,10 @@ static int xhci_align_td(struct xhci_hcd
 	if (usb_urb_dir_out(urb)) {
 		len = sg_pcopy_to_buffer(urb->sg, urb->num_sgs,
 				   seg->bounce_buf, new_buff_len, enqd_len);
-		if (len != seg->bounce_len)
+		if (len != new_buff_len)
 			xhci_warn(xhci,
 				"WARN Wrong bounce buffer write length: %zu != %d\n",
-				len, seg->bounce_len);
+				len, new_buff_len);
 		seg->bounce_dma = dma_map_single(dev, seg->bounce_buf,
 						 max_pkt, DMA_TO_DEVICE);
 	} else {


