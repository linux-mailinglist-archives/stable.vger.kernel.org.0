Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E98B32AF2C
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233614AbhCCAPw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:15:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:45332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1443586AbhCBMLa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:11:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 539D164F64;
        Tue,  2 Mar 2021 11:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686236;
        bh=MMMI+OuLDA3u1PKEN0sdy1klVPC1+9eo7l7J3WcUstE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pNrGRMwvPyCYfwHr0RVVsHSLjamDo8Rh1xE7QBcNeMYCJ/r71zTzgOrLzb50Iyw9l
         3kUptzY3xhZ7jW7g9aKxbdaU+9vP3Lo2UaQiNyMt4k/YPZ00O+FBD8JxaY0TxKaCfk
         9Fe/q8xJpvXX0uRkmKLNEMx4BiVbGyEHmcOeHYyMpPiLsyBLJQ/pJap7Tw2x4ow7Fd
         9XWGK8SqZul82Q2T9RUriUgZtUdMq3RqxHBUnesqsXGH8wlNlcTQ3dx6siyMulMwBF
         PZj/U/lYx9lIQXz7gL2PREmr5B4XapJEZzPsrR3lIX76zeYsJseUmfXbo0c2GXdcnN
         UKG47TqAH0oxQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andreas Larsson <andreas@gaisler.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, sparclinux@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 23/47] sparc32: Limit memblock allocation to low memory
Date:   Tue,  2 Mar 2021 06:56:22 -0500
Message-Id: <20210302115646.62291-23-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115646.62291-1-sashal@kernel.org>
References: <20210302115646.62291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index eb2946b1df8a..6139c5700ccc 100644
--- a/arch/sparc/mm/init_32.c
+++ b/arch/sparc/mm/init_32.c
@@ -197,6 +197,9 @@ unsigned long __init bootmem_init(unsigned long *pages_avail)
 	size = memblock_phys_mem_size() - memblock_reserved_size();
 	*pages_avail = (size >> PAGE_SHIFT) - high_pages;
 
+	/* Only allow low memory to be allocated via memblock allocation */
+	memblock_set_current_limit(max_low_pfn << PAGE_SHIFT);
+
 	return max_pfn;
 }
 
-- 
2.30.1

