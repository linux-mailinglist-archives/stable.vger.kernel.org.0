Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 531952C9B2B
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:15:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729363AbgLAJFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:05:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:41514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388860AbgLAJE2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:04:28 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C7F62067D;
        Tue,  1 Dec 2020 09:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813427;
        bh=WKrF+fHOogBVoC2LlHFQk2H2rxbSoQ6iIJIKlmMZy28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bw4suaGCix8LLypuEO/BnUKTqgg6VTvpMec160+WlhqD1UqFlzPP+2R7CPRcd4p1P
         KBHqirycnROMULek/pyCN/fv+Hi6y4Lo9LXIXUtVAsKT95jQf5urDz/n8Lo91vfDAF
         Vc0oiNsWz7r3A1Ag0NyjqcDMoutaSQUwZ0fDSReI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sugar Zhang <sugar.zhang@rock-chips.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 36/98] dmaengine: pl330: _prep_dma_memcpy: Fix wrong burst size
Date:   Tue,  1 Dec 2020 09:53:13 +0100
Message-Id: <20201201084656.912334712@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084652.827177826@linuxfoundation.org>
References: <20201201084652.827177826@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sugar Zhang <sugar.zhang@rock-chips.com>

[ Upstream commit e773ca7da8beeca7f17fe4c9d1284a2b66839cc1 ]

Actually, burst size is equal to '1 << desc->rqcfg.brst_size'.
we should use burst size, not desc->rqcfg.brst_size.

dma memcpy performance on Rockchip RV1126
@ 1512MHz A7, 1056MHz LPDDR3, 200MHz DMA:

dmatest:

/# echo dma0chan0 > /sys/module/dmatest/parameters/channel
/# echo 4194304 > /sys/module/dmatest/parameters/test_buf_size
/# echo 8 > /sys/module/dmatest/parameters/iterations
/# echo y > /sys/module/dmatest/parameters/norandom
/# echo y > /sys/module/dmatest/parameters/verbose
/# echo 1 > /sys/module/dmatest/parameters/run

dmatest: dma0chan0-copy0: result #1: 'test passed' with src_off=0x0 dst_off=0x0 len=0x400000
dmatest: dma0chan0-copy0: result #2: 'test passed' with src_off=0x0 dst_off=0x0 len=0x400000
dmatest: dma0chan0-copy0: result #3: 'test passed' with src_off=0x0 dst_off=0x0 len=0x400000
dmatest: dma0chan0-copy0: result #4: 'test passed' with src_off=0x0 dst_off=0x0 len=0x400000
dmatest: dma0chan0-copy0: result #5: 'test passed' with src_off=0x0 dst_off=0x0 len=0x400000
dmatest: dma0chan0-copy0: result #6: 'test passed' with src_off=0x0 dst_off=0x0 len=0x400000
dmatest: dma0chan0-copy0: result #7: 'test passed' with src_off=0x0 dst_off=0x0 len=0x400000
dmatest: dma0chan0-copy0: result #8: 'test passed' with src_off=0x0 dst_off=0x0 len=0x400000

Before:

  dmatest: dma0chan0-copy0: summary 8 tests, 0 failures 48 iops 200338 KB/s (0)

After this patch:

  dmatest: dma0chan0-copy0: summary 8 tests, 0 failures 179 iops 734873 KB/s (0)

After this patch and increase dma clk to 400MHz:

  dmatest: dma0chan0-copy0: summary 8 tests, 0 failures 259 iops 1062929 KB/s (0)

Signed-off-by: Sugar Zhang <sugar.zhang@rock-chips.com>
Link: https://lore.kernel.org/r/1605326106-55681-1-git-send-email-sugar.zhang@rock-chips.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/pl330.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index cd81d10974a29..57b6555d6d042 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2793,7 +2793,7 @@ pl330_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dst,
 	 * If burst size is smaller than bus width then make sure we only
 	 * transfer one at a time to avoid a burst stradling an MFIFO entry.
 	 */
-	if (desc->rqcfg.brst_size * 8 < pl330->pcfg.data_bus_width)
+	if (burst * 8 < pl330->pcfg.data_bus_width)
 		desc->rqcfg.brst_len = 1;
 
 	desc->bytes_requested = len;
-- 
2.27.0



