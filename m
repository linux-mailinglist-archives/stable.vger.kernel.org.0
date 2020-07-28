Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AECB230DC3
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 17:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730701AbgG1P2U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jul 2020 11:28:20 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:60118 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730637AbgG1P2T (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jul 2020 11:28:19 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 21959536-1500050 
        for multiple; Tue, 28 Jul 2020 16:28:12 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     thomas.hellstrom@intel.com, tvrtko.ursulin@intel.com,
        Chris Wilson <chris@chris-wilson.co.uk>,
        CQ Tang <cq.tang@intel.com>,
        Daniel Vetter <daniel.vetter@intel.com>, stable@vger.kernel.org
Subject: [PATCH 1/2] drm/i915/gem: Serialise debugfs i915_gem_objects with ctx->mutex
Date:   Tue, 28 Jul 2020 16:28:11 +0100
Message-Id: <20200728152812.26962-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/gpu/drm/i915/i915_debugfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
index 784219962193..ea469168cd44 100644
--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -326,6 +326,7 @@ static void print_context_stats(struct seq_file *m,
 		}
 		i915_gem_context_unlock_engines(ctx);
 
+		mutex_lock(&ctx->mutex);
 		if (!IS_ERR_OR_NULL(ctx->file_priv)) {
 			struct file_stats stats = {
 				.vm = rcu_access_pointer(ctx->vm),
@@ -346,6 +347,7 @@ static void print_context_stats(struct seq_file *m,
 
 			print_file_stats(m, name, stats);
 		}
+		mutex_unlock(&ctx->mutex);
 
 		spin_lock(&i915->gem.contexts.lock);
 		list_safe_reset_next(ctx, cn, link);
-- 
2.20.1

