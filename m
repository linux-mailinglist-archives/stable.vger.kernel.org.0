Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F07475FEC
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 09:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725945AbfGZHgK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 03:36:10 -0400
Received: from mga14.intel.com ([192.55.52.115]:41199 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725869AbfGZHgJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 03:36:09 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jul 2019 00:36:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,310,1559545200"; 
   d="scan'208";a="369967752"
Received: from jlahtine-desk.ger.corp.intel.com ([10.252.2.51])
  by fmsmga006.fm.intel.com with ESMTP; 26 Jul 2019 00:36:07 -0700
From:   Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
To:     stable@vger.kernel.org
Subject: [PATCH 4/8] drm/i915: Disable SAMPLER_STATE prefetching on all Gen11 steppings.
Date:   Fri, 26 Jul 2019 10:35:52 +0300
Message-Id: <20190726073556.9011-5-joonas.lahtinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726073556.9011-1-joonas.lahtinen@linux.intel.com>
References: <20190726073556.9011-1-joonas.lahtinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kenneth Graunke <kenneth@whitecape.org>

The Demand Prefetch workaround (binding table prefetching) only applies
to Icelake A0/B0.  But the Sampler Prefetch workaround needs to be
applied to all Gen11 steppings, according to a programming note in the
SARCHKMD documentation.

Using the Intel Gallium driver, I have seen intermittent failures in
the dEQP-GLES31.functional.copy_image.non_compressed.* tests.  After
applying this workaround, the tests reliably pass.

v2: Remove the overlap with a pre-production w/a

BSpec: 9663
Signed-off-by: Kenneth Graunke <kenneth@whitecape.org>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: stable@vger.kernel.org
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190625090655.19220-1-chris@chris-wilson.co.uk
(cherry picked from commit f9a393875d3af13cc3267477746608dadb7f17c1)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
---
 drivers/gpu/drm/i915/intel_workarounds.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_workarounds.c b/drivers/gpu/drm/i915/intel_workarounds.c
index 841b8e515f4d..2fb70fab2d1c 100644
--- a/drivers/gpu/drm/i915/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/intel_workarounds.c
@@ -1167,8 +1167,12 @@ rcs_engine_wa_init(struct intel_engine_cs *engine, struct i915_wa_list *wal)
 		if (IS_ICL_REVID(i915, ICL_REVID_A0, ICL_REVID_B0))
 			wa_write_or(wal,
 				    GEN7_SARCHKMD,
-				    GEN7_DISABLE_DEMAND_PREFETCH |
-				    GEN7_DISABLE_SAMPLER_PREFETCH);
+				    GEN7_DISABLE_DEMAND_PREFETCH);
+
+		/* Wa_1606682166:icl */
+		wa_write_or(wal,
+			    GEN7_SARCHKMD,
+			    GEN7_DISABLE_SAMPLER_PREFETCH);
 	}
 
 	if (IS_GEN_RANGE(i915, 9, 11)) {
-- 
2.20.1

