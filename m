Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9BD3ED68F
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239299AbhHPNWD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:22:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:44514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238847AbhHPNSh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:18:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 685D7632A5;
        Mon, 16 Aug 2021 13:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119653;
        bh=xnEEbijOMfrHTmOYRQd4OYxJJkSRALWwLLcgr77o9ns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dYUX4F/6nWuJd2xn047vJZ0vJkGquy3wzW7o3nhjt3RRIPebFphXwMJ9SM4E8cvSb
         GYxIhpP3Hy+0qB42HPaG/cdPENDao2M+k+h+nKDeaJyM/tad1QhZ4bB6xq2NHFLocj
         uYHaj5xEXSVlXSxqtpASjlWGfdVisFpJ5fXO0X+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 110/151] drm/i915: Only access SFC_DONE when media domain is not fused off
Date:   Mon, 16 Aug 2021 15:02:20 +0200
Message-Id: <20210816125447.685646043@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matt Roper <matthew.d.roper@intel.com>

[ Upstream commit 24d032e2359e3abc926b3d423f49a7c33e0b7836 ]

The SFC_DONE register lives within the corresponding VD0/VD2/VD4/VD6
forcewake domain and is not accessible if the vdbox in that domain is
fused off and the forcewake is not initialized.

This mistake went unnoticed because until recently we were using the
wrong register offset for the SFC_DONE register; once the register
offset was corrected, we started hitting errors like

  <4> [544.989065] i915 0000:cc:00.0: Uninitialized forcewake domain(s) 0x80 accessed at 0x1ce000

on parts with fused-off vdbox engines.

Fixes: e50dbdbfd9fb ("drm/i915/tgl: Add SFC instdone to error state")
Fixes: 9c9c6d0ab08a ("drm/i915: Correct SFC_DONE register offset")
Cc: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210806174130.1058960-1-matthew.d.roper@intel.com
Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
(cherry picked from commit c5589bb5dccb0c5cb74910da93663f489589f3ce)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
[Changed Fixes tag to match the cherry-picked 82929a2140eb]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/i915_gpu_error.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_gpu_error.c b/drivers/gpu/drm/i915/i915_gpu_error.c
index bb181fe5d47e..725f241a428c 100644
--- a/drivers/gpu/drm/i915/i915_gpu_error.c
+++ b/drivers/gpu/drm/i915/i915_gpu_error.c
@@ -728,9 +728,18 @@ static void err_print_gt(struct drm_i915_error_state_buf *m,
 	if (INTEL_GEN(m->i915) >= 12) {
 		int i;
 
-		for (i = 0; i < GEN12_SFC_DONE_MAX; i++)
+		for (i = 0; i < GEN12_SFC_DONE_MAX; i++) {
+			/*
+			 * SFC_DONE resides in the VD forcewake domain, so it
+			 * only exists if the corresponding VCS engine is
+			 * present.
+			 */
+			if (!HAS_ENGINE(gt->_gt, _VCS(i * 2)))
+				continue;
+
 			err_printf(m, "  SFC_DONE[%d]: 0x%08x\n", i,
 				   gt->sfc_done[i]);
+		}
 
 		err_printf(m, "  GAM_DONE: 0x%08x\n", gt->gam_done);
 	}
@@ -1586,6 +1595,14 @@ static void gt_record_regs(struct intel_gt_coredump *gt)
 
 	if (INTEL_GEN(i915) >= 12) {
 		for (i = 0; i < GEN12_SFC_DONE_MAX; i++) {
+			/*
+			 * SFC_DONE resides in the VD forcewake domain, so it
+			 * only exists if the corresponding VCS engine is
+			 * present.
+			 */
+			if (!HAS_ENGINE(gt->_gt, _VCS(i * 2)))
+				continue;
+
 			gt->sfc_done[i] =
 				intel_uncore_read(uncore, GEN12_SFC_DONE(i));
 		}
-- 
2.30.2



