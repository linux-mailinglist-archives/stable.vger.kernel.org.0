Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE66C167475
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388245AbgBUIVg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:21:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:32838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730936AbgBUIVd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:21:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EE02222C4;
        Fri, 21 Feb 2020 08:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582273292;
        bh=RM5bJZqD6fBIu+hMD74+5St8AFmtMUWd4KMgCZxZTrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jNEPBlM2bAwuI59kvNC5VKkD5DLcRUhiVpG3vm9zsRAaj1J6Ilb2Xs2p/0G2Q3ra1
         aYZH5NkFQmLfHt8urbSgo3MVppbZ1ga6FJYlDUjAk/UymWN4LPNWFNdB8XwKxrOA2N
         uBYprFHEYwt2sshAZu3tgFenb2fElWUcj+Uljd08=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Guralnik <michaelgur@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 115/191] RDMA/uverbs: Remove needs_kfree_rcu from uverbs_obj_type_class
Date:   Fri, 21 Feb 2020 08:41:28 +0100
Message-Id: <20200221072304.706440356@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072250.732482588@linuxfoundation.org>
References: <20200221072250.732482588@linuxfoundation.org>
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
index c4118bcd51035..c2c9bd72b350f 100644
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
@@ -753,20 +747,6 @@ const struct uverbs_obj_type_class uverbs_idr_class = {
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
 
@@ -954,7 +934,6 @@ const struct uverbs_obj_type_class uverbs_fd_class = {
 	.lookup_put = lookup_put_fd_uobject,
 	.destroy_hw = destroy_hw_fd_uobject,
 	.remove_handle = remove_handle_fd_uobject,
-	.needs_kfree_rcu = false,
 };
 EXPORT_SYMBOL(uverbs_fd_class);
 
diff --git a/include/rdma/uverbs_types.h b/include/rdma/uverbs_types.h
index acb1bfa3cc99a..f70155cc73979 100644
--- a/include/rdma/uverbs_types.h
+++ b/include/rdma/uverbs_types.h
@@ -97,7 +97,6 @@ struct uverbs_obj_type_class {
 	int __must_check (*destroy_hw)(struct ib_uobject *uobj,
 				       enum rdma_remove_reason why);
 	void (*remove_handle)(struct ib_uobject *uobj);
-	u8    needs_kfree_rcu;
 };
 
 struct uverbs_obj_type {
-- 
2.20.1



