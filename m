Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B925134DB26
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 00:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232648AbhC2WZ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 18:25:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:48708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232367AbhC2WXw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 18:23:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A79C6198E;
        Mon, 29 Mar 2021 22:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056602;
        bh=5PJ8YJfRJ8pDb18WCFvHlXgHhy6JpaWAJz0+M362HIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FUmNJCNAoNpl4I6U1vNJyeJQGnzSK2d2ajPcJEeKIRbw6NHa7Lx2OC6bxD2bIPgn7
         kL8YHtnq0iONtauDzHiesGv//NpwuGlBCJETgy3PEEPemkyNLlkzIyDgrxQ08V+/a1
         BWpU9PM4Broee+smlEzMsDhJoXiHzb8ujRNegVIS3vdPtEqOAvlWgYI3mJsOwjAPhk
         j07nTTimSTyJitxdZqFF3qNITMC/rYjpmtfZN74MXPbvaFpKaqR9v5UgZyabwXoExV
         sLqWyNx12oRHv2VuigoeoBLRxSKqMZK9TmN1yTAtqTIlcGA4LXNuyPcpYSlCXC6q+z
         bt46aFGhLaMPg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergei Trofimovich <slyfox@gentoo.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-ia64@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 16/19] ia64: mca: allocate early mca with GFP_ATOMIC
Date:   Mon, 29 Mar 2021 18:22:59 -0400
Message-Id: <20210329222303.2383319-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222303.2383319-1-sashal@kernel.org>
References: <20210329222303.2383319-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergei Trofimovich <slyfox@gentoo.org>

[ Upstream commit f2a419cf495f95cac49ea289318b833477e1a0e2 ]

The sleep warning happens at early boot right at secondary CPU
activation bootup:

    smp: Bringing up secondary CPUs ...
    BUG: sleeping function called from invalid context at mm/page_alloc.c:4942
    in_atomic(): 0, irqs_disabled(): 1, non_block: 0, pid: 0, name: swapper/1
    CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.12.0-rc2-00007-g79e228d0b611-dirty #99
    ..
    Call Trace:
      show_stack+0x90/0xc0
      dump_stack+0x150/0x1c0
      ___might_sleep+0x1c0/0x2a0
      __might_sleep+0xa0/0x160
      __alloc_pages_nodemask+0x1a0/0x600
      alloc_page_interleave+0x30/0x1c0
      alloc_pages_current+0x2c0/0x340
      __get_free_pages+0x30/0xa0
      ia64_mca_cpu_init+0x2d0/0x3a0
      cpu_init+0x8b0/0x1440
      start_secondary+0x60/0x700
      start_ap+0x750/0x780
    Fixed BSP b0 value from CPU 1

As I understand interrupts are not enabled yet and system has a lot of
memory.  There is little chance to sleep and switch to GFP_ATOMIC should
be a no-op.

Link: https://lkml.kernel.org/r/20210315085045.204414-1-slyfox@gentoo.org
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/ia64/kernel/mca.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/ia64/kernel/mca.c b/arch/ia64/kernel/mca.c
index bf2cb9294795..d96c68122eae 100644
--- a/arch/ia64/kernel/mca.c
+++ b/arch/ia64/kernel/mca.c
@@ -1851,7 +1851,7 @@ ia64_mca_cpu_init(void *cpu_data)
 			data = mca_bootmem();
 			first_time = 0;
 		} else
-			data = (void *)__get_free_pages(GFP_KERNEL,
+			data = (void *)__get_free_pages(GFP_ATOMIC,
 							get_order(sz));
 		if (!data)
 			panic("Could not allocate MCA memory for cpu %d\n",
-- 
2.30.1

