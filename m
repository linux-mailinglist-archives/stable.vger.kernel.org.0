Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC649594FCA
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbiHPEcw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiHPEcP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:32:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AFFD98A6A;
        Mon, 15 Aug 2022 13:22:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2ACFB80EAD;
        Mon, 15 Aug 2022 20:22:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F12C433D6;
        Mon, 15 Aug 2022 20:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594946;
        bh=oJPBOZbTLqjwAY3V+cE4v4X+ZSxA2feGqqazogwrNxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=leAa17qKQUrkwkNQArn0EabSoMeWzaqE92i9mwfpXK1Sl80kOUSwfiq1EXeotEX+s
         KwI7StOLo+W9jFjwULYcyIzHhEuyKbsqWDicJlztqv/o7mq2lMHLvLpvQLafItYJU/
         Gt3m6HcoBLAS2S2syrX5QUuX5JJ5M90XNdTVgzGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frank Li <Frank.Li@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0608/1157] usb: cdns3: fix random warning message when driver load
Date:   Mon, 15 Aug 2022 19:59:24 +0200
Message-Id: <20220815180503.984655166@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit 8659ab3d936fcf0084676f98b75b317017aa8f82 ]

Warning log:
[    4.141392] Unexpected gfp: 0x4 (GFP_DMA32). Fixing up to gfp: 0xa20 (GFP_ATOMIC). Fix your code!
[    4.150340] CPU: 1 PID: 175 Comm: 1-0050 Not tainted 5.15.5-00039-g2fd9ae1b568c #20
[    4.158010] Hardware name: Freescale i.MX8QXP MEK (DT)
[    4.163155] Call trace:
[    4.165600]  dump_backtrace+0x0/0x1b0
[    4.169286]  show_stack+0x18/0x68
[    4.172611]  dump_stack_lvl+0x68/0x84
[    4.176286]  dump_stack+0x18/0x34
[    4.179613]  kmalloc_fix_flags+0x60/0x88
[    4.183550]  new_slab+0x334/0x370
[    4.186878]  ___slab_alloc.part.108+0x4d4/0x748
[    4.191419]  __slab_alloc.isra.109+0x30/0x78
[    4.195702]  kmem_cache_alloc+0x40c/0x420
[    4.199725]  dma_pool_alloc+0xac/0x1f8
[    4.203486]  cdns3_allocate_trb_pool+0xb4/0xd0

pool_alloc_page(struct dma_pool *pool, gfp_t mem_flags)
{
	...
	page = kmalloc(sizeof(*page), mem_flags);
	page->vaddr = dma_alloc_coherent(pool->dev, pool->allocation,
					 &page->dma, mem_flags);
	...
}

kmalloc was called with mem_flags, which is passed down in
cdns3_allocate_trb_pool() and have GFP_DMA32 flags.
kmall_fix_flags() report warning.

GFP_DMA32 is not useful at all. dma_alloc_coherent() will handle
DMA memory region correctly by pool->dev. GFP_DMA32 can be removed
safely.

Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20220609154456.2871672-1-Frank.Li@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/cdns3/cdns3-gadget.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/cdns3/cdns3-gadget.c b/drivers/usb/cdns3/cdns3-gadget.c
index 5c15c48952a6..f5f5fbbefec0 100644
--- a/drivers/usb/cdns3/cdns3-gadget.c
+++ b/drivers/usb/cdns3/cdns3-gadget.c
@@ -220,7 +220,7 @@ int cdns3_allocate_trb_pool(struct cdns3_endpoint *priv_ep)
 
 	if (!priv_ep->trb_pool) {
 		priv_ep->trb_pool = dma_pool_alloc(priv_dev->eps_dma_pool,
-						   GFP_DMA32 | GFP_ATOMIC,
+						   GFP_ATOMIC,
 						   &priv_ep->trb_pool_dma);
 
 		if (!priv_ep->trb_pool)
-- 
2.35.1



