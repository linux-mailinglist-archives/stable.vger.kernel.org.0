Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 948C913A72E
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729224AbgANKT7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:19:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:60574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729930AbgANKEo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:04:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 731632465B;
        Tue, 14 Jan 2020 10:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996284;
        bh=nkghoqy5PO1R0vFhiLup2ZoVuVgw26sLl6ZOwSh8jKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fuf4EhHfoWPDvIblSxtsrvXswuagIGkL416fh0FSWY/csCMnirhGsLe+J8FlLxcJG
         FBjc16X4aiOJeHEVdRrMTWihoy0iUJqPBvEM+i8j/L+Fuxj5TmKjLDWl7nSQAlRH9c
         UV7xiE5JKhADEziTwbKRF0uYd5HHm/+w0Hh4nF34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.vger.org,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Matt Atwood <matthew.s.atwood@intel.com>,
        Radhakrishna Sripada <radhakrishna.sripada@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 5.4 23/78] drm/i915: Add Wa_1408615072 and Wa_1407596294 to icl,ehl
Date:   Tue, 14 Jan 2020 11:00:57 +0100
Message-Id: <20200114094356.857631672@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094352.428808181@linuxfoundation.org>
References: <20200114094352.428808181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matt Roper <matthew.d.roper@intel.com>

commit a7f3ad37f80d0d5eec9dad156964c0dac800a80e upstream.

Workaround database indicates we should disable clock gating of both the
vsunit and hsunit.

Bspec: 33450
Bspec: 33451
Cc: stable@kernel.vger.org
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Matt Atwood <matthew.s.atwood@intel.com>
Cc: Radhakrishna Sripada <radhakrishna.sripada@intel.com>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20191224012026.3157766-3-matthew.d.roper@intel.com
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit b9cf9dac3dac4c1d2a47d34f30ec53c0423cecf8)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_reg.h |    4 +++-
 drivers/gpu/drm/i915/intel_pm.c |    8 ++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -4049,7 +4049,9 @@ enum {
 #define  GWUNIT_CLKGATE_DIS		(1 << 16)
 
 #define UNSLICE_UNIT_LEVEL_CLKGATE	_MMIO(0x9434)
-#define  VFUNIT_CLKGATE_DIS		(1 << 20)
+#define   VFUNIT_CLKGATE_DIS		REG_BIT(20)
+#define   HSUNIT_CLKGATE_DIS		REG_BIT(8)
+#define   VSUNIT_CLKGATE_DIS		REG_BIT(3)
 
 #define INF_UNIT_LEVEL_CLKGATE		_MMIO(0x9560)
 #define   CGPSF_CLKGATE_DIS		(1 << 3)
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -9194,6 +9194,14 @@ static void icl_init_clock_gating(struct
 	/* WaEnable32PlaneMode:icl */
 	I915_WRITE(GEN9_CSFE_CHICKEN1_RCS,
 		   _MASKED_BIT_ENABLE(GEN11_ENABLE_32_PLANE_MODE));
+
+	/*
+	 * Wa_1408615072:icl,ehl  (vsunit)
+	 * Wa_1407596294:icl,ehl  (hsunit)
+	 */
+	intel_uncore_rmw(&dev_priv->uncore, UNSLICE_UNIT_LEVEL_CLKGATE,
+			 0, VSUNIT_CLKGATE_DIS | HSUNIT_CLKGATE_DIS);
+
 }
 
 static void cnp_init_clock_gating(struct drm_i915_private *dev_priv)


