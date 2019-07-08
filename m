Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79127623C7
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389531AbfGHPab (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:30:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:59488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389529AbfGHPaa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:30:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49F2020645;
        Mon,  8 Jul 2019 15:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599829;
        bh=hNG9zMpD2KcbjZHO4UlIwrogp7Cmi6S9ALIZ+siNpVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qocIKDreBUa1RFoYU8zb34qzo5uxqDeEHtn7XLvFBtkVbSubqU44tVK/YvNSvOXfE
         uB3b4EtWFTi60ENwCvaBf3fYu2pZ/42A0qNzCcrPfGHpCaCqFBCkuJs0WrrQaymibA
         ZiyavkEeR6Q2aCPUZ4OZCOWaE25LpSYbhS7VMQ9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Li <liwei391@huawei.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 39/90] ftrace: Fix NULL pointer dereference in free_ftrace_func_mapper()
Date:   Mon,  8 Jul 2019 17:13:06 +0200
Message-Id: <20190708150524.556419801@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150521.829733162@linuxfoundation.org>
References: <20190708150521.829733162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 04e03d9a616c19a47178eaca835358610e63a1dd ]

The mapper may be NULL when called from register_ftrace_function_probe()
with probe->data == NULL.

This issue can be reproduced as follow (it may be covered by compiler
optimization sometime):

/ # cat /sys/kernel/debug/tracing/set_ftrace_filter
#### all functions enabled ####
/ # echo foo_bar:dump > /sys/kernel/debug/tracing/set_ftrace_filter
[  206.949100] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
[  206.952402] Mem abort info:
[  206.952819]   ESR = 0x96000006
[  206.955326]   Exception class = DABT (current EL), IL = 32 bits
[  206.955844]   SET = 0, FnV = 0
[  206.956272]   EA = 0, S1PTW = 0
[  206.956652] Data abort info:
[  206.957320]   ISV = 0, ISS = 0x00000006
[  206.959271]   CM = 0, WnR = 0
[  206.959938] user pgtable: 4k pages, 48-bit VAs, pgdp=0000000419f3a000
[  206.960483] [0000000000000000] pgd=0000000411a87003, pud=0000000411a83003, pmd=0000000000000000
[  206.964953] Internal error: Oops: 96000006 [#1] SMP
[  206.971122] Dumping ftrace buffer:
[  206.973677]    (ftrace buffer empty)
[  206.975258] Modules linked in:
[  206.976631] Process sh (pid: 281, stack limit = 0x(____ptrval____))
[  206.978449] CPU: 10 PID: 281 Comm: sh Not tainted 5.2.0-rc1+ #17
[  206.978955] Hardware name: linux,dummy-virt (DT)
[  206.979883] pstate: 60000005 (nZCv daif -PAN -UAO)
[  206.980499] pc : free_ftrace_func_mapper+0x2c/0x118
[  206.980874] lr : ftrace_count_free+0x68/0x80
[  206.982539] sp : ffff0000182f3ab0
[  206.983102] x29: ffff0000182f3ab0 x28: ffff8003d0ec1700
[  206.983632] x27: ffff000013054b40 x26: 0000000000000001
[  206.984000] x25: ffff00001385f000 x24: 0000000000000000
[  206.984394] x23: ffff000013453000 x22: ffff000013054000
[  206.984775] x21: 0000000000000000 x20: ffff00001385fe28
[  206.986575] x19: ffff000013872c30 x18: 0000000000000000
[  206.987111] x17: 0000000000000000 x16: 0000000000000000
[  206.987491] x15: ffffffffffffffb0 x14: 0000000000000000
[  206.987850] x13: 000000000017430e x12: 0000000000000580
[  206.988251] x11: 0000000000000000 x10: cccccccccccccccc
[  206.988740] x9 : 0000000000000000 x8 : ffff000013917550
[  206.990198] x7 : ffff000012fac2e8 x6 : ffff000012fac000
[  206.991008] x5 : ffff0000103da588 x4 : 0000000000000001
[  206.991395] x3 : 0000000000000001 x2 : ffff000013872a28
[  206.991771] x1 : 0000000000000000 x0 : 0000000000000000
[  206.992557] Call trace:
[  206.993101]  free_ftrace_func_mapper+0x2c/0x118
[  206.994827]  ftrace_count_free+0x68/0x80
[  206.995238]  release_probe+0xfc/0x1d0
[  206.995555]  register_ftrace_function_probe+0x4a8/0x868
[  206.995923]  ftrace_trace_probe_callback.isra.4+0xb8/0x180
[  206.996330]  ftrace_dump_callback+0x50/0x70
[  206.996663]  ftrace_regex_write.isra.29+0x290/0x3a8
[  206.997157]  ftrace_filter_write+0x44/0x60
[  206.998971]  __vfs_write+0x64/0xf0
[  206.999285]  vfs_write+0x14c/0x2f0
[  206.999591]  ksys_write+0xbc/0x1b0
[  206.999888]  __arm64_sys_write+0x3c/0x58
[  207.000246]  el0_svc_common.constprop.0+0x408/0x5f0
[  207.000607]  el0_svc_handler+0x144/0x1c8
[  207.000916]  el0_svc+0x8/0xc
[  207.003699] Code: aa0003f8 a9025bf5 aa0103f5 f946ea80 (f9400303)
[  207.008388] ---[ end trace 7b6d11b5f542bdf1 ]---
[  207.010126] Kernel panic - not syncing: Fatal exception
[  207.011322] SMP: stopping secondary CPUs
[  207.013956] Dumping ftrace buffer:
[  207.014595]    (ftrace buffer empty)
[  207.015632] Kernel Offset: disabled
[  207.017187] CPU features: 0x002,20006008
[  207.017985] Memory Limit: none
[  207.019825] ---[ end Kernel panic - not syncing: Fatal exception ]---

Link: http://lkml.kernel.org/r/20190606031754.10798-1-liwei391@huawei.com

Signed-off-by: Wei Li <liwei391@huawei.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ftrace.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 50ba14591996..0a0bb839ac5e 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -4213,10 +4213,13 @@ void free_ftrace_func_mapper(struct ftrace_func_mapper *mapper,
 	struct ftrace_func_entry *entry;
 	struct ftrace_func_map *map;
 	struct hlist_head *hhd;
-	int size = 1 << mapper->hash.size_bits;
-	int i;
+	int size, i;
+
+	if (!mapper)
+		return;
 
 	if (free_func && mapper->hash.count) {
+		size = 1 << mapper->hash.size_bits;
 		for (i = 0; i < size; i++) {
 			hhd = &mapper->hash.buckets[i];
 			hlist_for_each_entry(entry, hhd, hlist) {
-- 
2.20.1



