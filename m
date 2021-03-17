Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A636B33E741
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 03:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbhCQC4S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 22:56:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:45758 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhCQCzq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 22:55:46 -0400
IronPort-SDR: QOSPsl+do2ii2YK45sQ+v72Ux8jxg7IHbKj+4iykiFIya3end7ypTN9VYKA9jhsto+5z+m3HYb
 Fufp/MsjAwqA==
X-IronPort-AV: E=McAfee;i="6000,8403,9925"; a="186016078"
X-IronPort-AV: E=Sophos;i="5.81,254,1610438400"; 
   d="scan'208";a="186016078"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2021 19:55:46 -0700
IronPort-SDR: tnUxgGADLeZ7i7QCogzmXNsgxBurNT1KdUovRM9pJ2AoyUWJeIeTBr6cz1tk94zGLUGYVDDZzX
 +exFi+ErqWmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,254,1610438400"; 
   d="scan'208";a="590888323"
Received: from unknown (HELO coxu-arch-shz.sh.intel.com) ([10.239.160.25])
  by orsmga005.jf.intel.com with ESMTP; 16 Mar 2021 19:55:45 -0700
From:   Colin Xu <colin.xu@intel.com>
To:     stable@vger.kernel.org
Cc:     intel-gvt-dev@lists.freedesktop.org, zhenyuw@linux.intel.com,
        colin.xu@intel.com
Subject: [PATCH 2/5] drm/i915/gvt: Fix mmio handler break on BXT/APL.
Date:   Wed, 17 Mar 2021 10:55:01 +0800
Message-Id: <71b10da4af9e8be3b38b99382e164dd4e83fdf27.1615946755.git.colin.xu@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1615946755.git.colin.xu@intel.com>
References: <cover.1615946755.git.colin.xu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 92010a97098c4c9fd777408cc98064d26b32695b upstream

- Remove dup mmio handler for BXT/APL. Otherwise mmio handler will fail
  to init.
- Add engine GPR with F_CMD_ACCESS since BXT/APL will load them via
  LRI. Otherwise, guest will enter failsafe mode.

V2:
Use RCS/BCS GPR macros instead of offset.
Revise commit message.

V3:
Use GEN8_RING_CS_GPR macros on ring base.

Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Colin Xu <colin.xu@intel.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20201016052913.209248-1-colin.xu@intel.com
(cherry picked from commit 92010a97098c4c9fd777408cc98064d26b32695b)
Signed-off-by: Colin Xu <colin.xu@intel.com>
Cc: <stable@vger.kernel.org> # 5.4.y
---
 drivers/gpu/drm/i915/gvt/handlers.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gvt/handlers.c b/drivers/gpu/drm/i915/gvt/handlers.c
index f14aefcb5b7b..245c20d36f1b 100644
--- a/drivers/gpu/drm/i915/gvt/handlers.c
+++ b/drivers/gpu/drm/i915/gvt/handlers.c
@@ -3132,7 +3132,7 @@ static int init_skl_mmio_info(struct intel_gvt *gvt)
 		 NULL, NULL);
 
 	MMIO_D(GAMT_CHKN_BIT_REG, D_KBL | D_CFL);
-	MMIO_D(GEN9_CTX_PREEMPT_REG, D_SKL_PLUS);
+	MMIO_D(GEN9_CTX_PREEMPT_REG, D_SKL_PLUS & ~D_BXT);
 
 	return 0;
 }
@@ -3306,6 +3306,12 @@ static int init_bxt_mmio_info(struct intel_gvt *gvt)
 	MMIO_D(GEN8_PUSHBUS_SHIFT, D_BXT);
 	MMIO_D(GEN6_GFXPAUSE, D_BXT);
 	MMIO_DFH(GEN8_L3SQCREG1, D_BXT, F_CMD_ACCESS, NULL, NULL);
+	MMIO_DFH(GEN8_L3CNTLREG, D_BXT, F_CMD_ACCESS, NULL, NULL);
+	MMIO_DFH(_MMIO(0x20D8), D_BXT, F_CMD_ACCESS, NULL, NULL);
+	MMIO_F(HSW_CS_GPR(0), 0x40, F_CMD_ACCESS, 0, 0, D_BXT, NULL, NULL);
+	MMIO_F(_MMIO(0x12600), 0x40, F_CMD_ACCESS, 0, 0, D_BXT, NULL, NULL);
+	MMIO_F(BCS_GPR(0), 0x40, F_CMD_ACCESS, 0, 0, D_BXT, NULL, NULL);
+	MMIO_F(_MMIO(0x1a600), 0x40, F_CMD_ACCESS, 0, 0, D_BXT, NULL, NULL);
 
 	MMIO_DFH(GEN9_CTX_PREEMPT_REG, D_BXT, F_CMD_ACCESS, NULL, NULL);
 
-- 
2.30.2

