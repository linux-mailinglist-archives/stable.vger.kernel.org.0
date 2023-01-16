Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4F4E66C47A
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbjAPPze (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:55:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbjAPPzK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:55:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA7822A0C
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:55:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 589B8B8105D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:55:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE422C433F1;
        Mon, 16 Jan 2023 15:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884506;
        bh=jaG+zHzcA6RDUPTWM3bKzkaP+3TsmEuIuLc2VeFcI8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TJJ43Wz6mK1y4VU+Rn0Ux9d0QW0LQX7zgo+dJvBBBIGIPV/WUeWkZ6CqFNQUw4QhD
         hXMTrBczGWGTlgxmNP7holKwpMJGNSiGOChMMpgcGUT6CLbGNsCOlI5AYRExXmUhxH
         EGeX8NNX2VFe45pV4cFpLLZRI1Hmxmxy0P7wwPBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rob Clark <robdclark@chromium.org>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.1 031/183] drm/i915: Fix potential context UAFs
Date:   Mon, 16 Jan 2023 16:49:14 +0100
Message-Id: <20230116154804.670690616@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Clark <robdclark@chromium.org>

commit afce71ff6daa9c0f852df0727fe32c6fb107f0fa upstream.

gem_context_register() makes the context visible to userspace, and which
point a separate thread can trigger the I915_GEM_CONTEXT_DESTROY ioctl.
So we need to ensure that nothing uses the ctx ptr after this.  And we
need to ensure that adding the ctx to the xarray is the *last* thing
that gem_context_register() does with the ctx pointer.

Signed-off-by: Rob Clark <robdclark@chromium.org>
Fixes: eb4dedae920a ("drm/i915/gem: Delay tracking the GEM context until it is registered")
Fixes: a4c1cdd34e2c ("drm/i915/gem: Delay context creation (v3)")
Fixes: 49bd54b390c2 ("drm/i915: Track all user contexts per client")
Cc: <stable@vger.kernel.org> # v5.10+
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
[tursulin: Stable and fixes tags add/tidy.]
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230103234948.1218393-1-robdclark@gmail.com
(cherry picked from commit bed4b455cf5374e68879be56971c1da563bcd90c)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_context.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_context.c
@@ -1688,6 +1688,10 @@ void i915_gem_init__contexts(struct drm_
 	init_contexts(&i915->gem.contexts);
 }
 
+/*
+ * Note that this implicitly consumes the ctx reference, by placing
+ * the ctx in the context_xa.
+ */
 static void gem_context_register(struct i915_gem_context *ctx,
 				 struct drm_i915_file_private *fpriv,
 				 u32 id)
@@ -1703,10 +1707,6 @@ static void gem_context_register(struct
 	snprintf(ctx->name, sizeof(ctx->name), "%s[%d]",
 		 current->comm, pid_nr(ctx->pid));
 
-	/* And finally expose ourselves to userspace via the idr */
-	old = xa_store(&fpriv->context_xa, id, ctx, GFP_KERNEL);
-	WARN_ON(old);
-
 	spin_lock(&ctx->client->ctx_lock);
 	list_add_tail_rcu(&ctx->client_link, &ctx->client->ctx_list);
 	spin_unlock(&ctx->client->ctx_lock);
@@ -1714,6 +1714,10 @@ static void gem_context_register(struct
 	spin_lock(&i915->gem.contexts.lock);
 	list_add_tail(&ctx->link, &i915->gem.contexts.list);
 	spin_unlock(&i915->gem.contexts.lock);
+
+	/* And finally expose ourselves to userspace via the idr */
+	old = xa_store(&fpriv->context_xa, id, ctx, GFP_KERNEL);
+	WARN_ON(old);
 }
 
 int i915_gem_context_open(struct drm_i915_private *i915,
@@ -2199,14 +2203,22 @@ finalize_create_context_locked(struct dr
 	if (IS_ERR(ctx))
 		return ctx;
 
+	/*
+	 * One for the xarray and one for the caller.  We need to grab
+	 * the reference *prior* to making the ctx visble to userspace
+	 * in gem_context_register(), as at any point after that
+	 * userspace can try to race us with another thread destroying
+	 * the context under our feet.
+	 */
+	i915_gem_context_get(ctx);
+
 	gem_context_register(ctx, file_priv, id);
 
 	old = xa_erase(&file_priv->proto_context_xa, id);
 	GEM_BUG_ON(old != pc);
 	proto_context_close(file_priv->dev_priv, pc);
 
-	/* One for the xarray and one for the caller */
-	return i915_gem_context_get(ctx);
+	return ctx;
 }
 
 struct i915_gem_context *


