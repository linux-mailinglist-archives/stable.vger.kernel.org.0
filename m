Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9CFC6AEFC6
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232832AbjCGS0L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:26:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232723AbjCGSYj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:24:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 731A4A403A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:20:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 699046154D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818C5C433EF;
        Tue,  7 Mar 2023 18:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213209;
        bh=r57Ea5GmEX0qfEv3DD/ciDbNj4bijMfTV9RcavoDFvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AtFMbqlXwvXI/oXvUDGIKqYZmx+76jMv6ky9NAXi5wJrrMRK48lfMQMaqGtvLs/GS
         djwsifYkxJSqz0r72tYKnNZ+7PRxizTdiys9Sots7pn1f6yNYXXXoFayaPVXcrtb/8
         gG37CBS29ETmwTwXEoyKfQQzkXE8TSBcZQelrYas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miaoqian Lin <linmq006@gmail.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 407/885] RDMA/hns: Fix refcount leak in hns_roce_mmap
Date:   Tue,  7 Mar 2023 17:55:41 +0100
Message-Id: <20230307170020.095171797@linuxfoundation.org>
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

[ Upstream commit cf6a05c8494a8ae7fec8e5f1229b45ca5b4bcd30 ]

rdma_user_mmap_entry_get_pgoff() takes the reference.
Add missing rdma_user_mmap_entry_put() to release the reference.

Fixes: 0045e0d3f42e ("RDMA/hns: Support direct wqe of userspace")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Acked-by Haoyue Xu <xuhaoyue1@hisilicon.com>
Link: https://lore.kernel.org/r/20221223072900.802728-1-linmq006@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index 8ba68ac12388d..946ba1109e878 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -443,14 +443,15 @@ static int hns_roce_mmap(struct ib_ucontext *uctx, struct vm_area_struct *vma)
 		prot = pgprot_device(vma->vm_page_prot);
 		break;
 	default:
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
 	ret = rdma_user_mmap_io(uctx, vma, pfn, rdma_entry->npages * PAGE_SIZE,
 				prot, rdma_entry);
 
+out:
 	rdma_user_mmap_entry_put(rdma_entry);
-
 	return ret;
 }
 
-- 
2.39.2



