Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4AF146251E
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233864AbhK2Wf1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:35:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233650AbhK2WfB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:35:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83F27C12A4F0;
        Mon, 29 Nov 2021 10:29:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C628B815C9;
        Mon, 29 Nov 2021 18:29:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AAE6C53FAD;
        Mon, 29 Nov 2021 18:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210572;
        bh=rIZnk9JVkN+pKjMzwurqP2b0pE+3G0x03CQOVPkhqgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iPUDFXS4OGCVc5Z5Qw411+uVmTuUb6WXSrAUUISs3Yt6d2hJx5RmYGz3D1riY2v4O
         PquwqN55lZ/FLFEvxQ/qEc2PGDghH09Oq48tlCwaV3mwjPs1Vy1eSZEUfiHIA6aKXp
         VkPqmI/xoONSVZDw1jBfhA1zINpxfbdTB2+yvv00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Baoquan He <bhe@redhat.com>, Dave Young <dyoung@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Philipp Rudo <prudo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 040/121] proc/vmcore: fix clearing user buffer by properly using clear_user()
Date:   Mon, 29 Nov 2021 19:17:51 +0100
Message-Id: <20211129181712.994866401@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

commit c1e63117711977cc4295b2ce73de29dd17066c82 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/proc/vmcore.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -124,9 +124,13 @@ ssize_t read_from_oldmem(char *buf, size
 			nr_bytes = count;
 
 		/* If pfn is not ram, return zeros for sparse dump files */
-		if (pfn_is_ram(pfn) == 0)
-			memset(buf, 0, nr_bytes);
-		else {
+		if (pfn_is_ram(pfn) == 0) {
+			tmp = 0;
+			if (!userbuf)
+				memset(buf, 0, nr_bytes);
+			else if (clear_user(buf, nr_bytes))
+				tmp = -EFAULT;
+		} else {
 			if (encrypted)
 				tmp = copy_oldmem_page_encrypted(pfn, buf,
 								 nr_bytes,
@@ -135,10 +139,10 @@ ssize_t read_from_oldmem(char *buf, size
 			else
 				tmp = copy_oldmem_page(pfn, buf, nr_bytes,
 						       offset, userbuf);
-
-			if (tmp < 0)
-				return tmp;
 		}
+		if (tmp < 0)
+			return tmp;
+
 		*ppos += nr_bytes;
 		count -= nr_bytes;
 		buf += nr_bytes;


