Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29CC424BDB4
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728250AbgHTNLM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:11:12 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:9795 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727084AbgHTNLG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 09:11:06 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id DE87FE644D56D59FBCBC;
        Thu, 20 Aug 2020 21:10:58 +0800 (CST)
Received: from DESKTOP-8N3QUD5.china.huawei.com (10.67.102.173) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Thu, 20 Aug 2020 21:10:49 +0800
From:   Guohua Zhong <zhongguohua1@huawei.com>
To:     <paulus@samba.org>, <mpe@ellerman.id.au>,
        <benh@kernel.crashing.org>, <gregkh@linuxfoundation.org>
CC:     <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, <nixiaoming@huawei.com>,
        <wangle6@huawei.com>
Subject: [PATCH] powerpc: Fix a bug in __div64_32 if divisor is zero
Date:   Thu, 20 Aug 2020 21:10:49 +0800
Message-ID: <20200820131049.42940-1-zhongguohua1@huawei.com>
X-Mailer: git-send-email 2.21.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.102.173]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When cat /proc/pid/stat, do_task_stat will call into cputime_adjust,
which call stack is like this:

[17179954.674326]BookE Watchdog detected hard LOCKUP on cpu 0
[17179954.674331]dCPU: 0 PID: 1262 Comm: TICK Tainted: P        W  O    4.4.176 #1
[17179954.674339]dtask: dc9d7040 task.stack: d3cb4000
[17179954.674344]NIP: c001b1a8 LR: c006a7ac CTR: 00000000
[17179954.674349]REGS: e6fe1f10 TRAP: 3202   Tainted: P        W  O     (4.4.176)
[17179954.674355]MSR: 00021002 <CE,ME>  CR: 28002224  XER: 00000000
[17179954.674364]
GPR00: 00000016 d3cb5cb0 dc9d7040 d3cb5cc0 00000000 0000025d ffe15b24 ffffffff
GPR08: de86aead 00000000 000003ff ffffffff 28002222 0084d1c0 00000000 ffffffff
GPR16: b5929ca0 b4bb7a48 c0863c08 0000048d 00000062 00000062 00000000 0000000f
GPR24: 00000000 d3cb5d08 d3cb5d60 d3cb5d64 00029002 d3e9c214 fffff30e d3e9c20c
[17179954.674410]NIP [c001b1a8] __div64_32+0x60/0xa0
[17179954.674422]LR [c006a7ac] cputime_adjust+0x124/0x138
[17179954.674434]Call Trace:
[17179961.832693]Call Trace:
[17179961.832695][d3cb5cb0] [c006a6dc] cputime_adjust+0x54/0x138 (unreliable)
[17179961.832705][d3cb5cf0] [c006a818] task_cputime_adjusted+0x58/0x80
[17179961.832713][d3cb5d20] [c01dab44] do_task_stat+0x298/0x870
[17179961.832720][d3cb5de0] [c01d4948] proc_single_show+0x60/0xa4
[17179961.832728][d3cb5e10] [c01963d8] seq_read+0x2d8/0x52c
[17179961.832736][d3cb5e80] [c01702fc] __vfs_read+0x40/0x114
[17179961.832744][d3cb5ef0] [c0170b1c] vfs_read+0x9c/0x10c
[17179961.832751][d3cb5f10] [c0171440] SyS_read+0x68/0xc4
[17179961.832759][d3cb5f40] [c0010a40] ret_from_syscall+0x0/0x3c

do_task_stat->task_cputime_adjusted->cputime_adjust->scale_stime->div_u64
->div_u64_rem->do_div->__div64_32

In some corner case, stime + utime = 0 if overflow. Even in v5.8.2  kernel
the cputime has changed from unsigned long to u64 data type. About 200
days, the lowwer 32 bit will be 0x00000000. Because divisor for __div64_32
is unsigned long data type,which is 32 bit for powepc 32, the bug still
exists.

So it is also a bug in the cputime_adjust which does not check if
stime + utime = 0

time = scale_stime((__force u64)stime, (__force u64)rtime,
                (__force u64)(stime + utime));

The commit 3dc167ba5729 ("sched/cputime: Improve cputime_adjust()") in
mainline kernel may has fixed this case. But it is also better to check
if divisor is 0 in __div64_32 for other situation.

Signed-off-by: Guohua Zhong <zhongguohua1@huawei.com>
Fixes:14cf11af6cf6 "( powerpc: Merge enough to start building in arch/powerpc.)"
Fixes:94b212c29f68 "( powerpc: Move ppc64 boot wrapper code over to arch/powerpc)"
Cc: stable@vger.kernel.org # v2.6.15+
---
 arch/powerpc/boot/div64.S | 4 ++++
 arch/powerpc/lib/div64.S  | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/arch/powerpc/boot/div64.S b/arch/powerpc/boot/div64.S
index 4354928ed62e..39a25b9712d1 100644
--- a/arch/powerpc/boot/div64.S
+++ b/arch/powerpc/boot/div64.S
@@ -13,6 +13,9 @@
 
 	.globl __div64_32
 __div64_32:
+	li	r9,0
+	cmplw	r4,r9	# check if divisor r4 is zero
+	beq	5f			# jump to label 5 if r4(divisor) is zero
 	lwz	r5,0(r3)	# get the dividend into r5/r6
 	lwz	r6,4(r3)
 	cmplw	r5,r4
@@ -52,6 +55,7 @@ __div64_32:
 4:	stw	r7,0(r3)	# return the quotient in *r3
 	stw	r8,4(r3)
 	mr	r3,r6		# return the remainder in r3
+5:					# return if divisor r4 is zero
 	blr
 
 /*
diff --git a/arch/powerpc/lib/div64.S b/arch/powerpc/lib/div64.S
index 3d5426e7dcc4..1cc9bcabf678 100644
--- a/arch/powerpc/lib/div64.S
+++ b/arch/powerpc/lib/div64.S
@@ -13,6 +13,9 @@
 #include <asm/processor.h>
 
 _GLOBAL(__div64_32)
+	li	r9,0
+	cmplw	r4,r9	# check if divisor r4 is zero
+	beq	5f			# jump to label 5 if r4(divisor) is zero
 	lwz	r5,0(r3)	# get the dividend into r5/r6
 	lwz	r6,4(r3)
 	cmplw	r5,r4
@@ -52,4 +55,5 @@ _GLOBAL(__div64_32)
 4:	stw	r7,0(r3)	# return the quotient in *r3
 	stw	r8,4(r3)
 	mr	r3,r6		# return the remainder in r3
+5:					# return if divisor r4 is zero
 	blr
-- 
2.12.3


