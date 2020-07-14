Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28BD521F64E
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 17:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbgGNPln (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 11:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbgGNPln (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jul 2020 11:41:43 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85264C061755
        for <stable@vger.kernel.org>; Tue, 14 Jul 2020 08:41:42 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id by13so17662843edb.11
        for <stable@vger.kernel.org>; Tue, 14 Jul 2020 08:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=basnieuwenhuizen-nl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fPc2Ss/8lpvcY2mROIad4+yzm0HXN/Mn6E5P50MZh+g=;
        b=At4gkRUItDv2bTs0xNUQM6klkWzkjBtcD5o50Y2SJAnx+zKx8I5H//b36vyamjzR/A
         RZzwpBJDvYsTOZz/Ai/RIUmNFK/bDWapx2VMd67/9AC5ekcX5ckzxokHGZ6ahFWqa6ye
         ctoxBjYJVT26gEdpOdAovQJpd0IAG9rgZbuNQ3nj7b1Lyw0PihmVFTpagYxhP9OxM1Tv
         9eMBXwsHA80WDrXTeDiTm12HJxzRet/p1RioqNg1ChFmKyP3MfQvWi2CQMD9J7hyHFqR
         /UpNGM5Fbv+sTgtTo9KLx9NzTjA+DMIAjGbmJfePiyTuSCBqSvjRLxH9aSq94Yi/25G6
         uFQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fPc2Ss/8lpvcY2mROIad4+yzm0HXN/Mn6E5P50MZh+g=;
        b=rk0bdcEIvHpY1IyePSz5SkEZkBIM+B8yB5ou8LgTS2wgyVTckg4FYHD2olDCRJbErK
         2QD+kXNM55n+eUP/YTyfCBgnj/rZAF1Wd4g7TkWzu/mwm7BDJR89mjm0FiT1qiUIMAlq
         z+eHgLGSy0XCALnHQWHL5RWsw8ZGSZKsHNPOBTsOVnsbc7NxPGVqesr7ZxI+8b0+VC3I
         YakDCV40T3DrkLlmGvQcgjBXHJof/WUJHP0eYf9uXH12zsPmotUJqET7qeVzZ4FnmhI+
         qUilUTvPXonPy0iIMKzpeaowfFqAvAdKTbJJ0TO2tW4N4M52xh3wXwTCd0JgPoRAVRyd
         Vesg==
X-Gm-Message-State: AOAM533C4v2gbHPkkPr7sT5/cAllqBY94QAFCOlM/ikd0aUZ2r1v9D6b
        FU0148gO8ZnponKC7juNUGM02PHPhHLFsg==
X-Google-Smtp-Source: ABdhPJwZObsEu8F5INUsvjQ8cz1MKDyRzRFpaBjGfKgiWcqbuSEzB2QfIMzWZgTdyKXSf+zp7gasYw==
X-Received: by 2002:a05:6402:559:: with SMTP id i25mr4994902edx.35.1594741301264;
        Tue, 14 Jul 2020 08:41:41 -0700 (PDT)
Received: from localhost.localdomain (31-10-158-161.cgn.dynamic.upc.ch. [31.10.158.161])
        by smtp.gmail.com with ESMTPSA id s7sm15200482edr.57.2020.07.14.08.41.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 08:41:40 -0700 (PDT)
From:   Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
To:     dri-devel@lists.freedesktop.org
Cc:     Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Gustavo Padovan <gustavo@padovan.org>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        stable@vger.kernel.org
Subject: [PATCH] dma-buf/sw_sync: Avoid recursive lock during fence signal.
Date:   Tue, 14 Jul 2020 17:41:02 +0200
Message-Id: <20200714154102.450826-1-bas@basnieuwenhuizen.nl>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Calltree:
  timeline_fence_release
  drm_sched_entity_wakeup
  dma_fence_signal_locked
  sync_timeline_signal
  sw_sync_ioctl

Releasing the reference to the fence in the fence signal callback
seems reasonable to me, so this patch avoids the locking issue in
sw_sync.

d3862e44daa7 ("dma-buf/sw-sync: Fix locking around sync_timeline lists")
fixed the recursive locking issue but caused an use-after-free. Later
d3c6dd1fb30d ("dma-buf/sw_sync: Synchronize signal vs syncpt free")
fixed the use-after-free but reintroduced the recursive locking issue.

In this attempt we avoid the use-after-free still because the release
function still always locks, and outside of the locking region in the
signal function we have properly refcounted references.

We furthermore also avoid the recurive lock by making sure that either:

1) We have a properly refcounted reference, preventing the signal from
   triggering the release function inside the locked region.
2) The refcount was already zero, and hence nobody will be able to trigger
   the release function from the signal function.

Fixes: d3c6dd1fb30d ("dma-buf/sw_sync: Synchronize signal vs syncpt free")
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Gustavo Padovan <gustavo@padovan.org>
Cc: Christian König <christian.koenig@amd.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
---
 drivers/dma-buf/sw_sync.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/dma-buf/sw_sync.c b/drivers/dma-buf/sw_sync.c
index 348b3a9170fa..30a482f75d56 100644
--- a/drivers/dma-buf/sw_sync.c
+++ b/drivers/dma-buf/sw_sync.c
@@ -192,9 +192,12 @@ static const struct dma_fence_ops timeline_fence_ops = {
 static void sync_timeline_signal(struct sync_timeline *obj, unsigned int inc)
 {
 	struct sync_pt *pt, *next;
+	struct list_head ref_list;
 
 	trace_sync_timeline(obj);
 
+	INIT_LIST_HEAD(&ref_list);
+
 	spin_lock_irq(&obj->lock);
 
 	obj->value += inc;
@@ -206,18 +209,27 @@ static void sync_timeline_signal(struct sync_timeline *obj, unsigned int inc)
 		list_del_init(&pt->link);
 		rb_erase(&pt->node, &obj->pt_tree);
 
-		/*
-		 * A signal callback may release the last reference to this
-		 * fence, causing it to be freed. That operation has to be
-		 * last to avoid a use after free inside this loop, and must
-		 * be after we remove the fence from the timeline in order to
-		 * prevent deadlocking on timeline->lock inside
-		 * timeline_fence_release().
-		 */
+		/* We need to take a reference to avoid a release during
+		 * signalling (which can cause a recursive lock of obj->lock).
+		 * If refcount was already zero, another thread is already taking
+		 * care of destructing the fence, so the signal cannot release
+		 * it again and we hence will not have the recursive lock. */
+		if (dma_fence_get_rcu(&pt->base))
+			list_add_tail(&pt->link, &ref_list);
+
 		dma_fence_signal_locked(&pt->base);
 	}
 
 	spin_unlock_irq(&obj->lock);
+
+	list_for_each_entry_safe(pt, next, &ref_list, link) {
+		/* This needs to be cleared before release, otherwise the
+		 * timeline_fence_release function gets confused about also
+		 * removing the fence from the pt_tree. */
+		list_del_init(&pt->link);
+
+		dma_fence_put(&pt->base);
+	}
 }
 
 /**
-- 
2.27.0

