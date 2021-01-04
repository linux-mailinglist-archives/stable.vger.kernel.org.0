Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9882E9A68
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbhADQJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:09:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:38400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728586AbhADQB3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:01:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50E382245C;
        Mon,  4 Jan 2021 16:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776073;
        bh=KnUIbIablvm3+WOQgt8EdeWIvVEZdEPzjBDG5VjNHQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RU6jjkqm7bdBX/pcjUxCAol2T/yuVTToWwSXmqUBV3tquRLKIizCvuQ/Bn3HPggcF
         pbPhvQ0tn86T62kvajtPc8belF5tm++xDWxG3ueJwgpYX4GFw9iZxtD2JMQdliOAyR
         cJ+2xYQMUfzH4hzKwm9PT8bfPIIS9unBX+hCvhAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Randy Dunlap <rdunlap@infradead.org>,
        Ramil Zaripov <Ramil.Zaripov@baikalelectronics.ru>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 10/63] spi: dw-bt1: Fix undefined devm_mux_control_get symbol
Date:   Mon,  4 Jan 2021 16:57:03 +0100
Message-Id: <20210104155709.309245084@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155708.800470590@linuxfoundation.org>
References: <20210104155708.800470590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

commit 7218838109fef61cdec988ff728e902d434c9cc5 upstream.

I mistakenly added the select attributes to the SPI_DW_BT1_DIRMAP config
instead of having them defined in SPI_DW_BT1. If the kernel doesn't have
the MULTIPLEXER and MUX_MMIO configs manually enabled and the
SPI_DW_BT1_DIRMAP config hasn't been selected, Baikal-T1 SPI device will
always fail to be probed by the driver. Fix that and the error reported by
the test robot:

>> ld.lld: error: undefined symbol: devm_mux_control_get
   >>> referenced by spi-dw-bt1.c
   >>> spi/spi-dw-bt1.o:(dw_spi_bt1_sys_init) in archive drivers/built-in.a

by moving the MULTIPLEXER/MUX_MMIO configs selection to the SPI_DW_BT1
config.

Link: https://lore.kernel.org/lkml/202011161745.uYRlekse-lkp@intel.com/
Link: https://lore.kernel.org/linux-spi/20201116040721.8001-1-rdunlap@infradead.org/
Fixes: abf00907538e ("spi: dw: Add Baikal-T1 SPI Controller glue driver")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Ramil Zaripov <Ramil.Zaripov@baikalelectronics.ru>
Link: https://lore.kernel.org/r/20201127144612.4204-1-Sergey.Semin@baikalelectronics.ru
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -256,6 +256,7 @@ config SPI_DW_BT1
 	tristate "Baikal-T1 SPI driver for DW SPI core"
 	depends on MIPS_BAIKAL_T1 || COMPILE_TEST
 	select MULTIPLEXER
+	select MUX_MMIO
 	help
 	  Baikal-T1 SoC is equipped with three DW APB SSI-based MMIO SPI
 	  controllers. Two of them are pretty much normal: with IRQ, DMA,
@@ -269,8 +270,6 @@ config SPI_DW_BT1
 config SPI_DW_BT1_DIRMAP
 	bool "Directly mapped Baikal-T1 Boot SPI flash support"
 	depends on SPI_DW_BT1
-	select MULTIPLEXER
-	select MUX_MMIO
 	help
 	  Directly mapped SPI flash memory is an interface specific to the
 	  Baikal-T1 System Boot Controller. It is a 16MB MMIO region, which


