Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18C8057EF48
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 15:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236259AbiGWNqe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 09:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233071AbiGWNqd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 09:46:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F058C2DC8
        for <stable@vger.kernel.org>; Sat, 23 Jul 2022 06:46:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A35FBB801B9
        for <stable@vger.kernel.org>; Sat, 23 Jul 2022 13:46:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A115C341C0;
        Sat, 23 Jul 2022 13:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658583989;
        bh=hDalBV5/kisL8CnZydeTu0twqVwu30M0ShpMl0tQ8Ng=;
        h=Subject:To:Cc:From:Date:From;
        b=0NkvaDbHt0VhVWmyoYWCaYgxHCCbAYtuU2+aLjD7D++C/u13M0pZqO2JlhP+AWMPF
         5GMdnluUwCHvUF4XNe54M9hpmWERADsVEKT9riwG/ew9NnwIMdL4Ha/kwl2aY4qBYl
         B65sXKWcy0nmsVLaXqM6ZfRn25YXHsQ3zaN/FoEw=
Subject: FAILED: patch "[PATCH] drm/amdgpu: Protect the amdgpu_bo_list list with a mutex v2" failed to apply to 5.18-stable tree
To:     luben.tuikov@amd.com, Alexander.Deucher@amd.com,
        Andrey.Grodzovsky@amd.com, Vitaly.Prosyak@amd.com,
        alexander.deucher@amd.com, christian.koenig@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 23 Jul 2022 15:46:18 +0200
Message-ID: <165858397812461@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.18-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 90af0ca047f3049c4b46e902f432ad6ef1e2ded6 Mon Sep 17 00:00:00 2001
From: Luben Tuikov <luben.tuikov@amd.com>
Date: Wed, 20 Jul 2022 15:04:18 -0400
Subject: [PATCH] drm/amdgpu: Protect the amdgpu_bo_list list with a mutex v2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Protect the struct amdgpu_bo_list with a mutex. This is used during command
submission in order to avoid buffer object corruption as recorded in
the link below.

v2 (chk): Keep the mutex looked for the whole CS to avoid using the
	  list from multiple CS threads at the same time.

Suggested-by: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <Alexander.Deucher@amd.com>
Cc: Andrey Grodzovsky <Andrey.Grodzovsky@amd.com>
Cc: Vitaly Prosyak <Vitaly.Prosyak@amd.com>
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2048
Signed-off-by: Luben Tuikov <luben.tuikov@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Tested-by: Luben Tuikov <luben.tuikov@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
index 714178f1b6c6..2168163aad2d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
@@ -40,7 +40,7 @@ static void amdgpu_bo_list_free_rcu(struct rcu_head *rcu)
 {
 	struct amdgpu_bo_list *list = container_of(rcu, struct amdgpu_bo_list,
 						   rhead);
-
+	mutex_destroy(&list->bo_list_mutex);
 	kvfree(list);
 }
 
@@ -136,6 +136,7 @@ int amdgpu_bo_list_create(struct amdgpu_device *adev, struct drm_file *filp,
 
 	trace_amdgpu_cs_bo_status(list->num_entries, total_size);
 
+	mutex_init(&list->bo_list_mutex);
 	*result = list;
 	return 0;
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.h
index 529d52a204cf..9caea1688fc3 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.h
@@ -47,6 +47,10 @@ struct amdgpu_bo_list {
 	struct amdgpu_bo *oa_obj;
 	unsigned first_userptr;
 	unsigned num_entries;
+
+	/* Protect access during command submission.
+	 */
+	struct mutex bo_list_mutex;
 };
 
 int amdgpu_bo_list_get(struct amdgpu_fpriv *fpriv, int id,
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index b28af04b0c3e..d8f1335bc68f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -519,6 +519,8 @@ static int amdgpu_cs_parser_bos(struct amdgpu_cs_parser *p,
 			return r;
 	}
 
+	mutex_lock(&p->bo_list->bo_list_mutex);
+
 	/* One for TTM and one for the CS job */
 	amdgpu_bo_list_for_each_entry(e, p->bo_list)
 		e->tv.num_shared = 2;
@@ -651,6 +653,7 @@ static int amdgpu_cs_parser_bos(struct amdgpu_cs_parser *p,
 			kvfree(e->user_pages);
 			e->user_pages = NULL;
 		}
+		mutex_unlock(&p->bo_list->bo_list_mutex);
 	}
 	return r;
 }
@@ -690,9 +693,11 @@ static void amdgpu_cs_parser_fini(struct amdgpu_cs_parser *parser, int error,
 {
 	unsigned i;
 
-	if (error && backoff)
+	if (error && backoff) {
 		ttm_eu_backoff_reservation(&parser->ticket,
 					   &parser->validated);
+		mutex_unlock(&parser->bo_list->bo_list_mutex);
+	}
 
 	for (i = 0; i < parser->num_post_deps; i++) {
 		drm_syncobj_put(parser->post_deps[i].syncobj);
@@ -832,12 +837,16 @@ static int amdgpu_cs_vm_handling(struct amdgpu_cs_parser *p)
 			continue;
 
 		r = amdgpu_vm_bo_update(adev, bo_va, false);
-		if (r)
+		if (r) {
+			mutex_unlock(&p->bo_list->bo_list_mutex);
 			return r;
+		}
 
 		r = amdgpu_sync_fence(&p->job->sync, bo_va->last_pt_update);
-		if (r)
+		if (r) {
+			mutex_unlock(&p->bo_list->bo_list_mutex);
 			return r;
+		}
 	}
 
 	r = amdgpu_vm_handle_moved(adev, vm);
@@ -1278,6 +1287,7 @@ static int amdgpu_cs_submit(struct amdgpu_cs_parser *p,
 
 	ttm_eu_fence_buffer_objects(&p->ticket, &p->validated, p->fence);
 	mutex_unlock(&p->adev->notifier_lock);
+	mutex_unlock(&p->bo_list->bo_list_mutex);
 
 	return 0;
 

