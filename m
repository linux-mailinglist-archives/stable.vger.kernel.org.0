Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5768D45AF5E
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 23:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239348AbhKWWtU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 17:49:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:51620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239245AbhKWWtS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 17:49:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC52860E0B;
        Tue, 23 Nov 2021 22:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637707569;
        bh=sCltMwsHLR4aRFO4J/uczcN9/JuobhCDzvWHbg2pwdA=;
        h=Date:From:To:Subject:From;
        b=hm1ozpgA+3Ao29WELnWwxQnCzvaSbTnOyyWfxE2L8scLSrrNfZ1U3zCqVas3LvxHs
         i4JIlucpWkk4YkJMxYan7by6NwF8rZmX2MuRvRumzya370FbGG5uOUZ4cRQmw5J85o
         tw8I2h8KhNVtsVC6XXsCCNDaF3Fdy2qsZqtmfNig=
Date:   Tue, 23 Nov 2021 14:46:09 -0800
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, david@redhat.com, dyoung@redhat.com,
        mm-commits@vger.kernel.org, prudo@redhat.com,
        stable@vger.kernel.org, vgoyal@redhat.com
Subject:  [merged]
 proc-vmcore-fix-clearing-user-buffer-by-properly-using-clear_user.patch
 removed from -mm tree
Message-ID: <20211123224609.H8PrpJStI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: proc/vmcore: fix clearing user buffer by properly using clear_user()
has been removed from the -mm tree.  Its filename was
     proc-vmcore-fix-clearing-user-buffer-by-properly-using-clear_user.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: proc/vmcore: fix clearing user buffer by properly using clear_user()

To clear a user buffer we cannot simply use memset, we have to use
clear_user().  With a virtio-mem device that registers a vmcore_cb and has
some logically unplugged memory inside an added Linux memory block, I can
easily trigger a BUG by copying the vmcore via "cp":

[   11.327580] systemd[1]: Starting Kdump Vmcore Save Service...
[   11.339697] kdump[420]: Kdump is using the default log level(3).
[   11.370964] kdump[453]: saving to /sysroot/var/crash/127.0.0.1-2021-11-11-14:59:22/
[   11.373997] kdump[458]: saving vmcore-dmesg.txt to /sysroot/var/crash/127.0.0.1-2021-11-11-14:59:22/
[   11.385357] kdump[465]: saving vmcore-dmesg.txt complete
[   11.386722] kdump[467]: saving vmcore
[   16.531275] BUG: unable to handle page fault for address: 00007f2374e01000
[   16.531705] #PF: supervisor write access in kernel mode
[   16.532037] #PF: error_code(0x0003) - permissions violation
[   16.532396] PGD 7a523067 P4D 7a523067 PUD 7a528067 PMD 7a525067 PTE 800000007048f867
[   16.532872] Oops: 0003 [#1] PREEMPT SMP NOPTI
[   16.533154] CPU: 0 PID: 468 Comm: cp Not tainted 5.15.0+ #6
[   16.533513] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.14.0-27-g64f37cc530f1-prebuilt.qemu.org 04/01/2014
[   16.534198] RIP: 0010:read_from_oldmem.part.0.cold+0x1d/0x86
[   16.534552] Code: ff ff ff e8 05 ff fe ff e9 b9 e9 7f ff 48 89 de 48 c7 c7 38 3b 60 82 e8 f1 fe fe ff 83 fd 08 72 3c 49 8d 7d 08 4c 89 e9 89 e8 <49> c7 45 00 00 00 00 00 49 c7 44 05 f8 00 00 00 00 48 83 e7 f81
[   16.535670] RSP: 0018:ffffc9000073be08 EFLAGS: 00010212
[   16.535998] RAX: 0000000000001000 RBX: 00000000002fd000 RCX: 00007f2374e01000
[   16.536441] RDX: 0000000000000001 RSI: 00000000ffffdfff RDI: 00007f2374e01008
[   16.536878] RBP: 0000000000001000 R08: 0000000000000000 R09: ffffc9000073bc50
[   16.537315] R10: ffffc9000073bc48 R11: ffffffff829461a8 R12: 000000000000f000
[   16.537755] R13: 00007f2374e01000 R14: 0000000000000000 R15: ffff88807bd421e8
[   16.538200] FS:  00007f2374e12140(0000) GS:ffff88807f000000(0000) knlGS:0000000000000000
[   16.538696] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   16.539055] CR2: 00007f2374e01000 CR3: 000000007a4aa000 CR4: 0000000000350eb0
[   16.539510] Call Trace:
[   16.539679]  <TASK>
[   16.539828]  read_vmcore+0x236/0x2c0
[   16.540063]  ? enqueue_hrtimer+0x2f/0x80
[   16.540323]  ? inode_security+0x22/0x60
[   16.540572]  proc_reg_read+0x55/0xa0
[   16.540807]  vfs_read+0x95/0x190
[   16.541022]  ksys_read+0x4f/0xc0
[   16.541238]  do_syscall_64+0x3b/0x90
[   16.541475]  entry_SYSCALL_64_after_hwframe+0x44/0xae

Some x86-64 CPUs have a CPU feature called "Supervisor Mode Access
Prevention (SMAP)", which is used to detect wrong access from the kernel
to user buffers like this: SMAP triggers a permissions violation on wrong
access.  In the x86-64 variant of clear_user(), SMAP is properly handled
via clac()+stac().

To fix, properly use clear_user() when we're dealing with a user buffer.

Link: https://lkml.kernel.org/r/20211112092750.6921-1-david@redhat.com
Fixes: 997c136f518c ("fs/proc/vmcore.c: add hook to read_from_oldmem() to check for non-ram pages")
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Philipp Rudo <prudo@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/fs/proc/vmcore.c~proc-vmcore-fix-clearing-user-buffer-by-properly-using-clear_user
+++ a/fs/proc/vmcore.c
@@ -154,9 +154,13 @@ ssize_t read_from_oldmem(char *buf, size
 			nr_bytes = count;
 
 		/* If pfn is not ram, return zeros for sparse dump files */
-		if (!pfn_is_ram(pfn))
-			memset(buf, 0, nr_bytes);
-		else {
+		if (!pfn_is_ram(pfn)) {
+			tmp = 0;
+			if (!userbuf)
+				memset(buf, 0, nr_bytes);
+			else if (clear_user(buf, nr_bytes))
+				tmp = -EFAULT;
+		} else {
 			if (encrypted)
 				tmp = copy_oldmem_page_encrypted(pfn, buf,
 								 nr_bytes,
@@ -165,12 +169,12 @@ ssize_t read_from_oldmem(char *buf, size
 			else
 				tmp = copy_oldmem_page(pfn, buf, nr_bytes,
 						       offset, userbuf);
-
-			if (tmp < 0) {
-				up_read(&vmcore_cb_rwsem);
-				return tmp;
-			}
 		}
+		if (tmp < 0) {
+			up_read(&vmcore_cb_rwsem);
+			return tmp;
+		}
+
 		*ppos += nr_bytes;
 		count -= nr_bytes;
 		buf += nr_bytes;
_

Patches currently in -mm which might be from david@redhat.com are

proc-vmcore-dont-fake-reading-zeroes-on-surprise-vmcore_cb-unregistration.patch

