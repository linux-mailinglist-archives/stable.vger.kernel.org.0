Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF182F7ACA
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732678AbhAOMyw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:54:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:42222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387680AbhAOMf3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:35:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2A55221FA;
        Fri, 15 Jan 2021 12:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714114;
        bh=RHSxbD25++s4zxRCAT48MXwswzAVHnPpqyvYZIo2iq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fHcE3Z9ySAewhunuwE7bcV1TXFbD0TmRQcV0QlqR7uLpPjPYobUD3zK54xhFBAHwp
         cli9gzDMLJI0QeEvtju4TqSBRPyU7TTyWc4It8cNi8obPQhP94SyoPr35TjSerqdoQ
         DC8sVTMcAz7M6I8UKM+yKRN89Ax6JBNC0VDtvfaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shravya Kumbham <shravya.kumbham@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.4 45/62] dmaengine: xilinx_dma: fix incompatible param warning in _child_probe()
Date:   Fri, 15 Jan 2021 13:28:07 +0100
Message-Id: <20210115122000.569003983@linuxfoundation.org>
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
@@ -2543,7 +2543,8 @@ static int xilinx_dma_chan_probe(struct
 static int xilinx_dma_child_probe(struct xilinx_dma_device *xdev,
 				    struct device_node *node)
 {
-	int ret, i, nr_channels = 1;
+	int ret, i;
+	u32 nr_channels = 1;
 
 	ret = of_property_read_u32(node, "dma-channels", &nr_channels);
 	if ((ret < 0) && xdev->mcdma)


