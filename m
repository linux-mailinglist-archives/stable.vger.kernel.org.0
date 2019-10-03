Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2270BCA9B4
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392902AbfJCQqb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:46:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:59784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390968AbfJCQqa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:46:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFFDE20867;
        Thu,  3 Oct 2019 16:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121189;
        bh=WytRyuAeD8r+lZci6Ro91yBin+ytXB3SZAzTOmA8unM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MgIqBvpBRM2a9z7524KBSwXdEXMOKdKM7zSpjkvsjN8WX2rkEaNGa6Nl3liZbbqam
         f+VXGHwaHB7ZdVW79TOPiqxLWUroj/Yla+FacUY3qh8H5mKopVY72WcXSIxuhwiaMg
         sS/yaxfivVTxK0W02TcCbAm3XR+zDkJbgxacaIFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 150/344] soc: renesas: rmobile-sysc: Set GENPD_FLAG_ALWAYS_ON for always-on domain
Date:   Thu,  3 Oct 2019 17:51:55 +0200
Message-Id: <20191003154555.056977978@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



