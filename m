Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8D7F2F7967
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387750AbhAOMfw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:35:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:42628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732197AbhAOMfv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:35:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2E8423339;
        Fri, 15 Jan 2021 12:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714136;
        bh=cIprcDPH7zjpR2EyWKCr0skt57I5LATyo8ftbF9ssT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ziwiy6WqKjL0lFqkSJ/CPir+JHVY1PYu9Z+qgIUapKAK+rUCGmXPXSXkjU/TNdcI1
         1KCPsSaWyHYHa+m2ELPYKn+DVM1eAt2KYzZz4Hrvwr0iBi/QJFGwpuEqX2VMyN4gHH
         VvPMpxEGZSJD6NRKrrjVBWfejUBZ056D8VVR3cbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shravya Kumbham <shravya.kumbham@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.4 46/62] dmaengine: xilinx_dma: fix mixed_enum_type coverity warning
Date:   Fri, 15 Jan 2021 13:28:08 +0100
Message-Id: <20210115122000.616874406@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121958.391610178@linuxfoundation.org>
References: <20210115121958.391610178@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shravya Kumbham <shravya.kumbham@xilinx.com>

commit 2d5efea64472469117dc1a9a39530069e95b21e9 upstream.

Typecast the fls(width -1) with (enum dmaengine_alignment) in
xilinx_dma_chan_probe function to fix the coverity warning.

Addresses-Coverity: Event mixed_enum_type.
Fixes: 9cd4360de609 ("dma: Add Xilinx AXI Video Direct Memory Access Engine driver support")
Signed-off-by: Shravya Kumbham <shravya.kumbham@xilinx.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Link: https://lore.kernel.org/r/1608722462-29519-4-git-send-email-radhey.shyam.pandey@xilinx.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/xilinx/xilinx_dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -2431,7 +2431,7 @@ static int xilinx_dma_chan_probe(struct
 		has_dre = false;
 
 	if (!has_dre)
-		xdev->common.copy_align = fls(width - 1);
+		xdev->common.copy_align = (enum dmaengine_alignment)fls(width - 1);
 
 	if (of_device_is_compatible(node, "xlnx,axi-vdma-mm2s-channel") ||
 	    of_device_is_compatible(node, "xlnx,axi-dma-mm2s-channel") ||


