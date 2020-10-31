Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56BD32A16F0
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727864AbgJaLme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:42:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:42126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727865AbgJaLmc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:42:32 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14514205F4;
        Sat, 31 Oct 2020 11:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144551;
        bh=hBXHsYZ6myK5Hnhs1bJ2kqbSzt3r4kUKTX4lwf4DFIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SuY1Pw6tugFlcoHoCa3LEttZqmsQ3HJTtUpZDtGRM+6N/KhHlQ7h+e4ArpV6zV55o
         UuyVSguxckXNO+5c6qypnvu2podq4K1EhZKJUOQXG2SBKQirBE/kYt+L6DWSWHQFrY
         Sap8SP5R7/8crZ8AiCGd49CH3x+gPAZtgDlqGWIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        CQ Tang <cq.tang@intel.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.8 62/70] drm/i915/gem: Serialise debugfs i915_gem_objects with ctx->mutex
Date:   Sat, 31 Oct 2020 12:36:34 +0100
Message-Id: <20201031113502.462944295@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113459.481803250@linuxfoundation.org>
References: <20201031113459.481803250@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 4fe9af8e881d946bf60790eeb37a7c4f96e28382 upstream.

Since the debugfs may peek into the GEM contexts as the corresponding
client/fd is being closed, we may try and follow a dangling pointer.
However, the context closure itself is serialised with the ctx->mutex,
so if we hold that mutex as we inspect the state coupled in the context,
we know the pointers within the context are stable and will remain valid
as we inspect their tables.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: CQ Tang <cq.tang@intel.com>
Cc: Daniel Vetter <daniel.vetter@intel.com>
Cc: stable@vger.kernel.org
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200723172119.17649-3-chris@chris-wilson.co.uk
(cherry picked from commit 102f5aa491f262c818e607fc4fee08a724a76c69)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_debugfs.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -323,6 +323,7 @@ static void print_context_stats(struct s
 		}
 		i915_gem_context_unlock_engines(ctx);
 
+		mutex_lock(&ctx->mutex);
 		if (!IS_ERR_OR_NULL(ctx->file_priv)) {
 			struct file_stats stats = {
 				.vm = rcu_access_pointer(ctx->vm),
@@ -343,6 +344,7 @@ static void print_context_stats(struct s
 
 			print_file_stats(m, name, stats);
 		}
+		mutex_unlock(&ctx->mutex);
 
 		spin_lock(&i915->gem.contexts.lock);
 		list_safe_reset_next(ctx, cn, link);


