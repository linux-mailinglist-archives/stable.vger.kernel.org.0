Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76B465F299F
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbiJCHWh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbiJCHVv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:21:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA33649B6D;
        Mon,  3 Oct 2022 00:16:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A85F6B80E6F;
        Mon,  3 Oct 2022 07:15:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13871C433D6;
        Mon,  3 Oct 2022 07:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781354;
        bh=DueJoZj4Ew6wuAWyr3FPZ4L4bjUI7T+MCT44ahsb0RY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1mzeiXS5i2ykyUx1RsjRSBv/Aq1WpMhdLGCsfKGtO8mRaXSY00V4yZ1n0+RRXAd5U
         vzbFs+gVAv8W3sU1HgUg11SXJh8jgIxx20ZG5psvsVRVMl1G5dKZv/aneBMNBEoHSC
         hHAuJS8sKcKoydZt/vJJpeMj4NFl9ASLmPhpstZ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 091/101] drm/i915/gt: Perf_limit_reasons are only available for Gen11+
Date:   Mon,  3 Oct 2022 09:11:27 +0200
Message-Id: <20221003070726.704306583@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ashutosh Dixit <ashutosh.dixit@intel.com>

[ Upstream commit 7738be973fc4e2ba22154fafd3a5d7b9666f9abf ]

Register GT0_PERF_LIMIT_REASONS (0x1381a8) is available only for
Gen11+. Therefore ensure perf_limit_reasons sysfs files are created only
for Gen11+. Otherwise on Gen < 5 accessing these files results in the
following oops:

<1> [88.829420] BUG: unable to handle page fault for address: ffffc90000bb81a8
<1> [88.829438] #PF: supervisor read access in kernel mode
<1> [88.829447] #PF: error_code(0x0000) - not-present page

This patch is a backport of the drm-tip commit 0d2d201095e9
("drm/i915: Perf_limit_reasons are only available for Gen11+") to
drm-intel-fixes. The backport is not identical to the original, it only
includes the sysfs portions of if. The debugfs portion is not available
in drm-intel-fixes so has not been backported.

Bspec: 20008
Bug: https://gitlab.freedesktop.org/drm/intel/-/issues/6863
Fixes: fa68bff7cf27 ("drm/i915/gt: Add sysfs throttle frequency interfaces")
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220919162401.2077713-1-ashutosh.dixit@intel.com
(backported from commit 0d2d201095e9f141d6a9fb44320afce761f8b5c2)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_gt_sysfs_pm.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_gt_sysfs_pm.c b/drivers/gpu/drm/i915/gt/intel_gt_sysfs_pm.c
index f76b6cf8040e..b8cb58e2819a 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt_sysfs_pm.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt_sysfs_pm.c
@@ -544,8 +544,7 @@ static INTEL_GT_RPS_BOOL_ATTR_RO(throttle_reason_ratl, RATL_MASK);
 static INTEL_GT_RPS_BOOL_ATTR_RO(throttle_reason_vr_thermalert, VR_THERMALERT_MASK);
 static INTEL_GT_RPS_BOOL_ATTR_RO(throttle_reason_vr_tdc, VR_TDC_MASK);
 
-static const struct attribute *freq_attrs[] = {
-	&dev_attr_punit_req_freq_mhz.attr,
+static const struct attribute *throttle_reason_attrs[] = {
 	&attr_throttle_reason_status.attr,
 	&attr_throttle_reason_pl1.attr,
 	&attr_throttle_reason_pl2.attr,
@@ -594,9 +593,17 @@ void intel_gt_sysfs_pm_init(struct intel_gt *gt, struct kobject *kobj)
 	if (!is_object_gt(kobj))
 		return;
 
-	ret = sysfs_create_files(kobj, freq_attrs);
+	ret = sysfs_create_file(kobj, &dev_attr_punit_req_freq_mhz.attr);
 	if (ret)
 		drm_warn(&gt->i915->drm,
-			 "failed to create gt%u throttle sysfs files (%pe)",
+			 "failed to create gt%u punit_req_freq_mhz sysfs (%pe)",
 			 gt->info.id, ERR_PTR(ret));
+
+	if (GRAPHICS_VER(gt->i915) >= 11) {
+		ret = sysfs_create_files(kobj, throttle_reason_attrs);
+		if (ret)
+			drm_warn(&gt->i915->drm,
+				 "failed to create gt%u throttle sysfs files (%pe)",
+				 gt->info.id, ERR_PTR(ret));
+	}
 }
-- 
2.35.1



