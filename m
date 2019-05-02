Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC9F111832
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 13:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbfEBLdE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 07:33:04 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45936 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbfEBLdE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 May 2019 07:33:04 -0400
Received: by mail-qt1-f195.google.com with SMTP id t1so1246116qtc.12
        for <stable@vger.kernel.org>; Thu, 02 May 2019 04:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Hg7TtsEFadnOjSgx3jp2tA+2HgpI1482WNMkndbFrzE=;
        b=acmlV9Nz3/KjYXscXwD/N8XxRhL7nlxpeSY1f8A3VPR3pvYN5HXkdNdXqSPupEUCM1
         wCwe9fzF87JG5D//SAGHAH2Dv7OfkhEzTWdi5hRp5r5lm+6203/YbFaFrtB6p9ZPnZcA
         crkPkD7fdZwRk7tTylCAncrS8awPHwTKwwRHI1PLHbFTUy1nInOt8vVWCO/+fzqpn+/X
         q4qV1KyqHio/5uVh01FiHlSv+BLITWUJYmdu4jKBnEYmhKbk/IGESNPGmEN04Zc4tKPu
         gf4DPaItIe1JP8c6kdOes0vpk5wOO66C4aKqonmjddfB4597wOuCKCHnIWavQO0igRE+
         EGgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Hg7TtsEFadnOjSgx3jp2tA+2HgpI1482WNMkndbFrzE=;
        b=hWQ4DeW6BU04l2QSfL+fCxuD3vmpcDLd12MKXIZGEQv0NcX9LkW7xEqpABgPZ67kql
         cx+0C9tclLZ5miOdFAP8zuN2aL6fXVlPL47Xl/XjyRrmaoST0gtLKhEj1RhszMbF4MlK
         aTpYBdjBxBamQFr5ZmXubXs8iNPRyUq8YulpYhYDqkcbkO1bHDx9UiMryADw5AvzVFFM
         kNO6+ERNnFSM3JV6SEvkDEJm8A/K/7k/9Psb/4++o8iaNJpDbowmVrmjPXVzDqevGdUJ
         xwfrSHxq+8SyIVGr+fqL5YDgW/06xigrUz72i0+FAPGzfGgpIWiTI36UOm7S0oO4J6uI
         90iw==
X-Gm-Message-State: APjAAAUMgVbVxz00VxSagzhyoZwRyNZzP5xh0ucUMsNMRcrGjGwwuVAA
        GDrrzPid0TKUcMx+T1PLM+s=
X-Google-Smtp-Source: APXvYqzAQr8cdbmARVLcsts793hCcZltNZV1HAC1L8AIp97l0A362BaRRxyz3ih407vfAWx6P+HL6w==
X-Received: by 2002:a0c:9ac1:: with SMTP id k1mr2553094qvf.36.1556796627624;
        Thu, 02 May 2019 04:30:27 -0700 (PDT)
Received: from fabio-Latitude-E5450.am.freescale.net ([2804:14c:482:3c8:56cb:1049:60d2:137b])
        by smtp.gmail.com with ESMTPSA id a15sm6787239qkk.87.2019.05.02.04.30.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 04:30:26 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     shawnguo@kernel.org
Cc:     kernel@pengutronix.de, linux-imx@nxp.com,
        cniedermaier@dh-electronics.com,
        linux-arm-kernel@lists.infradead.org, anson.huang@nxp.com,
        Fabio Estevam <festevam@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] ARM: imx: cpuidle-imx6sx: Restrict the SW2ISO increase to i.MX6SX
Date:   Thu,  2 May 2019 08:30:20 -0300
Message-Id: <20190502113020.8642-1-festevam@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since commit 1e434b703248 ("ARM: imx: update the cpu power up timing
setting on i.mx6sx") some characters loss is noticed on i.MX6ULL UART
as reported by Christoph Niedermaier.

The intention of such commit was to increase the SW2ISO field for i.MX6SX
only, but since cpuidle-imx6sx is also used on i.MX6UL/i.MX6ULL this caused
unintended side effects on other SoCs.

Fix this problem by keeping the original SW2ISO value for i.MX6UL/i.MX6ULL
and only increase SW2ISO in the i.MX6SX case.

Cc: stable@vger.kernel.org
Fixes: 1e434b703248 ("ARM: imx: update the cpu power up timing setting on i.mx6sx")
Reported-by: Christoph Niedermaier <cniedermaier@dh-electronics.com>
Signed-off-by: Fabio Estevam <festevam@gmail.com>
---
 arch/arm/mach-imx/cpuidle-imx6sx.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/cpuidle-imx6sx.c b/arch/arm/mach-imx/cpuidle-imx6sx.c
index fd0053e47a15..57cb9c763222 100644
--- a/arch/arm/mach-imx/cpuidle-imx6sx.c
+++ b/arch/arm/mach-imx/cpuidle-imx6sx.c
@@ -15,6 +15,7 @@
 
 #include "common.h"
 #include "cpuidle.h"
+#include "hardware.h"
 
 static int imx6sx_idle_finish(unsigned long val)
 {
@@ -99,8 +100,12 @@ static struct cpuidle_driver imx6sx_cpuidle_driver = {
 	.safe_state_index = 0,
 };
 
+#define SW2ISO_ORIGINAL		0x2
+#define SW2ISO_IMX6SX		0xf
 int __init imx6sx_cpuidle_init(void)
 {
+	u32 sw2iso = SW2ISO_ORIGINAL;
+
 	imx6_set_int_mem_clk_lpm(true);
 	imx6_enable_rbc(false);
 	imx_gpc_set_l2_mem_power_in_lpm(false);
@@ -110,7 +115,9 @@ int __init imx6sx_cpuidle_init(void)
 	 * except for power up sw2iso which need to be
 	 * larger than LDO ramp up time.
 	 */
-	imx_gpc_set_arm_power_up_timing(0xf, 1);
+	if (cpu_is_imx6sx())
+		sw2iso = SW2ISO_IMX6SX;
+	imx_gpc_set_arm_power_up_timing(sw2iso, 1);
 	imx_gpc_set_arm_power_down_timing(1, 1);
 
 	return cpuidle_register(&imx6sx_cpuidle_driver, NULL);
-- 
2.17.1

