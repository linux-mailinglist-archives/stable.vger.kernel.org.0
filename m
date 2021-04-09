Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE562359B17
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 12:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234057AbhDIKHb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 06:07:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234166AbhDIKFE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 06:05:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 064E56121F;
        Fri,  9 Apr 2021 10:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962483;
        bh=2IlAAvJl980xN2comXzCKxkWcE4IIyjNVu1VRmB5qJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EsU4K+HO8/+l+OfAPo5Lk7zDxwEgZH0wGyEwesxdlqZ41FTquySjT3Ib0Yr4BtPiL
         NFlH8RhfGnCpkbdB9CEuQ8WBxi757XqlBsW0NIhly06j+HPRcFwvC+vGz8sCXjgEoM
         gqgeALe+J/V7J6c2PEqmFWxMAixMDpGaYcAALU7I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergei Trofimovich <slyfox@gentoo.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 31/45] ia64: mca: allocate early mca with GFP_ATOMIC
Date:   Fri,  9 Apr 2021 11:53:57 +0200
Message-Id: <20210409095306.418920720@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095305.397149021@linuxfoundation.org>
References: <20210409095305.397149021@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 2703f7795672..bd0a51dc345a 100644
--- a/arch/ia64/kernel/mca.c
+++ b/arch/ia64/kernel/mca.c
@@ -1822,7 +1822,7 @@ ia64_mca_cpu_init(void *cpu_data)
 			data = mca_bootmem();
 			first_time = 0;
 		} else
-			data = (void *)__get_free_pages(GFP_KERNEL,
+			data = (void *)__get_free_pages(GFP_ATOMIC,
 							get_order(sz));
 		if (!data)
 			panic("Could not allocate MCA memory for cpu %d\n",
-- 
2.30.2



