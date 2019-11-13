Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DECAF9E8A
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 00:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbfKLXwH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 18:52:07 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57318 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726962AbfKLXuf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 18:50:35 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iUfvd-0008IG-Pi; Tue, 12 Nov 2019 23:50:33 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iUfvc-00057S-QY; Tue, 12 Nov 2019 23:50:32 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Imre Deak" <imre.deak@intel.com>,
        "Mika Kuoppala" <mika.kuoppala@linux.intel.com>
Date:   Tue, 12 Nov 2019 23:48:11 +0000
Message-ID: <lsq.1573602477.299501581@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 14/25] drm/i915/gen8+: Add RC6 CTX corruption WA
In-Reply-To: <lsq.1573602477.548403712@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.77-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

commit 7e34f4e4aad3fd34c02b294a3cf2321adf5b4438 upstream.

In some circumstances the RC6 context can get corrupted. We can detect
this and take the required action, that is disable RC6 and runtime PM.
The HW recovers from the corrupted state after a system suspend/resume
cycle, so detect the recovery and re-enable RC6 and runtime PM.

v2: rebase (Mika)
v3:
- Move intel_suspend_gt_powersave() to the end of the GEM suspend
  sequence.
- Add commit message.
v4:
- Rebased on intel_uncore_forcewake_put(i915->uncore, ...) API
  change.
v5:
- Rebased on latest upstream gt_pm refactoring.

Signed-off-by: Imre Deak <imre.deak@intel.com>
Signed-off-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/i915_drv.c      |   4 +
 drivers/gpu/drm/i915/i915_drv.h      |   5 +
 drivers/gpu/drm/i915/i915_reg.h      |   2 +
 drivers/gpu/drm/i915/intel_display.c |   9 ++
 drivers/gpu/drm/i915/intel_drv.h     |   3 +
 drivers/gpu/drm/i915/intel_pm.c      | 146 +++++++++++++++++++++++++--
 6 files changed, 162 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -604,6 +604,8 @@ static int i915_drm_thaw_early(struct dr
 	intel_uncore_sanitize(dev);
 	intel_power_domains_init_hw(dev_priv);
 
+	i915_rc6_ctx_wa_resume(dev_priv);
+
 	return 0;
 }
 
