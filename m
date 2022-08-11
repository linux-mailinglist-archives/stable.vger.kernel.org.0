Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29128590220
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236212AbiHKQDi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237011AbiHKQDM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:03:12 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA182785A8;
        Thu, 11 Aug 2022 08:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7DD5FCE224D;
        Thu, 11 Aug 2022 15:49:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54DF8C433C1;
        Thu, 11 Aug 2022 15:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232980;
        bh=MAiaC/5yBcdIJnS4EwGQVV4M3oiWPn1vOI6l1WzdSog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e0tDevSPU9uLn9bgjHiRVdBc2lHd0lOrKuGrr319QuI5qwTumKDWqWH5eHov1JZW1
         7Q2atpu96PkMjLDA3UQj8eGc/2t6JSy1uFAYc9aj9dYOfeklrF9yksCyLzWJfJHXXT
         h+cH8XIvlhIRBqGflyxptyB85B/UGUoj9Y/uNwDbmlTETuKRi2I4MdQIwn6Mdfwx4/
         H2poT0lZYqAp5rUfYUzbsEnLovYhQHLIsnn3eiB35Y7LFn5tGp/PgYQrZBjnEtasV2
         BFEWuby7tjpfv+RNx6pYk6IRRkuoYnly/Crl89Br47elrDtmEvVHNizeFOTVs51oWM
         Zu05NZFf6bUhw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>, robdclark@gmail.com,
        quic_abhinavk@quicinc.com, dmitry.baryshkov@linaro.org,
        airlied@linux.ie, daniel@ffwll.ch, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.18 56/93] drm/msm/gem: Drop obj lock in msm_gem_free_object()
Date:   Thu, 11 Aug 2022 11:41:50 -0400
Message-Id: <20220811154237.1531313-56-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811154237.1531313-1-sashal@kernel.org>
References: <20220811154237.1531313-1-sashal@kernel.org>
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
index a4f61972667b..59d5f327047e 100644
--- a/drivers/gpu/drm/msm/msm_gem.c
+++ b/drivers/gpu/drm/msm/msm_gem.c
@@ -991,8 +991,6 @@ void msm_gem_free_object(struct drm_gem_object *obj)
 	list_del(&msm_obj->mm_list);
 	mutex_unlock(&priv->mm_lock);
 
-	msm_gem_lock(obj);
-
 	/* object should not be on active list: */
 	GEM_WARN_ON(is_active(msm_obj));
 
@@ -1008,17 +1006,11 @@ void msm_gem_free_object(struct drm_gem_object *obj)
 
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
index af612add5264..f62855134660 100644
--- a/drivers/gpu/drm/msm/msm_gem.h
+++ b/drivers/gpu/drm/msm/msm_gem.h
@@ -196,7 +196,19 @@ msm_gem_unlock(struct drm_gem_object *obj)
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

