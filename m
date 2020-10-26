Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9AE29A08A
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443536AbgJ0AbK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:31:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:54062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409639AbgJZXwJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:52:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 609BE21655;
        Mon, 26 Oct 2020 23:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756328;
        bh=LdhIsQP3Wpe1HFkaDxMtIKxZKkDqsSdrPjQQjtv8TLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0iwr/5z9jJdMLNPgIFgiAonZlQTzRPomfI0UAV0UAeZCjxuT4CNJjbVCWtuVuFNjC
         zrcyH56iDvoZVyEb4ULBZMfNLvoKTbKiFmf/CxRsZcO7ivj1uj0kTDr7H6Pl6H52sI
         LBjP1LrPkAJdiIS9jZ/+k2/ZOgfyvIizmmzb1DK0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 002/132] RDMA/core: Change how failing destroy is handled during uobj abort
Date:   Mon, 26 Oct 2020 19:49:54 -0400
Message-Id: <20201026235205.1023962-2-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235205.1023962-1-sashal@kernel.org>
References: <20201026235205.1023962-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit f553246f7f794675da1794ae7ee07d1f35e561ae ]

Currently it triggers a WARN_ON and then goes ahead and destroys the
uobject anyhow, leaking any driver memory.

The only place that leaks driver memory should be during FD close() in
uverbs_destroy_ufile_hw().

Drivers are only allowed to fail destroy uobjects if they guarantee
destroy will eventually succeed. uverbs_destroy_ufile_hw() provides the
loop to give the driver that chance.

Link: https://lore.kernel.org/r/20200902081708.746631-1-leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/rdma_core.c | 30 ++++++++++++++---------------
 include/rdma/ib_verbs.h             |  5 -----
 2 files changed, 15 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
index 6d3ed7c6e19eb..3962da54ffbf4 100644
--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -130,17 +130,6 @@ static int uverbs_destroy_uobject(struct ib_uobject *uobj,
 	lockdep_assert_held(&ufile->hw_destroy_rwsem);
 	assert_uverbs_usecnt(uobj, UVERBS_LOOKUP_WRITE);
 
-	if (reason == RDMA_REMOVE_ABORT_HWOBJ) {
-		reason = RDMA_REMOVE_ABORT;
-		ret = uobj->uapi_object->type_class->destroy_hw(uobj, reason,
-								attrs);
-		/*
-		 * Drivers are not permitted to ignore RDMA_REMOVE_ABORT, see
-		 * ib_is_destroy_retryable, cleanup_retryable == false here.
-		 */
-		WARN_ON(ret);
-	}
-
 	if (reason == RDMA_REMOVE_ABORT) {
 		WARN_ON(!list_empty(&uobj->list));
 		WARN_ON(!uobj->context);
@@ -674,11 +663,22 @@ void rdma_alloc_abort_uobject(struct ib_uobject *uobj,
 			      bool hw_obj_valid)
 {
 	struct ib_uverbs_file *ufile = uobj->ufile;
+	int ret;
+
+	if (hw_obj_valid) {
+		ret = uobj->uapi_object->type_class->destroy_hw(
+			uobj, RDMA_REMOVE_ABORT, attrs);
+		/*
+		 * If the driver couldn't destroy the object then go ahead and
+		 * commit it. Leaking objects that can't be destroyed is only
+		 * done during FD close after the driver has a few more tries to
+		 * destroy it.
+		 */
+		if (WARN_ON(ret))
+			return rdma_alloc_commit_uobject(uobj, attrs);
+	}
 
-	uverbs_destroy_uobject(uobj,
-			       hw_obj_valid ? RDMA_REMOVE_ABORT_HWOBJ :
-					      RDMA_REMOVE_ABORT,
-			       attrs);
+	uverbs_destroy_uobject(uobj, RDMA_REMOVE_ABORT, attrs);
 
 	/* Matches the down_read in rdma_alloc_begin_uobject */
 	up_read(&ufile->hw_destroy_rwsem);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index ef2f3986c4933..f1a072cc9fc0e 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1489,11 +1489,6 @@ enum rdma_remove_reason {
 	RDMA_REMOVE_DRIVER_REMOVE,
 	/* uobj is being cleaned-up before being committed */
 	RDMA_REMOVE_ABORT,
-	/*
-	 * uobj has been fully created, with the uobj->object set, but is being
-	 * cleaned up before being comitted
-	 */
-	RDMA_REMOVE_ABORT_HWOBJ,
 };
 
 struct ib_rdmacg_object {
-- 
2.25.1

