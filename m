Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E725D2B6579
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731152AbgKQNWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:22:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:56802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731161AbgKQNWb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:22:31 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E55AE2464E;
        Tue, 17 Nov 2020 13:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619350;
        bh=xjhdHuJ0Paq8gtsXiv5Yho0nQBVHBBt8VfS/npQfWSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wAEmdtSa8Qt7D6beT2+VWDoH2bpFcnG9cckUQQE24pZLtSJoKo+fM3XY7APH6yokn
         NFvAxFACcXs8oe9jLu+3xagP8Yh/UaHSV34rse+EPeXZXgMVoJ3/zk6jGVceaPqZDl
         +ni72nheZuYnlW/1qa3+JZkA0pISpXEvMtRe1HDw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Zbigniew=20Kempczy=C5=84ski?= 
        <zbigniew.kempczynski@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Matthew Auld <matthew.william.auld@gmail.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 001/151] drm/i915/gem: Flush coherency domains on first set-domain-ioctl
Date:   Tue, 17 Nov 2020 14:03:51 +0100
Message-Id: <20201117122121.459286658@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

[ Upstream commit 59dd13ad310793757e34afa489dd6fc8544fc3da ]

Avoid skipping what appears to be a no-op set-domain-ioctl if the cache
coherency state is inconsistent with our target domain. This also has
the utility of using the population of the pages to validate the backing
store.

The danger in skipping the first set-domain is leaving the cache
inconsistent and submitting stale data, or worse leaving the clean data
in the cache and not flushing it to the GPU. The impact should be small
as it requires a no-op set-domain as the very first ioctl in a
particular sequence not found in typical userspace.

Reported-by: Zbigniew Kempczyński <zbigniew.kempczynski@intel.com>
Fixes: 754a25442705 ("drm/i915: Skip object locking around a no-op set-domain ioctl")
Testcase: igt/gem_mmap_offset/blt-coherency
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Matthew Auld <matthew.william.auld@gmail.com>
Cc: Zbigniew Kempczyński <zbigniew.kempczynski@intel.com>
Cc: <stable@vger.kernel.org> # v5.2+
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201019203825.10966-1-chris@chris-wilson.co.uk
(cherry picked from commit 44c2200afcd59f441b43f27829b4003397cc495d)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_domain.c | 28 ++++++++++------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_domain.c b/drivers/gpu/drm/i915/gem/i915_gem_domain.c
index 9c58e8fac1d97..a4b48c9abeacd 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_domain.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_domain.c
@@ -605,21 +605,6 @@ i915_gem_set_domain_ioctl(struct drm_device *dev, void *data,
 	if (!obj)
 		return -ENOENT;
 
-	/*
-	 * Already in the desired write domain? Nothing for us to do!
-	 *
-	 * We apply a little bit of cunning here to catch a broader set of
-	 * no-ops. If obj->write_domain is set, we must be in the same
-	 * obj->read_domains, and only that domain. Therefore, if that
-	 * obj->write_domain matches the request read_domains, we are
-	 * already in the same read/write domain and can skip the operation,
-	 * without having to further check the requested write_domain.
-	 */
-	if (READ_ONCE(obj->write_domain) == read_domains) {
-		err = 0;
-		goto out;
-	}
-
 	/*
 	 * Try to flush the object off the GPU without holding the lock.
 	 * We will repeat the flush holding the lock in the normal manner
@@ -657,6 +642,19 @@ i915_gem_set_domain_ioctl(struct drm_device *dev, void *data,
 	if (err)
 		goto out;
 
+	/*
+	 * Already in the desired write domain? Nothing for us to do!
+	 *
+	 * We apply a little bit of cunning here to catch a broader set of
+	 * no-ops. If obj->write_domain is set, we must be in the same
+	 * obj->read_domains, and only that domain. Therefore, if that
+	 * obj->write_domain matches the request read_domains, we are
+	 * already in the same read/write domain and can skip the operation,
+	 * without having to further check the requested write_domain.
+	 */
+	if (READ_ONCE(obj->write_domain) == read_domains)
+		goto out_unpin;
+
 	err = i915_gem_object_lock_interruptible(obj);
 	if (err)
 		goto out_unpin;
-- 
2.27.0



