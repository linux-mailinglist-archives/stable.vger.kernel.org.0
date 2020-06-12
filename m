Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5FAE1F77C9
	for <lists+stable@lfdr.de>; Fri, 12 Jun 2020 14:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbgFLMRf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jun 2020 08:17:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:3452 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbgFLMRf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jun 2020 08:17:35 -0400
IronPort-SDR: qbShTmu3K2ehklve2pQkVI0tVCYGT1YpkZ2UQX1886Np6Hdtvj0YvVmLhFokwcv7c3BwnaqRK9
 NSHCkM9NQWbQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2020 05:17:34 -0700
IronPort-SDR: SwHtQ8trcoBQgNu1CGmSQWMBZgbqjmNI/e/W8NWq0xJ6qjxJXTkiSSQx/MZL/R9Jj6iyikSWZ8
 PPptG5tFNhhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,503,1583222400"; 
   d="scan'208";a="271890504"
Received: from ideak-desk.fi.intel.com ([10.237.72.183])
  by orsmga003.jf.intel.com with ESMTP; 12 Jun 2020 05:17:32 -0700
From:   Imre Deak <imre.deak@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     Kunal Joshi <kunal1.joshi@intel.com>, stable@vger.kernel.org
Subject: [PATCH] drm/i915/icl+: Fix hotplug interrupt disabling after storm detection
Date:   Fri, 12 Jun 2020 15:17:31 +0300
Message-Id: <20200612121731.19596-1-imre.deak@intel.com>
X-Mailer: git-send-email 2.23.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Atm, hotplug interrupts on TypeC ports are left enabled after detecting
an interrupt storm, fix this.

Reported-by: Kunal Joshi <kunal1.joshi@intel.com>
References: https://gitlab.freedesktop.org/drm/intel/-/issues/351
Bugzilla: https://gitlab.freedesktop.org/drm/intel/-/issues/1964
Cc: Kunal Joshi <kunal1.joshi@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 drivers/gpu/drm/i915/i915_irq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index 8e823ba25f5f..710224d930c5 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -3132,6 +3132,7 @@ static void gen11_hpd_irq_setup(struct drm_i915_private *dev_priv)
 
 	val = I915_READ(GEN11_DE_HPD_IMR);
 	val &= ~hotplug_irqs;
+	val |= ~enabled_irqs & hotplug_irqs;
 	I915_WRITE(GEN11_DE_HPD_IMR, val);
 	POSTING_READ(GEN11_DE_HPD_IMR);
 
-- 
2.23.1

