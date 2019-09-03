Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADAAA7099
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730318AbfICQZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:25:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:44968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730313AbfICQZN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:25:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8033C23891;
        Tue,  3 Sep 2019 16:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567527912;
        bh=nToPhXUj90HieWOjQ0yRqNGpYJt6WrnFeBUHuwMdMz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TB8ykN43HSrnGhuM3rZFYy/ZFojIHnVIp9SEL0nuA3jsPaf2NDepnEyZJY1VU5B2U
         jd32kXXufxGi5idjRg3LwcAaf7CjQmdYmARlbEHFwxERz33aqVRij7UDyESMdCkk5h
         eJlXO5G2VIqdolzKxLxmJIfaD52aqn6p4Ojwmc1k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 21/23] drm/i915: whitelist PS_(DEPTH|INVOCATION)_COUNT
Date:   Tue,  3 Sep 2019 12:24:22 -0400
Message-Id: <20190903162424.6877-21-sashal@kernel.org>
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

From: Lionel Landwerlin <lionel.g.landwerlin@intel.com>

[ Upstream commit 6ce5bfe936ac31d5c52c4b1328d0bfda5f97e7ca ]

CFL:C0+ changed the status of those registers which are now
blacklisted by default.

This is breaking a number of CTS tests on GL & Vulkan :

  KHR-GL45.pipeline_statistics_query_tests_ARB.functional_fragment_shader_invocations (GL)

  dEQP-VK.query_pool.statistics_query.fragment_shader_invocations.* (Vulkan)

v2: Only use one whitelist entry (Lionel)

Bspec: 14091
Signed-off-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Cc: stable@vger.kernel.org # 6883eab27481: drm/i915: Support flags in whitlist WAs
Cc: stable@vger.kernel.org
Acked-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Link: https://patchwork.freedesktop.org/patch/msgid/20190628120720.21682-3-lionel.g.landwerlin@intel.com
(cherry picked from commit 2c903da50f5a9522b134e488bd0f92646c46f3c0)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/intel_workarounds.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_workarounds.c b/drivers/gpu/drm/i915/intel_workarounds.c
index 0b80fde927899..be3688908f0ce 100644
--- a/drivers/gpu/drm/i915/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/intel_workarounds.c
@@ -1061,10 +1061,25 @@ static void glk_whitelist_build(struct intel_engine_cs *engine)
 
 static void cfl_whitelist_build(struct intel_engine_cs *engine)
 {
+	struct i915_wa_list *w = &engine->whitelist;
+
 	if (engine->class != RENDER_CLASS)
 		return;
 
-	gen9_whitelist_build(&engine->whitelist);
+	gen9_whitelist_build(w);
+
+	/*
+	 * WaAllowPMDepthAndInvocationCountAccessFromUMD:cfl,whl,cml,aml
+	 *
+	 * This covers 4 register which are next to one another :
+	 *   - PS_INVOCATION_COUNT
+	 *   - PS_INVOCATION_COUNT_UDW
+	 *   - PS_DEPTH_COUNT
+	 *   - PS_DEPTH_COUNT_UDW
+	 */
+	whitelist_reg_ext(w, PS_INVOCATION_COUNT,
+			  RING_FORCE_TO_NONPRIV_RD |
+			  RING_FORCE_TO_NONPRIV_RANGE_4);
 }
 
 static void cnl_whitelist_build(struct intel_engine_cs *engine)
-- 
2.20.1

