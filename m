Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 980DE1F30F6
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 03:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728914AbgFIBES (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 21:04:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:51570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727891AbgFHXHZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:07:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D025320812;
        Mon,  8 Jun 2020 23:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657645;
        bh=dUkrinHv1Rv4amfGn74MI+e2YKhyXCrB1nrhBwjAXsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hRTpDfTaL3Gp0YHHVF/pVVfqBW/0xr2ASUfARjvkAgdOl3D6bKs1z6lxdLEI4sAqn
         H97X82m9CAPc9AxV3Kif1DCa9aRuJgNGOL4Ked6AWOzKOTbWI/KaqHy/ApcIvCfNSh
         k43dXp/cHWS/QF/MmerUTICdHqLjCYrF30XdypnM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Burton <paulburton@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 061/274] mips: Fix cpu_has_mips64r1/2 activation for MIPS32 CPUs
Date:   Mon,  8 Jun 2020 19:02:34 -0400
Message-Id: <20200608230607.3361041-61-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

[ Upstream commit a2ac81c6ef4018ea49c034ce165bb9ea1cf99f3e ]

Commit 1aeba347b3a9 ("MIPS: Hardcode cpu_has_mips* where target ISA
allows") updated the cpu_has_mips* macro to be replaced with a constant
expression where it's possible. By mistake it wasn't done correctly
for cpu_has_mips64r1/cpu_has_mips64r2 macro. They are defined to
be replaced with conditional expression __isa_range_or_flag(), which
means either ISA revision being within the range or the corresponding
CPU options flag was set at the probe stage or both being true at the
same time. But the ISA level value doesn't indicate whether the ISA is
MIPS32 or MIPS64. Due to this if we select MIPS32r1 - MIPS32r5
architectures the __isa_range() macro will activate the
cpu_has_mips64rX flags, which is incorrect. In order to fix the
problem we make sure the 64bits CPU support is enabled by means of
checking the flag cpu_has_64bits aside with proper ISA range and specific
Revision flag being set.

Fixes: 1aeba347b3a9 ("MIPS: Hardcode cpu_has_mips* where target ISA allows")
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc: Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Paul Burton <paulburton@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: devicetree@vger.kernel.org
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/cpu-features.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/mips/include/asm/cpu-features.h b/arch/mips/include/asm/cpu-features.h
index de44c92b1c1f..d4e120464d41 100644
--- a/arch/mips/include/asm/cpu-features.h
+++ b/arch/mips/include/asm/cpu-features.h
@@ -288,10 +288,12 @@
 # define cpu_has_mips32r6	__isa_ge_or_flag(6, MIPS_CPU_ISA_M32R6)
 #endif
 #ifndef cpu_has_mips64r1
-# define cpu_has_mips64r1	__isa_range_or_flag(1, 6, MIPS_CPU_ISA_M64R1)
+# define cpu_has_mips64r1	(cpu_has_64bits && \
+				 __isa_range_or_flag(1, 6, MIPS_CPU_ISA_M64R1))
 #endif
 #ifndef cpu_has_mips64r2
-# define cpu_has_mips64r2	__isa_range_or_flag(2, 6, MIPS_CPU_ISA_M64R2)
+# define cpu_has_mips64r2	(cpu_has_64bits && \
+				 __isa_range_or_flag(2, 6, MIPS_CPU_ISA_M64R2))
 #endif
 #ifndef cpu_has_mips64r6
 # define cpu_has_mips64r6	__isa_ge_and_flag(6, MIPS_CPU_ISA_M64R6)
-- 
2.25.1

