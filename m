Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEA6931E7C
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728295AbfFANVy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:21:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:49320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727879AbfFANVw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:21:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E52AE272E7;
        Sat,  1 Jun 2019 13:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395311;
        bh=9xEkafkImboL0Vlars0FgDOJ0ZEDWSP9hRRg7LPRHYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vKfp8LvM1ycMLry6ZOzD2N17bJXblFbOWNCUt8U3wqglHOYif7HVTgrmOGN4CJTkN
         G9HH/QqVSBB8IHT78InlULlWTQDMspfmOrUASgNm7ZXI4NqIhC8X+heuuz98Xk4Yo0
         1BxsQYb29ceXT+zw/zQIyMwGf5apo9MPnwO02fL8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Serge Semin <fancer.lancer@gmail.com>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        Huacai Chen <chenhc@lemote.com>,
        Stefan Agner <stefan@agner.ch>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Juergen Gross <jgross@suse.com>,
        Serge Semin <Sergey.Semin@t-platforms.ru>,
        linux-mips@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.0 066/173] mips: Make sure dt memory regions are valid
Date:   Sat,  1 Jun 2019 09:17:38 -0400
Message-Id: <20190601131934.25053-66-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601131934.25053-1-sashal@kernel.org>
References: <20190601131934.25053-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Serge Semin <fancer.lancer@gmail.com>

[ Upstream commit 93fa5b280761a4dbb14c5330f260380385ab2b49 ]

There are situations when memory regions coming from dts may be
too big for the platform physical address space. This especially
concerns XPA-capable systems. Bootloader may determine more than 4GB
memory available and pass it to the kernel over dts memory node, while
kernel is built without XPA/64BIT support. In this case the region
may either simply be truncated by add_memory_region() method
or by u64->phys_addr_t type casting. But in worst case the method
can even drop the memory region if it exceeds PHYS_ADDR_MAX size.
So lets make sure the retrieved from dts memory regions are valid,
and if some of them aren't, just manually truncate them with a warning
printed out.

Signed-off-by: Serge Semin <fancer.lancer@gmail.com>
Signed-off-by: Paul Burton <paul.burton@mips.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: James Hogan <jhogan@kernel.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc: Huacai Chen <chenhc@lemote.com>
Cc: Stefan Agner <stefan@agner.ch>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Serge Semin <Sergey.Semin@t-platforms.ru>
Cc: linux-mips@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/prom.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/mips/kernel/prom.c b/arch/mips/kernel/prom.c
index 93b8e0b4332f7..b9d6c6ec41778 100644
--- a/arch/mips/kernel/prom.c
+++ b/arch/mips/kernel/prom.c
@@ -41,7 +41,19 @@ char *mips_get_machine_name(void)
 #ifdef CONFIG_USE_OF
 void __init early_init_dt_add_memory_arch(u64 base, u64 size)
 {
-	return add_memory_region(base, size, BOOT_MEM_RAM);
+	if (base >= PHYS_ADDR_MAX) {
+		pr_warn("Trying to add an invalid memory region, skipped\n");
+		return;
+	}
+
+	/* Truncate the passed memory region instead of type casting */
+	if (base + size - 1 >= PHYS_ADDR_MAX || base + size < base) {
+		pr_warn("Truncate memory region %llx @ %llx to size %llx\n",
+			size, base, PHYS_ADDR_MAX - base);
+		size = PHYS_ADDR_MAX - base;
+	}
+
+	add_memory_region(base, size, BOOT_MEM_RAM);
 }
 
 int __init early_init_dt_reserve_memory_arch(phys_addr_t base,
-- 
2.20.1

