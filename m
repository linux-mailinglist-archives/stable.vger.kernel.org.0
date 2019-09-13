Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14210B1FAB
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390267AbfIMNVp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:21:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:51622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390268AbfIMNVp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:21:45 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10468206BB;
        Fri, 13 Sep 2019 13:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380904;
        bh=DICROOCqPlqU3DQD8ovucL65/+l4npmqF8Sd5pVTWHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NDHsHWOdQCFmWsStU/WJVo6du5ONgI7sDVKIQcfTN5pwchzylSVyYAuOioZUnAWAD
         UnmoGhA9aC2rC12UfaT9z6R8dzhZ06ubGPJg/GgzO4pMo3oKE5/1j9wggMo2SHzqaA
         dIPM8IR7sati/P3/g+3WHhKkKR01bPiK64ML0+D0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 32/37] drm/i915: whitelist PS_(DEPTH|INVOCATION)_COUNT
Date:   Fri, 13 Sep 2019 14:07:37 +0100
Message-Id: <20190913130521.659680299@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130510.727515099@linuxfoundation.org>
References: <20190913130510.727515099@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



