Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBAD3FDBE5
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344650AbhIAMpj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:45:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:43452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345278AbhIAMmz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:42:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DE9D611CC;
        Wed,  1 Sep 2021 12:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499891;
        bh=ikYgbC297fiIFBz93rM5Hb9aIdkxMY/8iUMvt0FWg1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RCRn4VkcaI/JbNRcNFip79Kcl0lpo64lt/ImVwINiZSxJtLm9uob2EASziUa1LLhH
         2oVvLnS2ECI8dOjpew4QXjwaODlgsK+rlM3y38Y6mWB3brWEbtFdEBk+47iY5Gjsgu
         y9zuM3ouIqG5Uj/l+k8P8B/j7i6lfXvTZ3H1IuQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Brost <matthew.brost@intel.com>,
        John Harrison <John.C.Harrison@Intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.13 023/113] drm/i915: Fix syncmap memory leak
Date:   Wed,  1 Sep 2021 14:27:38 +0200
Message-Id: <20210901122302.761468316@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Brost <matthew.brost@intel.com>

commit a63bcf08f0efb5348105bb8e0e1e8c6671077753 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/intel_timeline.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/gpu/drm/i915/gt/intel_timeline.c
+++ b/drivers/gpu/drm/i915/gt/intel_timeline.c
@@ -127,6 +127,15 @@ static void intel_timeline_fini(struct r
 
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
 


