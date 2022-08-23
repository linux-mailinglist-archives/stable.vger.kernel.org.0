Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39B6959D454
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241908AbiHWIKB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbiHWIJP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:09:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D24411EEEB;
        Tue, 23 Aug 2022 01:06:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E0776120C;
        Tue, 23 Aug 2022 08:06:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F4DC433C1;
        Tue, 23 Aug 2022 08:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661241963;
        bh=T6wbFxEZ0JNjVLGaAkLyy3eDIxIVf7DYXxIn42x7T0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sgLssvKhY+HyEc72wlpZxp/CJ2XScpyKQ7UrkbnIeWQmmC8yEyQgs1w1VzLzypuo8
         E+5MerUqOz7bVRSIYBv9GQgQBOIgG8tpkLb82wFbkBBUz6D8RyaLVwJPvXiYAm67/y
         wIW90yHkVPxmdWxSc2v0I6ZSRY7QRz/EhXoenZDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Nirmoy Das <nirmoy.das@intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.19 007/365] drm/i915/gem: Remove shared locking on freeing objects
Date:   Tue, 23 Aug 2022 09:58:28 +0200
Message-Id: <20220823080118.462276633@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 2826d447fbd60e6a05e53d5f918bceb8c04e315c upstream.

The obj->base.resv may be shared across many objects, some of which may
still be live and locked, preventing objects from being freed
indefintely. We could individualise the lock during the free, or rely on
a freed object having no contention and being able to immediately free
the pages it owns.

Fixes: be7612fd6665 ("drm/i915: Require object lock when freeing pages during destruction")
Fixes: 6cb12fbda1c2 ("drm/i915: Use trylock instead of blocking lock for __i915_gem_free_objects.")
Cc: <stable@vger.kernel.org> # v5.17+
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Tested-by: Nirmoy Das <nirmoy.das@intel.com>
Acked-by: Nirmoy Das <nirmoy.das@intel.com>
Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220726144844.18429-1-nirmoy.das@intel.com
(cherry picked from commit 7dd5c56531eb03696acdb17774721de5ef481c0b)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_object.c |   16 ++++------------
 drivers/gpu/drm/i915/i915_drv.h            |    4 ++--
 2 files changed, 6 insertions(+), 14 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_object.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_object.c
@@ -268,7 +268,7 @@ static void __i915_gem_object_free_mmaps
  */
 void __i915_gem_object_pages_fini(struct drm_i915_gem_object *obj)
 {
-	assert_object_held(obj);
+	assert_object_held_shared(obj);
 
 	if (!list_empty(&obj->vma.list)) {
 		struct i915_vma *vma;
@@ -331,15 +331,7 @@ static void __i915_gem_free_objects(stru
 			continue;
 		}
 
-		if (!i915_gem_object_trylock(obj, NULL)) {
-			/* busy, toss it back to the pile */
-			if (llist_add(&obj->freed, &i915->mm.free_list))
-				queue_delayed_work(i915->wq, &i915->mm.free_work, msecs_to_jiffies(10));
-			continue;
-		}
-
 		__i915_gem_object_pages_fini(obj);
-		i915_gem_object_unlock(obj);
 		__i915_gem_free_object(obj);
 
 		/* But keep the pointer alive for RCU-protected lookups */
@@ -359,7 +351,7 @@ void i915_gem_flush_free_objects(struct
 static void __i915_gem_free_work(struct work_struct *work)
 {
 	struct drm_i915_private *i915 =
-		container_of(work, struct drm_i915_private, mm.free_work.work);
+		container_of(work, struct drm_i915_private, mm.free_work);
 
 	i915_gem_flush_free_objects(i915);
 }
@@ -391,7 +383,7 @@ static void i915_gem_free_object(struct
 	 */
 
 	if (llist_add(&obj->freed, &i915->mm.free_list))
-		queue_delayed_work(i915->wq, &i915->mm.free_work, 0);
+		queue_work(i915->wq, &i915->mm.free_work);
 }
 
 void __i915_gem_object_flush_frontbuffer(struct drm_i915_gem_object *obj,
@@ -719,7 +711,7 @@ bool i915_gem_object_placement_possible(
 
 void i915_gem_init__objects(struct drm_i915_private *i915)
 {
-	INIT_DELAYED_WORK(&i915->mm.free_work, __i915_gem_free_work);
+	INIT_WORK(&i915->mm.free_work, __i915_gem_free_work);
 }
 
 void i915_objects_module_exit(void)
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -254,7 +254,7 @@ struct i915_gem_mm {
 	 * List of objects which are pending destruction.
 	 */
 	struct llist_head free_list;
-	struct delayed_work free_work;
+	struct work_struct free_work;
 	/**
 	 * Count of objects pending destructions. Used to skip needlessly
 	 * waiting on an RCU barrier if no objects are waiting to be freed.
@@ -1415,7 +1415,7 @@ static inline void i915_gem_drain_freed_
 	 * armed the work again.
 	 */
 	while (atomic_read(&i915->mm.free_count)) {
-		flush_delayed_work(&i915->mm.free_work);
+		flush_work(&i915->mm.free_work);
 		flush_delayed_work(&i915->bdev.wq);
 		rcu_barrier();
 	}


