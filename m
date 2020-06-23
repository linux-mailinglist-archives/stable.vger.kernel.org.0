Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 781992062E0
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391885AbgFWVIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:08:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:56496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391508AbgFWUea (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:34:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA0B62064B;
        Tue, 23 Jun 2020 20:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944470;
        bh=lVgjihfpqJXf5zAVwEVqRRYd2aypVWrRBu+KUG+YTIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N50N9j7eKcvsVCre7zMownFnTFGRE0j4xY1AUmzqvknC5KI6pyGalrpRzCLezZ0e8
         ZzZto6jxeflmsilrUcHS5+sfI5l/553yn2zeOIEBABQNKvqKL+VmkQ3uWe4hfk1h3J
         xsG5iov4JnGvf3Y958nOwhMsSY0UttTWDuGx6qHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Matthew Auld <matthew.auld@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Maciej Patelczyk <maciej.patelczyk@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 5.4 299/314] drm/i915/gem: Avoid iterating an empty list
Date:   Tue, 23 Jun 2020 21:58:14 +0200
Message-Id: <20200623195353.256372059@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 757a9395f33c51c4e6eff2c7c0fbd50226a58224 upstream.

Our __sgt_iter assumes that the scattergather list has at least one
element. But during construction we may fail in allocating the first
page, and so mark the first element as the terminator. This is
unexpected!

[22555.524752] RIP: 0010:shmem_get_pages+0x506/0x710 [i915]
[22555.524759] Code: 49 8b 2c 24 31 c0 66 89 44 24 40 48 85 ed 0f 84 62 01 00 00 4c 8b 75 00 8b 5d 08 44 8b 7d 0c 48 8b 0d 7e 34 07 e2 49 83 e6 fc <49> 8b 16 41 01 df 48 89 cf 48 89 d0 48 c1 e8 2d 48 85 c9 0f 84 c8
[22555.524765] RSP: 0018:ffffc9000053f9d0 EFLAGS: 00010246
[22555.524770] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff8881ffffa000
[22555.524774] RDX: fffffffffffffff4 RSI: ffffffffffffffff RDI: ffffffff821efe00
[22555.524778] RBP: ffff8881b099ab00 R08: 0000000000000000 R09: 00000000fffffff4
[22555.524782] R10: 0000000000000002 R11: 00000000ffec0a02 R12: ffff8881cd3c8d60
[22555.524786] R13: 00000000fffffff4 R14: 0000000000000000 R15: 0000000000000000
[22555.524790] FS:  00007f4fbeb9b9c0(0000) GS:ffff8881f8580000(0000) knlGS:0000000000000000
[22555.524795] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[22555.524799] CR2: 0000000000000000 CR3: 00000001ec7f0004 CR4: 00000000001606e0
[22555.524803] Call Trace:
[22555.524919]  __i915_gem_object_get_pages+0x4f/0x60 [i915]

Fixes: 85d1225ec066 ("drm/i915: Introduce & use new lightweight SGL iterators")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: <stable@vger.kernel.org> # v4.8+
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Reviewed-by: Maciej Patelczyk <maciej.patelczyk@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200522132706.5133-1-chris@chris-wilson.co.uk
(cherry picked from commit 957ad9a02be6faa87594c58ac09460cd3d190d0e)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
@@ -36,7 +36,6 @@ static int shmem_get_pages(struct drm_i9
 	unsigned long last_pfn = 0;	/* suppress gcc warning */
 	unsigned int max_segment = i915_sg_segment_size();
 	unsigned int sg_page_sizes;
-	struct pagevec pvec;
 	gfp_t noreclaim;
 	int ret;
 
@@ -188,13 +187,17 @@ err_sg:
 	sg_mark_end(sg);
 err_pages:
 	mapping_clear_unevictable(mapping);
-	pagevec_init(&pvec);
-	for_each_sgt_page(page, sgt_iter, st) {
-		if (!pagevec_add(&pvec, page))
+	if (sg != st->sgl) {
+		struct pagevec pvec;
+
+		pagevec_init(&pvec);
+		for_each_sgt_page(page, sgt_iter, st) {
+			if (!pagevec_add(&pvec, page))
+				check_release_pagevec(&pvec);
+		}
+		if (pagevec_count(&pvec))
 			check_release_pagevec(&pvec);
 	}
-	if (pagevec_count(&pvec))
-		check_release_pagevec(&pvec);
 	sg_free_table(st);
 	kfree(st);
 


