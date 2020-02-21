Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03DC216716A
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 08:54:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730199AbgBUHyD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:54:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:52466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730197AbgBUHyC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:54:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D1B120801;
        Fri, 21 Feb 2020 07:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271641;
        bh=NkbwHRPJTd0n1wMIX/xDQuhB5Pvxqjc3hAvIS3hSP/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EkY0CNrKrPwT0/Xzbg4oEOhHZ/KWW3R/wvIo6/m04im40itEIKYWL4nbhj9RWbLQD
         38LGc5xI8vI4HqWT462tv+aUUPL30VGQvAzcVoERLiJnk62i26orTWeqm0RV7pJxbj
         BgfWzJefcBwUdeFzPX2AqT/6SfGEqhl4XiKlzGmc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Guralnik <michaelgur@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 244/399] RDMA/uverbs: Remove needs_kfree_rcu from uverbs_obj_type_class
Date:   Fri, 21 Feb 2020 08:39:29 +0100
Message-Id: <20200221072426.203167714@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 6c72773faf291..17bdbe38fdfa5 100644
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
 
@@ -920,7 +900,6 @@ const struct uverbs_obj_type_class uverbs_fd_class = {
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



