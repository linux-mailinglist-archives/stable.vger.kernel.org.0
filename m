Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE6B657CDA
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233490AbiL1Pgq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:36:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233477AbiL1Pgp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:36:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D18CF15707
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:36:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D9F9B816D9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:36:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0227BC433EF;
        Wed, 28 Dec 2022 15:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241802;
        bh=qNLVgOCpTLN32DhSLdvueH8qqG8sjzSc6ai5ptu6FbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pUpICTZx+9WYxovBgh9naWUD/+fKLrXSCGlvDlZvAd/VLdJCOvcnHcSlXbnIWaqfG
         yWSXu3nPu/D1gfbdlu4pNM7EWrd0Hp9WOzRUQnLQMr0fwo6vNCtYiXfP/jYUnCyQHV
         e7wdHFc5+VZulbptArd6iyJjF6bTDmf0MnkA/EIM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Arnd Bergmann <arnd@arndb.de>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 524/731] RDMA/siw: Fix pointer cast warning
Date:   Wed, 28 Dec 2022 15:40:31 +0100
Message-Id: <20221228144311.736217560@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 5244ca88671a1981ceec09c5c8809f003e6a62aa ]

The previous build fix left a remaining issue in configurations with
64-bit dma_addr_t on 32-bit architectures:

drivers/infiniband/sw/siw/siw_qp_tx.c: In function 'siw_get_pblpage':
drivers/infiniband/sw/siw/siw_qp_tx.c:32:37: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
   32 |                 return virt_to_page((void *)paddr);
      |                                     ^

Use the same double cast here that the driver uses elsewhere to convert
between dma_addr_t and void*.

Fixes: 0d1b756acf60 ("RDMA/siw: Pass a pointer to virt_to_page()")
Link: https://lore.kernel.org/r/20221215170347.2612403-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Bernard Metzler <bmt@zurich.ibm.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_qp_tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/siw/siw_qp_tx.c b/drivers/infiniband/sw/siw/siw_qp_tx.c
index 7d47b521070b..05052b49107f 100644
--- a/drivers/infiniband/sw/siw/siw_qp_tx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
@@ -29,7 +29,7 @@ static struct page *siw_get_pblpage(struct siw_mem *mem, u64 addr, int *idx)
 	dma_addr_t paddr = siw_pbl_get_buffer(pbl, offset, NULL, idx);
 
 	if (paddr)
-		return virt_to_page((void *)paddr);
+		return virt_to_page((void *)(uintptr_t)paddr);
 
 	return NULL;
 }
-- 
2.35.1



