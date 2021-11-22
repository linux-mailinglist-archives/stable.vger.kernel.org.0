Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0E25458E46
	for <lists+stable@lfdr.de>; Mon, 22 Nov 2021 13:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235660AbhKVMaU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Nov 2021 07:30:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:51926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234322AbhKVMaT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Nov 2021 07:30:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 043BE60F9F;
        Mon, 22 Nov 2021 12:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637584033;
        bh=3VqFZYswdImOd5OJ/wKwTlpo+r0AbfOwu6gP3eospgw=;
        h=Subject:To:Cc:From:Date:From;
        b=MWNYWa8rIzz6kOLPB0PWeHTwcyP3QfYkP3c2Nb+yZWnPf5o6FfDpjgNwWdM5kleza
         R8QzvlV15WqdWnbh5ez6IfFtMW2C06t6pr+op0yu6pystX2GUUlGCTLaVGeljJkF/f
         3Vhmm1C/XSTFH+pSp2EJuyy3ytmPsdlDpxcUaCU0=
Subject: FAILED: patch "[PATCH] proc/vmcore: fix clearing user buffer by properly using" failed to apply to 5.10-stable tree
To:     david@redhat.com, akpm@linux-foundation.org, bhe@redhat.com,
        dyoung@redhat.com, prudo@redhat.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vgoyal@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Nov 2021 13:27:03 +0100
Message-ID: <16375840231750@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c1e63117711977cc4295b2ce73de29dd17066c82 Mon Sep 17 00:00:00 2001
From: David Hildenbrand <david@redhat.com>
Date: Fri, 19 Nov 2021 16:43:58 -0800
Subject: [PATCH] proc/vmcore: fix clearing user buffer by properly using
 clear_user()

To clear a user buffer we cannot simply use memset, we have to use
clear_user().  With a virtio-mem device that registers a vmcore_cb and
has some logically unplugged memory inside an added Linux memory block,
I can easily trigger a BUG by copying the vmcore via "cp":

  systemd[1]: Starting Kdump Vmcore Save Service...
  kdump[420]: Kdump is using the default log level(3).
  kdump[453]: saving to /sysroot/var/crash/127.0.0.1-2021-11-11-14:59:22/
  kdump[458]: saving vmcore-dmesg.txt to /sysroot/var/crash/127.0.0.1-2021-11-11-14:59:22/
  kdump[465]: saving vmcore-dmesg.txt complete
  kdump[467]: saving vmcore
  BUG: unable to handle page fault for address: 00007f2374e01000
  #PF: supervisor write access in kernel mode
  #PF: error_code(0x0003) - permissions violation
  PGD 7a523067 P4D 7a523067 PUD 7a528067 PMD 7a525067 PTE 800000007048f867
  Oops: 0003 [#1] PREEMPT SMP NOPTI
  CPU: 0 PID: 468 Comm: cp Not tainted 5.15.0+ #6
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.14.0-27-g64f37cc530f1-prebuilt.qemu.org 04/01/2014
  RIP: 0010:read_from_oldmem.part.0.cold+0x1d/0x86
  Code: ff ff ff e8 05 ff fe ff e9 b9 e9 7f ff 48 89 de 48 c7 c7 38 3b 60 82 e8 f1 fe fe ff 83 fd 08 72 3c 49 8d 7d 08 4c 89 e9 89 e8 <49> c7 45 00 00 00 00 00 49 c7 44 05 f8 00 00 00 00 48 83 e7 f81
  RSP: 0018:ffffc9000073be08 EFLAGS: 00010212
  RAX: 0000000000001000 RBX: 00000000002fd000 RCX: 00007f2374e01000
  RDX: 0000000000000001 RSI: 00000000ffffdfff RDI: 00007f2374e01008
  RBP: 0000000000001000 R08: 0000000000000000 R09: ffffc9000073bc50
  R10: ffffc9000073bc48 R11: ffffffff829461a8 R12: 000000000000f000
  R13: 00007f2374e01000 R14: 0000000000000000 R15: ffff88807bd421e8
  FS:  00007f2374e12140(0000) GS:ffff88807f000000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007f2374e01000 CR3: 000000007a4aa000 CR4: 0000000000350eb0
  Call Trace:
   read_vmcore+0x236/0x2c0
   proc_reg_read+0x55/0xa0
   vfs_read+0x95/0x190
   ksys_read+0x4f/0xc0
   do_syscall_64+0x3b/0x90
   entry_SYSCALL_64_after_hwframe+0x44/0xae

Some x86-64 CPUs have a CPU feature called "Supervisor Mode Access
Prevention (SMAP)", which is used to detect wrong access from the kernel
to user buffers like this: SMAP triggers a permissions violation on
wrong access.  In the x86-64 variant of clear_user(), SMAP is properly
handled via clac()+stac().

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 30a3b66f475a..509f85148fee 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -154,9 +154,13 @@ ssize_t read_from_oldmem(char *buf, size_t count,
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
@@ -165,12 +169,12 @@ ssize_t read_from_oldmem(char *buf, size_t count,
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

