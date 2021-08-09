Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D21683E4501
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 13:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235060AbhHILh0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 07:37:26 -0400
Received: from jsg.id.au ([193.114.144.202]:15947 "EHLO lechuck.jsg.id.au"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234991AbhHILh0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Aug 2021 07:37:26 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Aug 2021 07:37:25 EDT
Received: from largo.jsg.id.au (largo.jsg.id.au [192.168.1.43])
        by lechuck.jsg.id.au (OpenSMTPD) with ESMTP id 1a810b8b;
        Mon, 9 Aug 2021 21:30:23 +1000 (AEST)
Received: from largo.jsg.id.au (localhost [127.0.0.1])
        by largo.jsg.id.au (OpenSMTPD) with ESMTP id bd85246d;
        Mon, 9 Aug 2021 21:30:22 +1000 (AEST)
From:   Jonathan Gray <jsg@jsg.id.au>
To:     stable@vger.kernel.org
Cc:     jason@jlekstrand.net
Subject: [PATCH] drm/i915: avoid uninitialised var in eb_parse()
Date:   Mon,  9 Aug 2021 21:30:22 +1000
Message-Id: <20210809113022.49484-1-jsg@jsg.id.au>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The backport of c9d9fdbc108af8915d3f497bbdf3898bf8f321b8 to 5.10 in
6976f3cf34a1a8b791c048bbaa411ebfe48666b1 removed more than it should
have leading to 'batch' being used uninitialised.  The 5.13 backport and
the mainline commit did not remove the portion this patch adds back.

Signed-off-by: Jonathan Gray <jsg@jsg.id.au>
Fixes: 6976f3cf34a1 ("drm/i915: Revert "drm/i915/gem: Asynchronous cmdparser"")
Cc: <stable@vger.kernel.org> # 5.10
Cc: Jason Ekstrand <jason@jlekstrand.net>
---
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
index e5ac0936a587..0c083af5a59d 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -2351,6 +2351,12 @@ static int eb_parse(struct i915_execbuffer *eb)
 		eb->batch_flags |= I915_DISPATCH_SECURE;
 	}
 
+	batch = eb_dispatch_secure(eb, shadow);
+	if (IS_ERR(batch)) {
+		err = PTR_ERR(batch);
+		goto err_trampoline;
+	}
+
 	err = intel_engine_cmd_parser(eb->engine,
 				      eb->batch->vma,
 				      eb->batch_start_offset,
@@ -2377,6 +2383,7 @@ static int eb_parse(struct i915_execbuffer *eb)
 err_unpin_batch:
 	if (batch)
 		i915_vma_unpin(batch);
+err_trampoline:
 	if (trampoline)
 		i915_vma_unpin(trampoline);
 err_shadow:
-- 
2.32.0

