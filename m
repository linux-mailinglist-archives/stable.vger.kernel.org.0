Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88022429178
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238772AbhJKOTB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:19:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:39918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238795AbhJKOQz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:16:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8058761205;
        Mon, 11 Oct 2021 14:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633961166;
        bh=d4gLG3sbZOO9pgRmiG8GNpaDB9O1guu5oC67oVJ8LK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AWJ0kUcBjG++zoHh/komN9f+/6aDUSM/71x4kpNchXuZRBrYSevfHdCQ0HLRu2O1U
         AGvpQv7XObamr9dAtikyEUCz5ytJF1O1BD9ccyuEYYtQt5QArSf57Dn0PhkteZjp8d
         d8XdKK4IOUonMsqqiSD8xdneJPbyzCTc36JhlLJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 18/28] ARM: imx6: disable the GIC CPU interface before calling stby-poweroff sequence
Date:   Mon, 11 Oct 2021 15:47:08 +0200
Message-Id: <20211011134641.294817049@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134640.711218469@linuxfoundation.org>
References: <20211011134640.711218469@linuxfoundation.org>
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
index 4bfefbec971a..c3ca6e2cf7ff 100644
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
@@ -622,6 +623,7 @@ static void __init imx6_pm_common_init(const struct imx6_pm_socdata
 
 static void imx6_pm_stby_poweroff(void)
 {
+	gic_cpu_if_down(0);
 	imx6_set_lpm(STOP_POWER_OFF);
 	imx6q_suspend_finish(0);
 
-- 
2.33.0



