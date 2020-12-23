Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D30CE2E1663
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728421AbgLWCS7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:18:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:45448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728374AbgLWCS5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:18:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16515206EC;
        Wed, 23 Dec 2020 02:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689881;
        bh=BpPuUq+RGPXPBDI3Zh8K0rncYUYjHhqp3npWxWmQkM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tE4MKyHKkyHInSBUXXImGs48pADltKT+H8L5Idlz7g+yIuTpsmz4G/vlGylyVmUp6
         tej2Xq2ljnWFgNJ4cQ/oBvWSLLgXvXty2h1fLcATTKYhMxMVlNqGUkcV2sZ1x7hab+
         Hab424kOPNca6UyTYR1GuUOsCcEQziC9SqYk2S3VDo8lxAhONhpwN8DRYw1C+9q+C4
         Is41M7Zd566w88w92HEQYdqqU5pCZpW7+yCNXa7S5FjE4GqEHLHdBqfcENsnW/tNO9
         h6J4TygsF7H5rjm0DzJ/chyW6XhUS/yM4hF0eQHzgoUfiRpIt0Z/XdLyA6IF1TYSA7
         JwGbHzmjCUrzA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 071/217] RDMA/core: Postpone uobject cleanup on failure till FD close
Date:   Tue, 22 Dec 2020 21:14:00 -0500
Message-Id: <20201223021626.2790791-71-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021626.2790791-1-sashal@kernel.org>
References: <20201223021626.2790791-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit efa968ee20248ebf8da8542f21d5d2811e86392f ]

Remove the ib_is_destroyable_retryable() concept.

The idea here was to allow the drivers to forcibly clean the HW object
even if they otherwise didn't want to (eg because of usecnt). This was an
attempt to clean up in a world where drivers were not allowed to fail HW
object destruction.

Now that we are going back to allowing HW objects to fail destroy this
doesn't make sense. Instead if a uobject's HW object can't be destroyed it
is left on the uobject list and it is up to uverbs_destroy_ufile_hw() to
clean it. Multiple passes over the uobject list allow hidden dependencies
to be resolved. If that fails the HW driver is broken, throw a WARN_ON and
leak the HW object memory.

All the other tricky failure paths (eg on creation error unwind) have
already been updated to this new model.

Link: https://lore.kernel.org/r/20201104144556.3809085-2-leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/rdma_core.c           | 51 +++++++------------
 drivers/infiniband/core/uverbs_cmd.c          |  5 +-
 drivers/infiniband/core/uverbs_std_types.c    | 15 +++---
 .../core/uverbs_std_types_counters.c          |  5 +-
 drivers/infiniband/core/uverbs_std_types_cq.c |  4 +-
 drivers/infiniband/core/uverbs_std_types_dm.c |  6 +--
 .../core/uverbs_std_types_flow_action.c       |  6 +--
 drivers/infiniband/core/uverbs_std_types_qp.c |  4 +-
 .../infiniband/core/uverbs_std_types_srq.c    |  4 +-
 drivers/infiniband/core/uverbs_std_types_wq.c |  4 +-
 drivers/infiniband/hw/mlx5/devx.c             |  4 +-
 drivers/infiniband/hw/mlx5/fs.c               |  6 +--
 include/rdma/ib_verbs.h                       | 44 +---------------
 13 files changed, 45 insertions(+), 113 deletions(-)

diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
index ffe11b03724cf..61fa0a3f8e5ee 100644
--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -137,15 +137,9 @@ static int uverbs_destroy_uobject(struct ib_uobject *uobj,
 	} else if (uobj->object) {
 		ret = uobj->uapi_object->type_class->destroy_hw(uobj, reason,
 								attrs);
-		if (ret) {
-			if (ib_is_destroy_retryable(ret, reason, uobj))
-				return ret;
-
-			/* Nothing to be done, dangle the memory and move on */
-			WARN(true,
-			     "ib_uverbs: failed to remove uobject id %d, driver err=%d",
-			     uobj->id, ret);
-		}
+		if (ret)
+			/* Nothing to be done, wait till ucontext will clean it */
+			return ret;
 
 		uobj->object = NULL;
 	}
