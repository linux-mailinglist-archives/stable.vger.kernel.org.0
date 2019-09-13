Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7E60B200E
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389609AbfIMNOx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:14:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:40922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389600AbfIMNOx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:14:53 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1C2B206BB;
        Fri, 13 Sep 2019 13:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380492;
        bh=Ro1LNBFMViZiVBWiUqekWd88mjd50CtgzABBkEWYXUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZD4/Y83KZt/TgqnlxMnw1ivg9p29KzHSP9Pz+C7tiHb4w/0wHIhDT4xKN0c96K+DF
         2WowM93UVkUOXrfGWCluXLa9sFhiP17TAeGuDEH5ttoSyFj1Ld8jHNAvBDeP4tZBz0
         XYc7ge6ZDAa6wZE3X2xQhXmyQOhiQYUuntpfhqqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 083/190] mfd: Kconfig: Fix I2C_DESIGNWARE_PLATFORM dependencies
Date:   Fri, 13 Sep 2019 14:05:38 +0100
Message-Id: <20190913130606.162655922@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 09fdc98577120d4f47601c3127efde726a2300c6 ]

INTEL_SOC_PMIC, INTEL_SOC_PMIC_CHTWC and MFD_TPS68470 select the
I2C_DESIGNWARE_PLATFORM without its dependencies making it possible to see
warning and build error like below:

WARNING: unmet direct dependencies detected for I2C_DESIGNWARE_PLATFORM
  Depends on [n]: I2C [=y] && HAS_IOMEM [=y] && (ACPI [=y] && COMMON_CLK [=n] || !ACPI [=y])
  Selected by [y]:
  - MFD_TPS68470 [=y] && HAS_IOMEM [=y] && ACPI [=y] && I2C [=y]=y

/usr/bin/ld: drivers/i2c/busses/i2c-designware-platdrv.o: in function `dw_i2c_plat_resume':
i2c-designware-platdrv.c:(.text+0x62): undefined reference to `i2c_dw_prepare_clk'
/usr/bin/ld: drivers/i2c/busses/i2c-designware-platdrv.o: in function `dw_i2c_plat_suspend':
i2c-designware-platdrv.c:(.text+0x9a): undefined reference to `i2c_dw_prepare_clk'
/usr/bin/ld: drivers/i2c/busses/i2c-designware-platdrv.o: in function `dw_i2c_plat_probe':
i2c-designware-platdrv.c:(.text+0x41c): undefined reference to `i2c_dw_prepare_clk'
/usr/bin/ld: i2c-designware-platdrv.c:(.text+0x438): undefined reference to `i2c_dw_read_comp_param'
/usr/bin/ld: i2c-designware-platdrv.c:(.text+0x545): undefined reference to `i2c_dw_probe'
/usr/bin/ld: i2c-designware-platdrv.c:(.text+0x727): undefined reference to `i2c_dw_probe_slave'

Fix this by making above options to depend on I2C_DESIGNWARE_PLATFORM
being built-in. I2C_DESIGNWARE_PLATFORM is a visible symbol with
dependencies so in general the select should be avoided.

Fixes: acebcff9eda8 ("mfd: intel_soc_pmic: Select designware i2c-bus driver")
Fixes: de85d79f4aab ("mfd: Add Cherry Trail Whiskey Cove PMIC driver")
Fixes: 9bbf6a15ce19 ("mfd: Add support for TPS68470 device")
Cc: Stable <stable@vger.kernel.org> # v4.14+
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 11841f4b7b2ba..dd938a5d04094 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -509,10 +509,10 @@ config INTEL_SOC_PMIC
 	bool "Support for Crystal Cove PMIC"
 	depends on ACPI && HAS_IOMEM && I2C=y && GPIOLIB && COMMON_CLK
 	depends on X86 || COMPILE_TEST
+	depends on I2C_DESIGNWARE_PLATFORM=y
 	select MFD_CORE
 	select REGMAP_I2C
 	select REGMAP_IRQ
-	select I2C_DESIGNWARE_PLATFORM
 	help
 	  Select this option to enable support for Crystal Cove PMIC
 	  on some Intel SoC systems. The PMIC provides ADC, GPIO,
@@ -538,10 +538,10 @@ config INTEL_SOC_PMIC_CHTWC
 	bool "Support for Intel Cherry Trail Whiskey Cove PMIC"
 	depends on ACPI && HAS_IOMEM && I2C=y && COMMON_CLK
 	depends on X86 || COMPILE_TEST
+	depends on I2C_DESIGNWARE_PLATFORM=y
 	select MFD_CORE
 	select REGMAP_I2C
 	select REGMAP_IRQ
-	select I2C_DESIGNWARE_PLATFORM
 	help
 	  Select this option to enable support for the Intel Cherry Trail
 	  Whiskey Cove PMIC found on some Intel Cherry Trail systems.
@@ -1403,9 +1403,9 @@ config MFD_TPS65217
 config MFD_TPS68470
 	bool "TI TPS68470 Power Management / LED chips"
 	depends on ACPI && I2C=y
+	depends on I2C_DESIGNWARE_PLATFORM=y
 	select MFD_CORE
 	select REGMAP_I2C
-	select I2C_DESIGNWARE_PLATFORM
 	help
 	  If you say yes here you get support for the TPS68470 series of
 	  Power Management / LED chips.
-- 
2.20.1



