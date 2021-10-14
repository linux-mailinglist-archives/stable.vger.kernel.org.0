Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B12D42DC53
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 16:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232207AbhJNO6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 10:58:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:43006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232210AbhJNO5w (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 10:57:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E91BA60F4A;
        Thu, 14 Oct 2021 14:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223347;
        bh=QS7i1mFCt5hpyadcWznNirAIeA8qEwBcD2Gsv5uxyJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I+u9fGXY2lv2VyLuoyCuUec9uDndsujaFZLAlRibRdLsuPHgivrQQgWFsVEWHnHzs
         7tix2kAJkGi3SvgPHZ/208WztfEdTfsJuhIYemNfN2VyFD9K2Exu+6wcqdQVX64gLc
         fOTl+JY+CGOmh11JFgO/wqU7Za8hnei7QAF6ux/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 13/25] ARM: imx6: disable the GIC CPU interface before calling stby-poweroff sequence
Date:   Thu, 14 Oct 2021 16:53:44 +0200
Message-Id: <20211014145207.997033189@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145207.575041491@linuxfoundation.org>
References: <20211014145207.575041491@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 783f3db030563f7bcdfe2d26428af98ea1699a8e ]

Any pending interrupt can prevent entering standby based power off state.
To avoid it, disable the GIC CPU interface.

Fixes: 8148d2136002 ("ARM: imx6: register pm_power_off handler if "fsl,pmic-stby-poweroff" is set")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-imx/pm-imx6.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-imx/pm-imx6.c b/arch/arm/mach-imx/pm-imx6.c
index 6da26692f2fd..950c9f2ffe00 100644
--- a/arch/arm/mach-imx/pm-imx6.c
+++ b/arch/arm/mach-imx/pm-imx6.c
@@ -15,6 +15,7 @@
 #include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/genalloc.h>
+#include <linux/irqchip/arm-gic.h>
 #include <linux/mfd/syscon.h>
 #include <linux/mfd/syscon/imx6q-iomuxc-gpr.h>
 #include <linux/of.h>
@@ -606,6 +607,7 @@ static void __init imx6_pm_common_init(const struct imx6_pm_socdata
 
 static void imx6_pm_stby_poweroff(void)
 {
+	gic_cpu_if_down(0);
 	imx6_set_lpm(STOP_POWER_OFF);
 	imx6q_suspend_finish(0);
 
-- 
2.33.0



