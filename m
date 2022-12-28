Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91FC4658011
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234536AbiL1QNX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:13:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234749AbiL1QMh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:12:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B0A61A814
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:11:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61C7EB8172A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:11:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1BFC4339E;
        Wed, 28 Dec 2022 16:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243864;
        bh=P0WVHBO8likUkQRHK5qupw0dPHZMWENdeFfIbGGBecE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kUrSl91a8h2jWGS5+mrRxMjKog7Iw260L2MGDg7w/+q4Lens/2dQYTwqT3X3TeuED
         6xZ+TAM2rIhaFIwC+9L7yYH6shXiBO8OpbDoSUcYMkJNBetkwvbIFjt/ea/2gBflWA
         +SDN8hdbn17uDbCdIaQGoq/l+hy5ImWi3leCdtFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Li Zhijian <lizhijian@fujitsu.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0601/1073] RDMA/rxe: Fix mr->map double free
Date:   Wed, 28 Dec 2022 15:36:29 +0100
Message-Id: <20221228144344.370808749@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Li Zhijian <lizhijian@fujitsu.com>

[ Upstream commit 7d984dac8f6bf4ebd3398af82b357e1d181ecaac ]

rxe_mr_cleanup() which tries to free mr->map again will be called when
rxe_mr_init_user() fails:

   CPU: 0 PID: 4917 Comm: rdma_flush_serv Kdump: loaded Not tainted 6.1.0-rc1-roce-flush+ #25
   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
   Call Trace:
    <TASK>
    dump_stack_lvl+0x45/0x5d
    panic+0x19e/0x349
    end_report.part.0+0x54/0x7c
    kasan_report.cold+0xa/0xf
    rxe_mr_cleanup+0x9d/0xf0 [rdma_rxe]
    __rxe_cleanup+0x10a/0x1e0 [rdma_rxe]
    rxe_reg_user_mr+0xb7/0xd0 [rdma_rxe]
    ib_uverbs_reg_mr+0x26a/0x480 [ib_uverbs]
    ib_uverbs_handler_UVERBS_METHOD_INVOKE_WRITE+0x1a2/0x250 [ib_uverbs]
    ib_uverbs_cmd_verbs+0x1397/0x15a0 [ib_uverbs]

This issue was firstly exposed since commit b18c7da63fcb ("RDMA/rxe: Fix
memory leak in error path code") and then we fixed it in commit
8ff5f5d9d8cf ("RDMA/rxe: Prevent double freeing rxe_map_set()") but this
fix was reverted together at last by commit 1e75550648da (Revert
"RDMA/rxe: Create duplicate mapping tables for FMRs")

Simply let rxe_mr_cleanup() always handle freeing the mr->map once it is
successfully allocated.

Fixes: 1e75550648da ("Revert "RDMA/rxe: Create duplicate mapping tables for FMRs"")
Link: https://lore.kernel.org/r/1667099073-2-1-git-send-email-lizhijian@fujitsu.com
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_mr.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
index af34f198e645..8cd6f1b165d5 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -99,6 +99,7 @@ static int rxe_mr_alloc(struct rxe_mr *mr, int num_buf)
 		kfree(mr->map[i]);
 
 	kfree(mr->map);
+	mr->map = NULL;
 err1:
 	return -ENOMEM;
 }
@@ -122,7 +123,6 @@ int rxe_mr_init_user(struct rxe_dev *rxe, u64 start, u64 length, u64 iova,
 	int			num_buf;
 	void			*vaddr;
 	int err;
-	int i;
 
 	umem = ib_umem_get(&rxe->ib_dev, start, length, access);
 	if (IS_ERR(umem)) {
@@ -163,9 +163,8 @@ int rxe_mr_init_user(struct rxe_dev *rxe, u64 start, u64 length, u64 iova,
 				pr_warn("%s: Unable to get virtual address\n",
 						__func__);
 				err = -ENOMEM;
-				goto err_cleanup_map;
+				goto err_release_umem;
 			}
-
 			buf->addr = (uintptr_t)vaddr;
 			buf->size = PAGE_SIZE;
 			num_buf++;
@@ -185,10 +184,6 @@ int rxe_mr_init_user(struct rxe_dev *rxe, u64 start, u64 length, u64 iova,
 
 	return 0;
 
-err_cleanup_map:
-	for (i = 0; i < mr->num_map; i++)
-		kfree(mr->map[i]);
-	kfree(mr->map);
 err_release_umem:
 	ib_umem_release(umem);
 err_out:
-- 
2.35.1



