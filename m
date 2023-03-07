Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFE516AEA62
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbjCGRdR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:33:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231578AbjCGRcx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:32:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FBAA28235
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:28:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFBE0614D0
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:28:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7B8FC433D2;
        Tue,  7 Mar 2023 17:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210115;
        bh=MfUxuhAKXY+ENTkDF0Qsyqs6F6Tniek0qUM65TSR9ZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UWtXP3DSmBRqgouVH/st1XE4izTlPzhfbS02A64RQmAQTmXgQC105kY1tZt9T83VR
         FZTPgXKOIHSZYJnJPRPXSRzDrD3yTeGl3yOBzqGSctbYiwDp9VbitLmgDM0dqP6XQS
         az1z9ZJHrWocGTbV6TK0llcVgoXkBKSZpRFmbWOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wayne Boyer <wayne.boyer@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0438/1001] drm/i915/pvc: Implement recommended caching policy
Date:   Tue,  7 Mar 2023 17:53:30 +0100
Message-Id: <20230307170040.366549124@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wayne Boyer <wayne.boyer@intel.com>

[ Upstream commit e3995e08a39a41691742b380023a0d480247afb0 ]

As per the performance tuning guide, set the HOSTCACHEEN bit to
implement the recommended caching policy on PVC.

Signed-off-by: Wayne Boyer <wayne.boyer@intel.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221130170723.2460014-1-wayne.boyer@intel.com
Stable-dep-of: effc0905d741 ("drm/i915/pvc: Annotate two more workaround/tuning registers as MCR")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_gt_regs.h     | 1 +
 drivers/gpu/drm/i915/gt/intel_workarounds.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/i915/gt/intel_gt_regs.h b/drivers/gpu/drm/i915/gt/intel_gt_regs.h
index 0c7e7972cc1c4..838f73165ebbc 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt_regs.h
+++ b/drivers/gpu/drm/i915/gt/intel_gt_regs.h
@@ -970,6 +970,7 @@
 #define   GEN7_L3AGDIS				(1 << 19)
 
 #define XEHPC_LNCFMISCCFGREG0			_MMIO(0xb01c)
+#define   XEHPC_HOSTCACHEEN			REG_BIT(1)
 #define   XEHPC_OVRLSCCC			REG_BIT(0)
 
 #define GEN7_L3CNTLREG2				_MMIO(0xb020)
diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
index dcc694b8bc8c7..c2d9d07af7ee9 100644
--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -2973,6 +2973,7 @@ add_render_compute_tuning_settings(struct drm_i915_private *i915,
 	if (IS_PONTEVECCHIO(i915)) {
 		wa_write(wal, XEHPC_L3SCRUB,
 			 SCRUB_CL_DWNGRADE_SHARED | SCRUB_RATE_4B_PER_CLK);
+		wa_masked_en(wal, XEHPC_LNCFMISCCFGREG0, XEHPC_HOSTCACHEEN);
 	}
 
 	if (IS_DG2(i915)) {
-- 
2.39.2



