Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEC286AEF87
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbjCGSYK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:24:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232759AbjCGSXo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:23:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA0199650
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:19:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A1326150F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:19:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 510D8C433EF;
        Tue,  7 Mar 2023 18:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213143;
        bh=uxHyPQ84Cc9KG+RiY8sKm4hYv1FDwi4PYhcSRY7yHv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sc+neFppjafX3d1YXR25zItYKynJnk4bbLVVI7H0wk6K63/MCMk2uPikJ8VijNNAg
         nC7WrrPezLl8AHs1qmnOk8Cu/iOm3tm5QrOoY/LpUDcvpFMFsjtIZfi1vKlOfq7Fxp
         XwXpVG5YlrxgsEWMXyQwwJsM2zKJVsICL19Jz/v8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miaoqian Lin <linmq006@gmail.com>,
        Cheng Xu <chengyou@linux.alibaba.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 405/885] RDMA/erdma: Fix refcount leak in erdma_mmap
Date:   Tue,  7 Mar 2023 17:55:39 +0100
Message-Id: <20230307170019.995340708@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit ee84146c05ad2316b9a7222d0ec4413e0bf30eeb ]

rdma_user_mmap_entry_get() take reference, we should release it when not
need anymore, add the missing rdma_user_mmap_entry_put() in the error
path to fix it.

Fixes: 155055771704 ("RDMA/erdma: Add verbs implementation")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20221220121139.1540564-1-linmq006@gmail.com
Acked-by: Cheng Xu <chengyou@linux.alibaba.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/erdma/erdma_verbs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.c b/drivers/infiniband/hw/erdma/erdma_verbs.c
index 62be98e2b9414..19c69ea1b0c0f 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.c
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
@@ -1089,12 +1089,14 @@ int erdma_mmap(struct ib_ucontext *ctx, struct vm_area_struct *vma)
 		prot = pgprot_device(vma->vm_page_prot);
 		break;
 	default:
-		return -EINVAL;
+		err = -EINVAL;
+		goto put_entry;
 	}
 
 	err = rdma_user_mmap_io(ctx, vma, PFN_DOWN(entry->address), PAGE_SIZE,
 				prot, rdma_entry);
 
+put_entry:
 	rdma_user_mmap_entry_put(rdma_entry);
 	return err;
 }
-- 
2.39.2



