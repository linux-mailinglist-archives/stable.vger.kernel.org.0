Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6076AF4BB
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231540AbjCGTTU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:19:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233961AbjCGTTA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:19:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A658C3E3E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:02:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C5DFB819A7
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:02:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50340C433EF;
        Tue,  7 Mar 2023 19:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215762;
        bh=qbXq1e92zH5OmeV7aTT8amah4R+6GDyhpQfYoAnLgas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cK2HOuFrMQ8rq+HdzI6jcZj77E7GkInGNmlcx6GFS2qo6c+t58rk+KLNjR5ZGOqqX
         /h1dTOVTQs9htjeDB4F/6ZrHOVjfsFjyJ9E5FM45Nz4b4gF/9j2Rl7QdLBAw4i27zd
         w6Ek9F8nbvQVs7k+T1h3xhAkDu6hxQLj4dq+uo3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Shravan Chippa <shravan.chippa@microchip.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 335/567] dmaengine: sf-pdma: pdma_desc memory leak fix
Date:   Tue,  7 Mar 2023 18:01:11 +0100
Message-Id: <20230307165920.405431407@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shravan Chippa <shravan.chippa@microchip.com>

[ Upstream commit b02e07015a5ac7bbc029da931ae17914b8ae0339 ]

Commit b2cc5c465c2c ("dmaengine: sf-pdma: Add multithread support for a
DMA channel") changed sf_pdma_prep_dma_memcpy() to unconditionally
allocate a new sf_pdma_desc each time it is called.

The driver previously recycled descs, by checking the in_use flag, only
allocating additional descs if the existing one was in use. This logic
was removed in commit b2cc5c465c2c ("dmaengine: sf-pdma: Add multithread
support for a DMA channel"), but sf_pdma_free_desc() was not changed to
handle the new behaviour.

As a result, each time sf_pdma_prep_dma_memcpy() is called, the previous
descriptor is leaked, over time leading to memory starvation:

  unreferenced object 0xffffffe008447300 (size 192):
  comm "irq/39-mchp_dsc", pid 343, jiffies 4294906910 (age 981.200s)
  hex dump (first 32 bytes):
    00 00 00 ff 00 00 00 00 b8 c1 00 00 00 00 00 00  ................
    00 00 70 08 10 00 00 00 00 00 00 c0 00 00 00 00  ..p.............
  backtrace:
    [<00000000064a04f4>] kmemleak_alloc+0x1e/0x28
    [<00000000018927a7>] kmem_cache_alloc+0x11e/0x178
    [<000000002aea8d16>] sf_pdma_prep_dma_memcpy+0x40/0x112

Add the missing kfree() to sf_pdma_free_desc(), and remove the redundant
in_use flag.

Fixes: b2cc5c465c2c ("dmaengine: sf-pdma: Add multithread support for a DMA channel")
Signed-off-by: Shravan Chippa <shravan.chippa@microchip.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20230120100623.3530634-1-shravan.chippa@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/sf-pdma/sf-pdma.c | 3 +--
 drivers/dma/sf-pdma/sf-pdma.h | 1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/dma/sf-pdma/sf-pdma.c b/drivers/dma/sf-pdma/sf-pdma.c
index ab0ad7a2f2015..dcf2b7a4183c1 100644
--- a/drivers/dma/sf-pdma/sf-pdma.c
+++ b/drivers/dma/sf-pdma/sf-pdma.c
@@ -96,7 +96,6 @@ sf_pdma_prep_dma_memcpy(struct dma_chan *dchan,	dma_addr_t dest, dma_addr_t src,
 	if (!desc)
 		return NULL;
 
-	desc->in_use = true;
 	desc->dirn = DMA_MEM_TO_MEM;
 	desc->async_tx = vchan_tx_prep(&chan->vchan, &desc->vdesc, flags);
 
@@ -290,7 +289,7 @@ static void sf_pdma_free_desc(struct virt_dma_desc *vdesc)
 	struct sf_pdma_desc *desc;
 
 	desc = to_sf_pdma_desc(vdesc);
-	desc->in_use = false;
+	kfree(desc);
 }
 
 static void sf_pdma_donebh_tasklet(struct tasklet_struct *t)
diff --git a/drivers/dma/sf-pdma/sf-pdma.h b/drivers/dma/sf-pdma/sf-pdma.h
index 0c20167b097d0..02a229a3ae225 100644
--- a/drivers/dma/sf-pdma/sf-pdma.h
+++ b/drivers/dma/sf-pdma/sf-pdma.h
@@ -82,7 +82,6 @@ struct sf_pdma_desc {
 	u64				src_addr;
 	struct virt_dma_desc		vdesc;
 	struct sf_pdma_chan		*chan;
-	bool				in_use;
 	enum dma_transfer_direction	dirn;
 	struct dma_async_tx_descriptor *async_tx;
 };
-- 
2.39.2



