Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6C2C292F8C
	for <lists+stable@lfdr.de>; Mon, 19 Oct 2020 22:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgJSUia (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Oct 2020 16:38:30 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:52686 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725904AbgJSUia (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Oct 2020 16:38:30 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 22760834-1500050 
        for multiple; Mon, 19 Oct 2020 21:38:26 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        =?UTF-8?q?Zbigniew=20Kempczy=C5=84ski?= 
        <zbigniew.kempczynski@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Matthew Auld <matthew.william.auld@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/i915/gem: Flush coherency domains on first set-domain-ioctl
Date:   Mon, 19 Oct 2020 21:38:25 +0100
Message-Id: <20201019203825.10966-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/gpu/drm/i915/gem/i915_gem_domain.c | 28 ++++++++++------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_domain.c b/drivers/gpu/drm/i915/gem/i915_gem_domain.c
index 7c90a63c273d..fcce6909f201 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_domain.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_domain.c
@@ -508,21 +508,6 @@ i915_gem_set_domain_ioctl(struct drm_device *dev, void *data,
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
@@ -560,6 +545,19 @@ i915_gem_set_domain_ioctl(struct drm_device *dev, void *data,
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
 	err = i915_gem_object_lock_interruptible(obj, NULL);
 	if (err)
 		goto out_unpin;
-- 
2.20.1

