Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 616F5137F3F
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729932AbgAKKRk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:17:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:34618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728946AbgAKKRj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:17:39 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5163B205F4;
        Sat, 11 Jan 2020 10:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737858;
        bh=8HqPpUK4lbbYZ29XPFjNX0qGSsN6mCtBaDarIVX60QU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nq2tadundeYr3j3ojroYgpNy99VMFaxEMwLR+y3jSAV/nWKv4lW9RWUsdOjF23/z/
         y1xcHf0EaWyH+nD6r4w965ZB//7yRQBt9HrPRelxlNT/JmXDyj174RV1DyRPJkSaZ/
         as6Bt5egAJCFsWa3A33JvI+qlCeHsrL1zDfmfOGw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anson Huang <Anson.Huang@nxp.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        =?UTF-8?q?S=C3=A9bastien=20Szymanski?= 
        <sebastien.szymanski@armadeus.com>,
        Lucas Stach <l.stach@pengutronix.de>
Subject: [PATCH 4.19 62/84] cpufreq: imx6q: read OCOTP through nvmem for imx6ul/imx6ull
Date:   Sat, 11 Jan 2020 10:50:39 +0100
Message-Id: <20200111094909.497698930@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094845.328046411@linuxfoundation.org>
References: <20200111094845.328046411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anson Huang <Anson.Huang@nxp.com>

commit 2733fb0d0699246711cf622e0e2faf02a05b69dc upstream.

On i.MX6UL/i.MX6ULL, accessing OCOTP directly is wrong because
the ocotp clock needs to be enabled first. Add support for reading
OCOTP through the nvmem API, and keep the old method there to
support old dtb.

Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Sébastien Szymanski <sebastien.szymanski@armadeus.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/imx6q-cpufreq.c |   52 ++++++++++++++++++++++++++--------------
 1 file changed, 35 insertions(+), 17 deletions(-)

--- a/drivers/cpufreq/imx6q-cpufreq.c
+++ b/drivers/cpufreq/imx6q-cpufreq.c
@@ -12,6 +12,7 @@
 #include <linux/cpu_cooling.h>
 #include <linux/err.h>
 #include <linux/module.h>
+#include <linux/nvmem-consumer.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/pm_opp.h>
@@ -295,20 +296,32 @@ put_node:
 #define OCOTP_CFG3_6ULL_SPEED_792MHZ	0x2
 #define OCOTP_CFG3_6ULL_SPEED_900MHZ	0x3
 
-static void imx6ul_opp_check_speed_grading(struct device *dev)
+static int imx6ul_opp_check_speed_grading(struct device *dev)
 {
-	struct device_node *np;
-	void __iomem *base;
 	u32 val;
+	int ret = 0;
 
-	np = of_find_compatible_node(NULL, NULL, "fsl,imx6ul-ocotp");
-	if (!np)
-		return;
+	if (of_find_property(dev->of_node, "nvmem-cells", NULL)) {
+		ret = nvmem_cell_read_u32(dev, "speed_grade", &val);
+		if (ret)
+			return ret;
+	} else {
+		struct device_node *np;
+		void __iomem *base;
 
-	base = of_iomap(np, 0);
-	if (!base) {
-		dev_err(dev, "failed to map ocotp\n");
-		goto put_node;
+		np = of_find_compatible_node(NULL, NULL, "fsl,imx6ul-ocotp");
+		if (!np)
+			return -ENOENT;
+
+		base = of_iomap(np, 0);
+		of_node_put(np);
+		if (!base) {
+			dev_err(dev, "failed to map ocotp\n");
+			return -EFAULT;
+		}
+
+		val = readl_relaxed(base + OCOTP_CFG3);
+		iounmap(base);
 	}
 
 	/*
@@ -319,7 +332,6 @@ static void imx6ul_opp_check_speed_gradi
 	 * 2b'11: 900000000Hz on i.MX6ULL only;
 	 * We need to set the max speed of ARM according to fuse map.
 	 */
-	val = readl_relaxed(base + OCOTP_CFG3);
 	val >>= OCOTP_CFG3_SPEED_SHIFT;
 	val &= 0x3;
 
@@ -339,9 +351,7 @@ static void imx6ul_opp_check_speed_gradi
 				dev_warn(dev, "failed to disable 900MHz OPP\n");
 	}
 
-	iounmap(base);
-put_node:
-	of_node_put(np);
+	return ret;
 }
 
 static int imx6q_cpufreq_probe(struct platform_device *pdev)
@@ -399,10 +409,18 @@ static int imx6q_cpufreq_probe(struct pl
 	}
 
 	if (of_machine_is_compatible("fsl,imx6ul") ||
-	    of_machine_is_compatible("fsl,imx6ull"))
-		imx6ul_opp_check_speed_grading(cpu_dev);
-	else
+	    of_machine_is_compatible("fsl,imx6ull")) {
+		ret = imx6ul_opp_check_speed_grading(cpu_dev);
+		if (ret == -EPROBE_DEFER)
+			return ret;
+		if (ret) {
+			dev_err(cpu_dev, "failed to read ocotp: %d\n",
+				ret);
+			return ret;
+		}
+	} else {
 		imx6q_opp_check_speed_grading(cpu_dev);
+	}
 
 	/* Because we have added the OPPs here, we must free them */
 	free_opp = true;


