Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4E6F47E3
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 12:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387926AbfKHLx1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:53:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:34696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391418AbfKHLqo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:46:44 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF2DC21D82;
        Fri,  8 Nov 2019 11:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213604;
        bh=t1Z6oANTD0sjrIAyHNoQs/W7em2+BiiEHXb/QECHPfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P4tNmVRIW/SnsbfChuz8KtS+b11vu45FRYueBhqkRqHQf215ml+u6gNTjlyXnix5c
         +VQ5q5gEmNkyYVzg8ztMiMRnn6WH0piza5FxMp9/S5PVN/anqPD6BNilM/F+IKsDXH
         zCslpIgKSUt1xgUyaBidVPmaBrI+zoHkfqSNhfV0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 42/64] ARM: imx6: register pm_power_off handler if "fsl,pmic-stby-poweroff" is set
Date:   Fri,  8 Nov 2019 06:45:23 -0500
Message-Id: <20191108114545.15351-42-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114545.15351-1-sashal@kernel.org>
References: <20191108114545.15351-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 8148d2136002da2e2887caf6a07bbd9c033f14f3 ]

One of the Freescale recommended sequences for power off with external
PMIC is the following:
...
3.  SoC is programming PMIC for power off when standby is asserted.
4.  In CCM STOP mode, Standby is asserted, PMIC gates SoC supplies.

See:
http://www.nxp.com/assets/documents/data/en/reference-manuals/IMX6DQRM.pdf
page 5083

This patch implements step 4. of this sequence.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-imx/pm-imx6.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/arch/arm/mach-imx/pm-imx6.c b/arch/arm/mach-imx/pm-imx6.c
index 1515e498d348c..dd9eb3f14f45c 100644
--- a/arch/arm/mach-imx/pm-imx6.c
+++ b/arch/arm/mach-imx/pm-imx6.c
@@ -602,6 +602,28 @@ static void __init imx6_pm_common_init(const struct imx6_pm_socdata
 				   IMX6Q_GPR1_GINT);
 }
 
+static void imx6_pm_stby_poweroff(void)
+{
+	imx6_set_lpm(STOP_POWER_OFF);
+	imx6q_suspend_finish(0);
+
+	mdelay(1000);
+
+	pr_emerg("Unable to poweroff system\n");
+}
+
+static int imx6_pm_stby_poweroff_probe(void)
+{
+	if (pm_power_off) {
+		pr_warn("%s: pm_power_off already claimed  %p %pf!\n",
+			__func__, pm_power_off, pm_power_off);
+		return -EBUSY;
+	}
+
+	pm_power_off = imx6_pm_stby_poweroff;
+	return 0;
+}
+
 void __init imx6_pm_ccm_init(const char *ccm_compat)
 {
 	struct device_node *np;
@@ -618,6 +640,9 @@ void __init imx6_pm_ccm_init(const char *ccm_compat)
 	val = readl_relaxed(ccm_base + CLPCR);
 	val &= ~BM_CLPCR_LPM;
 	writel_relaxed(val, ccm_base + CLPCR);
+
+	if (of_property_read_bool(np, "fsl,pmic-stby-poweroff"))
+		imx6_pm_stby_poweroff_probe();
 }
 
 void __init imx6q_pm_init(void)
-- 
2.20.1

