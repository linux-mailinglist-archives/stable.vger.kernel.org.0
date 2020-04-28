Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4EF1BCA84
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731298AbgD1Stk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:49:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:58834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730415AbgD1Sjx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:39:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D18D20575;
        Tue, 28 Apr 2020 18:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099192;
        bh=xEfiGp962UeN7kUvT6zNM7UWw343DFk0w0KZsgijnW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mC/77zjBZOdU0x1lLiL+JeCftynrT2ibUUFtPuLadbFzzls7Ji+QEMckQDpYMYC0D
         n47JJ7eKHnjTfQgDh5Gnqb1f6tGE++U56cnbLOeqIC1hbeU9ILLgJpAzXmzO+xAkdR
         hBrmJ/3Svu2s9SXSTPogkc0pEIvKzE37dimWxMM8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Clemens Gruber <clemens.gruber@pqgruber.com>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Roland Hieber <rhi@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4.19 111/131] ARM: imx: provide v7_cpu_resume() only on ARM_CPU_SUSPEND=y
Date:   Tue, 28 Apr 2020 20:25:23 +0200
Message-Id: <20200428182239.183816463@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182224.822179290@linuxfoundation.org>
References: <20200428182224.822179290@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ahmad Fatoum <a.fatoum@pengutronix.de>

commit f1baca8896ae18e12c45552a4c4ae2086aa7e02c upstream.

512a928affd5 ("ARM: imx: build v7_cpu_resume() unconditionally")
introduced an unintended linker error for i.MX6 configurations that have
ARM_CPU_SUSPEND=n which can happen if neither CONFIG_PM, CONFIG_CPU_IDLE,
nor ARM_PSCI_FW are selected.

Fix this by having v7_cpu_resume() compiled only when cpu_resume() it
calls is available as well.

The C declaration for the function remains unguarded to avoid future code
inadvertently using a stub and introducing a regression to the bug the
original commit fixed.

Cc: <stable@vger.kernel.org>
Fixes: 512a928affd5 ("ARM: imx: build v7_cpu_resume() unconditionally")
Reported-by: Clemens Gruber <clemens.gruber@pqgruber.com>
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Tested-by: Roland Hieber <rhi@pengutronix.de>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-imx/Makefile |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm/mach-imx/Makefile
+++ b/arch/arm/mach-imx/Makefile
@@ -89,8 +89,10 @@ AFLAGS_suspend-imx6.o :=-Wa,-march=armv7
 obj-$(CONFIG_SOC_IMX6) += suspend-imx6.o
 obj-$(CONFIG_SOC_IMX53) += suspend-imx53.o
 endif
+ifeq ($(CONFIG_ARM_CPU_SUSPEND),y)
 AFLAGS_resume-imx6.o :=-Wa,-march=armv7-a
 obj-$(CONFIG_SOC_IMX6) += resume-imx6.o
+endif
 obj-$(CONFIG_SOC_IMX6) += pm-imx6.o
 
 obj-$(CONFIG_SOC_IMX1) += mach-imx1.o


