Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC63F6AF1B7
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbjCGSqh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:46:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233195AbjCGSqI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:46:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7633FAF754
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:35:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84C9861545
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:34:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94757C433EF;
        Tue,  7 Mar 2023 18:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214077;
        bh=Q6SBzlYL5SFhP1H7+YX4H5Mv1kMILOFMYuxwqpqj9dw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WymIiVTRbTSAJlMkQ9sOY6ymGyxcfwZudsvdWFD5PxhcGUg5QLK6RMD4LF5bLoVWT
         PN7l0IIyQGesgi9g2bsje4o0LUuLouD/hGk7vkH2UGUE2LvEmVfibCNgjI6ki4FjNv
         YByjDFjitrvhnLVcfzQ40SgY0soA55RJDRxV+t58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jason Gunthorpe <jgg@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 714/885] RDMA/siw: Fix user page pinning accounting
Date:   Tue,  7 Mar 2023 18:00:48 +0100
Message-Id: <20230307170033.051347344@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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



