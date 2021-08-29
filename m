Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB1A13FA99F
	for <lists+stable@lfdr.de>; Sun, 29 Aug 2021 08:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbhH2G5q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Aug 2021 02:57:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:49018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234585AbhH2G5q (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Aug 2021 02:57:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A95060F36;
        Sun, 29 Aug 2021 06:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630220212;
        bh=uHE+8zzWGTnST9PjYxuR4oL/OF5jqrkiaBFx6V8yebY=;
        h=Subject:To:Cc:From:Date:From;
        b=onggnIPIl2UM/miNTGinSi2YWXNspButy1lTsJH9/FV2MAdofuGJAfXOETfTHn/5d
         pLQtdFs6rVA7YVUWoFB1nGpTm2MCC7cFaUSWaMyfA3veedGoWI9eROGaz4sA1BT4LM
         +Hfy2Y2oEExxlIPeXA7o0Ad0En30MDOJcbfpvnJo=
Subject: FAILED: patch "[PATCH] drm/i915: Fix syncmap memory leak" failed to apply to 5.10-stable tree
To:     matthew.brost@intel.com, John.C.Harrison@Intel.com,
        rodrigo.vivi@intel.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 29 Aug 2021 08:56:43 +0200
Message-ID: <1630220203110238@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a63bcf08f0efb5348105bb8e0e1e8c6671077753 Mon Sep 17 00:00:00 2001
From: Matthew Brost <matthew.brost@intel.com>
Date: Fri, 30 Jul 2021 12:53:42 -0700
Subject: [PATCH] drm/i915: Fix syncmap memory leak

A small race exists between intel_gt_retire_requests_timeout and
intel_timeline_exit which could result in the syncmap not getting
free'd. Rather than work to hard to seal this race, simply cleanup the
syncmap on fini.

unreferenced object 0xffff88813bc53b18 (size 96):
  comm "gem_close_race", pid 5410, jiffies 4294917818 (age 1105.600s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 00 00 00 00 0a 00 00 00  ................
    00 00 00 00 00 00 00 00 6b 6b 6b 6b 06 00 00 00  ........kkkk....
  backtrace:
    [<00000000120b863a>] __sync_alloc_leaf+0x1e/0x40 [i915]
    [<00000000042f6959>] __sync_set+0x1bb/0x240 [i915]
    [<0000000090f0e90f>] i915_request_await_dma_fence+0x1c7/0x400 [i915]
    [<0000000056a48219>] i915_request_await_object+0x222/0x360 [i915]
    [<00000000aaac4ee3>] i915_gem_do_execbuffer+0x1bd0/0x2250 [i915]
    [<000000003c9d830f>] i915_gem_execbuffer2_ioctl+0x405/0xce0 [i915]
    [<00000000fd7a8e68>] drm_ioctl_kernel+0xb0/0xf0 [drm]
    [<00000000e721ee87>] drm_ioctl+0x305/0x3c0 [drm]
    [<000000008b0d8986>] __x64_sys_ioctl+0x71/0xb0
    [<0000000076c362a4>] do_syscall_64+0x33/0x80
    [<00000000eb7a4831>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Fixes: 531958f6f357 ("drm/i915/gt: Track timeline activeness in enter/exit")
Cc: <stable@vger.kernel.org>
Reviewed-by: John Harrison <John.C.Harrison@Intel.com>
Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210730195342.110234-1-matthew.brost@intel.com
(cherry picked from commit faf890985e30d5e88cc3a7c50c1bcad32f89ab7c)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_timeline.c b/drivers/gpu/drm/i915/gt/intel_timeline.c
index c4a126c8caef..1257f4f11e66 100644
--- a/drivers/gpu/drm/i915/gt/intel_timeline.c
+++ b/drivers/gpu/drm/i915/gt/intel_timeline.c
@@ -127,6 +127,15 @@ static void intel_timeline_fini(struct rcu_head *rcu)
 
 	i915_vma_put(timeline->hwsp_ggtt);
 	i915_active_fini(&timeline->active);
+
+	/*
+	 * A small race exists between intel_gt_retire_requests_timeout and
+	 * intel_timeline_exit which could result in the syncmap not getting
+	 * free'd. Rather than work to hard to seal this race, simply cleanup
+	 * the syncmap on fini.
+	 */
+	i915_syncmap_free(&timeline->sync);
+
 	kfree(timeline);
 }
 

