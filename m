Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81EE12A5130
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:39:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730025AbgKCUi4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:38:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:49452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730038AbgKCUiz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:38:55 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36AF022226;
        Tue,  3 Nov 2020 20:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604435934;
        bh=HnUn3Vu3B5ulZ4jyj7plw1wAf8WC61eCS9sUDj0JMKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GwlbYUQtKIVgOFMqbjTy5KwQGt20Bv7NUkl8n2HsYOh8H5gdJyK3REcXX0EnABqA1
         wOyZoH6QyV8t1igkn2ujQgC4DqPA7tHI0reKg4l843rL6w5QJwH4paHj5lOS8VhfE3
         597Wyoe+5mh/38fbTFIWLxcWGxDyGUVt+s2txdQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 045/391] RDMA/core: Change how failing destroy is handled during uobj abort
Date:   Tue,  3 Nov 2020 21:31:36 +0100
Message-Id: <20201103203350.624333877@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 5b4f0efc4241f..ef7b786b8675c 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1463,11 +1463,6 @@ enum rdma_remove_reason {
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
2.27.0



