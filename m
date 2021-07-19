Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 276673CD98B
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243958AbhGSOan (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:30:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244004AbhGSO3M (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:29:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 559F9610A5;
        Mon, 19 Jul 2021 15:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707320;
        bh=ap2oPNfRt02/mI9wdCfAdmDnlTx0/DgKFz4vx7ZONb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UePD8CgitfAwuJowcrcYKtilqfi4ea7yARHhR33izAzEAS/hghKlzZs8Y17SOUcpO
         wuHcRi/9eVW9dKu8ZX3Y83VwQcpapxRX49qf51FtmrdqThUn4uSGUZb0PZKc2a7pvc
         TTq7f7KYoGd7nS0HieCxzWINuDZVheGXsFxaqGRI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 113/245] of: Fix truncation of memory sizes on 32-bit platforms
Date:   Mon, 19 Jul 2021 16:50:55 +0200
Message-Id: <20210719144944.071969557@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 2892d8a00d23d511a0591ac4b2ff3f050ae1f004 ]

Variable "size" has type "phys_addr_t", which can be either 32-bit or
64-bit on 32-bit systems, while "unsigned long" is always 32-bit on
32-bit systems.  Hence the cast in

    (unsigned long)size / SZ_1M

may truncate a 64-bit size to 32-bit, as casts have a higher operator
precedence than divisions.

Fix this by inverting the order of the cast and division, which should
be safe for memory blocks smaller than 4 PiB.  Note that the division is
actually a shift, as SZ_1M is a power-of-two constant, hence there is no
need to use div_u64().

While at it, use "%lu" to format "unsigned long".

Fixes: e8d9d1f5485b52ec ("drivers: of: add initialization code for static reserved memory")
Fixes: 3f0c8206644836e4 ("drivers: of: add initialization code for dynamic reserved memory")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/4a1117e72d13d26126f57be034c20dac02f1e915.1623835273.git.geert+renesas@glider.be
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/fdt.c             | 8 ++++----
 drivers/of/of_reserved_mem.c | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index e9360d5cbcba..6a239c9bbf59 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -605,11 +605,11 @@ static int __init __reserved_mem_reserve_reg(unsigned long node,
 
 		if (size &&
 		    early_init_dt_reserve_memory_arch(base, size, nomap) == 0)
-			pr_debug("Reserved memory: reserved region for node '%s': base %pa, size %ld MiB\n",
-				uname, &base, (unsigned long)size / SZ_1M);
+			pr_debug("Reserved memory: reserved region for node '%s': base %pa, size %lu MiB\n",
+				uname, &base, (unsigned long)(size / SZ_1M));
 		else
-			pr_info("Reserved memory: failed to reserve memory for node '%s': base %pa, size %ld MiB\n",
-				uname, &base, (unsigned long)size / SZ_1M);
+			pr_info("Reserved memory: failed to reserve memory for node '%s': base %pa, size %lu MiB\n",
+				uname, &base, (unsigned long)(size / SZ_1M));
 
 		len -= t_len;
 		if (first) {
diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index f15bb936dfd8..fca446a13bbb 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -158,9 +158,9 @@ static int __init __reserved_mem_alloc_size(unsigned long node,
 			ret = early_init_dt_alloc_reserved_memory_arch(size,
 					align, start, end, nomap, &base);
 			if (ret == 0) {
-				pr_debug("allocated memory for '%s' node: base %pa, size %ld MiB\n",
+				pr_debug("allocated memory for '%s' node: base %pa, size %lu MiB\n",
 					uname, &base,
-					(unsigned long)size / SZ_1M);
+					(unsigned long)(size / SZ_1M));
 				break;
 			}
 			len -= t_len;
@@ -170,8 +170,8 @@ static int __init __reserved_mem_alloc_size(unsigned long node,
 		ret = early_init_dt_alloc_reserved_memory_arch(size, align,
 							0, 0, nomap, &base);
 		if (ret == 0)
-			pr_debug("allocated memory for '%s' node: base %pa, size %ld MiB\n",
-				uname, &base, (unsigned long)size / SZ_1M);
+			pr_debug("allocated memory for '%s' node: base %pa, size %lu MiB\n",
+				uname, &base, (unsigned long)(size / SZ_1M));
 	}
 
 	if (base == 0) {
-- 
2.30.2



