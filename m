Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47F4A590313
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237588AbiHKQVP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237663AbiHKQUE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:20:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8973E9C50B;
        Thu, 11 Aug 2022 09:01:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41DB8B82166;
        Thu, 11 Aug 2022 16:01:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B46AC433D7;
        Thu, 11 Aug 2022 16:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660233715;
        bh=5FJntoiGAy4FKurYXXyOYgeeCYPluPQ7jBivwhv82Vk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IRPnX1+8fIBudYbPaa4sHaQj2GuLevfqGoNATnAc6FW5R8W5wvwfySvCDtU1cFYXO
         uWlxtYZB29DdJA3emN/7DDT13QmM4rIQ8aVfKZPzZWFJEFq6Weng5w8v769+oJdSqi
         oEKhlMduuaGXn3qzsmcrS2cC0EDOtC6/GHqgAy4dhfjF26PVlxKwDZR5u42Q1V6oI+
         PUyVDMRZW20iBcYQXQV0yemvpD99wUKQoLYdvy2MKuYbyMkM91KDI4dzeSzdIKwfls
         6uQp7pWNeQhIBsdxOWDAvxBxlRnQhHiqypTciceDwoPrYfSORFj15rZEm9p+7HBS3K
         T9inrvWR7yBfg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>, robdclark@gmail.com,
        quic_abhinavk@quicinc.com, dmitry.baryshkov@linaro.org,
        airlied@linux.ie, daniel@ffwll.ch, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 46/69] drm/msm/gem: Drop obj lock in msm_gem_free_object()
Date:   Thu, 11 Aug 2022 11:55:55 -0400
Message-Id: <20220811155632.1536867-46-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811155632.1536867-1-sashal@kernel.org>
References: <20220811155632.1536867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit a414fe3a2129b490e1e9b8ad66f0364f4f961887 ]

The only reason we grabbed the lock was to satisfy a bunch of places
that WARN_ON() if called without the lock held.  But this angers lockdep
which doesn't realize no one else can be holding the lock by the time we
end up destroying the object (and sees what would otherwise be a locking
inversion between reservation_ww_class_mutex and fs_reclaim).

Closes: https://gitlab.freedesktop.org/drm/msm/-/issues/14
Signed-off-by: Rob Clark <robdclark@chromium.org>
Patchwork: https://patchwork.freedesktop.org/patch/489364/
Link: https://lore.kernel.org/r/20220613205032.2652374-1-robdclark@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gem.c |  8 --------
 drivers/gpu/drm/msm/msm_gem.h | 14 +++++++++++++-
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_gem.c b/drivers/gpu/drm/msm/msm_gem.c
index d280dd64744d..0d84bdd4a0a8 100644
--- a/drivers/gpu/drm/msm/msm_gem.c
+++ b/drivers/gpu/drm/msm/msm_gem.c
@@ -1017,8 +1017,6 @@ void msm_gem_free_object(struct drm_gem_object *obj)
 	list_del(&msm_obj->mm_list);
 	mutex_unlock(&priv->mm_lock);
 
-	msm_gem_lock(obj);
-
 	/* object should not be on active list: */
 	GEM_WARN_ON(is_active(msm_obj));
 
@@ -1034,17 +1032,11 @@ void msm_gem_free_object(struct drm_gem_object *obj)
 
 		put_iova_vmas(obj);
 
-		/* dma_buf_detach() grabs resv lock, so we need to unlock
-		 * prior to drm_prime_gem_destroy
-		 */
-		msm_gem_unlock(obj);
-
 		drm_prime_gem_destroy(obj, msm_obj->sgt);
 	} else {
 		msm_gem_vunmap(obj);
 		put_pages(obj);
 		put_iova_vmas(obj);
-		msm_gem_unlock(obj);
 	}
 
 	drm_gem_object_release(obj);
diff --git a/drivers/gpu/drm/msm/msm_gem.h b/drivers/gpu/drm/msm/msm_gem.h
index e39a8e7ad843..fdd9b1a08009 100644
--- a/drivers/gpu/drm/msm/msm_gem.h
+++ b/drivers/gpu/drm/msm/msm_gem.h
@@ -193,7 +193,19 @@ msm_gem_unlock(struct drm_gem_object *obj)
 static inline bool
 msm_gem_is_locked(struct drm_gem_object *obj)
 {
-	return dma_resv_is_locked(obj->resv);
+	/*
+	 * Destroying the object is a special case.. msm_gem_free_object()
+	 * calls many things that WARN_ON if the obj lock is not held.  But
+	 * acquiring the obj lock in msm_gem_free_object() can cause a
+	 * locking order inversion between reservation_ww_class_mutex and
+	 * fs_reclaim.
+	 *
+	 * This deadlock is not actually possible, because no one should
+	 * be already holding the lock when msm_gem_free_object() is called.
+	 * Unfortunately lockdep is not aware of this detail.  So when the
+	 * refcount drops to zero, we pretend it is already locked.
+	 */
+	return dma_resv_is_locked(obj->resv) || (kref_read(&obj->refcount) == 0);
 }
 
 static inline bool is_active(struct msm_gem_object *msm_obj)
-- 
2.35.1

