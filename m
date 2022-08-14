Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F297592084
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239471AbiHNP1f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239081AbiHNP1c (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:27:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7B7AE51;
        Sun, 14 Aug 2022 08:27:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7606B80B74;
        Sun, 14 Aug 2022 15:27:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A65C6C433D7;
        Sun, 14 Aug 2022 15:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660490848;
        bh=yJNbX/lEa6B5zb4AB956b5HRWtmg1Jood0nxTvZn2S4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t/wrqPFCMMAwDktOA+E/W5SlkJQut4lAG3G4QGARhamvoFV6nZxUCZTR5FJ3lZkRI
         KbhtpHrc4WabaJfUgGAiLORwxEC18u78CHoy67SG8g/hSvMacMbw3vLoJVTdOG1+ci
         7TNn0iNkOAsmBoXP1kpxHnyF5MQ/FJJ0X8Zvg2Bp+ZZWWvAXBd171P7PDwux3tH7pk
         lcjNWJ+oOgeuz9Mi1vd14+syBAtpaloM4j0S0GzNkGTCTP2B+mnkT9Wtux7QsyJo5P
         A3aTgdUFkLDxmfkFqApyaKuYFKXfScL7FRFaEnSem+38Zm5SNNphJR6alXkH3hvkuE
         eS+WWO2oOYAag==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Frank Li <Frank.Li@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, peter.chen@kernel.org,
        pawell@cadence.com, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 09/64] usb: cdns3: fix random warning message when driver load
Date:   Sun, 14 Aug 2022 11:23:42 -0400
Message-Id: <20220814152437.2374207-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814152437.2374207-1-sashal@kernel.org>
References: <20220814152437.2374207-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 29662c8ac024..555caafe4f04 100644
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