@@ -543,12 +537,7 @@ static int __must_check destroy_hw_idr_uobject(struct ib_uobject *uobj,
 			     struct uverbs_obj_idr_type, type);
 	int ret = idr_type->destroy_object(uobj, why, attrs);
 
-	/*
-	 * We can only fail gracefully if the user requested to destroy the
-	 * object or when a retry may be called upon an error.
-	 * In the rest of the cases, just remove whatever you can.
-	 */
-	if (ib_is_destroy_retryable(ret, why, uobj))
+	if (ret)
 		return ret;
 
 	if (why == RDMA_REMOVE_ABORT)
@@ -581,12 +570,8 @@ static int __must_check destroy_hw_fd_uobject(struct ib_uobject *uobj,
 {
 	const struct uverbs_obj_fd_type *fd_type = container_of(
 		uobj->uapi_object->type_attrs, struct uverbs_obj_fd_type, type);
-	int ret = fd_type->destroy_object(uobj, why);
 
-	if (ib_is_destroy_retryable(ret, why, uobj))
-		return ret;
-
-	return 0;
+	return fd_type->destroy_object(uobj, why);
 }
 
 static void remove_handle_fd_uobject(struct ib_uobject *uobj)
@@ -863,11 +848,18 @@ static int __uverbs_cleanup_ufile(struct ib_uverbs_file *ufile,
 		 * racing with a lookup_get.
 		 */
 		WARN_ON(uverbs_try_lock_object(obj, UVERBS_LOOKUP_WRITE));
+		if (reason == RDMA_REMOVE_DRIVER_FAILURE)
+			obj->object = NULL;
 		if (!uverbs_destroy_uobject(obj, reason, &attrs))
 			ret = 0;
 		else
 			atomic_set(&obj->usecnt, 0);
 	}
+
+	if (reason == RDMA_REMOVE_DRIVER_FAILURE) {
+		WARN_ON(!list_empty(&ufile->uobjects));
+		return 0;
+	}
 	return ret;
 }
 
