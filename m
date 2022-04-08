Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB954F8F64
	for <lists+stable@lfdr.de>; Fri,  8 Apr 2022 09:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbiDHHUt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Apr 2022 03:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbiDHHUr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Apr 2022 03:20:47 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 710E125F672
        for <stable@vger.kernel.org>; Fri,  8 Apr 2022 00:18:36 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id k13so1931101plk.12
        for <stable@vger.kernel.org>; Fri, 08 Apr 2022 00:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=co5p7yRLCSx9j8/2orMZ/a65NN70Y/hDxlRk7f3v2ok=;
        b=cAMsJS+RTVnYONCydincirhbTiKfpU79UzC5HmgS8HfK2pGzignQyozf0oXt6XEB3H
         0+SN4WGpmZ/8H2z6jW3Quoyjd/Rfi7oy49b0eDLRe21zJ4O0gUpEx5g+LJAXXObtEhfm
         Qcm+jHwXgFHXKdAbqLCpYEgbv/5Raz5qNQ4wx06QuPbAikoPutkpQMG8FlsRh1beFzF0
         nxKuo8L3ked66x4jdsCOjnEq1rP3y8tJgPOn7UMHcvnV+juHCKdiXKEPgspfLTEnlDPU
         u5U4Dp7T5FwuIEe/zR9QwL6ulcHRnJ+TEhZ4RE/zfqdZAJrie8XgcwUhPHkFPQ6YadWI
         uzng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=co5p7yRLCSx9j8/2orMZ/a65NN70Y/hDxlRk7f3v2ok=;
        b=f2yLeewBzNkJhIy9DuQAjC3OPDQqueMJ6unrsxNu2kiUDW2m0EYgU4mR/VkYpDv9oN
         FYLkxkzQjPkeX3fBTDLMl0OHd7Qj/q20ylDhR+nXf6InxHaAsP8LMxT5AaX7uaB3BuIt
         AUPzu+P6Jeji+UxEjOuUkyMrwbjRjG5rGvsszptutpyP8Mb9IQ7BTeSRMpgUi6U/oUhW
         Erk/NoqvauigvfOT/Uscrvyp0OeI+ftToEAxV/xb24DvouFYhYLDyeKkXcVN21b9hAjg
         rl1n/stlFJXPSAiGeUiSz4SKMbyYjTsmLNaOeeTZ5ksIBDdGFSBb9rT/VTwflebHeWpm
         +2SA==
X-Gm-Message-State: AOAM5310YE9/5qouveZMzeTlrjFSB6NJ0XZAWrao3SsZ1/f/ihmfQsD2
        Fyy6vceRhhbpHR87yDvIXFUus50C8GjaPQfSKtM=
X-Google-Smtp-Source: ABdhPJyRxmEZNxTm9ueSOpScy2SaOPAhHOV/2k23k+QSht9hYh8igX+QzqlBMdJDwtswwj7CwOzggg==
X-Received: by 2002:a17:902:8a8d:b0:157:ab0:a07 with SMTP id p13-20020a1709028a8d00b001570ab00a07mr6405805plo.77.1649402315839;
        Fri, 08 Apr 2022 00:18:35 -0700 (PDT)
Received: from localhost ([118.33.58.238])
        by smtp.gmail.com with ESMTPSA id b17-20020a056a000a9100b004e1b7cdb8fdsm27255997pfl.70.2022.04.08.00.18.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 00:18:35 -0700 (PDT)
Date:   Fri, 8 Apr 2022 16:18:33 +0900
From:   Paran Lee <p4ranlee@gmail.com>
To:     colin.i.king@gmail.com
Cc:     stable@vger.kernel.org, Austin Kim <austindh.kim@gmail.com>
Subject: [PATCH] writeback: expired dirty inodes can lead to a NULL
 dereference kernel panic issue in 'move_expired_inodes' function
Message-ID: <20220408071833.GA14552@DESKTOP-S4LJL03.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

