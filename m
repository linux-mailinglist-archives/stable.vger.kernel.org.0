Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10AD4B206C
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390906AbfIMNVu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:21:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:51706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390279AbfIMNVt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:21:49 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3E9420830;
        Fri, 13 Sep 2019 13:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380909;
        bh=tjS9jxRPe3MnVc1fSqzwm1qF40Tys6fPzN/oFmOmjhQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GAVYCuU80Oa9huVgpOiD+3EB6+CmFGwiJXxvgzosYsaI0NUU30BtwaI1aOcpXSWE9
         cXTexguv0oMopLrOPgm0Ez5Y/TX7uhdgKyGJIgklx5hMLX4IpY8XQ7yGbQQeiO5YMC
         TO86xMVSgDlhvEhsiPvmqFfXkE2CM6bPxTVkppyM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
        Anuj Phogat <anuj.phogat@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 34/37] drm/i915/icl: whitelist PS_(DEPTH|INVOCATION)_COUNT
Date:   Fri, 13 Sep 2019 14:07:39 +0100
Message-Id: <20190913130521.847990879@linuxfoundation.org>
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

[ Upstream commit cf8f9aa1eda7d916bd23f6b8c226404deb11690c ]

The same tests failing on CFL+ platforms are also failing on ICL.
Documentation doesn't list the
WaAllowPMDepthAndInvocationCountAccessFromUMD workaround for ICL but
applying it fixes the same tests as CFL.

v2: Use only one whitelist entry (Lionel)

Signed-off-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Tested-by: Anuj Phogat <anuj.phogat@gmail.com>
Cc: stable@vger.kernel.org # 6883eab27481: drm/i915: Support flags in whitlist WAs
Cc: stable@vger.kernel.org
Acked-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Link: https://patchwork.freedesktop.org/patch/msgid/20190628120720.21682-4-lionel.g.landwerlin@intel.com
(cherry picked from commit 3fe0107e45ab396342497e06b8924cdd485cde3b)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/intel_workarounds.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_workarounds.c b/drivers/gpu/drm/i915/intel_workarounds.c
index efea5a18fa6db..edd57a5e0495f 100644
--- a/drivers/gpu/drm/i915/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/intel_workarounds.c
@@ -1107,6 +1107,19 @@ static void icl_whitelist_build(struct intel_engine_cs *engine)
 
 		/* WaEnableStateCacheRedirectToCS:icl */
 		whitelist_reg(w, GEN9_SLICE_COMMON_ECO_CHICKEN1);
+
+		/*
+		 * WaAllowPMDepthAndInvocationCountAccessFromUMD:icl
+		 *
+		 * This covers 4 register which are next to one another :
+		 *   - PS_INVOCATION_COUNT
+		 *   - PS_INVOCATION_COUNT_UDW
+		 *   - PS_DEPTH_COUNT
+		 *   - PS_DEPTH_COUNT_UDW
+		 */
+		whitelist_reg_ext(w, PS_INVOCATION_COUNT,
+				  RING_FORCE_TO_NONPRIV_RD |
+				  RING_FORCE_TO_NONPRIV_RANGE_4);
 		break;
 
 	case VIDEO_DECODE_CLASS:
-- 
2.20.1



