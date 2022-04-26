Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77F2750F7B9
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245375AbiDZJIE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347560AbiDZJF5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:05:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49617D6;
        Tue, 26 Apr 2022 01:44:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74C5861344;
        Tue, 26 Apr 2022 08:44:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80739C385A0;
        Tue, 26 Apr 2022 08:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962697;
        bh=Fu+nhyd4Ftx9wFwzYrhYVHcQbXFxR67KTnPhaztFH/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T5krVWyUWsNw91QjtpY5qQ2B0EMhUES4YdvsSMNgbEGefMQxJArnsAFcazvjC0fhS
         0d2K8dFxkCgRy6vp4eC1GyRRmRuttasKYi2ifh94eC25VGAV7ya/6YIqsygYHexX96
         gkTtsFohREiNTW0WNNezQSDrFtf9LQ89sKBaI8go=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herve Codina <herve.codina@bootlin.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 019/146] dmaengine: dw-edma: Fix unaligned 64bit access
Date:   Tue, 26 Apr 2022 10:20:14 +0200
Message-Id: <20220426081750.605299587@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herve Codina <herve.codina@bootlin.com>

[ Upstream commit 8fc5133d6d4da65cad6b73152fc714ad3d7f91c1 ]

On some arch (ie aarch64 iMX8MM) unaligned PCIe accesses are
not allowed and lead to a kernel Oops.
  [ 1911.668835] Unable to handle kernel paging request at virtual address ffff80001bc00a8c
  [ 1911.668841] Mem abort info:
  [ 1911.668844]   ESR = 0x96000061
  [ 1911.668847]   EC = 0x25: DABT (current EL), IL = 32 bits
  [ 1911.668850]   SET = 0, FnV = 0
  [ 1911.668852]   EA = 0, S1PTW = 0
  [ 1911.668853] Data abort info:
  [ 1911.668855]   ISV = 0, ISS = 0x00000061
  [ 1911.668857]   CM = 0, WnR = 1
  [ 1911.668861] swapper pgtable: 4k pages, 48-bit VAs, pgdp=0000000040ff4000
  [ 1911.668864] [ffff80001bc00a8c] pgd=00000000bffff003, pud=00000000bfffe003, pmd=0068000018400705
  [ 1911.668872] Internal error: Oops: 96000061 [#1] PREEMPT SMP
  ...

The llp register present in the channel group registers is not
aligned on 64bit.

Fix unaligned 64bit access using two 32bit accesses

Fixes: 04e0a39fc10f ("dmaengine: dw-edma: Add writeq() and readq() for 64 bits architectures")
Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Link: https://lore.kernel.org/r/20220225120252.309404-1-herve.codina@bootlin.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw-edma/dw-edma-v0-core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/dw-edma/dw-edma-v0-core.c b/drivers/dma/dw-edma/dw-edma-v0-core.c
index 329fc2e57b70..b5b8f8181e77 100644
--- a/drivers/dma/dw-edma/dw-edma-v0-core.c
+++ b/drivers/dma/dw-edma/dw-edma-v0-core.c
@@ -415,8 +415,11 @@ void dw_edma_v0_core_start(struct dw_edma_chunk *chunk, bool first)
 			  (DW_EDMA_V0_CCS | DW_EDMA_V0_LLE));
 		/* Linked list */
 		#ifdef CONFIG_64BIT
-			SET_CH_64(dw, chan->dir, chan->id, llp.reg,
-				  chunk->ll_region.paddr);
+			/* llp is not aligned on 64bit -> keep 32bit accesses */
+			SET_CH_32(dw, chan->dir, chan->id, llp.lsb,
+				  lower_32_bits(chunk->ll_region.paddr));
+			SET_CH_32(dw, chan->dir, chan->id, llp.msb,
+				  upper_32_bits(chunk->ll_region.paddr));
 		#else /* CONFIG_64BIT */
 			SET_CH_32(dw, chan->dir, chan->id, llp.lsb,
 				  lower_32_bits(chunk->ll_region.paddr));
-- 
2.35.1



