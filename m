Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44B1A6AF55C
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233862AbjCGTYa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:24:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233785AbjCGTYJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:24:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4758C2D8A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:09:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7923FB817C2
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:09:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7DCAC433D2;
        Tue,  7 Mar 2023 19:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678216197;
        bh=Q6SBzlYL5SFhP1H7+YX4H5Mv1kMILOFMYuxwqpqj9dw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BWL2MgJa9cBxMhJ1cYRpywyXcMgSS3tOvgTWxp/y3j8qrSCuqJGKfWqpSuYyOO7Mh
         TG58IzCuooDGsL7XJXhlOtTjykaHEk8rotAERHCyV35zV9Uo97UsslBwxFt1/xaqqa
         ELk8ErwfTWlezNmlSITzgToEBGMqHC8Wo7owqhWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jason Gunthorpe <jgg@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 465/567] RDMA/siw: Fix user page pinning accounting
Date:   Tue,  7 Mar 2023 18:03:21 +0100
Message-Id: <20230307165926.024373743@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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

From: Bernard Metzler <bmt@zurich.ibm.com>

[ Upstream commit 65a8fc30fb6722fc25adec6d7dd5b53b0bb85820 ]

To avoid racing with other user memory reservations, immediately
account full amount of pages to be pinned.

Fixes: 2251334dcac9 ("rdma/siw: application buffer management")
Reported-by: Jason Gunthorpe <jgg@nvidia.com>
Suggested-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Bernard Metzler <bmt@zurich.ibm.com>
Link: https://lore.kernel.org/r/20230202101000.402990-1-bmt@zurich.ibm.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_mem.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_mem.c b/drivers/infiniband/sw/siw/siw_mem.c
index 61c17db70d658..bf69566e2eb63 100644
--- a/drivers/infiniband/sw/siw/siw_mem.c
+++ b/drivers/infiniband/sw/siw/siw_mem.c
@@ -398,7 +398,7 @@ struct siw_umem *siw_umem_get(u64 start, u64 len, bool writable)
 
 	mlock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
 
-	if (num_pages + atomic64_read(&mm_s->pinned_vm) > mlock_limit) {
+	if (atomic64_add_return(num_pages, &mm_s->pinned_vm) > mlock_limit) {
 		rv = -ENOMEM;
 		goto out_sem_up;
 	}
@@ -411,18 +411,16 @@ struct siw_umem *siw_umem_get(u64 start, u64 len, bool writable)
 		goto out_sem_up;
 	}
 	for (i = 0; num_pages; i++) {
-		int got, nents = min_t(int, num_pages, PAGES_PER_CHUNK);
-
-		umem->page_chunk[i].plist =
+		int nents = min_t(int, num_pages, PAGES_PER_CHUNK);
+		struct page **plist =
 			kcalloc(nents, sizeof(struct page *), GFP_KERNEL);
-		if (!umem->page_chunk[i].plist) {
+
+		if (!plist) {
 			rv = -ENOMEM;
 			goto out_sem_up;
 		}
-		got = 0;
+		umem->page_chunk[i].plist = plist;
 		while (nents) {
-			struct page **plist = &umem->page_chunk[i].plist[got];
-
 			rv = pin_user_pages(first_page_va, nents,
 					    foll_flags | FOLL_LONGTERM,
 					    plist, NULL);
@@ -430,12 +428,11 @@ struct siw_umem *siw_umem_get(u64 start, u64 len, bool writable)
 				goto out_sem_up;
 
 			umem->num_pages += rv;
-			atomic64_add(rv, &mm_s->pinned_vm);
 			first_page_va += rv * PAGE_SIZE;
+			plist += rv;
 			nents -= rv;
-			got += rv;
+			num_pages -= rv;
 		}
-		num_pages -= got;
 	}
 out_sem_up:
 	mmap_read_unlock(mm_s);
@@ -443,6 +440,10 @@ struct siw_umem *siw_umem_get(u64 start, u64 len, bool writable)
 	if (rv > 0)
 		return umem;
 
+	/* Adjust accounting for pages not pinned */
+	if (num_pages)
+		atomic64_sub(num_pages, &mm_s->pinned_vm);
+
 	siw_umem_release(umem, false);
 
 	return ERR_PTR(rv);
-- 
2.39.2



