Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4CE2F7B7D
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 14:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731288AbhAOMcj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:32:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:39354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731075AbhAOMcj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:32:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FEF52333E;
        Fri, 15 Jan 2021 12:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610713918;
        bh=aSnKwTyvPSgMuEGzB6MgxvdJEneQ1pXlJJIoOqU/ADE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yx8Nf/AiSfn4M7zIgBdytdP5bBS0z9ih0iq+4szgdVNqKV44me4mu6SlxKKBmO9Nm
         QuKbpmpDU5IbrTetFdp2kKgKLikXKJYO5+To8XP+Nx4+r73gwKlP6KDa+wwlfN6jM9
         kejhrVCwKY5woJYdQAryK2sGFRLCD7dbvSZbalsE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shravya Kumbham <shravya.kumbham@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 4.14 19/28] dmaengine: xilinx_dma: fix mixed_enum_type coverity warning
Date:   Fri, 15 Jan 2021 13:27:56 +0100
Message-Id: <20210115121957.711108493@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121956.731354372@linuxfoundation.org>
References: <20210115121956.731354372@linuxfoundation.org>
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
@@ -2360,7 +2360,7 @@ static int xilinx_dma_chan_probe(struct
 		has_dre = false;
 
 	if (!has_dre)
-		xdev->common.copy_align = fls(width - 1);
+		xdev->common.copy_align = (enum dmaengine_alignment)fls(width - 1);
 
 	if (of_device_is_compatible(node, "xlnx,axi-vdma-mm2s-channel") ||
 	    of_device_is_compatible(node, "xlnx,axi-dma-mm2s-channel") ||


