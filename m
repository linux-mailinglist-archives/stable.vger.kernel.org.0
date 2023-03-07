Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3A426AF49E
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233953AbjCGTR5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:17:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbjCGTRb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:17:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D781DC48AD
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:01:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71B0161531
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:01:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81FBBC433EF;
        Tue,  7 Mar 2023 19:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215685;
        bh=SqsO+dNSrha6bEz5DkV35TiHBZEQJowDcfNfTh1nQbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vfkx3wR2BGVEBjlidxKOEi4SvwYU/qWWW0CePhyRZWwMttu44KoLYmYNSkQGzQSwT
         v4kvrpLwy8YP3J0pMPWROPjtslCUX78CFS8cVruGc4whPQxZc3Ke6cQexXGQPYk43N
         yuzCIj8iDeSH6V12VN8sxSmynh8g32+jffX299zE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Brendan Cunningham <bcunningham@cornelisnetworks.com>,
        Patrick Kelsey <pat.kelsey@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 342/567] IB/hfi1: Fix math bugs in hfi1_can_pin_pages()
Date:   Tue,  7 Mar 2023 18:01:18 +0100
Message-Id: <20230307165920.698007578@linuxfoundation.org>
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

From: Patrick Kelsey <pat.kelsey@cornelisnetworks.com>

[ Upstream commit a0d198f79a8d033bd46605b779859193649f1f99 ]

Fix arithmetic and logic errors in hfi1_can_pin_pages() that  would allow
hfi1 to attempt pinning pages in cases where it should not because of
resource limits or lack of required capability.

Fixes: 2c97ce4f3c29 ("IB/hfi1: Add pin query function")
Link: https://lore.kernel.org/r/167656658362.2223096.10954762619837718026.stgit@awfm-02.cornelisnetworks.com
Signed-off-by: Brendan Cunningham <bcunningham@cornelisnetworks.com>
Signed-off-by: Patrick Kelsey <pat.kelsey@cornelisnetworks.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/user_pages.c | 61 ++++++++++++++++---------
 1 file changed, 40 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/user_pages.c b/drivers/infiniband/hw/hfi1/user_pages.c
index 7bce963e2ae69..36aaedc651456 100644
--- a/drivers/infiniband/hw/hfi1/user_pages.c
+++ b/drivers/infiniband/hw/hfi1/user_pages.c
@@ -29,33 +29,52 @@ MODULE_PARM_DESC(cache_size, "Send and receive side cache size limit (in MB)");
 bool hfi1_can_pin_pages(struct hfi1_devdata *dd, struct mm_struct *mm,
 			u32 nlocked, u32 npages)
 {
-	unsigned long ulimit = rlimit(RLIMIT_MEMLOCK), pinned, cache_limit,
-		size = (cache_size * (1UL << 20)); /* convert to bytes */
-	unsigned int usr_ctxts =
-			dd->num_rcv_contexts - dd->first_dyn_alloc_ctxt;
-	bool can_lock = capable(CAP_IPC_LOCK);
+	unsigned long ulimit_pages;
+	unsigned long cache_limit_pages;
+	unsigned int usr_ctxts;
 
 	/*
-	 * Calculate per-cache size. The calculation below uses only a quarter
-	 * of the available per-context limit. This leaves space for other
-	 * pinning. Should we worry about shared ctxts?
+	 * Perform RLIMIT_MEMLOCK based checks unless CAP_IPC_LOCK is present.
 	 */
-	cache_limit = (ulimit / usr_ctxts) / 4;
-
-	/* If ulimit isn't set to "unlimited" and is smaller than cache_size. */
-	if (ulimit != (-1UL) && size > cache_limit)
-		size = cache_limit;
-
-	/* Convert to number of pages */
-	size = DIV_ROUND_UP(size, PAGE_SIZE);
-
-	pinned = atomic64_read(&mm->pinned_vm);
+	if (!capable(CAP_IPC_LOCK)) {
+		ulimit_pages =
+			DIV_ROUND_DOWN_ULL(rlimit(RLIMIT_MEMLOCK), PAGE_SIZE);
+
+		/*
+		 * Pinning these pages would exceed this process's locked memory
+		 * limit.
+		 */
+		if (atomic64_read(&mm->pinned_vm) + npages > ulimit_pages)
+			return false;
+
+		/*
+		 * Only allow 1/4 of the user's RLIMIT_MEMLOCK to be used for HFI
+		 * caches.  This fraction is then equally distributed among all
+		 * existing user contexts.  Note that if RLIMIT_MEMLOCK is
+		 * 'unlimited' (-1), the value of this limit will be > 2^42 pages
+		 * (2^64 / 2^12 / 2^8 / 2^2).
+		 *
+		 * The effectiveness of this check may be reduced if I/O occurs on
+		 * some user contexts before all user contexts are created.  This
+		 * check assumes that this process is the only one using this
+		 * context (e.g., the corresponding fd was not passed to another
+		 * process for concurrent access) as there is no per-context,
+		 * per-process tracking of pinned pages.  It also assumes that each
+		 * user context has only one cache to limit.
+		 */
+		usr_ctxts = dd->num_rcv_contexts - dd->first_dyn_alloc_ctxt;
+		if (nlocked + npages > (ulimit_pages / usr_ctxts / 4))
+			return false;
+	}
 
-	/* First, check the absolute limit against all pinned pages. */
-	if (pinned + npages >= ulimit && !can_lock)
+	/*
+	 * Pinning these pages would exceed the size limit for this cache.
+	 */
+	cache_limit_pages = cache_size * (1024 * 1024) / PAGE_SIZE;
+	if (nlocked + npages > cache_limit_pages)
 		return false;
 
-	return ((nlocked + npages) <= size) || can_lock;
+	return true;
 }
 
 int hfi1_acquire_user_pages(struct mm_struct *mm, unsigned long vaddr, size_t npages,
-- 
2.39.2



