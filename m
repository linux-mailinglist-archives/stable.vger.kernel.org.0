Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAF9D15F35E
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403970AbgBNSK5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 13:10:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:32910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730866AbgBNPxh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:53:37 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CB2824686;
        Fri, 14 Feb 2020 15:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695617;
        bh=PQOkeAtDCq+cjqGZA9ta64157BXnd9PeZOgV32vNY80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uQWCRfvBEtzOI+Fuax8+z5ke8jGEcJ7/olaBOeZzGgUPkDCkdUqhceewNRSbqCNT+
         va48EFwswRhlNnBgmT9jEZ91ERbOqCJt6uQeElwkFAjybU98iYmR9uZkh0yIL+IyTu
         ebkje0kjz7TtRG80VmvkCQXo1z+y0SBf9ADVl438=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tero Kristo <t-kristo@ti.com>, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.5 217/542] ARM: OMAP2+: pdata-quirks: add PRM data for reset support
Date:   Fri, 14 Feb 2020 10:43:29 -0500
Message-Id: <20200214154854.6746-217-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tero Kristo <t-kristo@ti.com>

[ Upstream commit 8de44fb70659a5bc0c53a443e6129ea1bf00fd8b ]

The parent clockdomain for reset must be in force wakeup mode, otherwise
the reset may never complete. Add pdata quirks for this purpose for PRM
driver.

Signed-off-by: Tero Kristo <t-kristo@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/pdata-quirks.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/mach-omap2/pdata-quirks.c b/arch/arm/mach-omap2/pdata-quirks.c
index e95c224ffc4d8..7a79bcc02a11b 100644
--- a/arch/arm/mach-omap2/pdata-quirks.c
+++ b/arch/arm/mach-omap2/pdata-quirks.c
@@ -23,6 +23,7 @@
 #include <linux/platform_data/ti-sysc.h>
 #include <linux/platform_data/wkup_m3.h>
 #include <linux/platform_data/asoc-ti-mcbsp.h>
+#include <linux/platform_data/ti-prm.h>
 
 #include "clockdomain.h"
 #include "common.h"
@@ -412,6 +413,12 @@ void omap_pcs_legacy_init(int irq, void (*rearm)(void))
 	pcs_pdata.rearm = rearm;
 }
 
+static struct ti_prm_platform_data ti_prm_pdata = {
+	.clkdm_deny_idle = clkdm_deny_idle,
+	.clkdm_allow_idle = clkdm_allow_idle,
+	.clkdm_lookup = clkdm_lookup,
+};
+
 /*
  * GPIOs for TWL are initialized by the I2C bus and need custom
  * handing until DSS has device tree bindings.
@@ -514,6 +521,7 @@ static struct of_dev_auxdata omap_auxdata_lookup[] = {
 	/* Common auxdata */
 	OF_DEV_AUXDATA("ti,sysc", 0, NULL, &ti_sysc_pdata),
 	OF_DEV_AUXDATA("pinctrl-single", 0, NULL, &pcs_pdata),
+	OF_DEV_AUXDATA("ti,omap-prm-inst", 0, NULL, &ti_prm_pdata),
 	{ /* sentinel */ },
 };
 
-- 
2.20.1

