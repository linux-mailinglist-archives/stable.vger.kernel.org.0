Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1EF413A5D9
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729367AbgANKEE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:04:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:59338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728944AbgANKEE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:04:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1EA62465B;
        Tue, 14 Jan 2020 10:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996243;
        bh=W5N6q/aieE9QO/Hc3x5iSQ/MBUSQsGG6v/4EOBiiYiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ccz4U9bfaE2fqI89h3VItU1xwOHBlW8Coc/peph/KjaC44Uzhj475vfAoJgQbejnd
         gaxwS+F/0TPWoG5SXuarbPCtkb/iXmYLcrFC0Mps4NFG57/haq7T4z5FCsRaYJeMlj
         dm+9863OX7DE2Hi7E/mSjfFyFGmo6N84GAde7nPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Matt Atwood <matthew.s.atwood@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 5.4 29/78] drm/i915: Add Wa_1407352427:icl,ehl
Date:   Tue, 14 Jan 2020 11:01:03 +0100
Message-Id: <20200114094357.587657283@linuxfoundation.org>
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

commit 25b79ad51bf04a8aa67b5bccd631fc05f963b8e0 upstream.

The workaround database now indicates we need to disable psdunit clock
gating as well.

v3:
 - Rebase on top of other workarounds that have landed.
 - Restrict cc:stable tag to 5.2+ since that's when ICL was first
   officially supported.

Bspec: 32354
Bspec: 33450
Bspec: 33451
Suggested-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Cc: stable@vger.kernel.org # v5.2+
Cc: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Matt Atwood <matthew.s.atwood@intel.com>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Acked-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20191231190713.1549533-1-matthew.d.roper@intel.com
(cherry picked from commit 1cd21a7c5679015352e8a6f46813aced51d71bb8)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_reg.h |    4 ++++
 drivers/gpu/drm/i915/intel_pm.c |    3 +++
 2 files changed, 7 insertions(+)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -4053,6 +4053,10 @@ enum {
 #define   HSUNIT_CLKGATE_DIS		REG_BIT(8)
 #define   VSUNIT_CLKGATE_DIS		REG_BIT(3)
 
+#define UNSLICE_UNIT_LEVEL_CLKGATE2	_MMIO(0x94e4)
+#define   VSUNIT_CLKGATE_DIS_TGL	REG_BIT(19)
+#define   PSDUNIT_CLKGATE_DIS		REG_BIT(5)
+
 #define INF_UNIT_LEVEL_CLKGATE		_MMIO(0x9560)
 #define   CGPSF_CLKGATE_DIS		(1 << 3)
 
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -9202,6 +9202,9 @@ static void icl_init_clock_gating(struct
 	intel_uncore_rmw(&dev_priv->uncore, UNSLICE_UNIT_LEVEL_CLKGATE,
 			 0, VSUNIT_CLKGATE_DIS | HSUNIT_CLKGATE_DIS);
 
+	/* Wa_1407352427:icl,ehl */
+	intel_uncore_rmw(&dev_priv->uncore, UNSLICE_UNIT_LEVEL_CLKGATE2,
+			 0, PSDUNIT_CLKGATE_DIS);
 }
 
 static void cnp_init_clock_gating(struct drm_i915_private *dev_priv)


