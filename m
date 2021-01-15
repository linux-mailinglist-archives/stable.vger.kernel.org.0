Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1B92F79F4
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732271AbhAOMjQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:39:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:46440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732533AbhAOMjP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:39:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E0F82333E;
        Fri, 15 Jan 2021 12:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714339;
        bh=O1WTyTpbWUOyifY9/6ViHB5aRX4OdMR5v6FP+mkiBVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GQSxovAWppe7UygbxM/ywAHXHNoxPecbKBCLAW9Hl+GLYv94b1VueaGX+RzY0lj+4
         5bReAwJFcyZihlgBYRARAZXLfRaSNpOvcbMzGs2eWxmmQssM84aj0SdTaWJINEa1d2
         n8oi2+CNQggJzvHnCZKxdZzR1aBnEoCdiIy2Ew5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Imre Deak <imre.deak@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.10 091/103] drm/i915/dp: Track pm_qos per connector
Date:   Fri, 15 Jan 2021 13:28:24 +0100
Message-Id: <20210115122010.415612934@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 9397d66212cdf7a21c66523f1583e5d63a609e84 upstream.

Since multiple connectors may run intel_dp_aux_xfer conncurrently, a
single global pm_qos does not suffice. (One connector may disable the
dma-latency boost prematurely while the second is still depending on
it.) Instead of a single global pm_qos, track the pm_qos request for
each intel_dp.

v2: Move the pm_qos setup/teardown to intel_dp_aux_init/fini

Fixes: 9ee32fea5fe8 ("drm/i915: irq-drive the dp aux communication")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Imre Deak <imre.deak@intel.com>
Reviewed-by: Imre Deak <imre.deak@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201230202309.23982-1-chris@chris-wilson.co.uk
(cherry picked from commit b3304591f14b437b6bccd8dbff06006c11837031)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/display/intel_display_types.h |    3 +++
 drivers/gpu/drm/i915/display/intel_dp.c            |    8 ++++++--
 drivers/gpu/drm/i915/i915_drv.c                    |    5 -----
 drivers/gpu/drm/i915/i915_drv.h                    |    3 ---
 4 files changed, 9 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_display_types.h
+++ b/drivers/gpu/drm/i915/display/intel_display_types.h
@@ -1382,6 +1382,9 @@ struct intel_dp {
 		bool ycbcr_444_to_420;
 	} dfp;
 
+	/* To control wakeup latency, e.g. for irq-driven dp aux transfers. */
+	struct pm_qos_request pm_qos;
+
 	/* Display stream compression testing */
 	bool force_dsc_en;
 
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -1411,7 +1411,7 @@ intel_dp_aux_xfer(struct intel_dp *intel
 	 * lowest possible wakeup latency and so prevent the cpu from going into
 	 * deep sleep states.
 	 */
-	cpu_latency_qos_update_request(&i915->pm_qos, 0);
+	cpu_latency_qos_update_request(&intel_dp->pm_qos, 0);
 
 	intel_dp_check_edp(intel_dp);
 
@@ -1544,7 +1544,7 @@ done:
 
 	ret = recv_bytes;
 out:
-	cpu_latency_qos_update_request(&i915->pm_qos, PM_QOS_DEFAULT_VALUE);
+	cpu_latency_qos_update_request(&intel_dp->pm_qos, PM_QOS_DEFAULT_VALUE);
 
 	if (vdd)
 		edp_panel_vdd_off(intel_dp, false);
@@ -1776,6 +1776,9 @@ static i915_reg_t skl_aux_data_reg(struc
 static void
 intel_dp_aux_fini(struct intel_dp *intel_dp)
 {
+	if (cpu_latency_qos_request_active(&intel_dp->pm_qos))
+		cpu_latency_qos_remove_request(&intel_dp->pm_qos);
+
 	kfree(intel_dp->aux.name);
 }
 
@@ -1818,6 +1821,7 @@ intel_dp_aux_init(struct intel_dp *intel
 				       aux_ch_name(dig_port->aux_ch),
 				       port_name(encoder->port));
 	intel_dp->aux.transfer = intel_dp_aux_transfer;
+	cpu_latency_qos_add_request(&intel_dp->pm_qos, PM_QOS_DEFAULT_VALUE);
 }
 
 bool intel_dp_source_supports_hbr2(struct intel_dp *intel_dp)
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -577,8 +577,6 @@ static int i915_driver_hw_probe(struct d
 
 	pci_set_master(pdev);
 
-	cpu_latency_qos_add_request(&dev_priv->pm_qos, PM_QOS_DEFAULT_VALUE);
-
 	intel_gt_init_workarounds(dev_priv);
 
 	/* On the 945G/GM, the chipset reports the MSI capability on the
@@ -623,7 +621,6 @@ static int i915_driver_hw_probe(struct d
 err_msi:
 	if (pdev->msi_enabled)
 		pci_disable_msi(pdev);
-	cpu_latency_qos_remove_request(&dev_priv->pm_qos);
 err_mem_regions:
 	intel_memory_regions_driver_release(dev_priv);
 err_ggtt:
@@ -645,8 +642,6 @@ static void i915_driver_hw_remove(struct
 
 	if (pdev->msi_enabled)
 		pci_disable_msi(pdev);
-
-	cpu_latency_qos_remove_request(&dev_priv->pm_qos);
 }
 
 /**
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -892,9 +892,6 @@ struct drm_i915_private {
 
 	bool display_irqs_enabled;
 
-	/* To control wakeup latency, e.g. for irq-driven dp aux transfers. */
-	struct pm_qos_request pm_qos;
-
 	/* Sideband mailbox protection */
 	struct mutex sb_lock;
 	struct pm_qos_request sb_qos;


