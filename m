Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06FDB45CE5A
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 21:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239243AbhKXUtr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 15:49:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:40574 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238974AbhKXUtp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 15:49:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637786794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FnS6r8ruobXlhNxbMOJkwoBK27bqYlpEfG342+fFQ+k=;
        b=gfSrXkgvQ3bnHWhlPndWL5gPaswHnSnbQGT5aZ6e75+Umn2EdaHt4Om1UDqFvm/xDY+GV2
        B+hO4IsYtvNn5eX69/aMyVIxdP/thj6WMKbKTA9LHIdwfovYC43scocKxK/nWJ6vY5tKnC
        fv7Fi6BWJbmabyTTQIs5GedLaj3aHOw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-207-cmdll6VKPGqu7VBdY2aFWA-1; Wed, 24 Nov 2021 15:46:33 -0500
X-MC-Unique: cmdll6VKPGqu7VBdY2aFWA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6410E85B665;
        Wed, 24 Nov 2021 20:46:32 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.194.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BEAF5369A;
        Wed, 24 Nov 2021 20:46:11 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org, David Hildenbrand <david@redhat.com>,
        Baoquan He <bhe@redhat.com>, Dave Young <dyoung@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Philipp Rudo <prudo@redhat.com>
Subject: [PATCH for 5.15-stable] proc/vmcore: fix clearing user buffer by properly using clear_user()
Date:   Wed, 24 Nov 2021 21:46:10 +0100
Message-Id: <20211124204610.27368-1-david@redhat.com>
In-Reply-To: <163758402560135@kroah.com>
References: <163758402560135@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 fs/proc/vmcore.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 9a15334da208..e5730986758f 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -124,9 +124,13 @@ ssize_t read_from_oldmem(char *buf, size_t count,
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
@@ -135,10 +139,10 @@ ssize_t read_from_oldmem(char *buf, size_t count,
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
-- 
2.31.1

