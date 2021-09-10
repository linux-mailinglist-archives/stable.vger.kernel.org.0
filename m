Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E934406201
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233424AbhIJAoZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:44:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:46316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233544AbhIJAUT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:20:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC1586023D;
        Fri, 10 Sep 2021 00:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233144;
        bh=CJrES0oAwJTPIo0BiAy8EvkGblO9RDeUA9LmpITn31A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ja92+DuVHTp9nZX77gW1N65lTxVs6bL/TOe3Y7FTKnAdqLbHnzhwkRO3zxIyV+1uM
         ber0LX/2lftDndFfIC49qVCBgWJgSOA8vXjsoFE5RThHUM3+JaHmEZKGIJ3288I2yl
         n2PyQUYXHRFswJmOiNgXmKH7EsOq0rhreTAmwnHUYoj1EA8wEPojeIFhONwGzFEDrS
         o9HhMm7sMlFbT8I++0H8VOVvx2VcAMRSvKLsGQML4IGEqUcXHPksI0WOYj/Z6XSl1B
         vF0HUTHq7ng4y0nxkuzeCzwyQGB8/J6O+4kdH3ushcG/2rl00Wzl24YvAe1kgnJOjw
         ztbabiJoaaqcw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.13 30/88] MIPS: loongson2ef: don't build serial.o unconditionally
Date:   Thu,  9 Sep 2021 20:17:22 -0400
Message-Id: <20210910001820.174272-30-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001820.174272-1-sashal@kernel.org>
References: <20210910001820.174272-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit ad548993a66c498267695edd8b19a682be0e3a8b ]

LOONGSON_UART_BASE depends on EARLY_PRINTK || SERIAL_8250, but when
neither of these Kconfig symbols is set, the kernel build has errors:

../arch/mips/loongson2ef/common/serial.c: In function 'serial_init':
../arch/mips/loongson2ef/common/serial.c:66:25: error: 'loongson_uart_base' undeclared (first use in this function)
   66 |                         loongson_uart_base;
../arch/mips/loongson2ef/common/serial.c:66:25: note: each undeclared identifier is reported only once for each function it appears in
../arch/mips/loongson2ef/common/serial.c:68:41: error: '_loongson_uart_base' undeclared (first use in this function)
   68 |                         (void __iomem *)_loongson_uart_base;

Fix this by building serial.o only when one (or both) of these
Kconfig symbols is enabled.

Tested with:
	(a) EARLY_PRINTK=y, SERIAL_8250 not set;
	(b) EARLY_PRINTK=y, SERIAL_8250=y;
	(c) EARLY_PRINTK=y, SERIAL_8250=m.
	(d) EARLY_PRINTK not set, SERIAL_8250=y;
	(e) EARLY_PRINTK not set, SERIAL_8250=m;
	(f) EARLY_PRINTK not set, SERIAL_8250 not set.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-mips@vger.kernel.org
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/loongson2ef/common/Makefile | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/mips/loongson2ef/common/Makefile b/arch/mips/loongson2ef/common/Makefile
index d5ab3e543ea3..30ea8b5ca685 100644
--- a/arch/mips/loongson2ef/common/Makefile
+++ b/arch/mips/loongson2ef/common/Makefile
@@ -4,12 +4,14 @@
 #
 
 obj-y += setup.o init.o env.o time.o reset.o irq.o \
-    bonito-irq.o mem.o machtype.o platform.o serial.o
+    bonito-irq.o mem.o machtype.o platform.o
 obj-$(CONFIG_PCI) += pci.o
 
 #
 # Serial port support
 #
+obj-$(CONFIG_LOONGSON_UART_BASE) += serial.o
+obj-$(CONFIG_EARLY_PRINTK) += serial.o
 obj-$(CONFIG_LOONGSON_UART_BASE) += uart_base.o
 obj-$(CONFIG_LOONGSON_MC146818) += rtc.o
 
-- 
2.30.2

