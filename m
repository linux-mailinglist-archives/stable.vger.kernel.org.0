Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D43E2F79D9
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388142AbhAOMlz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:41:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:47660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388436AbhAOMkE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:40:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B805C23884;
        Fri, 15 Jan 2021 12:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714364;
        bh=FbfaLdxrvUAHnvf55tXZ6lnwrFG6eHqoox8NUXoHg7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oj3GlVYW4VWW7NhCBryu5QZw9BTRsv2wt+xKnExDsylMPTw/nrjLKYiJ4fMfuiXlp
         WTJu2ljk5j55+p76//bsCfongG8520+vlPkr4ME4Sb1V0LY2mLs59mLyMIU/CVJEt4
         P09kKwOULHgyEhzeJzWIpi+bReki5ZGobsyDAEyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shravya Kumbham <shravya.kumbham@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 072/103] dmaengine: xilinx_dma: fix mixed_enum_type coverity warning
Date:   Fri, 15 Jan 2021 13:28:05 +0100
Message-Id: <20210115122009.517371773@linuxfoundation.org>
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
@@ -2781,7 +2781,7 @@ static int xilinx_dma_chan_probe(struct
 		has_dre = false;
 
 	if (!has_dre)
-		xdev->common.copy_align = fls(width - 1);
+		xdev->common.copy_align = (enum dmaengine_alignment)fls(width - 1);
 
 	if (of_device_is_compatible(node, "xlnx,axi-vdma-mm2s-channel") ||
 	    of_device_is_compatible(node, "xlnx,axi-dma-mm2s-channel") ||


