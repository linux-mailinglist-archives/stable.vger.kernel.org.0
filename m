Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA602F7B36
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 14:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733193AbhAOMdi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:33:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:39960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733154AbhAOMdh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:33:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 962DC235F8;
        Fri, 15 Jan 2021 12:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714002;
        bh=TDDpXuBgLVCiAQrY2XBfhsvvI8CTbty4gxeGpYh89g8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BSOeeDcJkX+BFZb3fmsDKNlFzJiq9T/8CTPqwU1SiIEUaogL3b/Hjq6nWAEin2U+C
         CGGh22iNFBMGMYHjZ1eYcpk33d2G5Bqv6T2Um9y6uccdCA4ZxUvDJCDenia6yGV8+s
         0d9b5gUms6FFJIkuGkfC807lv0htZvZPEyDlu+ns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shravya Kumbham <shravya.kumbham@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 4.19 29/43] dmaengine: xilinx_dma: check dma_async_device_register return value
Date:   Fri, 15 Jan 2021 13:27:59 +0100
Message-Id: <20210115121958.458407619@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121957.037407908@linuxfoundation.org>
References: <20210115121957.037407908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shravya Kumbham <shravya.kumbham@xilinx.com>

commit 99974aedbd73523969afb09f33c6e3047cd0ddae upstream.

dma_async_device_register() can return non-zero error code. Add
condition to check the return value of dma_async_device_register
function and handle the error path.

Addresses-Coverity: Event check_return.
Fixes: 9cd4360de609 ("dma: Add Xilinx AXI Video Direct Memory Access Engine driver support")
Signed-off-by: Shravya Kumbham <shravya.kumbham@xilinx.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Link: https://lore.kernel.org/r/1608722462-29519-2-git-send-email-radhey.shyam.pandey@xilinx.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/xilinx/xilinx_dma.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -2713,7 +2713,11 @@ static int xilinx_dma_probe(struct platf
 	}
 
 	/* Register the DMA engine with the core */
-	dma_async_device_register(&xdev->common);
+	err = dma_async_device_register(&xdev->common);
+	if (err) {
+		dev_err(xdev->dev, "failed to register the dma device\n");
+		goto error;
+	}
 
 	err = of_dma_controller_register(node, of_dma_xilinx_xlate,
 					 xdev);


