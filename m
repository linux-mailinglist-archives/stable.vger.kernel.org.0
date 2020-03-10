Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C819C180952
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 21:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbgCJUlW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 16:41:22 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:61523 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727320AbgCJUlV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 16:41:21 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from haswell.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 20514555-1500050 
        for multiple; Tue, 10 Mar 2020 20:40:47 +0000
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     stable@vger.kernel.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Imre Deak <imre.deak@intel.com>
Subject: [PATCH 3/5] drm/i915: Add a simple is-bound check before unbinding
Date:   Tue, 10 Mar 2020 20:40:44 +0000
Message-Id: <20200310204046.3995087-3-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310204046.3995087-1-chris@chris-wilson.co.uk>
References: <20200310204046.3995087-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Only acquire the various atomic references required to unbind the vma if
we do need to unbind the vma.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Acked-by: Imre Deak <imre.deak@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20191222210256.2066451-1-chris@chris-wilson.co.uk
(cherry picked from commit f5af1659d809e264d619e5f483fd8f47bced3b6a)
---
 drivers/gpu/drm/i915/i915_gem.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index f7c52b437f6a..998b67e3466e 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -130,6 +130,10 @@ int i915_gem_object_unbind(struct drm_i915_gem_object *obj,
 		struct i915_address_space *vm = vma->vm;
 		bool awake = false;
 
+		list_move_tail(&vma->obj_link, &still_in_list);
+		if (!i915_vma_is_bound(vma, I915_VMA_BIND_MASK))
+			continue;
+
 		ret = -EAGAIN;
 		if (!i915_vm_tryopen(vm))
 			break;
@@ -144,7 +148,6 @@ int i915_gem_object_unbind(struct drm_i915_gem_object *obj,
 			}
 		}
 
-		list_move_tail(&vma->obj_link, &still_in_list);
 		spin_unlock(&obj->vma.lock);
 
 		ret = -EBUSY;
-- 
2.25.1

