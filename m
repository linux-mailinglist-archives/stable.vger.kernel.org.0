Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B13E15EC7E
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390997AbgBNR2D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:28:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:60016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390539AbgBNQIK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:08:10 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3953B2187F;
        Fri, 14 Feb 2020 16:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696489;
        bh=EfqTLV/Ja2CAc990v9LG2sf9f+XqMnZ58KAWfhoHIno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MB+nutMk7c4E/ws3m9Uj9brCfHhB44Gd8dRMz3QAF1lTNsy8GmewO5qYeY/yikcCT
         dfAC6o6h9OoGuJcPm3ymzTs9E+rgfqLmYmGUfdhiBloVFbjPOSdlQ5W0sf3P2qPAcG
         dluY0jA8zg+12lAj6uvu1/tpZQ0C9AuOv36RjhPQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        Michael Guralnik <michaelgur@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 295/459] RDMA/uverbs: Remove needs_kfree_rcu from uverbs_obj_type_class
Date:   Fri, 14 Feb 2020 10:59:05 -0500
Message-Id: <20200214160149.11681-295-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

[ Upstream commit 8bdf9dd984c18375d1090ddeb1792511f619c5c1 ]

After device disassociation the uapi_objects are destroyed and freed,
however it is still possible that core code can be holding a kref on the
uobject. When it finally goes to uverbs_uobject_free() via the kref_put()
it can trigger a use-after-free on the uapi_object.

Since needs_kfree_rcu is a micro optimization that only benefits file
uobjects, just get rid of it. There is no harm in using kfree_rcu even if
it isn't required, and the number of involved objects is small.

Link: https://lore.kernel.org/r/20200113143306.GA28717@ziepe.ca
Signed-off-by: Michael Guralnik <michaelgur@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/rdma_core.c | 23 +----------------------
 include/rdma/uverbs_types.h         |  1 -
 2 files changed, 1 insertion(+), 23 deletions(-)

diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
index ccf4d069c25c9..7dd9bd1e4d118 100644
--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -49,13 +49,7 @@ void uverbs_uobject_get(struct ib_uobject *uobject)
 
 static void uverbs_uobject_free(struct kref *ref)
 {
-	struct ib_uobject *uobj =
-		container_of(ref, struct ib_uobject, ref);
-
-	if (uobj->uapi_object->type_class->needs_kfree_rcu)
-		kfree_rcu(uobj, rcu);
-	else
-		kfree(uobj);
+	kfree_rcu(container_of(ref, struct ib_uobject, ref), rcu);
 }
 
 void uverbs_uobject_put(struct ib_uobject *uobject)
@@ -744,20 +738,6 @@ const struct uverbs_obj_type_class uverbs_idr_class = {
 	.lookup_put = lookup_put_idr_uobject,
 	.destroy_hw = destroy_hw_idr_uobject,
 	.remove_handle = remove_handle_idr_uobject,
-	/*
-	 * When we destroy an object, we first just lock it for WRITE and
-	 * actually DESTROY it in the finalize stage. So, the problematic
-	 * scenario is when we just started the finalize stage of the
-	 * destruction (nothing was executed yet). Now, the other thread
-	 * fetched the object for READ access, but it didn't lock it yet.
-	 * The DESTROY thread continues and starts destroying the object.
-	 * When the other thread continue - without the RCU, it would
-	 * access freed memory. However, the rcu_read_lock delays the free
-	 * until the rcu_read_lock of the READ operation quits. Since the
-	 * exclusive lock of the object is still taken by the DESTROY flow, the
-	 * READ operation will get -EBUSY and it'll just bail out.
-	 */
-	.needs_kfree_rcu = true,
 };
 EXPORT_SYMBOL(uverbs_idr_class);
 
@@ -919,7 +899,6 @@ const struct uverbs_obj_type_class uverbs_fd_class = {
 	.lookup_put = lookup_put_fd_uobject,
 	.destroy_hw = destroy_hw_fd_uobject,
 	.remove_handle = remove_handle_fd_uobject,
-	.needs_kfree_rcu = false,
 };
 EXPORT_SYMBOL(uverbs_fd_class);
 
diff --git a/include/rdma/uverbs_types.h b/include/rdma/uverbs_types.h
index d57a5ba00c743..0b0f5a5f392de 100644
--- a/include/rdma/uverbs_types.h
+++ b/include/rdma/uverbs_types.h
@@ -98,7 +98,6 @@ struct uverbs_obj_type_class {
 				       enum rdma_remove_reason why,
 				       struct uverbs_attr_bundle *attrs);
 	void (*remove_handle)(struct ib_uobject *uobj);
-	u8    needs_kfree_rcu;
 };
 
 struct uverbs_obj_type {
-- 
2.20.1

