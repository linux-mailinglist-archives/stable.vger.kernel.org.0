Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A811E44312
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392005AbfFMQ1M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:27:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:53586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730953AbfFMIgB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:36:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26BFB2133D;
        Thu, 13 Jun 2019 08:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560414959;
        bh=iP6jYzHfUINowF7qCGsk1zqpztI8LShfOQD5iyTaOSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UJMGGzfPWPLQiQtmT9EhUhBWyl9PJI7YVf6UanFRgfVFTup0XYqWywLREialMc791
         +XLigljfc2YwUOzkMLbPMd8wMjvnJo4vUUkoQANqjLbtPuSiFH4HDZrk6Urz6e2RrI
         P7Zob8SIY1lJ6htwWcKhD6FHIYg3CdSmtJQAY/hY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Serge Semin <fancer.lancer@gmail.com>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.com>,
        Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        Huacai Chen <chenhc@lemote.com>,
        Stefan Agner <stefan@agner.ch>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Juergen Gross <jgross@suse.com>,
        Serge Semin <Sergey.Semin@t-platforms.ru>,
        linux-mips@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 34/81] mips: Make sure dt memory regions are valid
Date:   Thu, 13 Jun 2019 10:33:17 +0200
Message-Id: <20190613075651.799315210@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075649.074682929@linuxfoundation.org>
References: <20190613075649.074682929@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 0dbcd152a1a9..90f332f0625f 100644
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
 
 void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
-- 
2.20.1