@@ -889,21 +881,12 @@ void uverbs_destroy_ufile_hw(struct ib_uverbs_file *ufile,
 	if (!ufile->ucontext)
 		goto done;
 
-	ufile->ucontext->cleanup_retryable = true;
-	while (!list_empty(&ufile->uobjects))
-		if (__uverbs_cleanup_ufile(ufile, reason)) {
-			/*
-			 * No entry was cleaned-up successfully during this
-			 * iteration. It is a driver bug to fail destruction.
-			 */
-			WARN_ON(!list_empty(&ufile->uobjects));
-			break;
-		}
-
-	ufile->ucontext->cleanup_retryable = false;
-	if (!list_empty(&ufile->uobjects))
-		__uverbs_cleanup_ufile(ufile, reason);
+	while (!list_empty(&ufile->uobjects) &&
+	       !__uverbs_cleanup_ufile(ufile, reason)) {
+	}
 
+	if (WARN_ON(!list_empty(&ufile->uobjects)))
+		__uverbs_cleanup_ufile(ufile, RDMA_REMOVE_DRIVER_FAILURE);
 	ufile_destroy_ucontext(ufile, reason);
 
 done:
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 418d133a8fb08..c05be41f0199d 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -681,8 +681,7 @@ int ib_uverbs_dealloc_xrcd(struct ib_uobject *uobject, struct ib_xrcd *xrcd,
 		return 0;
 
 	ret = ib_dealloc_xrcd_user(xrcd, &attrs->driver_udata);
-
-	if (ib_is_destroy_retryable(ret, why, uobject)) {
+	if (ret) {
 		atomic_inc(&xrcd->usecnt);
 		return ret;
 	}
@@ -690,7 +689,7 @@ int ib_uverbs_dealloc_xrcd(struct ib_uobject *uobject, struct ib_xrcd *xrcd,
 	if (inode)
 		xrcd_table_delete(dev, inode);
 
-	return ret;
+	return 0;
 }
 
 static int ib_uverbs_reg_mr(struct uverbs_attr_bundle *attrs)
diff --git a/drivers/infiniband/core/uverbs_std_types.c b/drivers/infiniband/core/uverbs_std_types.c
index 0658101fca004..585042ead9392 100644
--- a/drivers/infiniband/core/uverbs_std_types.c
+++ b/drivers/infiniband/core/uverbs_std_types.c
@@ -88,7 +88,7 @@ static int uverbs_free_rwq_ind_tbl(struct ib_uobject *uobject,
 		return -EBUSY;
 
 	ret = rwq_ind_tbl->device->ops.destroy_rwq_ind_table(rwq_ind_tbl);
-	if (ib_is_destroy_retryable(ret, why, uobject))
+	if (ret)
 		return ret;
 
 	for (i = 0; i < table_size; i++)
@@ -96,7 +96,7 @@ static int uverbs_free_rwq_ind_tbl(struct ib_uobject *uobject,
 
 	kfree(rwq_ind_tbl);
 	kfree(ind_tbl);
-	return ret;
+	return 0;
 }
 
 static int uverbs_free_xrcd(struct ib_uobject *uobject,
@@ -108,9 +108,8 @@ static int uverbs_free_xrcd(struct ib_uobject *uobject,
 		container_of(uobject, struct ib_uxrcd_object, uobject);
 	int ret;
 
-	ret = ib_destroy_usecnt(&uxrcd->refcnt, why, uobject);
-	if (ret)
-		return ret;
+	if (atomic_read(&uxrcd->refcnt))
+		return -EBUSY;
 
 	mutex_lock(&attrs->ufile->device->xrcd_tree_mutex);
 	ret = ib_uverbs_dealloc_xrcd(uobject, xrcd, why, attrs);
@@ -124,11 +123,9 @@ static int uverbs_free_pd(struct ib_uobject *uobject,
 			  struct uverbs_attr_bundle *attrs)
 {
 	struct ib_pd *pd = uobject->object;
-	int ret;
 
-	ret = ib_destroy_usecnt(&pd->usecnt, why, uobject);
-	if (ret)
-		return ret;
+	if (atomic_read(&pd->usecnt))
+		return -EBUSY;
 
 	return ib_dealloc_pd_user(pd, &attrs->driver_udata);
 }
diff --git a/drivers/infiniband/core/uverbs_std_types_counters.c b/drivers/infiniband/core/uverbs_std_types_counters.c
index b3c6c066b6010..999da9c798668 100644
--- a/drivers/infiniband/core/uverbs_std_types_counters.c
+++ b/drivers/infiniband/core/uverbs_std_types_counters.c
@@ -42,9 +42,8 @@ static int uverbs_free_counters(struct ib_uobject *uobject,
 	struct ib_counters *counters = uobject->object;
 	int ret;
 
-	ret = ib_destroy_usecnt(&counters->usecnt, why, uobject);
-	if (ret)
-		return ret;
+	if (atomic_read(&counters->usecnt))
+		return -EBUSY;
 
 	ret = counters->device->ops.destroy_counters(counters);
 	if (ret)
diff --git a/drivers/infiniband/core/uverbs_std_types_cq.c b/drivers/infiniband/core/uverbs_std_types_cq.c
index 8dabd05988b23..370ad7c83f880 100644
--- a/drivers/infiniband/core/uverbs_std_types_cq.c
+++ b/drivers/infiniband/core/uverbs_std_types_cq.c
@@ -46,7 +46,7 @@ static int uverbs_free_cq(struct ib_uobject *uobject,
 	int ret;
 
 	ret = ib_destroy_cq_user(cq, &attrs->driver_udata);
-	if (ib_is_destroy_retryable(ret, why, uobject))
+	if (ret)
 		return ret;
 
 	ib_uverbs_release_ucq(
@@ -55,7 +55,7 @@ static int uverbs_free_cq(struct ib_uobject *uobject,
 					ev_queue) :
 			   NULL,
 		ucq);
-	return ret;
+	return 0;
 }
 
 static int UVERBS_HANDLER(UVERBS_METHOD_CQ_CREATE)(
diff --git a/drivers/infiniband/core/uverbs_std_types_dm.c b/drivers/infiniband/core/uverbs_std_types_dm.c
index d5a1de33c2c9a..98c522cf86d6f 100644
--- a/drivers/infiniband/core/uverbs_std_types_dm.c
+++ b/drivers/infiniband/core/uverbs_std_types_dm.c
@@ -39,11 +39,9 @@ static int uverbs_free_dm(struct ib_uobject *uobject,
 			  struct uverbs_attr_bundle *attrs)
 {
 	struct ib_dm *dm = uobject->object;
-	int ret;
 
-	ret = ib_destroy_usecnt(&dm->usecnt, why, uobject);
-	if (ret)
-		return ret;
+	if (atomic_read(&dm->usecnt))
+		return -EBUSY;
 
 	return dm->device->ops.dealloc_dm(dm, attrs);
 }
diff --git a/drivers/infiniband/core/uverbs_std_types_flow_action.c b/drivers/infiniband/core/uverbs_std_types_flow_action.c
index 459cf165b231e..d42ed7ff223e3 100644
--- a/drivers/infiniband/core/uverbs_std_types_flow_action.c
+++ b/drivers/infiniband/core/uverbs_std_types_flow_action.c
@@ -39,11 +39,9 @@ static int uverbs_free_flow_action(struct ib_uobject *uobject,
 				   struct uverbs_attr_bundle *attrs)
 {
 	struct ib_flow_action *action = uobject->object;
-	int ret;
 
-	ret = ib_destroy_usecnt(&action->usecnt, why, uobject);
-	if (ret)
-		return ret;
+	if (atomic_read(&action->usecnt))
+		return -EBUSY;
 
 	return action->device->ops.destroy_flow_action(action);
 }
diff --git a/drivers/infiniband/core/uverbs_std_types_qp.c b/drivers/infiniband/core/uverbs_std_types_qp.c
index 3bf8dcdfe7eb6..294cd29d5cede 100644
--- a/drivers/infiniband/core/uverbs_std_types_qp.c
+++ b/drivers/infiniband/core/uverbs_std_types_qp.c
@@ -32,14 +32,14 @@ static int uverbs_free_qp(struct ib_uobject *uobject,
 	}
 
 	ret = ib_destroy_qp_user(qp, &attrs->driver_udata);
-	if (ib_is_destroy_retryable(ret, why, uobject))
+	if (ret)
 		return ret;
 
 	if (uqp->uxrcd)
 		atomic_dec(&uqp->uxrcd->refcnt);
 
 	ib_uverbs_release_uevent(&uqp->uevent);
-	return ret;
+	return 0;
 }
 
 static int check_creation_flags(enum ib_qp_type qp_type,
diff --git a/drivers/infiniband/core/uverbs_std_types_srq.c b/drivers/infiniband/core/uverbs_std_types_srq.c
index c0ecbba26bf49..e5513f828bdc1 100644
--- a/drivers/infiniband/core/uverbs_std_types_srq.c
+++ b/drivers/infiniband/core/uverbs_std_types_srq.c
@@ -18,7 +18,7 @@ static int uverbs_free_srq(struct ib_uobject *uobject,
 	int ret;
 
 	ret = ib_destroy_srq_user(srq, &attrs->driver_udata);
-	if (ib_is_destroy_retryable(ret, why, uobject))
+	if (ret)
 		return ret;
 
 	if (srq_type == IB_SRQT_XRC) {
@@ -30,7 +30,7 @@ static int uverbs_free_srq(struct ib_uobject *uobject,
 	}
 
 	ib_uverbs_release_uevent(uevent);
-	return ret;
+	return 0;
 }
 
 static int UVERBS_HANDLER(UVERBS_METHOD_SRQ_CREATE)(
diff --git a/drivers/infiniband/core/uverbs_std_types_wq.c b/drivers/infiniband/core/uverbs_std_types_wq.c
index f2e6a625724a4..7ded8339346f3 100644
--- a/drivers/infiniband/core/uverbs_std_types_wq.c
+++ b/drivers/infiniband/core/uverbs_std_types_wq.c
@@ -17,11 +17,11 @@ static int uverbs_free_wq(struct ib_uobject *uobject,
 	int ret;
 
 	ret = ib_destroy_wq_user(wq, &attrs->driver_udata);
-	if (ib_is_destroy_retryable(ret, why, uobject))
+	if (ret)
 		return ret;
 
 	ib_uverbs_release_uevent(&uwq->uevent);
-	return ret;
+	return 0;
 }
 
 static int UVERBS_HANDLER(UVERBS_METHOD_WQ_CREATE)(
diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 9e3d8b8264980..cb9b263f6bf30 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -1311,7 +1311,7 @@ static int devx_obj_cleanup(struct ib_uobject *uobject,
 	else
 		ret = mlx5_cmd_exec(obj->ib_dev->mdev, obj->dinbox,
 				    obj->dinlen, out, sizeof(out));
-	if (ib_is_destroy_retryable(ret, why, uobject))
+	if (ret)
 		return ret;
 
 	devx_event_table = &dev->devx_event_table;
@@ -2187,7 +2187,7 @@ static int devx_umem_cleanup(struct ib_uobject *uobject,
 	int err;
 
 	err = mlx5_cmd_exec(obj->mdev, obj->dinbox, obj->dinlen, out, sizeof(out));
-	if (ib_is_destroy_retryable(err, why, uobject))
+	if (err)
 		return err;
 
 	ib_umem_release(obj->umem);
diff --git a/drivers/infiniband/hw/mlx5/fs.c b/drivers/infiniband/hw/mlx5/fs.c
index 492cfe063bcad..25da0b05b4e2f 100644
--- a/drivers/infiniband/hw/mlx5/fs.c
+++ b/drivers/infiniband/hw/mlx5/fs.c
@@ -2035,11 +2035,9 @@ static int flow_matcher_cleanup(struct ib_uobject *uobject,
 				struct uverbs_attr_bundle *attrs)
 {
 	struct mlx5_ib_flow_matcher *obj = uobject->object;
-	int ret;
 
-	ret = ib_destroy_usecnt(&obj->usecnt, why, uobject);
-	if (ret)
-		return ret;
+	if (atomic_read(&obj->usecnt))
+		return -EBUSY;
 
 	kfree(obj);
 	return 0;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 9bf6c319a670e..a767ca63f08d7 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1469,6 +1469,8 @@ enum rdma_remove_reason {
 	RDMA_REMOVE_DRIVER_REMOVE,
 	/* uobj is being cleaned-up before being committed */
 	RDMA_REMOVE_ABORT,
+	/* The driver failed to destroy the uobject and is being disconnected */
+	RDMA_REMOVE_DRIVER_FAILURE,
 };
 
 struct ib_rdmacg_object {
@@ -1481,8 +1483,6 @@ struct ib_ucontext {
 	struct ib_device       *device;
 	struct ib_uverbs_file  *ufile;
 
-	bool cleanup_retryable;
-
 	struct ib_rdmacg_object	cg_obj;
 	/*
 	 * Implementation details of the RDMA core, don't use in drivers:
@@ -2900,46 +2900,6 @@ static inline bool ib_is_udata_cleared(struct ib_udata *udata,
 	return ib_is_buffer_cleared(udata->inbuf + offset, len);
 }
 
-/**
- * ib_is_destroy_retryable - Check whether the uobject destruction
- * is retryable.
- * @ret: The initial destruction return code
- * @why: remove reason
- * @uobj: The uobject that is destroyed
- *
- * This function is a helper function that IB layer and low-level drivers
- * can use to consider whether the destruction of the given uobject is
- * retry-able.
- * It checks the original return code, if it wasn't success the destruction
- * is retryable according to the ucontext state (i.e. cleanup_retryable) and
- * the remove reason. (i.e. why).
- * Must be called with the object locked for destroy.
- */
-static inline bool ib_is_destroy_retryable(int ret, enum rdma_remove_reason why,
-					   struct ib_uobject *uobj)
-{
-	return ret && (why == RDMA_REMOVE_DESTROY ||
-		       uobj->context->cleanup_retryable);
-}
-
-/**
- * ib_destroy_usecnt - Called during destruction to check the usecnt
- * @usecnt: The usecnt atomic
- * @why: remove reason
- * @uobj: The uobject that is destroyed
- *
- * Non-zero usecnts will block destruction unless destruction was triggered by
- * a ucontext cleanup.
- */
-static inline int ib_destroy_usecnt(atomic_t *usecnt,
-				    enum rdma_remove_reason why,
-				    struct ib_uobject *uobj)
-{
-	if (atomic_read(usecnt) && ib_is_destroy_retryable(-EBUSY, why, uobj))
-		return -EBUSY;
-	return 0;
-}
-
 /**
  * ib_modify_qp_is_ok - Check that the supplied attribute mask
  * contains all required attributes and no attributes not allowed for
-- 
2.27.0

