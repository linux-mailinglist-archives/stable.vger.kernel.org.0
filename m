Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B850E33B7B1
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233201AbhCOOBK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:01:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:35186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232730AbhCON7h (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF25164EED;
        Mon, 15 Mar 2021 13:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816758;
        bh=0tFYE3MtH4RazdZlGrhlquZE9L0mDp7osAYvpz8Ww1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I50eQtcvIWo81rdeqao5QIBWENdgsoEJA1AKU8SiJBktjyQTvUFnQOKZh8W3hSQ8U
         BPqhbnCOlozkK6tOQ3i90WjcRwtBW0rGyPUFtjEKNG9iQfB7vmyeWsrO7pPpi1t5V0
         3HkiCpv0g53/GdAPZOEV4nncAYnH4ugvjqxDt7ZQ=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Larsson <andreas@gaisler.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 049/120] sparc32: Limit memblock allocation to low memory
Date:   Mon, 15 Mar 2021 14:56:40 +0100
Message-Id: <20210315135721.590718391@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135720.002213995@linuxfoundation.org>
References: <20210315135720.002213995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Andreas Larsson <andreas@gaisler.com>

[ Upstream commit bda166930c37604ffa93f2425426af6921ec575a ]

Commit cca079ef8ac29a7c02192d2bad2ffe4c0c5ffdd0 changed sparc32 to use
memblocks instead of bootmem, but also made high memory available via
memblock allocation which does not work together with e.g. phys_to_virt
and can lead to kernel panic.

This changes back to only low memory being allocatable in the early
stages, now using memblock allocation.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/mm/init_32.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/sparc/mm/init_32.c b/arch/sparc/mm/init_32.c
index 92634d4e440c..89a9244f2cf0 100644
--- a/arch/sparc/mm/init_32.c
+++ b/arch/sparc/mm/init_32.c
@@ -199,6 +199,9 @@ unsigned long __init bootmem_init(unsigned long *pages_avail)
 	size = memblock_phys_mem_size() - memblock_reserved_size();
 	*pages_avail = (size >> PAGE_SHIFT) - high_pages;
 
+	/* Only allow low memory to be allocated via memblock allocation */
+	memblock_set_current_limit(max_low_pfn << PAGE_SHIFT);
+
 	return max_pfn;
 }
 
-- 
2.30.1



