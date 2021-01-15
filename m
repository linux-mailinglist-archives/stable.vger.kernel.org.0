Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D93E92F793B
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733154AbhAOMdl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:33:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:39612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733218AbhAOMdj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:33:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C349223339;
        Fri, 15 Jan 2021 12:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714004;
        bh=MfLHoS0vnrYuPWiEEYF5pa32RrfYysgWSlR23/eQX0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ldBVeE+/0sC6dDfVI6nKJvCx2TRhsh9czebO0mLiNc/tn13ypwDJZMDkl08Ab46S2
         zUHZUmXbK8kok8CP4xTCZVRYq5M3HapUi8cKXqCLaZDICcVAkFHw2cEEq6JZfJ7hQe
         Izs88PJDOJsrIpuF6WMmniNZkIzZsub537uM8zDE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shravya Kumbham <shravya.kumbham@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 4.19 30/43] dmaengine: xilinx_dma: fix incompatible param warning in _child_probe()
Date:   Fri, 15 Jan 2021 13:28:00 +0100
Message-Id: <20210115121958.506620898@linuxfoundation.org>
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

commit faeb0731be0a31e2246b21a85fa7dabbd750101d upstream.

In xilinx_dma_child_probe function, the nr_channels variable is
passed to of_property_read_u32() which expects an u32 return value
pointer. Modify the nr_channels variable type from int to u32 to
fix the incompatible parameter coverity warning.

Addresses-Coverity: Event incompatible_param.
Fixes: 1a9e7a03c761 ("dmaengine: vdma: Add support for mulit-channel dma mode")
Signed-off-by: Shravya Kumbham <shravya.kumbham@xilinx.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Link: https://lore.kernel.org/r/1608722462-29519-3-git-send-email-radhey.shyam.pandey@xilinx.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/xilinx/xilinx_dma.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -2529,7 +2529,8 @@ static int xilinx_dma_chan_probe(struct
 static int xilinx_dma_child_probe(struct xilinx_dma_device *xdev,
 				    struct device_node *node)
 {
-	int ret, i, nr_channels = 1;
+	int ret, i;
+	u32 nr_channels = 1;
 
 	ret = of_property_read_u32(node, "dma-channels", &nr_channels);
 	if ((ret < 0) && xdev->mcdma)


