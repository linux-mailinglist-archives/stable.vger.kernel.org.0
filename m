Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2E828F9B7
	for <lists+stable@lfdr.de>; Thu, 15 Oct 2020 21:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730775AbgJOTu1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Oct 2020 15:50:27 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:60446 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725919AbgJOTu1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Oct 2020 15:50:27 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 22728731-1500050 
        for multiple; Thu, 15 Oct 2020 20:50:24 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Bruce Chang <yu.bruce.chang@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/i915/gt: Delay execlist processing for tgl
Date:   Thu, 15 Oct 2020 20:50:23 +0100
Message-Id: <20201015195023.32346-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When running gem_exec_nop, it floods the system with many requests (with
the goal of userspace submitting faster than the HW can process a single
empty batch). This causes the driver to continually resubmit new
requests onto the end of an active context, a flood of lite-restore
preemptions. If we time this just right, Tigerlake hangs.

Inserting a small delay between the processing of CS events and
submitting the next context, prevents the hang. Naturally it does not
occur with debugging enabled. The suspicion then is that this is related
to the issues with the CS event buffer, and inserting an mmio read of
the CS pointer status appears to be very successful in preventing the
hang. Other registers, or uncached reads, or plain mb, do not prevent
the hang, suggesting that register is key -- but that the hang can be
prevented by a simple udelay, suggests it is just a timing issue like
that encountered by commit 233c1ae3c83f ("drm/i915/gt: Wait for CSB
entries on Tigerlake"). Also note that the hang is not prevented by
applying CTX_DESC_FORCE_RESTORE, or by inserting a delay on the GPU
between requests.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: Bruce Chang <yu.bruce.chang@intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/i915/gt/intel_lrc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
index 6170f6874f52..d15d561152ba 100644
--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -2711,6 +2711,9 @@ static void process_csb(struct intel_engine_cs *engine)
 			smp_wmb(); /* complete the seqlock */
 			WRITE_ONCE(execlists->active, execlists->inflight);
 
+			/* Magic delay for tgl */
+			ENGINE_POSTING_READ(engine, RING_CONTEXT_STATUS_PTR);
+
 			WRITE_ONCE(execlists->pending[0], NULL);
 		} else {
 			if (GEM_WARN_ON(!*execlists->active)) {
-- 
2.20.1

