Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0871F2E9A
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730124AbgFIAnL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:43:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:59628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728347AbgFHXMQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:12:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4D32208C7;
        Mon,  8 Jun 2020 23:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657935;
        bh=fte2bte/XDzfHp7/FRDNEq/bGVrJTW18C2qlNPGHEh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cY6LrFwYfKFe3lIK5ORGDXUFpdGQIqth1Ok8c/B8t8PpFbj95B9ESJLmy8FBZLGg1
         m+ahLIGkrlMYawTYBCwtFWdHt0cZwjbHhewXe1Lk3FHs7R0FHdHBejKkTdTl0lOiKD
         9iBJdPKtEfBVdZYIfqje0CXShpvyrlfibVqGgX64=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.6 003/606] drm/i915: Handle idling during i915_gem_evict_something busy loops
Date:   Mon,  8 Jun 2020 19:02:08 -0400
Message-Id: <20200608231211.3363633-3-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

[ Upstream commit 955da9d77435acac066139e9d7f7723ce7204a1d ]

i915_gem_evict_something() is charged with finding a slot within the GTT
that we may reuse. Since our goal is not to stall, we first look for a
slot that only overlaps idle vma. To this end, on the first pass we move
any active vma to the end of the search list. However, we only stopped
moving active vma after we see the first active vma twice. If during the
search, that first active vma completed, we would not notice and keep on
extending the search list.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/1746
Fixes: 2850748ef876 ("drm/i915: Pull i915_vma_pin under the vm->mutex")
Fixes: b1e3177bd1d8 ("drm/i915: Coordinate i915_active with its own mutex")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: <stable@vger.kernel.org> # v5.5+
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200509115217.26853-1-chris@chris-wilson.co.uk
(cherry picked from commit 73e28cc40bf00b5d168cb8f5cff1ae63e9097446)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/i915_gem_evict.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_evict.c b/drivers/gpu/drm/i915/i915_gem_evict.c
index 0697bedebeef..d99df9c33708 100644
--- a/drivers/gpu/drm/i915/i915_gem_evict.c
+++ b/drivers/gpu/drm/i915/i915_gem_evict.c
@@ -130,6 +130,13 @@ i915_gem_evict_something(struct i915_address_space *vm,
 	active = NULL;
 	INIT_LIST_HEAD(&eviction_list);
 	list_for_each_entry_safe(vma, next, &vm->bound_list, vm_link) {
+		if (vma == active) { /* now seen this vma twice */
+			if (flags & PIN_NONBLOCK)
+				break;
+
+			active = ERR_PTR(-EAGAIN);
+		}
+
 		/*
 		 * We keep this list in a rough least-recently scanned order
 		 * of active elements (inactive elements are cheap to reap).
@@ -145,21 +152,12 @@ i915_gem_evict_something(struct i915_address_space *vm,
 		 * To notice when we complete one full cycle, we record the
 		 * first active element seen, before moving it to the tail.
 		 */
-		if (i915_vma_is_active(vma)) {
-			if (vma == active) {
-				if (flags & PIN_NONBLOCK)
-					break;
-
-				active = ERR_PTR(-EAGAIN);
-			}
-
-			if (active != ERR_PTR(-EAGAIN)) {
-				if (!active)
-					active = vma;
+		if (active != ERR_PTR(-EAGAIN) && i915_vma_is_active(vma)) {
+			if (!active)
+				active = vma;
 
-				list_move_tail(&vma->vm_link, &vm->bound_list);
-				continue;
-			}
+			list_move_tail(&vma->vm_link, &vm->bound_list);
+			continue;
 		}
 
 		if (mark_free(&scan, vma, flags, &eviction_list))
-- 
2.25.1

