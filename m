Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B05FC45E63F
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 04:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244768AbhKZCuU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 21:50:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:51534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358509AbhKZCrT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 21:47:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8499961374;
        Fri, 26 Nov 2021 02:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637894228;
        bh=uqawlr9zy7pGfMRipHFNWdvMwmCbYY28igxknANgURg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZSU5qhwptnwQWYjMe+Qu259Ee0t2VlLdgTa5D2slh3Gi1wwOKpTW+VqtndFq+gqWi
         4DYcAXfqYr8BIVmVnExYwet9dYCSnNQaLKfffSBx7Qn+SAuGhFcRSd0tLkMnSym6Ah
         lu2hdbL1lwVhhUKLt1oVQbUgMkj60WQfAyubfOjAXRKXcLEhBqNYwLX2Rj/UiXBF31
         c1ivxF4t5Yz7ip1CYHiYLLzS8WKHQXKjdvnnpofPlR6rcOt9QllRgDrksIyEQZsdAa
         jp9p3pn5KixTLOtW7fJS3BMGFxHJ2Gm10BCXFgr2svPrH/r/YDrQcZ828fKAuBqe/K
         XRoWuJgbQh8Hg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, borntraeger@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com,
        egorenar@linux.ibm.com, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 3/6] s390/setup: avoid using memblock_enforce_memory_limit
Date:   Thu, 25 Nov 2021 21:36:58 -0500
Message-Id: <20211126023701.443472-3-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023701.443472-1-sashal@kernel.org>
References: <20211126023701.443472-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit 5dbc4cb4667457b0c53bcd7bff11500b3c362975 ]

There is a difference in how architectures treat "mem=" option. For some
that is an amount of online memory, for s390 and x86 this is the limiting
max address. Some memblock api like memblock_enforce_memory_limit()
take limit argument and explicitly treat it as the size of online memory,
and use __find_max_addr to convert it to an actual max address. Current
s390 usage:

memblock_enforce_memory_limit(memblock_end_of_DRAM());

yields different results depending on presence of memory holes (offline
memory blocks in between online memory). If there are no memory holes
limit == max_addr in memblock_enforce_memory_limit() and it does trim
online memory and reserved memory regions. With memory holes present it
actually does nothing.

Since we already use memblock_remove() explicitly to trim online memory
regions to potential limit (think mem=, kdump, addressing limits, etc.)
drop the usage of memblock_enforce_memory_limit() altogether. Trimming
reserved regions should not be required, since we now use
memblock_set_current_limit() to limit allocations and any explicit memory
reservations above the limit is an actual problem we should not hide.

Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/setup.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index fdc5e76e1f6b0..a765b4936c10c 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -687,9 +687,6 @@ static void __init setup_memory(void)
 		storage_key_init_range(reg->base, reg->base + reg->size);
 	}
 	psw_set_key(PAGE_DEFAULT_KEY);
-
-	/* Only cosmetics */
-	memblock_enforce_memory_limit(memblock_end_of_DRAM());
 }
 
 /*
-- 
2.33.0

