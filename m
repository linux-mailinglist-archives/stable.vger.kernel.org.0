Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 563F365D62F
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239690AbjADOmA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:42:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239548AbjADOlP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:41:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28FDA6416
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:41:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA08161746
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:41:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA57BC433F1;
        Wed,  4 Jan 2023 14:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672843274;
        bh=/s0Kc3hKeHharE/OUK92bpXc9nN7RCpXAgtVCOS5frg=;
        h=Subject:To:Cc:From:Date:From;
        b=jm5qF8F8AH2sJNWvLiZaG7iG6tYBLhPv81JyS/d0Zv0/HDmCdlL6V/IGcWU8lw3sV
         XdYbw6a8+uTqZZFK65+KgOCqi4iSmZJN4k805FPeFQ7TwGh1ikvR63ATNJNe1rng5+
         4eGmrCjVKHQ4Wymhj47Ft2MdTlY2mlARHW/ixy74=
Subject: FAILED: patch "[PATCH] drm/i915/gem: Flush contexts on driver release" failed to apply to 6.0-stable tree
To:     janusz.krzysztofik@linux.intel.com, andi.shyti@linux.intel.com,
        chris@chris-wilson.co.uk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:41:03 +0100
Message-ID: <167284326373248@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

1cec34442408 ("drm/i915/gem: Flush contexts on driver release")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1cec34442408a77ba5396b19725fed2c398005c3 Mon Sep 17 00:00:00 2001
From: Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
Date: Fri, 16 Sep 2022 11:24:02 +0200
Subject: [PATCH] drm/i915/gem: Flush contexts on driver release

Due to i915_perf assuming that it can use the i915_gem_context reference
to protect its i915->gem.contexts.list iteration, we need to defer removal
of the context from the list until last reference to the context is put.
However, there is a risk of triggering kernel warning on contexts list not
empty at driver release time if we deleagate that task to a worker for
i915_gem_context_release_work(), unless that work is flushed first.
Unfortunately, it is not flushed on driver release.  Fix it.

Instead of additionally calling flush_workqueue(), either directly or via
a new dedicated wrapper around it, replace last call to
i915_gem_drain_freed_objects() with existing i915_gem_drain_workqueue()
that performs both tasks.

Fixes: 75eefd82581f ("drm/i915: Release i915_gem_context from a worker")
Suggested-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Cc: stable@kernel.org # v5.16+
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220916092403.201355-2-janusz.krzysztofik@linux.intel.com

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index be7fede6cd6f..4539431a3c3e 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1214,7 +1214,8 @@ void i915_gem_driver_release(struct drm_i915_private *dev_priv)
 		intel_uc_cleanup_firmwares(&gt->uc);
 	}
 
-	i915_gem_drain_freed_objects(dev_priv);
+	/* Flush any outstanding work, including i915_gem_context.release_work. */
+	i915_gem_drain_workqueue(dev_priv);
 
 	drm_WARN_ON(&dev_priv->drm, !list_empty(&dev_priv->gem.contexts.list));
 }

