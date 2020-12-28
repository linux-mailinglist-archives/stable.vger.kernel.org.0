Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C55F2E40DA
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439338AbgL1O6Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:58:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:49528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440534AbgL1OO5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:14:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1599022AAD;
        Mon, 28 Dec 2020 14:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164881;
        bh=BThpZ5djaZCNKZZrYR7gqdhOtxJEpl/PIxIzu+CFFPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qdkAASDu5HAVK1J0jx3yJ5yzqJN4/4D7m1QgxzYQLthpDsU5pvfWSmivXIT9jc4dJ
         hL/K/0IfXVqdfl0fNP0PJcEDABKaEYJmSRfIbeisrsLUNy1AoV8lnwHS3dELqkG0eZ
         BusHYqknkmLDDHk98DBf75BSMcaOcy3M9cxJkFD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 332/717] cpufreq: imx: fix NVMEM_IMX_OCOTP dependency
Date:   Mon, 28 Dec 2020 13:45:30 +0100
Message-Id: <20201228125036.929757567@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit fc928b901dc68481ba3e524860a641fe13e25dfe ]

A driver should not 'select' drivers from another subsystem.
If NVMEM is disabled, this one results in a warning:

WARNING: unmet direct dependencies detected for NVMEM_IMX_OCOTP
  Depends on [n]: NVMEM [=n] && (ARCH_MXC [=y] || COMPILE_TEST [=y]) && HAS_IOMEM [=y]
  Selected by [y]:
  - ARM_IMX6Q_CPUFREQ [=y] && CPU_FREQ [=y] && (ARM || ARM64 [=y]) && ARCH_MXC [=y] && REGULATOR_ANATOP [=y]

Change the 'select' to 'depends on' to prevent it from going wrong,
and allow compile-testing without that driver, since it is only
a runtime dependency.

Fixes: 2782ef34ed23 ("cpufreq: imx: Select NVMEM_IMX_OCOTP")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/Kconfig.arm | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
index 015ec0c028358..1f73fa75b1a05 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -94,7 +94,7 @@ config ARM_IMX6Q_CPUFREQ
 	tristate "Freescale i.MX6 cpufreq support"
 	depends on ARCH_MXC
 	depends on REGULATOR_ANATOP
-	select NVMEM_IMX_OCOTP
+	depends on NVMEM_IMX_OCOTP || COMPILE_TEST
 	select PM_OPP
 	help
 	  This adds cpufreq driver support for Freescale i.MX6 series SoCs.
-- 
2.27.0



