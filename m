Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57562493F3
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729453AbfFQVX7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:23:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:49330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729017AbfFQVX6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:23:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69CF22063F;
        Mon, 17 Jun 2019 21:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806637;
        bh=Sqcme+VWlYgXM3RIsP6CG6OkhM/xpEogeAgWCEriq2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NdenmgdGG2NtD7rWP49I5JXRBz3Qb4FSjgtMPbhkVs/XxXk9/lAJ+d5gn0heAALIr
         RKF+IhmWoPB/oOP1IY1WWY2hskSteymfbRvl4iCRUK2u41Pzohbz6j345sZo1TVJpf
         KvZNxT8iCbi/rfIh6Ewi7SMIArNtCCV/yE7PGulM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        Martin Schiller <ms@dev.tdt.de>,
        Felipe Balbi <felipe.balbi@linux.intel.com>
Subject: [PATCH 5.1 097/115] usb: dwc2: Fix DMA cache alignment issues
Date:   Mon, 17 Jun 2019 23:09:57 +0200
Message-Id: <20190617210804.850628684@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210759.929316339@linuxfoundation.org>
References: <20190617210759.929316339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Schiller <ms@dev.tdt.de>

commit 4a4863bf2e7932e584a3a462d3c6daf891142ddc upstream.

Insert a padding between data and the stored_xfer_buffer pointer to
ensure they are not on the same cache line.

Otherwise, the stored_xfer_buffer gets corrupted for IN URBs on
non-cache-coherent systems. (In my case: Lantiq xRX200 MIPS)

Fixes: 3bc04e28a030 ("usb: dwc2: host: Get aligned DMA in a more supported way")
Fixes: 56406e017a88 ("usb: dwc2: Fix DMA alignment to start at allocated boundary")
Cc: <stable@vger.kernel.org>
Tested-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Acked-by: Minas Harutyunyan <hminas@synopsys.com>
Signed-off-by: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc2/hcd.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -2664,8 +2664,10 @@ static void dwc2_free_dma_aligned_buffer
 		return;
 
 	/* Restore urb->transfer_buffer from the end of the allocated area */
-	memcpy(&stored_xfer_buffer, urb->transfer_buffer +
-	       urb->transfer_buffer_length, sizeof(urb->transfer_buffer));
+	memcpy(&stored_xfer_buffer,
+	       PTR_ALIGN(urb->transfer_buffer + urb->transfer_buffer_length,
+			 dma_get_cache_alignment()),
+	       sizeof(urb->transfer_buffer));
 
 	if (usb_urb_dir_in(urb)) {
 		if (usb_pipeisoc(urb->pipe))
@@ -2697,6 +2699,7 @@ static int dwc2_alloc_dma_aligned_buffer
 	 * DMA
 	 */
 	kmalloc_size = urb->transfer_buffer_length +
+		(dma_get_cache_alignment() - 1) +
 		sizeof(urb->transfer_buffer);
 
 	kmalloc_ptr = kmalloc(kmalloc_size, mem_flags);
@@ -2707,7 +2710,8 @@ static int dwc2_alloc_dma_aligned_buffer
 	 * Position value of original urb->transfer_buffer pointer to the end
 	 * of allocation for later referencing
 	 */
-	memcpy(kmalloc_ptr + urb->transfer_buffer_length,
+	memcpy(PTR_ALIGN(kmalloc_ptr + urb->transfer_buffer_length,
+			 dma_get_cache_alignment()),
 	       &urb->transfer_buffer, sizeof(urb->transfer_buffer));
 
 	if (usb_urb_dir_out(urb))


