Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCF42E3CB8
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437695AbgL1OFx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:05:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:40222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437662AbgL1OFs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:05:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A4E5205CB;
        Mon, 28 Dec 2020 14:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164308;
        bh=8d4/T0SO+fMjgAg05wfN5fgA6YcsyiBhedVrT9V6beM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XdZj0scuQAgBdWH9atFIFjFe6PmmNSYtFK0ff7RBUGLGR/DtePv/BCVQjLPeCgEKx
         tASluzPvgkVGRjefORz72r1jxlIlcIANexO4FW+AN64QX3sJvKRIvOctUzpA7eu+IE
         U7dyMCaf6x9OIAsN9nqX7p51Sfp8bvOWQum3Uc18=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Ramil Zaripov <Ramil.Zaripov@baikalelectronics.ru>,
        Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        Serge Semin <fancer.lancer@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 134/717] spi: dw: fix build error by selecting MULTIPLEXER
Date:   Mon, 28 Dec 2020 13:42:12 +0100
Message-Id: <20201228125027.369952724@linuxfoundation.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 1241f0787578136ab58f49adc52f2dcd2bbc4bf2 ]

Fix build error for spi-dw-bt1.o by selecting MULTIPLEXER.

hppa-linux-ld: drivers/spi/spi-dw-bt1.o: in function `dw_spi_bt1_sys_init':
(.text+0x1ac): undefined reference to `devm_mux_control_get'

Fixes: abf00907538e ("spi: dw: Add Baikal-T1 SPI Controller glue driver")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc: Ramil Zaripov <Ramil.Zaripov@baikalelectronics.ru>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org
Acked-by: Serge Semin <fancer.lancer@gmail.com>
Link: https://lore.kernel.org/r/20201116040721.8001-1-rdunlap@infradead.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 5cff60de8e834..3fd16b7f61507 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -255,6 +255,7 @@ config SPI_DW_MMIO
 config SPI_DW_BT1
 	tristate "Baikal-T1 SPI driver for DW SPI core"
 	depends on MIPS_BAIKAL_T1 || COMPILE_TEST
+	select MULTIPLEXER
 	help
 	  Baikal-T1 SoC is equipped with three DW APB SSI-based MMIO SPI
 	  controllers. Two of them are pretty much normal: with IRQ, DMA,
-- 
2.27.0



