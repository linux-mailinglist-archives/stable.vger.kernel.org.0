Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5512926B89F
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbgIPAry (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:47:54 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:49601 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726321AbgIOMmQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 08:42:16 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 22434180-1500050 
        for multiple; Tue, 15 Sep 2020 13:41:51 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Bruce Chang <yu.bruce.chang@intel.com>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/4] drm/i915/gt: Wait for CSB entries on Tigerlake
Date:   Tue, 15 Sep 2020 13:41:48 +0100
Message-Id: <20200915124150.12045-2-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200915124150.12045-1-chris@chris-wilson.co.uk>
References: <20200915124150.12045-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tigerlake, we are seeing a repeat of commit d8f505311717 ("drm/i915/icl:
Forcibly evict stale csb entries") where, presumably, due to a missing
Global Observation Point synchronisation, the write pointer of the CSB
ringbuffer is updated _prior_ to the contents of the ringbuffer. That is
we see the GPU report more context-switch entries for us to parse, but
those entries have not been written, leading us to process stale events,
and eventually report a hung GPU.

However, this effect appears to be much more severe than we previously
saw on Icelake (though it might be best if we try the same approach
there as well and measure), and Bruce suggested the good idea of resetting
the CSB entry after use so that we can detect when it has been updated by
the GPU. By instrumenting how long that may be, we can set a reliable
upper bound for how long we should wait for:

    513 late, avg of 61 retries (590 ns), max of 1061 retries (10099 ns)

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2045
References: d8f505311717 ("drm/i915/icl: Forcibly evict stale csb entries")
Suggested-by: Bruce Chang <yu.bruce.chang@intel.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Bruce Chang <yu.bruce.chang@intel.com>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: stable@vger.kernel.org # v5.4
---
 drivers/gpu/drm/i915/gt/intel_lrc.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
index d6e0f62337b4..d75712a503b7 100644
--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -2498,9 +2498,22 @@ invalidate_csb_entries(const u64 *first, const u64 *last)
  */
 static inline bool gen12_csb_parse(const u64 *csb)
 {
-	u64 entry = READ_ONCE(*csb);
-	bool ctx_away_valid = GEN12_CSB_CTX_VALID(upper_32_bits(entry));
-	bool new_queue =
+	bool ctx_away_valid;
+	bool new_queue;
+	u64 entry;
+
+	/* HSD#22011248461 */
+	entry = READ_ONCE(*csb);
+	if (unlikely(entry == -1)) {
+		preempt_disable();
+		if (wait_for_atomic_us((entry = READ_ONCE(*csb)) != -1, 50))
+			GEM_WARN_ON("50us CSB timeout");
+		preempt_enable();
+	}
+	WRITE_ONCE(*(u64 *)csb, -1);
+
+	ctx_away_valid = GEN12_CSB_CTX_VALID(upper_32_bits(entry));
+	new_queue =
 		lower_32_bits(entry) & GEN12_CTX_STATUS_SWITCHED_TO_NEW_QUEUE;
 
 	/*
@@ -4004,6 +4017,8 @@ static void reset_csb_pointers(struct intel_engine_cs *engine)
 	WRITE_ONCE(*execlists->csb_write, reset_value);
 	wmb(); /* Make sure this is visible to HW (paranoia?) */
 
+	/* Check that the GPU does indeed update the CSB entries! */
+	memset(execlists->csb_status, -1, (reset_value + 1) * sizeof(u64));
 	invalidate_csb_entries(&execlists->csb_status[0],
 			       &execlists->csb_status[reset_value]);
 
-- 
2.20.1