writeback: expired dirty inodes can lead to a NULL dereference kernel panic issue in 'move_expired_inodes' function

Hello, Colin Ian King.

I am Paran Lee.

While tracing the null dereference kernel panic issue during the stress-ng(stress-ng-proc) test,
I found the inode code block that could cause a null dereference kernel panic.

If this issue is confirmed as a bug that may have occurred in the past, wouldn't it be added to the link below?

@ Bugs found with stress-ng
- https://github.com/ColinIanKing/stress-ng#bugs-found-with-stress-ng

* kernel log

[21881.096120] ICMPv6: process `stress-ng-procf' is using deprecated sysctl (syscall) net.ipv6.neigh.default.base_reachable_time - use net.ipv6.neigh.default.base_reachable_time_ms instead
[22009.051158] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
[22009.051167] IP: move_expired_inodes+0x59/0x1a0
[22009.051168] PGD 0 P4D 0
[22009.051170] Oops: 0002 [#1] SMP NOPTI
...
[22009.051221] RIP: 0010:move_expired_inodes+0x59/0x1a0
...
[22009.051257] Call Trace:
[22009.051260]  queue_io+0x66/0x110
[22009.051262]  wb_writeback+0x253/0x300
[22009.051264]  wb_workfn+0xc0/0x400
[22009.051265]  ? wb_workfn+0xc0/0x400
[22009.051268]  ? __switch_to_asm+0x35/0x70
[22009.051272]  process_one_work+0x1de/0x420
[22009.051274]  worker_thread+0x32/0x410
[22009.051276]  kthread+0x121/0x140
[22009.051277]  ? process_one_work+0x420/0x420
[22009.051279]  ? kthread_create_worker_on_cpu+0x70/0x70
[22009.051280]  ret_from_fork+0x1f/0x40
[22009.051282] Code: 04 25 28 00 00 00 48 89 45 d0 31 c0 4c 89 75 c8 c7 45 b0 00 00 00 00 c7 45 b4 00 00 00 00 eb 76 48 8b 3b 48 8b 43 08 83 45 b0 01 <48> 89 47 08 48 89 38 48 8b 45 c0 48 89 58 08 48 89 03 48 8d 43
[22009.051293] RIP: move_expired_inodes+0x59/0x1a0 RSP: ffffa2f68413bcb0

* trace log on crash utility

      KERNEL: vmlinux-4.15.0-166-generic
    DUMPFILE: 202204072123-wb_inode-delaying_queue-list-null-check/dump.202204072123  [PARTIAL DUMP]
        CPUS: 4
        DATE: Fri Apr  8 06:23:30 2022
      UPTIME: 01:35:27
LOAD AVERAGE: 8.30, 8.37, 9.17
       TASKS: 668
    NODENAME: ubuntu1804
     RELEASE: 4.15.0-166-generic
     VERSION: #174-Ubuntu SMP Wed Dec 8 19:07:44 UTC 2021
     MACHINE: x86_64  (2394 Mhz)
      MEMORY: 16 GB
       PANIC: "BUG: unable to handle kernel NULL pointer dereference at 0000000000000008"
         PID: 22864
     COMMAND: "kworker/u8:0"
        TASK: ffff91490b55d880  [THREAD_INFO: ffff91490b55d880]
         CPU: 0
       STATE: TASK_RUNNING (PANIC)

crash> bt
...
 #9 [ffffa2f68413bc00] page_fault at ffffffffae401615
    [exception RIP: move_expired_inodes+89]
    RIP: ffffffffadcb11f9  RSP: ffffa2f68413bcb0  RFLAGS: 00010202
    RAX: 0000000000000000  RBX: ffff9148083af9b8  RCX: ffff91496659a090
    RDX: 000000010052d046  RSI: ffff91496659a080  RDI: 0000000000000000
    RBP: ffffa2f68413bd08   R8: ffff91496676727f   R9: ffff914951111f76
    R10: ffffa2f68413bdf8  R11: 0000000000000334  R12: 0000000000000000
    R13: ffff91496659a070  R14: ffffa2f68413bcc8  R15: ffff91496659a080
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
#10 [ffffa2f68413bd10] queue_io at ffffffffadcb32d6
#11 [ffffa2f68413bd48] wb_writeback at ffffffffadcb77a3
#12 [ffffa2f68413bde8] wb_workfn at ffffffffadcb7eb0
#13 [ffffa2f68413be80] process_one_work at ffffffffadaaa68e
#14 [ffffa2f68413bec8] worker_thread at ffffffffadaaa902
#15 [ffffa2f68413bf08] kthread at ffffffffadab1361
#16 [ffffa2f68413bf50] ret_from_fork at ffffffffae4001ef

crash> dis ffffffffadcb32c6 20
...
0xffffffffadcb32c6 <queue_io+86>:       jg     0xffffffffadcb32e0 <queue_io+112>
0xffffffffadcb32c8 <queue_io+88>:       mov    %rsi,%r14
0xffffffffadcb32cb <queue_io+91>:       mov    %r12,%rsi
0xffffffffadcb32ce <queue_io+94>:       mov    %rdx,%r13
0xffffffffadcb32d1 <queue_io+97>:       callq  0xffffffffadcb11a0 <move_expired_inodes>

crash> dis 0xffffffffadcb11a0
0xffffffffadcb11a0 <move_expired_inodes>:       nopl   0x0(%rax,%rax,1) [FTRACE NOP]
...
0xffffffffadcb11ec <move_expired_inodes+76>:    jmp    0xffffffffadcb1264 <move_expired_inodes+196>
0xffffffffadcb11ee <move_expired_inodes+78>:    mov    (%rbx),%rdi
0xffffffffadcb11f1 <move_expired_inodes+81>:    mov    0x8(%rbx),%rax
0xffffffffadcb11f5 <move_expired_inodes+85>:    addl   $0x1,-0x50(%rbp)
0xffffffffadcb11f9 <move_expired_inodes+89>:    mov    %rax,0x8(%rdi)    <<<<<< Don't you think this is the NULL dereference RIP point of it?
0xffffffffadcb11fd <move_expired_inodes+93>:    mov    %rdi,(%rax)
...
0xffffffffadcb121e <move_expired_inodes+126>:   callq  0xffffffffae3cd460 <_raw_spin_lock>

Have a good day.
Paran Lee.

Signed-off-by: Paran Lee <p4ranlee@gmail.com>
---
 fs/fs-writeback.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 591fe9cf1659..23a7a567e443 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1357,12 +1357,14 @@ static int move_expired_inodes(struct list_head *delaying_queue,
 	LIST_HEAD(tmp);
 	struct list_head *pos, *node;
 	struct super_block *sb = NULL;
-	struct inode *inode;
+	struct inode *inode = NULL;
 	int do_sb_sort = 0;
 	int moved = 0;
 
 	while (!list_empty(delaying_queue)) {
 		inode = wb_inode(delaying_queue->prev);
+		if(!inode)
+			continue;
 		if (inode_dirtied_after(inode, dirtied_before))
 			break;
 		list_move(&inode->i_io_list, &tmp);
@@ -1385,7 +1387,12 @@ static int move_expired_inodes(struct list_head *delaying_queue,
 
 	/* Move inodes from one superblock together */
 	while (!list_empty(&tmp)) {
-		sb = wb_inode(tmp.prev)->i_sb;
+		inode = wb_inode(tmp.prev);
+		if(!inode)
+			continue;
+		sb = inode->i_sb;
+		if(!sb)
+			continue;
 		list_for_each_prev_safe(pos, node, &tmp) {
 			inode = wb_inode(pos);
 			if (inode->i_sb == sb)
-- 
2.25.1

