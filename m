Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C63DA7098
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730311AbfICQZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:25:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:44968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730297AbfICQZL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:25:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C13DF23711;
        Tue,  3 Sep 2019 16:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567527909;
        bh=YEKpx2P2hrGWksNlq1jYo57hOhkCpoZ8pPpWkNg0n7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y6tofRjy31mgcYBs/IyrFck/TggwP24LSg7gq6ugduq5ViEoFLxNMQ2SQhpeMnRvS
         f/ZgrDfmMvqk7+vCq2DHd6bbxrc31pHIlIOXQFzX/BhpVEiG7lANOS/ksiodX6CKZS
         JZUsT2VgOF1wxzYE2dmw24fOyLuuQIhCIqtuwFh4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Harrison <John.C.Harrison@Intel.com>,
        "Robert M . Fosha" <robert.m.fosha@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 19/23] drm/i915: Support flags in whitlist WAs
Date:   Tue,  3 Sep 2019 12:24:20 -0400
Message-Id: <20190903162424.6877-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162424.6877-1-sashal@kernel.org>
References: <20190903162424.6877-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Harrison <John.C.Harrison@Intel.com>

[ Upstream commit 6883eab274813d158bfcfb499aa225ece61c0f29 ]

Newer hardware adds flags to the whitelist work-around register. These
allow per access direction privileges and ranges.

Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Signed-off-by: Robert M. Fosha <robert.m.fosha@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190618010108.27499-2-John.C.Harrison@Intel.com
(cherry picked from commit 5380d0b781c491d94b4f4690ecf9762c1946c4ec)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/i915_reg.h          | 7 +++++++
 drivers/gpu/drm/i915/intel_workarounds.c | 9 ++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 13d6bd4e17b20..cf748b80e6401 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -2510,6 +2510,13 @@ enum i915_power_well_id {
 #define   RING_WAIT_SEMAPHORE	(1 << 10) /* gen6+ */
 
 #define RING_FORCE_TO_NONPRIV(base, i) _MMIO(((base) + 0x4D0) + (i) * 4)
+#define   RING_FORCE_TO_NONPRIV_RW		(0 << 28)    /* CFL+ & Gen11+ */
+#define   RING_FORCE_TO_NONPRIV_RD		(1 << 28)
+#define   RING_FORCE_TO_NONPRIV_WR		(2 << 28)
+#define   RING_FORCE_TO_NONPRIV_RANGE_1		(0 << 0)     /* CFL+ & Gen11+ */
+#define   RING_FORCE_TO_NONPRIV_RANGE_4		(1 << 0)
+#define   RING_FORCE_TO_NONPRIV_RANGE_16	(2 << 0)
+#define   RING_FORCE_TO_NONPRIV_RANGE_64	(3 << 0)
 #define   RING_MAX_NONPRIV_SLOTS  12
 
 #define GEN7_TLB_RD_ADDR	_MMIO(0x4700)
diff --git a/drivers/gpu/drm/i915/intel_workarounds.c b/drivers/gpu/drm/i915/intel_workarounds.c
index 2fb70fab2d1c6..1db826b12774e 100644
--- a/drivers/gpu/drm/i915/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/intel_workarounds.c
@@ -981,7 +981,7 @@ bool intel_gt_verify_workarounds(struct drm_i915_private *i915,
 }
 
 static void
-whitelist_reg(struct i915_wa_list *wal, i915_reg_t reg)
+whitelist_reg_ext(struct i915_wa_list *wal, i915_reg_t reg, u32 flags)
 {
 	struct i915_wa wa = {
 		.reg = reg
@@ -990,9 +990,16 @@ whitelist_reg(struct i915_wa_list *wal, i915_reg_t reg)
 	if (GEM_DEBUG_WARN_ON(wal->count >= RING_MAX_NONPRIV_SLOTS))
 		return;
 
+	wa.reg.reg |= flags;
 	_wa_add(wal, &wa);
 }
 
+static void
+whitelist_reg(struct i915_wa_list *wal, i915_reg_t reg)
+{
+	whitelist_reg_ext(wal, reg, RING_FORCE_TO_NONPRIV_RW);
+}
+
 static void gen9_whitelist_build(struct i915_wa_list *w)
 {
 	/* WaVFEStateAfterPipeControlwithMediaStateClear:skl,bxt,glk,cfl */
-- 
2.20.1

