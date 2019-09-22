Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68576BA6BA
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388591AbfIVSwb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:52:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407910AbfIVSwa (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:52:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DA0B21A4A;
        Sun, 22 Sep 2019 18:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178349;
        bh=WytRyuAeD8r+lZci6Ro91yBin+ytXB3SZAzTOmA8unM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GQ8mptiwOmtKUUWalX/TeZ9JYmNjrYE3WNWcNDMn8B1QML1IdmPbJb9eAxEwpBSJ/
         b5+6XGgtHQB+za1N7OTxmkyhwcKlWHrmytjIXfWQv4syRU5fndjZ4gnb6BO+QhcxdU
         FclBDJ/SZ/W3eIRu2j6P4vyxoE67ndIiis4ZyeHs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 106/185] soc: renesas: rmobile-sysc: Set GENPD_FLAG_ALWAYS_ON for always-on domain
Date:   Sun, 22 Sep 2019 14:48:04 -0400
Message-Id: <20190922184924.32534-106-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184924.32534-1-sashal@kernel.org>
References: <20190922184924.32534-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit af0bc634728c0bc6a3f66f911f227d5c6396db88 ]

Currently the R-Mobile "always-on" PM Domain is implemented by returning
-EBUSY from the generic_pm_domain.power_off() callback, and doing
nothing in the generic_pm_domain.power_on() callback.  However, this
means the PM Domain core code is not aware of the semantics of this
special domain, leading to boot warnings like the following on
SH/R-Mobile SoCs:

    sh_cmt e6130000.timer: PM domain c5 will not be powered off

Fix this by making the always-on nature of the domain explicit instead,
by setting the GENPD_FLAG_ALWAYS_ON flag.  This removes the need for the
domain to provide power control callbacks.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/renesas/rmobile-sysc.c | 31 +++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/soc/renesas/rmobile-sysc.c b/drivers/soc/renesas/rmobile-sysc.c
index 421ae1c887d82..54b616ad4a62a 100644
--- a/drivers/soc/renesas/rmobile-sysc.c
+++ b/drivers/soc/renesas/rmobile-sysc.c
@@ -48,12 +48,8 @@ struct rmobile_pm_domain *to_rmobile_pd(struct generic_pm_domain *d)
 static int rmobile_pd_power_down(struct generic_pm_domain *genpd)
 {
 	struct rmobile_pm_domain *rmobile_pd = to_rmobile_pd(genpd);
-	unsigned int mask;
+	unsigned int mask = BIT(rmobile_pd->bit_shift);
 
-	if (rmobile_pd->bit_shift == ~0)
-		return -EBUSY;
-
-	mask = BIT(rmobile_pd->bit_shift);
 	if (rmobile_pd->suspend) {
 		int ret = rmobile_pd->suspend();
 
@@ -80,14 +76,10 @@ static int rmobile_pd_power_down(struct generic_pm_domain *genpd)
 
 static int __rmobile_pd_power_up(struct rmobile_pm_domain *rmobile_pd)
 {
-	unsigned int mask;
+	unsigned int mask = BIT(rmobile_pd->bit_shift);
 	unsigned int retry_count;
 	int ret = 0;
 
-	if (rmobile_pd->bit_shift == ~0)
-		return 0;
-
-	mask = BIT(rmobile_pd->bit_shift);
 	if (__raw_readl(rmobile_pd->base + PSTR) & mask)
 		return ret;
 
@@ -122,11 +114,15 @@ static void rmobile_init_pm_domain(struct rmobile_pm_domain *rmobile_pd)
 	struct dev_power_governor *gov = rmobile_pd->gov;
 
 	genpd->flags |= GENPD_FLAG_PM_CLK | GENPD_FLAG_ACTIVE_WAKEUP;
-	genpd->power_off		= rmobile_pd_power_down;
-	genpd->power_on			= rmobile_pd_power_up;
-	genpd->attach_dev		= cpg_mstp_attach_dev;
-	genpd->detach_dev		= cpg_mstp_detach_dev;
-	__rmobile_pd_power_up(rmobile_pd);
+	genpd->attach_dev = cpg_mstp_attach_dev;
+	genpd->detach_dev = cpg_mstp_detach_dev;
+
+	if (!(genpd->flags & GENPD_FLAG_ALWAYS_ON)) {
+		genpd->power_off = rmobile_pd_power_down;
+		genpd->power_on = rmobile_pd_power_up;
+		__rmobile_pd_power_up(rmobile_pd);
+	}
+
 	pm_genpd_init(genpd, gov ? : &simple_qos_governor, false);
 }
 
@@ -270,6 +266,11 @@ static void __init rmobile_setup_pm_domain(struct device_node *np,
 		break;
 
 	case PD_NORMAL:
+		if (pd->bit_shift == ~0) {
+			/* Top-level always-on domain */
+			pr_debug("PM domain %s is always-on domain\n", name);
+			pd->genpd.flags |= GENPD_FLAG_ALWAYS_ON;
+		}
 		break;
 	}
 
-- 
2.20.1

