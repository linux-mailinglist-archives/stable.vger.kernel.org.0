Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FCB3B9335
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392316AbfITOie (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:38:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35646 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728970AbfITOY7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:24:59 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqC-0004w6-F4; Fri, 20 Sep 2019 15:24:56 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqB-0007pQ-Mo; Fri, 20 Sep 2019 15:24:55 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jiri Slaby" <jslaby@suse.com>,
        "Sergei Trofimovich" <slyfox@gentoo.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.148842370@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 011/132] tty/vt: fix write/write race in
 ioctl(KDSKBSENT) handler
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Sergei Trofimovich <slyfox@gentoo.org>

commit 46ca3f735f345c9d87383dd3a09fa5d43870770e upstream.

The bug manifests as an attempt to access deallocated memory:

    BUG: unable to handle kernel paging request at ffff9c8735448000
    #PF error: [PROT] [WRITE]
    PGD 288a05067 P4D 288a05067 PUD 288a07067 PMD 7f60c2063 PTE 80000007f5448161
    Oops: 0003 [#1] PREEMPT SMP
    CPU: 6 PID: 388 Comm: loadkeys Tainted: G         C        5.0.0-rc6-00153-g5ded5871030e #91
    Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./H77M-D3H, BIOS F12 11/14/2013
    RIP: 0010:__memmove+0x81/0x1a0
    Code: 4c 89 4f 10 4c 89 47 18 48 8d 7f 20 73 d4 48 83 c2 20 e9 a2 00 00 00 66 90 48 89 d1 4c 8b 5c 16 f8 4c 8d 54 17 f8 48 c1 e9 03 <f3> 48 a5 4d 89 1a e9 0c 01 00 00 0f 1f 40 00 48 89 d1 4c 8b 1e 49
    RSP: 0018:ffffa1b9002d7d08 EFLAGS: 00010203
    RAX: ffff9c873541af43 RBX: ffff9c873541af43 RCX: 00000c6f105cd6bf
    RDX: 0000637882e986b6 RSI: ffff9c8735447ffb RDI: ffff9c8735447ffb
    RBP: ffff9c8739cd3800 R08: ffff9c873b802f00 R09: 00000000fffff73b
    R10: ffffffffb82b35f1 R11: 00505b1b004d5b1b R12: 0000000000000000
    R13: ffff9c873541af3d R14: 000000000000000b R15: 000000000000000c
    FS:  00007f450c390580(0000) GS:ffff9c873f180000(0000) knlGS:0000000000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: ffff9c8735448000 CR3: 00000007e213c002 CR4: 00000000000606e0
    Call Trace:
     vt_do_kdgkb_ioctl+0x34d/0x440
     vt_ioctl+0xba3/0x1190
     ? __bpf_prog_run32+0x39/0x60
     ? mem_cgroup_commit_charge+0x7b/0x4e0
     tty_ioctl+0x23f/0x920
     ? preempt_count_sub+0x98/0xe0
     ? __seccomp_filter+0x67/0x600
     do_vfs_ioctl+0xa2/0x6a0
     ? syscall_trace_enter+0x192/0x2d0
     ksys_ioctl+0x3a/0x70
     __x64_sys_ioctl+0x16/0x20
     do_syscall_64+0x54/0xe0
     entry_SYSCALL_64_after_hwframe+0x49/0xbe

The bug manifests on systemd systems with multiple vtcon devices:
  # cat /sys/devices/virtual/vtconsole/vtcon0/name
  (S) dummy device
  # cat /sys/devices/virtual/vtconsole/vtcon1/name
  (M) frame buffer device

There systemd runs 'loadkeys' tool in tapallel for each vtcon
instance. This causes two parallel ioctl(KDSKBSENT) calls to
race into adding the same entry into 'func_table' array at:

    drivers/tty/vt/keyboard.c:vt_do_kdgkb_ioctl()

The function has no locking around writes to 'func_table'.

The simplest reproducer is to have initrams with the following
init on a 8-CPU machine x86_64:

    #!/bin/sh

    loadkeys -q windowkeys ru4 &
    loadkeys -q windowkeys ru4 &
    loadkeys -q windowkeys ru4 &
    loadkeys -q windowkeys ru4 &

    loadkeys -q windowkeys ru4 &
    loadkeys -q windowkeys ru4 &
    loadkeys -q windowkeys ru4 &
    loadkeys -q windowkeys ru4 &
    wait

The change adds lock on write path only. Reads are still racy.

CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Jiri Slaby <jslaby@suse.com>
Link: https://lkml.org/lkml/2019/2/17/256
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/vt/keyboard.c | 33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -120,6 +120,7 @@ static const int NR_TYPES = ARRAY_SIZE(m
 static struct input_handler kbd_handler;
 static DEFINE_SPINLOCK(kbd_event_lock);
 static DEFINE_SPINLOCK(led_lock);
+static DEFINE_SPINLOCK(func_buf_lock); /* guard 'func_buf'  and friends */
 static unsigned long key_down[BITS_TO_LONGS(KEY_CNT)];	/* keyboard key bitmap */
 static unsigned char shift_down[NR_SHIFT];		/* shift state counters.. */
 static bool dead_key_next;
@@ -1865,11 +1866,12 @@ int vt_do_kdgkb_ioctl(int cmd, struct kb
 	char *p;
 	u_char *q;
 	u_char __user *up;
-	int sz;
+	int sz, fnw_sz;
 	int delta;
 	char *first_free, *fj, *fnw;
 	int i, j, k;
 	int ret;
+	unsigned long flags;
 
 	if (!capable(CAP_SYS_TTY_CONFIG))
 		perm = 0;
@@ -1912,7 +1914,14 @@ int vt_do_kdgkb_ioctl(int cmd, struct kb
 			goto reterr;
 		}
 
+		fnw = NULL;
+		fnw_sz = 0;
+		/* race aginst other writers */
+		again:
+		spin_lock_irqsave(&func_buf_lock, flags);
 		q = func_table[i];
+
+		/* fj pointer to next entry after 'q' */
 		first_free = funcbufptr + (funcbufsize - funcbufleft);
 		for (j = i+1; j < MAX_NR_FUNC && !func_table[j]; j++)
 			;
@@ -1920,10 +1929,12 @@ int vt_do_kdgkb_ioctl(int cmd, struct kb
 			fj = func_table[j];
 		else
 			fj = first_free;
-
+		/* buffer usage increase by new entry */
 		delta = (q ? -strlen(q) : 1) + strlen(kbs->kb_string);
+
 		if (delta <= funcbufleft) { 	/* it fits in current buf */
 		    if (j < MAX_NR_FUNC) {
+			/* make enough space for new entry at 'fj' */
 			memmove(fj + delta, fj, first_free - fj);
 			for (k = j; k < MAX_NR_FUNC; k++)
 			    if (func_table[k])
@@ -1936,20 +1947,28 @@ int vt_do_kdgkb_ioctl(int cmd, struct kb
 		    sz = 256;
 		    while (sz < funcbufsize - funcbufleft + delta)
 		      sz <<= 1;
-		    fnw = kmalloc(sz, GFP_KERNEL);
-		    if(!fnw) {
-		      ret = -ENOMEM;
-		      goto reterr;
+		    if (fnw_sz != sz) {
+		      spin_unlock_irqrestore(&func_buf_lock, flags);
+		      kfree(fnw);
+		      fnw = kmalloc(sz, GFP_KERNEL);
+		      fnw_sz = sz;
+		      if (!fnw) {
+			ret = -ENOMEM;
+			goto reterr;
+		      }
+		      goto again;
 		    }
 
 		    if (!q)
 		      func_table[i] = fj;
+		    /* copy data before insertion point to new location */
 		    if (fj > funcbufptr)
 			memmove(fnw, funcbufptr, fj - funcbufptr);
 		    for (k = 0; k < j; k++)
 		      if (func_table[k])
 			func_table[k] = fnw + (func_table[k] - funcbufptr);
 
+		    /* copy data after insertion point to new location */
 		    if (first_free > fj) {
 			memmove(fnw + (fj - funcbufptr) + delta, fj, first_free - fj);
 			for (k = j; k < MAX_NR_FUNC; k++)
@@ -1962,7 +1981,9 @@ int vt_do_kdgkb_ioctl(int cmd, struct kb
 		    funcbufleft = funcbufleft - delta + sz - funcbufsize;
 		    funcbufsize = sz;
 		}
+		/* finally insert item itself */
 		strcpy(func_table[i], kbs->kb_string);
+		spin_unlock_irqrestore(&func_buf_lock, flags);
 		break;
 	}
 	ret = 0;

