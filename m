Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF3F02062DA
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387767AbgFWVId (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:08:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:56766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403781AbgFWUek (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:34:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 955B42064B;
        Tue, 23 Jun 2020 20:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944481;
        bh=1OvDeqrNdnLngoQvs8UegGnHsWT0Edkwhrm/k31VQEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IsHbDZQI6yZlqtsSAhuWGBI8NPftbGf75t4B+d4NOyp0fZQUvtlqsqIKTwh+vDxzR
         +YCWbx7qB3dw3A2FrJTOB7vvd8KEGaj8fYChZu1rEBPDc6kpGgSp1h4J0Rz5zdvHt9
         hrXMKR8TW9MZUhU56Iu8G5cdcMxHm2uJo+Jr2Riw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kunal Joshi <kunal1.joshi@intel.com>,
        Imre Deak <imre.deak@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 5.4 303/314] drm/i915/icl+: Fix hotplug interrupt disabling after storm detection
Date:   Tue, 23 Jun 2020 21:58:18 +0200
Message-Id: <20200623195353.449491429@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Imre Deak <imre.deak@intel.com>

commit a3005c2edf7e8c3478880db1ca84028a2b6819bb upstream.

Atm, hotplug interrupts on TypeC ports are left enabled after detecting
an interrupt storm, fix this.

Reported-by: Kunal Joshi <kunal1.joshi@intel.com>
Bugzilla: https://gitlab.freedesktop.org/drm/intel/-/issues/1964
Cc: Kunal Joshi <kunal1.joshi@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200612121731.19596-1-imre.deak@intel.com
(cherry picked from commit 587a87b9d7e94927edcdea018565bc1939381eb1)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_irq.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -3500,6 +3500,7 @@ static void gen11_hpd_irq_setup(struct d
 
 	val = I915_READ(GEN11_DE_HPD_IMR);
 	val &= ~hotplug_irqs;
+	val |= ~enabled_irqs & hotplug_irqs;
 	I915_WRITE(GEN11_DE_HPD_IMR, val);
 	POSTING_READ(GEN11_DE_HPD_IMR);
 


