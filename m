Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75B6765D609
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239587AbjADOjZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:39:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239445AbjADOjQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:39:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A660F6416
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:39:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4362661748
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:39:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50518C433F0;
        Wed,  4 Jan 2023 14:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672843154;
        bh=QfJpQJm0WKUqCu1hGsMhHizxdPUgT5WFM+gs74pp7gQ=;
        h=Subject:To:Cc:From:Date:From;
        b=jhP4XCqm9r2f9gvxzJ1U/g5vtLsOrWzu3Rp8vm48TXplQziQmC+MkuTF8SzJXpmVE
         AyxZjlywS0cUBKvvjdqx+GrXytCMrXklwz6ZbWH8k0Qj8QKTHq9QpR14ed9NNYH3Xy
         NRmiikd1ceN9fPhcWDNTBLWs+haSgSvy0BlJPwrM=
Subject: FAILED: patch "[PATCH] drm/i915: Fix negative value passed as remaining time" failed to apply to 6.0-stable tree
To:     janusz.krzysztofik@linux.intel.com, andrzej.hajda@intel.com,
        rodrigo.vivi@intel.com, tvrtko.ursulin@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:39:06 +0100
Message-ID: <167284314622566@kroah.com>
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

6a5347293992 ("drm/i915: Fix negative value passed as remaining time")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6a5347293992e0412bc748dae11228a7081393fa Mon Sep 17 00:00:00 2001
From: Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
Date: Mon, 21 Nov 2022 15:56:54 +0100
Subject: [PATCH] drm/i915: Fix negative value passed as remaining time

Commit b97060a99b01 ("drm/i915/guc: Update intel_gt_wait_for_idle to work
with GuC") extended the API of intel_gt_retire_requests_timeout() with an
extra argument 'remaining_timeout', intended for passing back unconsumed
portion of requested timeout when 0 (success) is returned.  However, when
request retirement happens to succeed despite an error returned by a call
to dma_fence_wait_timeout(), that error code (a negative value) is passed
back instead of remaining time.  If we then pass that negative value
forward as requested timeout to intel_uc_wait_for_idle(), an explicit BUG
will be triggered.

If request retirement succeeds but an error code is passed back via
remaininig_timeout, we may have no clue on how much of the initial timeout
might have been left for spending it on waiting for GuC to become idle.
OTOH, since all pending requests have been successfully retired, that
error code has been already ignored by intel_gt_retire_requests_timeout(),
then we shouldn't fail.

Assume no more time has been left on error and pass 0 timeout value to
intel_uc_wait_for_idle() to give it a chance to return success if GuC is
already idle.

v3: Don't fail on any error passed back via remaining_timeout.

v2: Fix the issue on the caller side, not the provider.

Fixes: b97060a99b01 ("drm/i915/guc: Update intel_gt_wait_for_idle to work with GuC")
Signed-off-by: Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
Cc: stable@vger.kernel.org # v5.15+
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221121145655.75141-2-janusz.krzysztofik@linux.intel.com
(cherry picked from commit f235dbd5b768e238d365fd05d92de5a32abc1c1f)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_gt.c b/drivers/gpu/drm/i915/gt/intel_gt.c
index b5ad9caa5537..7ef0edb2e37c 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt.c
@@ -677,8 +677,13 @@ int intel_gt_wait_for_idle(struct intel_gt *gt, long timeout)
 			return -EINTR;
 	}
 
-	return timeout ? timeout : intel_uc_wait_for_idle(&gt->uc,
-							  remaining_timeout);
+	if (timeout)
+		return timeout;
+
+	if (remaining_timeout < 0)
+		remaining_timeout = 0;
+
+	return intel_uc_wait_for_idle(&gt->uc, remaining_timeout);
 }
 
 int intel_gt_init(struct intel_gt *gt)

