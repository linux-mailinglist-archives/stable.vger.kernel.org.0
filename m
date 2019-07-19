Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E707F6DC5C
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727190AbfGSEPa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:15:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:51758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390103AbfGSEP2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:15:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99EF22189E;
        Fri, 19 Jul 2019 04:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509727;
        bh=AI3xRFnnUV5UPqRP4tNimsvoXXObJLv9QTyaf2yDCpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TBt89N1nBUOjm0LoLxP9oIKFZ0zTewFZ4KsDAwwYHL9AEVq4YKuDxO3ce4V4MaEf1
         y8vL1IfJ3m/6F37NjqGWU3d4Mpsk8CXD96A6uCsXkEkKqYgZEqpdb1gJGk3rl4apm/
         l/mowcop7eFehaDFJEn4wrHCC0dfViQP7gWBXu+M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 4.4 32/35] mm/kmemleak.c: fix check for softirq context
Date:   Fri, 19 Jul 2019 00:14:20 -0400
Message-Id: <20190719041423.19322-32-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719041423.19322-1-sashal@kernel.org>
References: <20190719041423.19322-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Vyukov <dvyukov@google.com>

[ Upstream commit 6ef9056952532c3b746de46aa10d45b4d7797bd8 ]

in_softirq() is a wrong predicate to check if we are in a softirq
context.  It also returns true if we have BH disabled, so objects are
falsely stamped with "softirq" comm.  The correct predicate is
in_serving_softirq().

If user does cat from /sys/kernel/debug/kmemleak previously they would
see this, which is clearly wrong, this is system call context (see the
comm):

unreferenced object 0xffff88805bd661c0 (size 64):
  comm "softirq", pid 0, jiffies 4294942959 (age 12.400s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
    00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00  ................
  backtrace:
    [<0000000007dcb30c>] kmemleak_alloc_recursive include/linux/kmemleak.h:55 [inline]
    [<0000000007dcb30c>] slab_post_alloc_hook mm/slab.h:439 [inline]
    [<0000000007dcb30c>] slab_alloc mm/slab.c:3326 [inline]
    [<0000000007dcb30c>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
    [<00000000969722b7>] kmalloc include/linux/slab.h:547 [inline]
    [<00000000969722b7>] kzalloc include/linux/slab.h:742 [inline]
    [<00000000969722b7>] ip_mc_add1_src net/ipv4/igmp.c:1961 [inline]
    [<00000000969722b7>] ip_mc_add_src+0x36b/0x400 net/ipv4/igmp.c:2085
    [<00000000a4134b5f>] ip_mc_msfilter+0x22d/0x310 net/ipv4/igmp.c:2475
    [<00000000d20248ad>] do_ip_setsockopt.isra.0+0x19fe/0x1c00 net/ipv4/ip_sockglue.c:957
    [<000000003d367be7>] ip_setsockopt+0x3b/0xb0 net/ipv4/ip_sockglue.c:1246
    [<000000003c7c76af>] udp_setsockopt+0x4e/0x90 net/ipv4/udp.c:2616
    [<000000000c1aeb23>] sock_common_setsockopt+0x3e/0x50 net/core/sock.c:3130
    [<000000000157b92b>] __sys_setsockopt+0x9e/0x120 net/socket.c:2078
    [<00000000a9f3d058>] __do_sys_setsockopt net/socket.c:2089 [inline]
    [<00000000a9f3d058>] __se_sys_setsockopt net/socket.c:2086 [inline]
    [<00000000a9f3d058>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2086
    [<000000001b8da885>] do_syscall_64+0x7c/0x1a0 arch/x86/entry/common.c:301
    [<00000000ba770c62>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

now they will see this:

unreferenced object 0xffff88805413c800 (size 64):
  comm "syz-executor.4", pid 8960, jiffies 4294994003 (age 14.350s)
  hex dump (first 32 bytes):
    00 7a 8a 57 80 88 ff ff e0 00 00 01 00 00 00 00  .z.W............
    00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000c5d3be64>] kmemleak_alloc_recursive include/linux/kmemleak.h:55 [inline]
    [<00000000c5d3be64>] slab_post_alloc_hook mm/slab.h:439 [inline]
    [<00000000c5d3be64>] slab_alloc mm/slab.c:3326 [inline]
    [<00000000c5d3be64>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
    [<0000000023865be2>] kmalloc include/linux/slab.h:547 [inline]
    [<0000000023865be2>] kzalloc include/linux/slab.h:742 [inline]
    [<0000000023865be2>] ip_mc_add1_src net/ipv4/igmp.c:1961 [inline]
    [<0000000023865be2>] ip_mc_add_src+0x36b/0x400 net/ipv4/igmp.c:2085
    [<000000003029a9d4>] ip_mc_msfilter+0x22d/0x310 net/ipv4/igmp.c:2475
    [<00000000ccd0a87c>] do_ip_setsockopt.isra.0+0x19fe/0x1c00 net/ipv4/ip_sockglue.c:957
    [<00000000a85a3785>] ip_setsockopt+0x3b/0xb0 net/ipv4/ip_sockglue.c:1246
    [<00000000ec13c18d>] udp_setsockopt+0x4e/0x90 net/ipv4/udp.c:2616
    [<0000000052d748e3>] sock_common_setsockopt+0x3e/0x50 net/core/sock.c:3130
    [<00000000512f1014>] __sys_setsockopt+0x9e/0x120 net/socket.c:2078
    [<00000000181758bc>] __do_sys_setsockopt net/socket.c:2089 [inline]
    [<00000000181758bc>] __se_sys_setsockopt net/socket.c:2086 [inline]
    [<00000000181758bc>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2086
    [<00000000d4b73623>] do_syscall_64+0x7c/0x1a0 arch/x86/entry/common.c:301
    [<00000000c1098bec>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Link: http://lkml.kernel.org/r/20190517171507.96046-1-dvyukov@gmail.com
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/kmemleak.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 84c93879aa5d..4d675318754e 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -566,7 +566,7 @@ static struct kmemleak_object *create_object(unsigned long ptr, size_t size,
 	if (in_irq()) {
 		object->pid = 0;
 		strncpy(object->comm, "hardirq", sizeof(object->comm));
-	} else if (in_softirq()) {
+	} else if (in_serving_softirq()) {
 		object->pid = 0;
 		strncpy(object->comm, "softirq", sizeof(object->comm));
 	} else {
-- 
2.20.1

