Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1FAF21FB7A
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730152AbgGNTBi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 15:01:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:58032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730811AbgGNS7Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:59:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77B7B22507;
        Tue, 14 Jul 2020 18:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753165;
        bh=jWQtq7pInRAYrl6IC7TSv07RwIeZV1rWARAg9nRFZDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PSoskA6eK49TZSXRVFkO7ZDT/Vf9x3KhVQ8sB1HtynhpvvLlpqf0Ed5zK0eLSSVIt
         IrpH6581HPc+zuguoWIO2sGhlFGn9tSgw9lLMRPE7P+/qykwTKx6oBZEuRaVWN82iK
         OdN/uBygD+TC9XP1IzN+VBMPTwoCZHiZr0for5qk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.7 144/166] drm/i915: Drop vm.ref for duplicate vma on construction
Date:   Tue, 14 Jul 2020 20:45:09 +0200
Message-Id: <20200714184122.720602973@linuxfoundation.org>
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

commit 42723673a193d5f8e30dba6ea9826d42262a502b upstream.

As we allow for parallel threads to create the same vma instance
concurrently, and we only filter out the duplicates upon reacquiring the
spinlock for the rbtree, we have to free the loser of the constructors'
race. When freeing, we should also drop any resource references acquired
for the redundant vma.

Fixes: 2850748ef876 ("drm/i915: Pull i915_vma_pin under the vm->mutex")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: <stable@vger.kernel.org> # v5.5+
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200702083225.20044-1-chris@chris-wilson.co.uk
(cherry picked from commit 2377427cdd2b7514eb4c40241cf5c4dec63c1bec)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_vma.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/i915/i915_vma.c
+++ b/drivers/gpu/drm/i915/i915_vma.c
@@ -198,6 +198,7 @@ vma_create(struct drm_i915_gem_object *o
 		cmp = i915_vma_compare(pos, vm, view);
 		if (cmp == 0) {
 			spin_unlock(&obj->vma.lock);
+			i915_vm_put(vm);
 			i915_vma_free(vma);
 			return pos;
 		}


