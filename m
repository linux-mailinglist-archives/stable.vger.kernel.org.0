Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3088A61589E
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbiKBCzR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbiKBCzQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:55:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC6121E09
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:55:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91D2AB82064
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:55:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75098C433D6;
        Wed,  2 Nov 2022 02:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357713;
        bh=NldS0n6sT1PHI9Uy86+qt7slQHyu9wy6gMR9iPPyimI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j1Xl/wiZTJ7s435tA7jz196r6pORllPPo6SIUyOg8hCslD3UataFTbHDToWeLQsMK
         Dp+csavE2f5wHpM9y4UzXotWBsorv+wk970PR2BFGSKwTkRtSIfoli1Q0fQ2J+BiAC
         XJrPc3iAj8ujasHjX10e2HPXWJ8tQbyhU9KfodTs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Anshuman Gupta <anshuman.gupta@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 180/240] drm/i915/dgfx: Keep PCI autosuspend control on by default on all dGPU
Date:   Wed,  2 Nov 2022 03:32:35 +0100
Message-Id: <20221102022115.457962176@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anshuman Gupta <anshuman.gupta@intel.com>

[ Upstream commit 62c52eac1ad680fc68ef6d75955127dca46e2740 ]

DGFX platforms has lmem and cpu can access the lmem objects
via mmap and i915 internal i915_gem_object_pin_map() for
i915 own usages. Both of these methods has pre-requisite
requirement to keep GFX PCI endpoint in D0 for a supported
iomem transaction over PCI link. (Refer PCIe specs 5.3.1.4.1)

Both DG1/DG2 have a known hardware bug that violates the PCIe specs
and support the iomem read write transaction over PCIe bus despite
endpoint is D3 state.
Due to above H/W bug, we had never observed any issue with i915 runtime
PM versus lmem access.
But this issue becomes visible when PCIe gfx endpoint's upstream
bridge enters to D3, at this point any lmem read/write access will be
returned as unsupported request. But again this issue is not observed
on every platform because it has been observed on few host machines
DG1/DG2 endpoint's upstream bridge does not bind with pcieport driver.
which really disables the PCIe  power savings and leaves the bridge
at D0 state.

We need a unique interface to read/write from lmem with runtime PM
wakeref protection something similar to intel_uncore_{read, write},
keep autosuspend control to 'on' on all discrete platforms,
until we have a unique interface to read/write from lmem.

This just change the default autosuspend setting of i915 on dGPU,
user can still change it to 'auto'.

v2:
- Modified the commit message and subject with more information.
- Changed the Fixes tag to LMEM support commit. [Joonas]
- Changed !HAS_LMEM() Cond to !IS_DGFX(). [Rodrigo]

Fixes: b908be543e44 ("drm/i915: support creating LMEM objects")
Suggested-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Anshuman Gupta <anshuman.gupta@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221014113258.1284226-1-anshuman.gupta@intel.com
(cherry picked from commit 66eb93e71a7a6695b7c5eb682e3ca1c980cf9d58)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/intel_runtime_pm.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_runtime_pm.c b/drivers/gpu/drm/i915/intel_runtime_pm.c
index 6ed5786bcd29..744cca507946 100644
--- a/drivers/gpu/drm/i915/intel_runtime_pm.c
+++ b/drivers/gpu/drm/i915/intel_runtime_pm.c
@@ -591,8 +591,15 @@ void intel_runtime_pm_enable(struct intel_runtime_pm *rpm)
 		pm_runtime_use_autosuspend(kdev);
 	}
 
-	/* Enable by default */
-	pm_runtime_allow(kdev);
+	/*
+	 *  FIXME: Temp hammer to keep autosupend disable on lmem supported platforms.
+	 *  As per PCIe specs 5.3.1.4.1, all iomem read write request over a PCIe
+	 *  function will be unsupported in case PCIe endpoint function is in D3.
+	 *  Let's keep i915 autosuspend control 'on' till we fix all known issue
+	 *  with lmem access in D3.
+	 */
+	if (!IS_DGFX(i915))
+		pm_runtime_allow(kdev);
 
 	/*
 	 * The core calls the driver load handler with an RPM reference held.
-- 
2.35.1



