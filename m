Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7B381C1462
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731090AbgEANit (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:38:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:38316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730124AbgEANip (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:38:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1638220757;
        Fri,  1 May 2020 13:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340324;
        bh=EzBuUbP+MAp5jtdhazYUJEvVoX5tSl+lvg7WtwU5M/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ziWPgqnUz8VYhb1Od3tUnxA3fYhJBZPGEXkJx/Y5aSNauv5Q0xKmEBSjAyIWzkZZo
         8tu3/mZR+7r1SDBuuSncW+gb5+NUbLbjuIbHcc+avX9znnBgB7DPngadrN0AXOF1A2
         e8vO8CVEPiVfqI1ZBUU2F+OnIb8CDLuzbwzAEFzw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Michal Simek <michal.simek@xilinx.com>
Subject: [PATCH 5.4 19/83] drivers: soc: xilinx: fix firmware driver Kconfig dependency
Date:   Fri,  1 May 2020 15:22:58 +0200
Message-Id: <20200501131528.930744749@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131524.004332640@linuxfoundation.org>
References: <20200501131524.004332640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit d0384eedcde21276ac51f57c641f875605024b32 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/soc/xilinx/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/soc/xilinx/Kconfig
+++ b/drivers/soc/xilinx/Kconfig
@@ -19,7 +19,7 @@ config XILINX_VCU
 
 config ZYNQMP_POWER
 	bool "Enable Xilinx Zynq MPSoC Power Management driver"
-	depends on PM && ARCH_ZYNQMP
+	depends on PM && ZYNQMP_FIRMWARE
 	default y
 	help
 	  Say yes to enable power management support for ZyqnMP SoC.
@@ -31,7 +31,7 @@ config ZYNQMP_POWER
 config ZYNQMP_PM_DOMAINS
 	bool "Enable Zynq MPSoC generic PM domains"
 	default y
-	depends on PM && ARCH_ZYNQMP && ZYNQMP_FIRMWARE
+	depends on PM && ZYNQMP_FIRMWARE
 	select PM_GENERIC_DOMAINS
 	help
 	  Say yes to enable device power management through PM domains


