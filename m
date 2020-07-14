Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F33BF21FB2C
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730534AbgGNS72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:59:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731273AbgGNS72 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:59:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1903D22B2E;
        Tue, 14 Jul 2020 18:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753167;
        bh=Q0LQgVtH4CFpQOkg6bdkoLilcxloV5tF80mkP6KjlnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cWs8ePDxfrO+O0YV91ZYlv1Ym1fY3Uzj/R2G4+azwB2KLhOt3LM2o2HayXnkWsVj8
         9aNPrIHajWENs1W40Yw4994VMhx/kd6lg859NQUfU6J5Fjj5Zo5m+gkyeQho2VhLgL
         f4DRYBm1argIQiylTD26m7rYudqDqbrBrN+n3KS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andi Shyti <andi.shyti@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.7 145/166] drm/i915: Also drop vm.ref along error paths for vma construction
Date:   Tue, 14 Jul 2020 20:45:10 +0200
Message-Id: <20200714184122.768805571@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit cf1976b11372cac3b57fbae1831f66a4486355d3 upstream.

Not only do we need to release the vm.ref we acquired for the vma on the
duplicate insert branch, but also for the normal error paths, so roll
them all into one.

Reported-by: Andi Shyti <andi.shyti@intel.com>
Suggested-by: Andi Shyti <andi.shyti@intel.com>
Fixes: 2850748ef876 ("drm/i915: Pull i915_vma_pin under the vm->mutex")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Andi Shyti <andi.shyti@intel.com>
Cc: <stable@vger.kernel.org> # v5.5+
Reviewed-by: Andi Shyti <andi.shyti@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200702211015.29604-1-chris@chris-wilson.co.uk
(cherry picked from commit 03fca66b7a36b52da8915341eee388267f6d5b73)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_vma.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/i915/i915_vma.c
+++ b/drivers/gpu/drm/i915/i915_vma.c
@@ -104,6 +104,7 @@ vma_create(struct drm_i915_gem_object *o
 	   struct i915_address_space *vm,
 	   const struct i915_ggtt_view *view)
 {
+	struct i915_vma *pos = ERR_PTR(-E2BIG);
 	struct i915_vma *vma;
 	struct rb_node *rb, **p;
 
@@ -184,7 +185,6 @@ vma_create(struct drm_i915_gem_object *o
 	rb = NULL;
 	p = &obj->vma.tree.rb_node;
 	while (*p) {
-		struct i915_vma *pos;
 		long cmp;
 
 		rb = *p;
@@ -196,17 +196,12 @@ vma_create(struct drm_i915_gem_object *o
 		 * and dispose of ours.
 		 */
 		cmp = i915_vma_compare(pos, vm, view);
-		if (cmp == 0) {
-			spin_unlock(&obj->vma.lock);
-			i915_vm_put(vm);
-			i915_vma_free(vma);
-			return pos;
-		}
-
 		if (cmp < 0)
 			p = &rb->rb_right;
-		else
+		else if (cmp > 0)
 			p = &rb->rb_left;
+		else
+			goto err_unlock;
 	}
 	rb_link_node(&vma->obj_node, rb, p);
 	rb_insert_color(&vma->obj_node, &obj->vma.tree);
@@ -229,8 +224,9 @@ vma_create(struct drm_i915_gem_object *o
 err_unlock:
 	spin_unlock(&obj->vma.lock);
 err_vma:
+	i915_vm_put(vm);
 	i915_vma_free(vma);
-	return ERR_PTR(-E2BIG);
+	return pos;
 }
 
 static struct i915_vma *


