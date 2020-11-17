Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AFBD2B62B2
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731786AbgKQNai (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:30:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:39710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731758AbgKQNae (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:30:34 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B2FD20781;
        Tue, 17 Nov 2020 13:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619835;
        bh=FXhnEZUHqx+tUFAwV1GiZtp7xAjItAUvEr3Lkrfh9w8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j9emVM3IxVjC/h9YjemngtBl98UXLR4ddrOfo+jLvNZ89IBvc58pbgSvMZW6pXp3g
         YciQzluG+C9rISSpeoJe6Bq0JpDDjQnmMS42t9HIAlqgp+cFB1D/a5UTlV704+fuSl
         onVx8sgZAc+cFt3dtetg4PGXaUI36TX1fyGz8tKw=
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
Subject: [PATCH 5.9 002/255] drm/i915/gem: Flush coherency domains on first set-domain-ioctl
Date:   Tue, 17 Nov 2020 14:02:22 +0100
Message-Id: <20201117122139.047545665@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
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
index 7f76fc68f498a..ba8758011e297 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_domain.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_domain.c
@@ -484,21 +484,6 @@ i915_gem_set_domain_ioctl(struct drm_device *dev, void *data,
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
@@ -536,6 +521,19 @@ i915_gem_set_domain_ioctl(struct drm_device *dev, void *data,
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



