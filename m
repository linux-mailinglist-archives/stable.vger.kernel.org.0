Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82FE914B677
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbgA1OF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:05:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:53062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727717AbgA1OF0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:05:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D99ED2468E;
        Tue, 28 Jan 2020 14:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220325;
        bh=tAkXsxBhVJ/xUwlOx9WXZde1RHbuiUeq54zWGgXD+Yg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IZxSotJS06nB3azFT2j1ZjtdO5MT5JPdD44X6WwHoXIjifu5InVMa18dBGYvRCfEB
         ZmvwPu3kKJHpOEwQ3Ly11W90nBGJRoDWSjJtmhlorMm46QZh2s+SJPZt2aHehBNjhu
         cVmvTucDCmb2W366ASTjQKBQLrkncWQCd/i6Vb8o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Auld <matthew.auld@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 5.4 082/104] drm/i915/userptr: fix size calculation
Date:   Tue, 28 Jan 2020 15:00:43 +0100
Message-Id: <20200128135828.513738490@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Auld <matthew.auld@intel.com>

commit ecc4d2a52df65479de5e333a9065ed02202a400f upstream.

If we create a rather large userptr object(e.g 1ULL << 32) we might
shift past the type-width of num_pages: (int)num_pages << PAGE_SHIFT,
resulting in a totally bogus sg_table, which fortunately will eventually
manifest as:

gen8_ppgtt_insert_huge:463 GEM_BUG_ON(iter->sg->length < page_size)
kernel BUG at drivers/gpu/drm/i915/gt/gen8_ppgtt.c:463!

v2: more unsigned long
    prefer I915_GTT_PAGE_SIZE

Fixes: 5cc9ed4b9a7a ("drm/i915: Introduce mapping of user pages into video memory (userptr) ioctl")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Link: https://patchwork.freedesktop.org/patch/msgid/20200117132413.1170563-2-matthew.auld@intel.com
(cherry picked from commit 8e78871bc1e5efec22c950d3fd24ddb63d4ff28a)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gem/i915_gem_userptr.c |    9 +++++----
 drivers/gpu/drm/i915/i915_gem_gtt.c         |    2 ++
 2 files changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
@@ -427,7 +427,7 @@ struct get_pages_work {
 
 static struct sg_table *
 __i915_gem_userptr_alloc_pages(struct drm_i915_gem_object *obj,
-			       struct page **pvec, int num_pages)
+			       struct page **pvec, unsigned long num_pages)
 {
 	unsigned int max_segment = i915_sg_segment_size();
 	struct sg_table *st;
@@ -473,9 +473,10 @@ __i915_gem_userptr_get_pages_worker(stru
 {
 	struct get_pages_work *work = container_of(_work, typeof(*work), work);
 	struct drm_i915_gem_object *obj = work->obj;
-	const int npages = obj->base.size >> PAGE_SHIFT;
+	const unsigned long npages = obj->base.size >> PAGE_SHIFT;
+	unsigned long pinned;
 	struct page **pvec;
-	int pinned, ret;
+	int ret;
 
 	ret = -ENOMEM;
 	pinned = 0;
@@ -578,7 +579,7 @@ __i915_gem_userptr_get_pages_schedule(st
 
 static int i915_gem_userptr_get_pages(struct drm_i915_gem_object *obj)
 {
-	const int num_pages = obj->base.size >> PAGE_SHIFT;
+	const unsigned long num_pages = obj->base.size >> PAGE_SHIFT;
 	struct mm_struct *mm = obj->userptr.mm->mm;
 	struct page **pvec;
 	struct sg_table *pages;
--- a/drivers/gpu/drm/i915/i915_gem_gtt.c
+++ b/drivers/gpu/drm/i915/i915_gem_gtt.c
@@ -1178,6 +1178,7 @@ gen8_ppgtt_insert_pte(struct i915_ppgtt
 	pd = i915_pd_entry(pdp, gen8_pd_index(idx, 2));
 	vaddr = kmap_atomic_px(i915_pt_entry(pd, gen8_pd_index(idx, 1)));
 	do {
+		GEM_BUG_ON(iter->sg->length < I915_GTT_PAGE_SIZE);
 		vaddr[gen8_pd_index(idx, 0)] = pte_encode | iter->dma;
 
 		iter->dma += I915_GTT_PAGE_SIZE;
@@ -1657,6 +1658,7 @@ static void gen6_ppgtt_insert_entries(st
 
 	vaddr = kmap_atomic_px(i915_pt_entry(pd, act_pt));
 	do {
+		GEM_BUG_ON(iter.sg->length < I915_GTT_PAGE_SIZE);
 		vaddr[act_pte] = pte_encode | GEN6_PTE_ADDR_ENCODE(iter.dma);
 
 		iter.dma += I915_GTT_PAGE_SIZE;


