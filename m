Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC022F79C4
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732628AbhAOMkQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:40:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:47622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388406AbhAOMkC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:40:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80B8F221FA;
        Fri, 15 Jan 2021 12:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714362;
        bh=6OlmSlUJCEgMlZvgbtiAKRfbfgar+IOvZ+Uyx64BnmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OEM+/NFtaWUpbiV7v2njwIkK0O+UOvksLUITEyE1Vv0ITEFRMs+WnWkmdQv+imnRZ
         vt4N/IduxSGZeBjQAZDFIV1zgVbI7sVeAJqpA0Ak0uRmV6e1ptCpUKpsbLa/wFW77Q
         HT89L1eA7AohlyOpa9qDqKWxzt0C7yqqyTUc/kXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shravya Kumbham <shravya.kumbham@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 071/103] dmaengine: xilinx_dma: fix incompatible param warning in _child_probe()
Date:   Fri, 15 Jan 2021 13:28:04 +0100
Message-Id: <20210115122009.470989425@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
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
@@ -2900,7 +2900,8 @@ static int xilinx_dma_chan_probe(struct
 static int xilinx_dma_child_probe(struct xilinx_dma_device *xdev,
 				    struct device_node *node)
 {
-	int ret, i, nr_channels = 1;
+	int ret, i;
+	u32 nr_channels = 1;
 
 	ret = of_property_read_u32(node, "dma-channels", &nr_channels);
 	if (xdev->dma_config->dmatype == XDMA_TYPE_AXIMCDMA && ret < 0)


