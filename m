Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB27F1EAD6C
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730902AbgFASJj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:09:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:56086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730898AbgFASJi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:09:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 102592077D;
        Mon,  1 Jun 2020 18:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034977;
        bh=8bbNrHkO2/ayD6jTxjv5QS86mmd4Vl6ttGz2CyoF+IE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0p+UMl4fXVFwo2f4nyNnJDzWw823Rcy9+oSF0pWNVJGCuUla6wqgPEFglfcVSF8Qa
         Ge3HF3Rv4NuiUYF/rx3kYjnjsJnH3q3zuy1vQUDVR1o9WMwD/ZCE9C7pZz6Hza2Awu
         WTOjZ2/ogDOsmi3LkpHoHe3ERWEILBhLH45pbeZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Gottlieb <maorg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 096/142] RDMA/core: Fix double destruction of uobject
Date:   Mon,  1 Jun 2020 19:54:14 +0200
Message-Id: <20200601174047.930420982@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174037.904070960@linuxfoundation.org>
References: <20200601174037.904070960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

[ Upstream commit c85f4abe66bea0b5db8d28d55da760c4fe0a0301 ]

Fix use after free when user user space request uobject concurrently for
the same object, within the RCU grace period.

In that case, remove_handle_idr_uobject() is called twice and we will have
an extra put on the uobject which cause use after free.  Fix it by leaving
the uobject write locked after it was removed from the idr.

Call to rdma_lookup_put_uobject with UVERBS_LOOKUP_DESTROY instead of
UVERBS_LOOKUP_WRITE will do the work.

  refcount_t: underflow; use-after-free.
  WARNING: CPU: 0 PID: 1381 at lib/refcount.c:28 refcount_warn_saturate+0xfe/0x1a0
  Kernel panic - not syncing: panic_on_warn set ...
  CPU: 0 PID: 1381 Comm: syz-executor.0 Not tainted 5.5.0-rc3 #8
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
  Call Trace:
   dump_stack+0x94/0xce
   panic+0x234/0x56f
   __warn+0x1cc/0x1e1
   report_bug+0x200/0x310
   fixup_bug.part.11+0x32/0x80
   do_error_trap+0xd3/0x100
   do_invalid_op+0x31/0x40
   invalid_op+0x1e/0x30
  RIP: 0010:refcount_warn_saturate+0xfe/0x1a0
  Code: 0f 0b eb 9b e8 23 f6 6d ff 80 3d 6c d4 19 03 00 75 8d e8 15 f6 6d ff 48 c7 c7 c0 02 55 bd c6 05 57 d4 19 03 01 e8 a2 58 49 ff <0f> 0b e9 6e ff ff ff e8 f6 f5 6d ff 80 3d 42 d4 19 03 00 0f 85 5c
  RSP: 0018:ffffc90002df7b98 EFLAGS: 00010282
  RAX: 0000000000000000 RBX: ffff88810f6a193c RCX: ffffffffba649009
  RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff88811b0283cc
  RBP: 0000000000000003 R08: ffffed10236060e3 R09: ffffed10236060e3
  R10: 0000000000000001 R11: ffffed10236060e2 R12: ffff88810f6a193c
  R13: ffffc90002df7d60 R14: 0000000000000000 R15: ffff888116ae6a08
   uverbs_uobject_put+0xfd/0x140
   __uobj_perform_destroy+0x3d/0x60
   ib_uverbs_close_xrcd+0x148/0x170
   ib_uverbs_write+0xaa5/0xdf0
   __vfs_write+0x7c/0x100
   vfs_write+0x168/0x4a0
   ksys_write+0xc8/0x200
   do_syscall_64+0x9c/0x390
   entry_SYSCALL_64_after_hwframe+0x44/0xa9
  RIP: 0033:0x465b49
  Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
  RSP: 002b:00007f759d122c58 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
  RAX: ffffffffffffffda RBX: 000000000073bfa8 RCX: 0000000000465b49
  RDX: 000000000000000c RSI: 0000000020000080 RDI: 0000000000000003
  RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000246 R12: 00007f759d1236bc
  R13: 00000000004ca27c R14: 000000000070de40 R15: 00000000ffffffff
  Dumping ftrace buffer:
     (ftrace buffer empty)
  Kernel Offset: 0x39400000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)

