Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3844B49347
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730080AbfFQV32 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:29:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:56610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730702AbfFQV31 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:29:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9C782063F;
        Mon, 17 Jun 2019 21:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806966;
        bh=50KnVm1WMS4CbST70N/lWUYI26/0dp84qG0OkcYUK8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rRtwW4sUMSLNPVQtj2JZ+sbKRaBadBjM17j+OrIzhoRk1xQYc8T0yHztq2V7WByly
         A5TB1fQpd69E4aLeg7581UYdLcbje3Mc0SGdxpB8W+rPwfDpETEcsfKVc2xDBT5CnE
         toskEUjS4rX5LUtc+ZX+q7fBjW9uOolYDjBpFsSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        Martin Schiller <ms@dev.tdt.de>,
        Felipe Balbi <felipe.balbi@linux.intel.com>
Subject: [PATCH 4.14 43/53] usb: dwc2: Fix DMA cache alignment issues
Date:   Mon, 17 Jun 2019 23:10:26 +0200
Message-Id: <20190617210752.152355123@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210745.104187490@linuxfoundation.org>
References: <20190617210745.104187490@linuxfoundation.org>
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
@@ -2652,8 +2652,10 @@ static void dwc2_free_dma_aligned_buffer
 		return;
 
 	/* Restore urb->transfer_buffer from the end of the allocated area */
-	memcpy(&stored_xfer_buffer, urb->transfer_buffer +
-	       urb->transfer_buffer_length, sizeof(urb->transfer_buffer));
+	memcpy(&stored_xfer_buffer,
+	       PTR_ALIGN(urb->transfer_buffer + urb->transfer_buffer_length,
+			 dma_get_cache_alignment()),
+	       sizeof(urb->transfer_buffer));
 
 	if (usb_urb_dir_in(urb))
 		memcpy(stored_xfer_buffer, urb->transfer_buffer,
@@ -2680,6 +2682,7 @@ static int dwc2_alloc_dma_aligned_buffer
 	 * DMA
 	 */
 	kmalloc_size = urb->transfer_buffer_length +
+		(dma_get_cache_alignment() - 1) +
 		sizeof(urb->transfer_buffer);
 
 	kmalloc_ptr = kmalloc(kmalloc_size, mem_flags);
@@ -2690,7 +2693,8 @@ static int dwc2_alloc_dma_aligned_buffer
 	 * Position value of original urb->transfer_buffer pointer to the end
 	 * of allocation for later referencing
 	 */
-	memcpy(kmalloc_ptr + urb->transfer_buffer_length,
+	memcpy(PTR_ALIGN(kmalloc_ptr + urb->transfer_buffer_length,
+			 dma_get_cache_alignment()),
 	       &urb->transfer_buffer, sizeof(urb->transfer_buffer));
 
 	if (usb_urb_dir_out(urb))


