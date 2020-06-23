Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFD8205E14
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389844AbgFWUTn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:19:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:36850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389833AbgFWUTn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:19:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 618FF20EDD;
        Tue, 23 Jun 2020 20:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943583;
        bh=h1PD7x36mnaDW/l1YHYv9hW4HSlW4BimCrjOOY0poIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kk6WlWL+jKs9h433YyiwTYb2fHNiMPQ75gIiIb3DnXOC3mcdce6eT10U8A/dVrXDH
         CNItFhTGZjWA6//hjAtBmam9l/UmRTvnMyIeDgfOXmiaVeSw/Ut7AmxI3FYReDCM/B
         YWaoSds/8jU1RbN8F7dwT8PNvqG5fmalKJuH3mtM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kunal Joshi <kunal1.joshi@intel.com>,
        Imre Deak <imre.deak@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 5.7 449/477] drm/i915/icl+: Fix hotplug interrupt disabling after storm detection
Date:   Tue, 23 Jun 2020 21:57:26 +0200
Message-Id: <20200623195428.759539500@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
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
@@ -3092,6 +3092,7 @@ static void gen11_hpd_irq_setup(struct d
 
 	val = I915_READ(GEN11_DE_HPD_IMR);
 	val &= ~hotplug_irqs;
+	val |= ~enabled_irqs & hotplug_irqs;
 	I915_WRITE(GEN11_DE_HPD_IMR, val);
 	POSTING_READ(GEN11_DE_HPD_IMR);
 