Fixes: 7452a3c745a2 ("IB/uverbs: Allow RDMA_REMOVE_DESTROY to work concurrently with disassociate")
Link: https://lore.kernel.org/r/20200527135534.482279-1-leon@kernel.org
Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/rdma_core.c | 20 +++++++++++++-------
 include/rdma/uverbs_std_types.h     |  2 +-
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
index 1c95fefa1f06..d0580eed3bcb 100644
--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -160,9 +160,9 @@ static int uverbs_destroy_uobject(struct ib_uobject *uobj,
 	uobj->context = NULL;
 
 	/*
-	 * For DESTROY the usecnt is held write locked, the caller is expected
-	 * to put it unlock and put the object when done with it. Only DESTROY
-	 * can remove the IDR handle.
+	 * For DESTROY the usecnt is not changed, the caller is expected to
+	 * manage it via uobj_put_destroy(). Only DESTROY can remove the IDR
+	 * handle.
 	 */
 	if (reason != RDMA_REMOVE_DESTROY)
 		atomic_set(&uobj->usecnt, 0);
@@ -194,7 +194,7 @@ static int uverbs_destroy_uobject(struct ib_uobject *uobj,
 /*
  * This calls uverbs_destroy_uobject() using the RDMA_REMOVE_DESTROY
  * sequence. It should only be used from command callbacks. On success the
- * caller must pair this with rdma_lookup_put_uobject(LOOKUP_WRITE). This
+ * caller must pair this with uobj_put_destroy(). This
  * version requires the caller to have already obtained an
  * LOOKUP_DESTROY uobject kref.
  */
@@ -205,6 +205,13 @@ int uobj_destroy(struct ib_uobject *uobj, struct uverbs_attr_bundle *attrs)
 
 	down_read(&ufile->hw_destroy_rwsem);
 
+	/*
+	 * Once the uobject is destroyed by RDMA_REMOVE_DESTROY then it is left
+	 * write locked as the callers put it back with UVERBS_LOOKUP_DESTROY.
+	 * This is because any other concurrent thread can still see the object
+	 * in the xarray due to RCU. Leaving it locked ensures nothing else will
+	 * touch it.
+	 */
 	ret = uverbs_try_lock_object(uobj, UVERBS_LOOKUP_WRITE);
 	if (ret)
 		goto out_unlock;
@@ -223,7 +230,7 @@ out_unlock:
 /*
  * uobj_get_destroy destroys the HW object and returns a handle to the uobj
  * with a NULL object pointer. The caller must pair this with
- * uverbs_put_destroy.
+ * uobj_put_destroy().
  */
 struct ib_uobject *__uobj_get_destroy(const struct uverbs_api_object *obj,
 				      u32 id, struct uverbs_attr_bundle *attrs)
@@ -257,8 +264,7 @@ int __uobj_perform_destroy(const struct uverbs_api_object *obj, u32 id,
 	uobj = __uobj_get_destroy(obj, id, attrs);
 	if (IS_ERR(uobj))
 		return PTR_ERR(uobj);
-
-	rdma_lookup_put_uobject(uobj, UVERBS_LOOKUP_WRITE);
+	uobj_put_destroy(uobj);
 	return 0;
 }
 
diff --git a/include/rdma/uverbs_std_types.h b/include/rdma/uverbs_std_types.h
index 05eabfd5d0d3..9f382e7d4579 100644
--- a/include/rdma/uverbs_std_types.h
+++ b/include/rdma/uverbs_std_types.h
@@ -88,7 +88,7 @@ struct ib_uobject *__uobj_get_destroy(const struct uverbs_api_object *obj,
 
 static inline void uobj_put_destroy(struct ib_uobject *uobj)
 {
-	rdma_lookup_put_uobject(uobj, UVERBS_LOOKUP_WRITE);
+	rdma_lookup_put_uobject(uobj, UVERBS_LOOKUP_DESTROY);
 }
 
 static inline void uobj_put_read(struct ib_uobject *uobj)
-- 
2.25.1



