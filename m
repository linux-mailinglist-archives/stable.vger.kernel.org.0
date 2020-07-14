Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B14BC21FB23
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 20:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731061AbgGNS7L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:59:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:57742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730680AbgGNS7K (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:59:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69B40229CA;
        Tue, 14 Jul 2020 18:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753150;
        bh=X/IC48WbTd3ilrpMEuVJHlFQ8+HOo4HRvoUoEGbs6D4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R91qpM+atylo6hSA3uxlsz0D3PsYPoWWDeTEfbgylFQW0BxMHjFyk+Woj1eatNCS7
         fdJtTHdTzKXeHf5xuKA7n6rPcx9NJJc5aOfMhptBbvTc8GsxOnx9KcWXRhQVdMa2y5
         YONkODbPklZFw8scbD/cgkoKiCcYKBt8n/1b0dAo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.7 139/166] drm/i915/gt: Pin the rings before marking active
Date:   Tue, 14 Jul 2020 20:45:04 +0200
Message-Id: <20200714184122.488639251@linuxfoundation.org>
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

commit 5a383d443b29a140094430f3ad1d02fa1acc2b80 upstream.

On eviction, we acquire the vm->mutex and then wait on the vma->active.
Therefore when binding and pinning the vma, we must follow the same
sequence, lock/pin the vma then mark it active. Otherwise, we mark the
vma as active, then wait for the vm->mutex, and meanwhile the evictor
holding the mutex waits upon us to complete our activity.

Fixes: 8ccfc20a7d56 ("drm/i915/gt: Mark ring->vma as active while pinned")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: <stable@vger.kernel.org> # v5.6+
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200706170138.8993-1-chris@chris-wilson.co.uk
(cherry picked from commit 8567774e87e23a57155e5102f81208729b992ae6)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gt/intel_context.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_context.c
+++ b/drivers/gpu/drm/i915/gt/intel_context.c
@@ -201,25 +201,25 @@ static int __ring_active(struct intel_ri
 {
 	int err;
 
-	err = i915_active_acquire(&ring->vma->active);
+	err = intel_ring_pin(ring);
 	if (err)
 		return err;
 
-	err = intel_ring_pin(ring);
+	err = i915_active_acquire(&ring->vma->active);
 	if (err)
-		goto err_active;
+		goto err_pin;
 
 	return 0;
 
-err_active:
-	i915_active_release(&ring->vma->active);
+err_pin:
+	intel_ring_unpin(ring);
 	return err;
 }
 
 static void __ring_retire(struct intel_ring *ring)
 {
-	intel_ring_unpin(ring);
 	i915_active_release(&ring->vma->active);
+	intel_ring_unpin(ring);
 }
 
 __i915_active_call