@@ -926,6 +928,8 @@ static int i915_pm_suspend_late(struct d
 	if (drm_dev->switch_power_state == DRM_SWITCH_POWER_OFF)
 		return 0;
 
+	i915_rc6_ctx_wa_suspend(to_i915(drm_dev));
+
 	pci_disable_device(pdev);
 	pci_set_power_state(pdev, PCI_D3hot);
 
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -910,6 +910,7 @@ struct intel_gen6_power_mgmt {
 	enum { LOW_POWER, BETWEEN, HIGH_POWER } power;
 
 	bool enabled;
+	bool ctx_corrupted;
 	struct delayed_work delayed_resume_work;
 
 	/*
@@ -1959,6 +1960,10 @@ struct drm_i915_cmd_table {
 
 /* Early gen2 have a totally busted CS tlb and require pinned batches. */
 #define HAS_BROKEN_CS_TLB(dev)		(IS_I830(dev) || IS_845G(dev))
+
+#define NEEDS_RC6_CTX_CORRUPTION_WA(dev)	\
+	(IS_BROADWELL(dev) || INTEL_INFO(dev)->gen == 9)
+
 /*
  * dp aux and gmbus irq on gen4 seems to be able to generate legacy interrupts
  * even when in MSI mode. This results in spurious interrupt warnings if the
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -136,6 +136,8 @@
 #define   ECOCHK_PPGTT_WT_HSW		(0x2<<3)
 #define   ECOCHK_PPGTT_WB_HSW		(0x3<<3)
 
+#define GEN8_RC6_CTX_INFO		0x8504
+
 #define GAC_ECO_BITS			0x14090
 #define   ECOBITS_SNB_BIT		(1<<13)
 #define   ECOBITS_PPGTT_CACHE64B	(3<<8)
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -8787,6 +8787,10 @@ void intel_mark_busy(struct drm_device *
 		return;
 
 	intel_runtime_pm_get(dev_priv);
+
+	if (NEEDS_RC6_CTX_CORRUPTION_WA(dev))
+		gen6_gt_force_wake_get(dev_priv, FORCEWAKE_ALL);
+
 	i915_update_gfx_val(dev_priv);
 	dev_priv->mm.busy = true;
 }
@@ -8814,6 +8818,11 @@ void intel_mark_idle(struct drm_device *
 	if (INTEL_INFO(dev)->gen >= 6)
 		gen6_rps_idle(dev->dev_private);
 
+	if (NEEDS_RC6_CTX_CORRUPTION_WA(dev)) {
+		i915_rc6_ctx_wa_check(dev_priv);
+		gen6_gt_force_wake_put(dev_priv, FORCEWAKE_ALL);
+	}
+
 out:
 	intel_runtime_pm_put(dev_priv);
 }
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -965,6 +965,9 @@ void intel_enable_gt_powersave(struct dr
 void intel_disable_gt_powersave(struct drm_device *dev);
 void intel_reset_gt_powersave(struct drm_device *dev);
 void ironlake_teardown_rc6(struct drm_device *dev);
+bool i915_rc6_ctx_wa_check(struct drm_i915_private *i915);
+void i915_rc6_ctx_wa_suspend(struct drm_i915_private *i915);
+void i915_rc6_ctx_wa_resume(struct drm_i915_private *i915);
 void gen6_update_ring_freq(struct drm_device *dev);
 void gen6_rps_idle(struct drm_i915_private *dev_priv);
 void gen6_rps_boost(struct drm_i915_private *dev_priv);
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -3378,11 +3378,17 @@ static void gen6_disable_rps_interrupts(
 	I915_WRITE(GEN6_PMIIR, dev_priv->pm_rps_events);
 }
 
-static void gen6_disable_rps(struct drm_device *dev)
+static void gen6_disable_rc6(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 
 	I915_WRITE(GEN6_RC_CONTROL, 0);
+}
+
+static void gen6_disable_rps(struct drm_device *dev)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
+
 	I915_WRITE(GEN6_RPNSWREQ, 1 << 31);
 
 	if (IS_BROADWELL(dev))
@@ -3391,12 +3397,15 @@ static void gen6_disable_rps(struct drm_
 		gen6_disable_rps_interrupts(dev);
 }
 
-static void valleyview_disable_rps(struct drm_device *dev)
+static void valleyview_disable_rc6(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 
 	I915_WRITE(GEN6_RC_CONTROL, 0);
+}
 
+static void valleyview_disable_rps(struct drm_device *dev)
+{
 	gen6_disable_rps_interrupts(dev);
 }
 
@@ -3529,7 +3538,8 @@ static void gen8_enable_rps(struct drm_d
 	I915_WRITE(GEN6_RC6_THRESHOLD, 50000); /* 50/125ms per EI */
 
 	/* 3: Enable RC6 */
-	if (intel_enable_rc6(dev) & INTEL_RC6_ENABLE)
+	if (!dev_priv->rps.ctx_corrupted &&
+	    intel_enable_rc6(dev) & INTEL_RC6_ENABLE)
 		rc6_mask = GEN6_RC_CTL_RC6_ENABLE;
 	intel_print_rc6_info(dev, rc6_mask);
 	I915_WRITE(GEN6_RC_CONTROL, GEN6_RC_CTL_HW_ENABLE |
@@ -4707,10 +4717,103 @@ static void intel_init_emon(struct drm_d
 	dev_priv->ips.corr = (lcfuse & LCFUSE_HIV_MASK);
 }
 
+static bool i915_rc6_ctx_corrupted(struct drm_i915_private *dev_priv)
+{
+	return !I915_READ(GEN8_RC6_CTX_INFO);
+}
+
+static void i915_rc6_ctx_wa_init(struct drm_i915_private *i915)
+{
+	if (!NEEDS_RC6_CTX_CORRUPTION_WA(i915->dev))
+		return;
+
+	if (i915_rc6_ctx_corrupted(i915)) {
+		DRM_INFO("RC6 context corrupted, disabling runtime power management\n");
+		i915->rps.ctx_corrupted = true;
+		intel_runtime_pm_get(i915);
+	}
+}
+
+static void i915_rc6_ctx_wa_cleanup(struct drm_i915_private *i915)
+{
+	if (i915->rps.ctx_corrupted) {
+		intel_runtime_pm_put(i915);
+		i915->rps.ctx_corrupted = false;
+	}
+}
+
+/**
+ * i915_rc6_ctx_wa_suspend - system suspend sequence for the RC6 CTX WA
+ * @i915: i915 device
+ *
+ * Perform any steps needed to clean up the RC6 CTX WA before system suspend.
+ */
+void i915_rc6_ctx_wa_suspend(struct drm_i915_private *i915)
+{
+	if (i915->rps.ctx_corrupted)
+		intel_runtime_pm_put(i915);
+}
+
+/**
+ * i915_rc6_ctx_wa_resume - system resume sequence for the RC6 CTX WA
+ * @i915: i915 device
+ *
+ * Perform any steps needed to re-init the RC6 CTX WA after system resume.
+ */
+void i915_rc6_ctx_wa_resume(struct drm_i915_private *i915)
+{
+	if (!i915->rps.ctx_corrupted)
+		return;
+
+	if (i915_rc6_ctx_corrupted(i915)) {
+		intel_runtime_pm_get(i915);
+		return;
+	}
+
+	DRM_INFO("RC6 context restored, re-enabling runtime power management\n");
+	i915->rps.ctx_corrupted = false;
+}
+
+static void intel_disable_rc6(struct drm_device *dev);
+
+/**
+ * i915_rc6_ctx_wa_check - check for a new RC6 CTX corruption
+ * @i915: i915 device
+ *
+ * Check if an RC6 CTX corruption has happened since the last check and if so
+ * disable RC6 and runtime power management.
+ *
+ * Return false if no context corruption has happened since the last call of
+ * this function, true otherwise.
+*/
+bool i915_rc6_ctx_wa_check(struct drm_i915_private *i915)
+{
+	if (!NEEDS_RC6_CTX_CORRUPTION_WA(i915->dev))
+		return false;
+
+	if (i915->rps.ctx_corrupted)
+		return false;
+
+	if (!i915_rc6_ctx_corrupted(i915))
+		return false;
+
+	printk(KERN_NOTICE "[" DRM_NAME "] "
+	       "RC6 context corruption, disabling runtime power management\n");
+
+	intel_disable_rc6(i915->dev);
+	i915->rps.ctx_corrupted = true;
+	intel_runtime_pm_get_noresume(i915);
+
+	return true;
+}
+
+
 void intel_init_gt_powersave(struct drm_device *dev)
 {
 	i915.enable_rc6 = sanitize_rc6_option(dev, i915.enable_rc6);
 
+	i915_rc6_ctx_wa_init(to_i915(dev));
+
 	if (IS_VALLEYVIEW(dev))
 		valleyview_init_gt_powersave(dev);
 }
@@ -4719,6 +4822,33 @@ void intel_cleanup_gt_powersave(struct d
 {
 	if (IS_VALLEYVIEW(dev))
 		valleyview_cleanup_gt_powersave(dev);
+
+	i915_rc6_ctx_wa_cleanup(to_i915(dev));
+}
+
+static void __intel_disable_rc6(struct drm_device *dev)
+{
+	if (IS_VALLEYVIEW(dev))
+		valleyview_disable_rc6(dev);
+	else
+		gen6_disable_rc6(dev);
+}
+
+static void intel_disable_rc6(struct drm_device *dev)
+{
+	struct drm_i915_private *dev_priv = to_i915(dev);
+
+	mutex_lock(&dev_priv->rps.hw_lock);
+	__intel_disable_rc6(dev);
+	mutex_unlock(&dev_priv->rps.hw_lock);
+}
+
+static void intel_disable_rps(struct drm_device *dev)
+{
+	if (IS_VALLEYVIEW(dev))
+		valleyview_disable_rps(dev);
+	else
+		gen6_disable_rps(dev);
 }
 
 void intel_disable_gt_powersave(struct drm_device *dev)
@@ -4736,12 +4866,14 @@ void intel_disable_gt_powersave(struct d
 			intel_runtime_pm_put(dev_priv);
 
 		cancel_work_sync(&dev_priv->rps.work);
+
 		mutex_lock(&dev_priv->rps.hw_lock);
-		if (IS_VALLEYVIEW(dev))
-			valleyview_disable_rps(dev);
-		else
-			gen6_disable_rps(dev);
+
+		__intel_disable_rc6(dev);
+		intel_disable_rps(dev);
+
 		dev_priv->rps.enabled = false;
+
 		mutex_unlock(&dev_priv->rps.hw_lock);
 	}
 }

