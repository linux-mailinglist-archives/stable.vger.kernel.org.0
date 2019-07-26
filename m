Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 642AC7685E
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727997AbfGZNoK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:44:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:52152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727348AbfGZNoH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:44:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E74622CC2;
        Fri, 26 Jul 2019 13:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148646;
        bh=ItV/L+YqpHgl/KAEB0KZea0d2qVCwzkzhqwD8RJx8cU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V7jx6t4vWtqHHt59KrWRICnzspkZfmSGLjwyDlSzrzzyl4iL56qUBep2u8Tdph1rh
         n0mso3R83KiTGBm1/CPYm3WYsVYZNijew/ZR+hT8b6qA7z6z8LMrywDBTMEIaVwJrM
         SUY7l5Dqt+SREEzLtHo0dMUFOnliVIIPQpo9RADM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Doug Berger <opendmb@gmail.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Yue Hu <huyue2@yulong.com>, Mike Rapoport <rppt@linux.ibm.com>,
        Laura Abbott <labbott@redhat.com>, Peng Fan <peng.fan@nxp.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 4.14 23/37] mm/cma.c: fail if fixed declaration can't be honored
Date:   Fri, 26 Jul 2019 09:43:18 -0400
Message-Id: <20190726134332.12626-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726134332.12626-1-sashal@kernel.org>
References: <20190726134332.12626-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Doug Berger <opendmb@gmail.com>

[ Upstream commit c633324e311243586675e732249339685e5d6faa ]

The description of cma_declare_contiguous() indicates that if the
'fixed' argument is true the reserved contiguous area must be exactly at
the address of the 'base' argument.

However, the function currently allows the 'base', 'size', and 'limit'
arguments to be silently adjusted to meet alignment constraints.  This
commit enforces the documented behavior through explicit checks that
return an error if the region does not fit within a specified region.

Link: http://lkml.kernel.org/r/1561422051-16142-1-git-send-email-opendmb@gmail.com
Fixes: 5ea3b1b2f8ad ("cma: add placement specifier for "cma=" kernel parameter")
Signed-off-by: Doug Berger <opendmb@gmail.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Yue Hu <huyue2@yulong.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Peng Fan <peng.fan@nxp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/cma.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/mm/cma.c b/mm/cma.c
index 56761e40d191..c4a34c813d47 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -277,6 +277,12 @@ int __init cma_declare_contiguous(phys_addr_t base,
 	 */
 	alignment = max(alignment,  (phys_addr_t)PAGE_SIZE <<
 			  max_t(unsigned long, MAX_ORDER - 1, pageblock_order));
+	if (fixed && base & (alignment - 1)) {
+		ret = -EINVAL;
+		pr_err("Region at %pa must be aligned to %pa bytes\n",
+			&base, &alignment);
+		goto err;
+	}
 	base = ALIGN(base, alignment);
 	size = ALIGN(size, alignment);
 	limit &= ~(alignment - 1);
@@ -307,6 +313,13 @@ int __init cma_declare_contiguous(phys_addr_t base,
 	if (limit == 0 || limit > memblock_end)
 		limit = memblock_end;
 
+	if (base + size > limit) {
+		ret = -EINVAL;
+		pr_err("Size (%pa) of region at %pa exceeds limit (%pa)\n",
+			&size, &base, &limit);
+		goto err;
+	}
+
 	/* Reserve memory */
 	if (fixed) {
 		if (memblock_is_region_reserved(base, size) ||
-- 
2.20.1

