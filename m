Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 394AF33E743
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 03:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbhCQC4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 22:56:20 -0400
Received: from mga12.intel.com ([192.55.52.136]:15388 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229618AbhCQC4R (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 22:56:17 -0400
IronPort-SDR: jGJ36CRLl9eAY/TiIaMy86LXEwxVrtLR/xw/jU1YmkNMi1FEe3uI21txP2dBEMM5/on1l3Lgb/
 AyhWlUzk1trQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9925"; a="168648173"
X-IronPort-AV: E=Sophos;i="5.81,254,1610438400"; 
   d="scan'208";a="168648173"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2021 19:56:15 -0700
IronPort-SDR: G01i1MdDSxq0vt+pETknguNqD7G0/8/EODy1gpnyIE1fVErgo3cPDwkj46uqS2weGydAivYpk1
 PwgnONUT3oWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,254,1610438400"; 
   d="scan'208";a="590888420"
Received: from unknown (HELO coxu-arch-shz.sh.intel.com) ([10.239.160.25])
  by orsmga005.jf.intel.com with ESMTP; 16 Mar 2021 19:56:14 -0700
From:   Colin Xu <colin.xu@intel.com>
To:     stable@vger.kernel.org
Cc:     intel-gvt-dev@lists.freedesktop.org, zhenyuw@linux.intel.com,
        colin.xu@intel.com
Subject: [PATCH 4/5] drm/i915/gvt: Fix port number for BDW on EDID region setup
Date:   Wed, 17 Mar 2021 10:55:03 +0800
Message-Id: <ef9ce56bfd3bee8b68063503d12b1d5d3535536e.1615946755.git.colin.xu@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1615946755.git.colin.xu@intel.com>
References: <cover.1615946755.git.colin.xu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhenyu Wang <zhenyuw@linux.intel.com>

commit 28284943ac94014767ecc2f7b3c5747c4a5617a0 upstream

Current BDW virtual display port is initialized as PORT_B, so need
to use same port for VFIO EDID region, otherwise invalid EDID blob
pointer is assigned which caused kernel null pointer reference. We
might evaluate actual display hotplug for BDW to make this function
work as expected, anyway this is always required to be fixed first.

Reported-by: Alejandro Sior <aho@sior.be>
Cc: Alejandro Sior <aho@sior.be>
Fixes: 0178f4ce3c3b ("drm/i915/gvt: Enable vfio edid for all GVT supported platform")
Reviewed-by: Hang Yuan <hang.yuan@intel.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20200914030302.2775505-1-zhenyuw@linux.intel.com
(cherry picked from commit 28284943ac94014767ecc2f7b3c5747c4a5617a0)
Signed-off-by: Colin Xu <colin.xu@intel.com>
Cc: <stable@vger.kernel.org> # 5.4.y
---
 drivers/gpu/drm/i915/gvt/vgpu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/vgpu.c b/drivers/gpu/drm/i915/gvt/vgpu.c
index 32e57635709a..4daaf302f429 100644
--- a/drivers/gpu/drm/i915/gvt/vgpu.c
+++ b/drivers/gpu/drm/i915/gvt/vgpu.c
@@ -432,8 +432,9 @@ static struct intel_vgpu *__intel_gvt_create_vgpu(struct intel_gvt *gvt,
 	if (ret)
 		goto out_clean_sched_policy;
 
-	/*TODO: add more platforms support */
-	if (IS_SKYLAKE(gvt->dev_priv) || IS_KABYLAKE(gvt->dev_priv))
+	if (IS_BROADWELL(gvt->dev_priv))
+		ret = intel_gvt_hypervisor_set_edid(vgpu, PORT_B);
+	else
 		ret = intel_gvt_hypervisor_set_edid(vgpu, PORT_D);
 	if (ret)
 		goto out_clean_sched_policy;
-- 
2.30.2

