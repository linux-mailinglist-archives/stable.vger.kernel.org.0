Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF925B7242
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232617AbiIMOuQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234273AbiIMOsi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:48:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D4F53FA3F;
        Tue, 13 Sep 2022 07:25:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B75BA614B4;
        Tue, 13 Sep 2022 14:25:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD11BC433D6;
        Tue, 13 Sep 2022 14:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079106;
        bh=GMkAOvpeS2Q4DXNwpdWazj8uVwJMqhidTuecDSVaYYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mYqJUxN0g6hD+5HtSCZqz+eGIKzBThq+wP7BuTSJtbuttqaaaKNN4XH9ZwOWECv44
         gU3ZfEUlFDkMOVwD2RmJbMMLSl8DUqLD5oFSToE+PXsj7nL6MjUh2XTol8CxW/KRMc
         UpNfCS0p2Oy7BRyo/uyz5rIXMtiDgkik3eg/gTAE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-rdma@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 61/79] RDMA/siw: Pass a pointer to virt_to_page()
Date:   Tue, 13 Sep 2022 16:05:06 +0200
Message-Id: <20220913140353.160139198@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140350.291927556@linuxfoundation.org>
References: <20220913140350.291927556@linuxfoundation.org>
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

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 0d1b756acf60da5004c1e20ca4462f0c257bf6e1 ]

Functions that work on a pointer to virtual memory such as
virt_to_pfn() and users of that function such as
virt_to_page() are supposed to pass a pointer to virtual
memory, ideally a (void *) or other pointer. However since
many architectures implement virt_to_pfn() as a macro,
this function becomes polymorphic and accepts both a
(unsigned long) and a (void *).

If we instead implement a proper virt_to_pfn(void *addr)
function the following happens (occurred on arch/arm):

drivers/infiniband/sw/siw/siw_qp_tx.c:32:23: warning: incompatible
  integer to pointer conversion passing 'dma_addr_t' (aka 'unsigned int')
  to parameter of type 'const void *' [-Wint-conversion]
drivers/infiniband/sw/siw/siw_qp_tx.c:32:37: warning: passing argument
  1 of 'virt_to_pfn' makes pointer from integer without a cast
  [-Wint-conversion]
drivers/infiniband/sw/siw/siw_qp_tx.c:538:36: warning: incompatible
  integer to pointer conversion passing 'unsigned long long'
  to parameter of type 'const void *' [-Wint-conversion]

Fix this with an explicit cast. In one case where the SIW
SGE uses an unaligned u64 we need a double cast modifying the
virtual address (va) to a platform-specific uintptr_t before
casting to a (void *).

Fixes: b9be6f18cf9e ("rdma/siw: transmit path")
Cc: linux-rdma@vger.kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20220902215918.603761-1-linus.walleij@linaro.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_qp_tx.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_qp_tx.c b/drivers/infiniband/sw/siw/siw_qp_tx.c
index 7989c4043db4e..3c3ae5ef29428 100644
--- a/drivers/infiniband/sw/siw/siw_qp_tx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
@@ -29,7 +29,7 @@ static struct page *siw_get_pblpage(struct siw_mem *mem, u64 addr, int *idx)
 	dma_addr_t paddr = siw_pbl_get_buffer(pbl, offset, NULL, idx);
 
 	if (paddr)
-		return virt_to_page(paddr);
+		return virt_to_page((void *)paddr);
 
 	return NULL;
 }
@@ -523,13 +523,23 @@ static int siw_tx_hdt(struct siw_iwarp_tx *c_tx, struct socket *s)
 					kunmap(p);
 				}
 			} else {
-				u64 va = sge->laddr + sge_off;
+				/*
+				 * Cast to an uintptr_t to preserve all 64 bits
+				 * in sge->laddr.
+				 */
+				uintptr_t va = (uintptr_t)(sge->laddr + sge_off);
 
-				page_array[seg] = virt_to_page(va & PAGE_MASK);
+				/*
+				 * virt_to_page() takes a (void *) pointer
+				 * so cast to a (void *) meaning it will be 64
+				 * bits on a 64 bit platform and 32 bits on a
+				 * 32 bit platform.
+				 */
+				page_array[seg] = virt_to_page((void *)(va & PAGE_MASK));
 				if (do_crc)
 					crypto_shash_update(
 						c_tx->mpa_crc_hd,
-						(void *)(uintptr_t)va,
+						(void *)va,
 						plen);
 			}
 
-- 
2.35.1



