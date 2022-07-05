Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0B24566E2C
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238293AbiGEMbv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237993AbiGEM0x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:26:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37A5019284;
        Tue,  5 Jul 2022 05:19:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C76DB619A6;
        Tue,  5 Jul 2022 12:19:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB0FC341C7;
        Tue,  5 Jul 2022 12:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023565;
        bh=HdYYE3I5KhDfAvnpBS4PTQiqIye2bFN7nkq1ChD7oNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oWI0CAEDtyJLoe2zLARU+iio3w8Z6CD0WJFmThn/vhPvnuuXbSjKCsDTRbiJAf1ye
         w+Xp4lWxa4S2uuTT4hca6IZqheFrx01MOzgNitgebc2oh3tsElz4gwiCkH36LJuwlv
         t+NlsL7ibv1SXFXyEaANq3wgjwK5K/e8GD+FqnSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Anshuman Gupta <anshuman.gupta@intel.com>,
        Badal Nilawar <badal.nilawar@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 085/102] drm/i915/dgfx: Disable d3cold at gfx root port
Date:   Tue,  5 Jul 2022 13:58:51 +0200
Message-Id: <20220705115620.826013908@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anshuman Gupta <anshuman.gupta@intel.com>

[ Upstream commit 7d23a80dc9720a378707edc03a7275d5a372355f ]

Currently i915 disables d3cold for i915 pci dev.
This blocks D3 for i915 gfx pci upstream bridge (VSP).
Let's disable d3cold at gfx root port to make sure that
i915 gfx VSP can transition to D3 to save some power.

We don't need to disable/enable d3cold in rpm, s2idle
suspend/resume handlers. Disabling/Enabling d3cold at
gfx root port in probe/remove phase is sufficient.

Fixes: 1a085e23411d ("drm/i915: Disable D3Cold in s2idle and runtime pm")
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Anshuman Gupta <anshuman.gupta@intel.com>
Reviewed-by: Badal Nilawar <badal.nilawar@intel.com>
Acked-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220616122249.5007-1-anshuman.gupta@intel.com
(cherry picked from commit 138c2fca6f408f397ea8fbbbf33203f244d96e01)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/i915_driver.c | 34 +++++++++++++-----------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_driver.c b/drivers/gpu/drm/i915/i915_driver.c
index 62b3f332bbf5..0478fa6259eb 100644
--- a/drivers/gpu/drm/i915/i915_driver.c
+++ b/drivers/gpu/drm/i915/i915_driver.c
@@ -538,6 +538,7 @@ static int i915_set_dma_info(struct drm_i915_private *i915)
 static int i915_driver_hw_probe(struct drm_i915_private *dev_priv)
 {
 	struct pci_dev *pdev = to_pci_dev(dev_priv->drm.dev);
+	struct pci_dev *root_pdev;
 	int ret;
 
 	if (i915_inject_probe_failure(dev_priv))
@@ -651,6 +652,15 @@ static int i915_driver_hw_probe(struct drm_i915_private *dev_priv)
 
 	intel_bw_init_hw(dev_priv);
 
+	/*
+	 * FIXME: Temporary hammer to avoid freezing the machine on our DGFX
+	 * This should be totally removed when we handle the pci states properly
+	 * on runtime PM and on s2idle cases.
+	 */
+	root_pdev = pcie_find_root_port(pdev);
+	if (root_pdev)
+		pci_d3cold_disable(root_pdev);
+
 	return 0;
 
 err_msi:
@@ -674,11 +684,16 @@ static int i915_driver_hw_probe(struct drm_i915_private *dev_priv)
 static void i915_driver_hw_remove(struct drm_i915_private *dev_priv)
 {
 	struct pci_dev *pdev = to_pci_dev(dev_priv->drm.dev);
+	struct pci_dev *root_pdev;
 
 	i915_perf_fini(dev_priv);
 
 	if (pdev->msi_enabled)
 		pci_disable_msi(pdev);
+
+	root_pdev = pcie_find_root_port(pdev);
+	if (root_pdev)
+		pci_d3cold_enable(root_pdev);
 }
 
 /**
@@ -1195,14 +1210,6 @@ static int i915_drm_suspend_late(struct drm_device *dev, bool hibernation)
 		goto out;
 	}
 
-	/*
-	 * FIXME: Temporary hammer to avoid freezing the machine on our DGFX
-	 * This should be totally removed when we handle the pci states properly
-	 * on runtime PM and on s2idle cases.
-	 */
-	if (suspend_to_idle(dev_priv))
-		pci_d3cold_disable(pdev);
-
 	pci_disable_device(pdev);
 	/*
 	 * During hibernation on some platforms the BIOS may try to access
@@ -1367,8 +1374,6 @@ static int i915_drm_resume_early(struct drm_device *dev)
 
 	pci_set_master(pdev);
 
-	pci_d3cold_enable(pdev);
-
 	disable_rpm_wakeref_asserts(&dev_priv->runtime_pm);
 
 	ret = vlv_resume_prepare(dev_priv, false);
@@ -1545,7 +1550,6 @@ static int intel_runtime_suspend(struct device *kdev)
 {
 	struct drm_i915_private *dev_priv = kdev_to_i915(kdev);
 	struct intel_runtime_pm *rpm = &dev_priv->runtime_pm;
-	struct pci_dev *pdev = to_pci_dev(dev_priv->drm.dev);
 	int ret;
 
 	if (drm_WARN_ON_ONCE(&dev_priv->drm, !HAS_RUNTIME_PM(dev_priv)))
@@ -1591,12 +1595,6 @@ static int intel_runtime_suspend(struct device *kdev)
 		drm_err(&dev_priv->drm,
 			"Unclaimed access detected prior to suspending\n");
 
-	/*
-	 * FIXME: Temporary hammer to avoid freezing the machine on our DGFX
-	 * This should be totally removed when we handle the pci states properly
-	 * on runtime PM and on s2idle cases.
-	 */
-	pci_d3cold_disable(pdev);
 	rpm->suspended = true;
 
 	/*
@@ -1635,7 +1633,6 @@ static int intel_runtime_resume(struct device *kdev)
 {
 	struct drm_i915_private *dev_priv = kdev_to_i915(kdev);
 	struct intel_runtime_pm *rpm = &dev_priv->runtime_pm;
-	struct pci_dev *pdev = to_pci_dev(dev_priv->drm.dev);
 	int ret;
 
 	if (drm_WARN_ON_ONCE(&dev_priv->drm, !HAS_RUNTIME_PM(dev_priv)))
@@ -1648,7 +1645,6 @@ static int intel_runtime_resume(struct device *kdev)
 
 	intel_opregion_notify_adapter(dev_priv, PCI_D0);
 	rpm->suspended = false;
-	pci_d3cold_enable(pdev);
 	if (intel_uncore_unclaimed_mmio(&dev_priv->uncore))
 		drm_dbg(&dev_priv->drm,
 			"Unclaimed access during suspend, bios?\n");
-- 
2.35.1



