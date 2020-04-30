Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A701BFD67
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 16:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgD3OMO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 10:12:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:59152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727921AbgD3NvK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 09:51:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 474BE20873;
        Thu, 30 Apr 2020 13:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254669;
        bh=RrOjOmwlFZRTd7KGEyHN6f9S1J4hCIihGGuUoP738dw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LUtZ5uhQ9u062uddtNRZAQbxnLHbQlr45+bnsy2lcMNBi5EZses057QrjcUrrmfD1
         oNXhPxahMIhHBwXbMcD45M/WvfnH7yO+x53yb4QTzN3mpUIPhbOQI4LCiM5cy4RsIV
         JPTkYSM/rLmfD6Q3zcl9Sb3KuDTRXtzrS3s8S+Mk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.6 22/79] drivers: soc: xilinx: fix firmware driver Kconfig dependency
Date:   Thu, 30 Apr 2020 09:49:46 -0400
Message-Id: <20200430135043.19851-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135043.19851-1-sashal@kernel.org>
References: <20200430135043.19851-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit d0384eedcde21276ac51f57c641f875605024b32 ]

The firmware driver is optional, but the power driver depends on it,
which needs to be reflected in Kconfig to avoid link errors:

aarch64-linux-ld: drivers/soc/xilinx/zynqmp_power.o: in function `zynqmp_pm_isr':
zynqmp_power.c:(.text+0x284): undefined reference to `zynqmp_pm_invoke_fn'

The firmware driver can probably be allowed for compile-testing as
well, so it's best to drop the dependency on the ZYNQ platform
here and allow building as long as the firmware code is built-in.

Fixes: ab272643d723 ("drivers: soc: xilinx: Add ZynqMP PM driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20200408155224.2070880-1-arnd@arndb.de
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/xilinx/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/xilinx/Kconfig b/drivers/soc/xilinx/Kconfig
index 223f1f9d0922f..646512d7276f4 100644
--- a/drivers/soc/xilinx/Kconfig
+++ b/drivers/soc/xilinx/Kconfig
@@ -19,7 +19,7 @@ config XILINX_VCU
 
 config ZYNQMP_POWER
 	bool "Enable Xilinx Zynq MPSoC Power Management driver"
-	depends on PM && ARCH_ZYNQMP
+	depends on PM && ZYNQMP_FIRMWARE
 	default y
 	select MAILBOX
 	select ZYNQMP_IPI_MBOX
@@ -35,7 +35,7 @@ config ZYNQMP_POWER
 config ZYNQMP_PM_DOMAINS
 	bool "Enable Zynq MPSoC generic PM domains"
 	default y
-	depends on PM && ARCH_ZYNQMP && ZYNQMP_FIRMWARE
+	depends on PM && ZYNQMP_FIRMWARE
 	select PM_GENERIC_DOMAINS
 	help
 	  Say yes to enable device power management through PM domains
-- 
2.20.1

