Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4CEE5EA425
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238208AbiIZLlO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238213AbiIZLkr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:40:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB8754CAB;
        Mon, 26 Sep 2022 03:45:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A695760B4A;
        Mon, 26 Sep 2022 10:44:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA022C433D6;
        Mon, 26 Sep 2022 10:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189048;
        bh=7JnsuAXEvBceyJsJFdQODT+KhmgkDfvrhwdZoOUtVDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iUOOOqZhldmHl1SXzNHmLVUn2jhpB5MoiIqFM5nwDMu6KlWgbEkZTagGIEPHeEtIy
         EMrUeySG5A+weh2B9yTEu300cQUTaWMwS3QoGkVgB2Wf3HYWgsBxBbTQOtrOgX2Wg7
         2Lpx88awrJkuwTRXiz7Vf67bw/SSGZb/5BjQMVMM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>, stable@kernel.org
Subject: [PATCH 5.19 056/207] drm/i915/gem: Flush contexts on driver release
Date:   Mon, 26 Sep 2022 12:10:45 +0200
Message-Id: <20220926100809.117685854@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>

commit 5ce8f7444f8fbb5adee644590c0e4e1890ab004c upstream.

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
(cherry picked from commit 1cec34442408a77ba5396b19725fed2c398005c3)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/i915_gem.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1191,7 +1191,8 @@ void i915_gem_driver_release(struct drm_
 
 	intel_uc_cleanup_firmwares(&to_gt(dev_priv)->uc);
 
-	i915_gem_drain_freed_objects(dev_priv);
+	/* Flush any outstanding work, including i915_gem_context.release_work. */
+	i915_gem_drain_workqueue(dev_priv);
 
 	drm_WARN_ON(&dev_priv->drm, !list_empty(&dev_priv->gem.contexts.list));
 }


