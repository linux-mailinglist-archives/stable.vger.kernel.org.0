Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E773788CB
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234897AbhEJLYD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:24:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:54898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237316AbhEJLLt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2842761929;
        Mon, 10 May 2021 11:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644944;
        bh=emmUT6X+le+R32azMXmL8HSHFWXsMqDAUpNenGZzSqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0a1txdfmgFsBnRFrs5e3YvRTLrde1eIac0N8SXSDg71tPQy3BTzfG240a2FGIEKv1
         /ai4ToerXjosfw8bvRQP4XJVo6aL0sWtf5fsxWid1ukENLa9e8RASKd3BVUcHDc746
         LJka+kQVSE3nj+ytpSSw5RKfixcVpR6pcFE8kOeE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liao Chang <liaochang1@huawei.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>
Subject: [PATCH 5.12 287/384] riscv/kprobe: fix kernel panic when invoking sys_read traced by kprobe
Date:   Mon, 10 May 2021 12:21:16 +0200
Message-Id: <20210510102024.274389091@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liao Chang <liaochang1@huawei.com>

commit b1ebaa0e1318494a7637099a26add50509e37964 upstream.

The execution of sys_read end up hitting a BUG_ON() in __find_get_block
after installing kprobe at sys_read, the BUG message like the following:

[   65.708663] ------------[ cut here ]------------
[   65.709987] kernel BUG at fs/buffer.c:1251!
[   65.711283] Kernel BUG [#1]
[   65.712032] Modules linked in:
[   65.712925] CPU: 0 PID: 51 Comm: sh Not tainted 5.12.0-rc4 #1
[   65.714407] Hardware name: riscv-virtio,qemu (DT)
[   65.715696] epc : __find_get_block+0x218/0x2c8
[   65.716835]  ra : __getblk_gfp+0x1c/0x4a
[   65.717831] epc : ffffffe00019f11e ra : ffffffe00019f56a sp : ffffffe002437930
[   65.719553]  gp : ffffffe000f06030 tp : ffffffe0015abc00 t0 : ffffffe00191e038
[   65.721290]  t1 : ffffffe00191e038 t2 : 000000000000000a s0 : ffffffe002437960
[   65.723051]  s1 : ffffffe00160ad00 a0 : ffffffe00160ad00 a1 : 000000000000012a
[   65.724772]  a2 : 0000000000000400 a3 : 0000000000000008 a4 : 0000000000000040
[   65.726545]  a5 : 0000000000000000 a6 : ffffffe00191e000 a7 : 0000000000000000
[   65.728308]  s2 : 000000000000012a s3 : 0000000000000400 s4 : 0000000000000008
[   65.730049]  s5 : 000000000000006c s6 : ffffffe00240f800 s7 : ffffffe000f080a8
[   65.731802]  s8 : 0000000000000001 s9 : 000000000000012a s10: 0000000000000008
[   65.733516]  s11: 0000000000000008 t3 : 00000000000003ff t4 : 000000000000000f
[   65.734434]  t5 : 00000000000003ff t6 : 0000000000040000
[   65.734613] status: 0000000000000100 badaddr: 0000000000000000 cause: 0000000000000003
[   65.734901] Call Trace:
[   65.735076] [<ffffffe00019f11e>] __find_get_block+0x218/0x2c8
[   65.735417] [<ffffffe00020017a>] __ext4_get_inode_loc+0xb2/0x2f6
[   65.735618] [<ffffffe000201b6c>] ext4_get_inode_loc+0x3a/0x8a
[   65.735802] [<ffffffe000203380>] ext4_reserve_inode_write+0x2e/0x8c
[   65.735999] [<ffffffe00020357a>] __ext4_mark_inode_dirty+0x4c/0x18e
[   65.736208] [<ffffffe000206bb0>] ext4_dirty_inode+0x46/0x66
[   65.736387] [<ffffffe000192914>] __mark_inode_dirty+0x12c/0x3da
[   65.736576] [<ffffffe000180dd2>] touch_atime+0x146/0x150
[   65.736748] [<ffffffe00010d762>] filemap_read+0x234/0x246
[   65.736920] [<ffffffe00010d834>] generic_file_read_iter+0xc0/0x114
[   65.737114] [<ffffffe0001f5d7a>] ext4_file_read_iter+0x42/0xea
[   65.737310] [<ffffffe000163f2c>] new_sync_read+0xe2/0x15a
[   65.737483] [<ffffffe000165814>] vfs_read+0xca/0xf2
[   65.737641] [<ffffffe000165bae>] ksys_read+0x5e/0xc8
[   65.737816] [<ffffffe000165c26>] sys_read+0xe/0x16
[   65.737973] [<ffffffe000003972>] ret_from_syscall+0x0/0x2
[   65.738858] ---[ end trace fe93f985456c935d ]---

A simple reproducer looks like:
	echo 'p:myprobe sys_read fd=%a0 buf=%a1 count=%a2' > /sys/kernel/debug/tracing/kprobe_events
	echo 1 > /sys/kernel/debug/tracing/events/kprobes/myprobe/enable
	cat /sys/kernel/debug/tracing/trace

Here's what happens to hit that BUG_ON():

1) After installing kprobe at entry of sys_read, the first instruction
   is replaced by 'ebreak' instruction on riscv64 platform.

2) Once kernel reach the 'ebreak' instruction at the entry of sys_read,
   it trap into the riscv breakpoint handler, where it do something to
   setup for coming single-step of origin instruction, including backup
   the 'sstatus' in pt_regs, followed by disable interrupt during single
   stepping via clear 'SIE' bit of 'sstatus' in pt_regs.

3) Then kernel restore to the instruction slot contains two instructions,
   one is original instruction at entry of sys_read, the other is 'ebreak'.
   Here it trigger a 'Instruction page fault' exception (value at 'scause'
   is '0xc'), if PF is not filled into PageTabe for that slot yet.

4) Again kernel trap into page fault exception handler, where it choose
   different policy according to the state of running kprobe. Because
   afte 2) the state is KPROBE_HIT_SS, so kernel reset the current kprobe
   and 'pc' points back to the probe address.

5) Because 'epc' point back to 'ebreak' instrution at sys_read probe,
   kernel trap into breakpoint handler again, and repeat the operations
   at 2), however 'sstatus' without 'SIE' is keep at 4), it cause the
   real 'sstatus' saved at 2) is overwritten by the one withou 'SIE'.

6) When kernel cross the probe the 'sstatus' CSR restore with value
   without 'SIE', and reach __find_get_block where it requires the
   interrupt must be enabled.

Fix this is very trivial, just restore the value of 'sstatus' in pt_regs
with backup one at 2) when the instruction being single stepped cause a
page fault.

Fixes: c22b0bcb1dd02 ("riscv: Add kprobes supported")
Signed-off-by: Liao Chang <liaochang1@huawei.com>
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/probes/kprobes.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/riscv/kernel/probes/kprobes.c
+++ b/arch/riscv/kernel/probes/kprobes.c
@@ -260,8 +260,10 @@ int __kprobes kprobe_fault_handler(struc
 
 		if (kcb->kprobe_status == KPROBE_REENTER)
 			restore_previous_kprobe(kcb);
-		else
+		else {
+			kprobes_restore_local_irqflag(kcb, regs);
 			reset_current_kprobe();
+		}
 
 		break;
 	case KPROBE_HIT_ACTIVE:


