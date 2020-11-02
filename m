Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53BEB2A364E
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 23:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725807AbgKBWLD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 17:11:03 -0500
Received: from mail.fireflyinternet.com ([77.68.26.236]:55764 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725777AbgKBWLD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 17:11:03 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 22874953-1500050 
        for multiple; Mon, 02 Nov 2020 22:11:02 +0000
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/2] drm/i915/gt: Flush xcs before tgl breadcrumbs
Date:   Mon,  2 Nov 2020 22:10:57 +0000
Message-Id: <20201102221057.29626-2-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201102221057.29626-1-chris@chris-wilson.co.uk>
References: <20201102221057.29626-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In a simple test case that writes to scratch and then busy-waits for the
batch to be signaled, we observe that the signal is before the write is
posted. That is bad news.

Splitting the flush + write_dword into two separate flush_dw prevents
the issue from being reproduced, we can presume the post-sync op is not
so post-sync.

Testcase: igt/gem_exec_fence/parallel
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/i915/gt/intel_lrc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
index d0be98b67138..a437140a987d 100644
--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -5047,7 +5047,8 @@ gen12_emit_fini_breadcrumb_tail(struct i915_request *request, u32 *cs)
 
 static u32 *gen12_emit_fini_breadcrumb(struct i915_request *rq, u32 *cs)
 {
-	return gen12_emit_fini_breadcrumb_tail(rq, emit_xcs_breadcrumb(rq, cs));
+	cs = emit_xcs_breadcrumb(rq, __gen8_emit_flush_dw(cs, 0, 0, 0));
+	return gen12_emit_fini_breadcrumb_tail(rq, cs);
 }
 
 static u32 *
-- 
2.20.1

