Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 754CA412EB9
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 08:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbhIUGnA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 02:43:00 -0400
Received: from rn-mailsvcp-ppex-lapp44.apple.com ([17.179.253.48]:51966 "EHLO
        rn-mailsvcp-ppex-lapp44.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229788AbhIUGm7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 02:42:59 -0400
X-Greylist: delayed 7365 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Sep 2021 02:42:59 EDT
Received: from pps.filterd (rn-mailsvcp-ppex-lapp44.rno.apple.com [127.0.0.1])
        by rn-mailsvcp-ppex-lapp44.rno.apple.com (8.16.1.2/8.16.1.2) with SMTP id 18L4ao8T013367;
        Mon, 20 Sep 2021 21:38:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=cc : from : subject :
 to : message-id : date : mime-version : content-type :
 content-transfer-encoding; s=20180706;
 bh=S4U9re3F2Mbh/Pkuydk3z4vcCN13N9hiDA8wPV2znSs=;
 b=h/BOQFKHLOik6fD6lekP1VYVWPLkcSY99c6ZImdASgEXEVwXYGn0DRBn8o+Gtm6UEvr+
 w9FUWEaSwws19z/5fPAzDu5+8Pg3DZRTCr3b33aR0yff3pDDtbN3hOInoajrP9WHGeEV
 8TjLoRjykv/dn1KhOa0t0kJwwrIeXdPH4SiuavQ+pR2rNP4CdR2fJMclgKY/HgalwSjc
 eiZoa9xnOBhHrxrFixmQaex5mdCTiOW/UKCe3fRr+DJ36BrA5xlS7hE2oVkreZMj6JAy
 PQ1/SDo4rjk9/GchRHi18ukd+6GC6bILP2fws1P4Uxh/bNSRMdzLltpQ9M1BDyFShgMe Lw== 
Received: from ma-mailsvcp-mta-lapp04.corp.apple.com (ma-mailsvcp-mta-lapp04.corp.apple.com [10.226.18.136])
        by rn-mailsvcp-ppex-lapp44.rno.apple.com with ESMTP id 3b5bmb2j3d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Mon, 20 Sep 2021 21:38:42 -0700
Received: from ma-mailsvcp-mmp-lapp01.apple.com
 (ma-mailsvcp-mmp-lapp01.apple.com [17.32.222.14])
 by ma-mailsvcp-mta-lapp04.corp.apple.com
 (Oracle Communications Messaging Server 8.1.0.9.20210415 64bit (built Apr 15
 2021))
 with ESMTPS id <0QZR00ENTOWHZZ10@ma-mailsvcp-mta-lapp04.corp.apple.com>; Mon,
 20 Sep 2021 21:38:41 -0700 (PDT)
Received: from process_milters-daemon.ma-mailsvcp-mmp-lapp01.apple.com by
 ma-mailsvcp-mmp-lapp01.apple.com
 (Oracle Communications Messaging Server 8.1.0.9.20210415 64bit (built Apr 15
 2021)) id <0QZR00M00OBA4K00@ma-mailsvcp-mmp-lapp01.apple.com>; Mon,
 20 Sep 2021 21:38:41 -0700 (PDT)
X-Va-A: 
X-Va-T-CD: d5b3a1fcc7da27abb9160183583a5404
X-Va-E-CD: 3e89611b360c530842f7aca1f508208c
X-Va-R-CD: 2aafdd1a66914cad20b8966d251bd628
X-Va-CD: 0
X-Va-ID: 54147b7f-437f-406b-97ce-95bcdc1ca2e5
X-V-A:  
X-V-T-CD: d5b3a1fcc7da27abb9160183583a5404
X-V-E-CD: 3e89611b360c530842f7aca1f508208c
X-V-R-CD: 2aafdd1a66914cad20b8966d251bd628
X-V-CD: 0
X-V-ID: 25b70092-addd-4b82-aaf8-7a74e1b939f8
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-21_01:2021-09-20,2021-09-21 signatures=0
Received: from Vishnus-iPro.lan (unknown [17.168.70.206])
 by ma-mailsvcp-mmp-lapp01.apple.com
 (Oracle Communications Messaging Server 8.1.0.9.20210415 64bit (built Apr 15
 2021)) with ESMTPSA id <0QZR00U7AOWGHR00@ma-mailsvcp-mmp-lapp01.apple.com>;
 Mon, 20 Sep 2021 21:38:41 -0700 (PDT)
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Vishnu Rangayyan <vishnu.rangayyan@apple.com>
Subject: [PATCH] fs: fix for core dumping of a process getting oom-killed
To:     Al Viro <viro@zeniv.linux.org.uk>
Message-id: <9aec4002-754c-ca6d-7caf-9de6e8c31dd7@apple.com>
Date:   Mon, 20 Sep 2021 23:38:40 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed
Content-language: en-US
Content-transfer-encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-20_10:2021-09-20,2021-09-20 signatures=0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Processes inside a memcg that get core dumped when there is less memory
available in the memcg can have the core dumping interrupted by the 
oom-killer.
We saw this with qemu processes inside a memcg, as in this trace below.
The memcg was not out of memory when the core dump was triggered.

[201169.028782] qemu-kata-syste invoked oom-killer: 
gfp_mask=0x101c4a(GFP_NOFS|__GFP_HIGHMEM|__GFP_HARDWALL|__GFP_MOVABLE|__GFP_WRITE), 
order=0, oom_score_adj=-100
[201169.028785] CPU: 3 PID: 1887079 Comm: qemu-kata-syste Kdump: loaded 
Tainted: P W O 5.4.77-7.el7pie #1
[201169.028786] Call Trace:
[201169.028794] dump_stack+0x8f/0xd0
[201169.028797] dump_header+0x4a/0x1d8
[201169.028799] oom_kill_process.cold.33+0xb/0x10
[201169.028800] out_of_memory+0x199/0x460
[201169.028804] mem_cgroup_out_of_memory+0xbe/0xd0
[201169.028805] try_charge+0x789/0x800
[201169.028807] mem_cgroup_try_charge+0x6a/0x190
[201169.028809] __add_to_page_cache_locked+0x29d/0x2f0
[201169.028812] ? scan_shadow_nodes+0x30/0x30
[201169.028813] add_to_page_cache_lru+0x4a/0xc0
[201169.028814] pagecache_get_page+0x101/0x220
[201169.028816] grab_cache_page_write_begin+0x1f/0x40
[201169.028818] iomap_write_begin.constprop.31+0x1b6/0x330
[201169.028819] ? iomap_write_end+0x240/0x240
[201169.028822] ? xfs_file_iomap_begin+0x387/0x5d0
[201169.028823] ? iomap_write_end+0x240/0x240
[201169.028824] iomap_write_actor+0x92/0x170
[201169.028825] ? iomap_write_end+0x240/0x240
[201169.028826] iomap_apply+0xba/0x130
[201169.028827] ? iomap_write_end+0x240/0x240
[201169.028828] iomap_file_buffered_write+0x61/0x80
[201169.028829] ? iomap_write_end+0x240/0x240
[201169.028831] xfs_file_buffered_aio_write+0xca/0x320
[201169.028832] new_sync_write+0x11b/0x1b0
[201169.028833] __kernel_write+0x4f/0xf0
[201169.028834] dump_emit+0x91/0xc0
[201169.028837] elf_core_dump+0x818/0x9a0
[201169.028839] do_coredump+0x52b/0xb0b
[201169.028842] get_signal+0x134/0x820
[201169.028844] do_signal+0x36/0x5d0
[201169.028845] ? do_send_specific+0x66/0x80
[201169.028847] ? audit_filter_inodes+0x2e/0x100
[201169.028848] ? audit_filter_syscall.constprop.19+0x2c/0xd0
[201169.028850] do_syscall_64+0x1aa/0x58e
[201169.028852] ? trace_hardirqs_off_thunk+0x1a/0x30
[201169.028854] entry_SYSCALL_64_after_hwframe+0x49/0xbe
[201169.028856] RIP: 0033:0x7fdf0bbd73d7
[201169.028857] Code: 02 00 00 85 f6 75 34 b8 ba 00 00 00 0f 05 89 c1 64 
89 04 25 d0 02 00 00 89 c6 48 63 d7 48 63 f6 48 63 f9 b8 ea 00 00 00 0f 
05 <48> 3d 00 f0 ff ff 77 1e f3 c3 0f 1f 80 00 00 00 00 85 c9 7f db 89
[201169.028858] RSP: 002b:00007fff9b56a018 EFLAGS: 00000202 ORIG_RAX: 
00000000000000ea
[201169.028860] RAX: 0000000000000000 RBX: 00007fdf20d7b000 RCX: 
00007fdf0bbd73d7
[201169.028860] RDX: 0000000000000006 RSI: 00000000001ccb67 RDI: 
00000000001ccb67
[201169.028861] RBP: 00007fdf0bd2be00 R08: 0000000000000000 R09: 
0000556728a30390
[201169.028861] R10: 0000000000000008 R11: 0000000000000202 R12: 
0000556727115cb5
[201169.028862] R13: 0000556727115e20 R14: 00005567277fe700 R15: 
0000556727806701
[201169.028863] memory: usage 12218368kB, limit 12218368kB, failcnt 1728013
[201169.028864] memory+swap: usage 12218368kB, limit 9007199254740988kB, 
failcnt 0
[201169.028864] kmem: usage 154424kB, limit 9007199254740988kB, failcnt 0
[201169.028880] 
oom-kill:constraint=CONSTRAINT_MEMCG,nodemask=(null),cpuset=podacfa3d53-2068-4b61-a754-fa21968b4201,mems_allowed=0-1,oom_memcg=/kubepods/burstable/podacfa3d53-2068-4b61-a754-fa21968b4201,task_memcg=/kubepods/burstable/podacfa3d53-2068-4b61-a754-fa21968b4201,task=qemu-kata-syste,pid=1887079,uid=0
[201169.028888] Memory cgroup out of memory: Killed process 1887079 
(qemu-kata-syste) total-vm:13598556kB, anon-rss:39836kB, 
file-rss:8712kB, shmem-rss:12017992kB, UID:0 pgtables:24204kB 
oom_score_adj:-100
[201169.045201] oom_reaper: reaped process 1887079 (qemu-kata-syste), 
now anon-rss:0kB, file-rss:28kB, shmem-rss:12018016kB

This change adds an fsync only for regular file core dumps based on a 
configurable limit core_sync_bytes placed alongside other core dump 
params and defaults the limit to (an arbitrary value) of 128KB.
Setting core_sync_bytes to zero disables the sync.

Cc: stable@vger.kernel.org
Reported-by: Eric Ernst <eric_ernst@apple.com>
Signed-off-by: Vishnu Rangayyan <vrangayyan@apple.com>
---
  fs/coredump.c            | 9 +++++++++
  include/linux/binfmts.h  | 1 +
  include/linux/coredump.h | 1 +
  kernel/sysctl.c          | 7 +++++++
  4 files changed, 18 insertions(+)

diff --git a/fs/coredump.c b/fs/coredump.c
index 3224dee44d30..187813704533 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -54,6 +54,7 @@

  int core_uses_pid;
  unsigned int core_pipe_limit;
+unsigned int core_sync_bytes = 131072; /* sync core file every so many 
bytes */
  char core_pattern[CORENAME_MAX_SIZE] = "core";
  static int core_name_size = CORENAME_MAX_SIZE;

@@ -866,6 +867,14 @@ static int __dump_emit(struct coredump_params 
*cprm, const void *addr, int nr)
         n = __kernel_write(file, addr, nr, &pos);
         if (n != nr)
                 return 0;
+       if (file->f_inode && S_ISREG(file->f_inode->i_mode)) {
+               cprm->not_synced += n;
+               if (cprm->not_synced >= core_sync_bytes &&
+                   core_sync_bytes) {
+                       generic_file_fsync(file, 0, pos - 1, 0);
+                       cprm->not_synced = 0;
+               }
+       }
         file->f_pos = pos;
         cprm->written += n;
         cprm->pos += n;
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 049cf9421d83..588d8f240715 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -84,6 +84,7 @@ struct coredump_params {
         struct file *file;
         unsigned long limit;
         unsigned long mm_flags;
+       loff_t not_synced;
         loff_t written;
         loff_t pos;
         loff_t to_skip;
diff --git a/include/linux/coredump.h b/include/linux/coredump.h
index 78fcd776b185..2f65e2f10118 100644
--- a/include/linux/coredump.h
+++ b/include/linux/coredump.h
@@ -17,6 +17,7 @@ struct core_vma_metadata {
  extern int core_uses_pid;
  extern char core_pattern[];
  extern unsigned int core_pipe_limit;
+extern unsigned int core_sync_bytes;

  /*
   * These are the only things you should do on a core-file: use only these
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 083be6af29d7..89b54e9ca963 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1948,6 +1948,13 @@ static struct ctl_table kern_table[] = {
                 .mode           = 0644,
                 .proc_handler   = proc_dointvec,
         },
+       {
+               .procname       = "core_sync_bytes",
+               .data           = &core_sync_bytes,
+               .maxlen         = sizeof(unsigned int),
+               .mode           = 0644,
+               .proc_handler   = proc_dointvec,
+       },
  #endif
  #ifdef CONFIG_PROC_SYSCTL
         {
-- 
2.25.1

