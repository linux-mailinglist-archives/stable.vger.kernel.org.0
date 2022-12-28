Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43AE16584F8
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 18:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234194AbiL1REz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 12:04:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235247AbiL1RD5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 12:03:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07321FF82
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:58:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83C88B8171F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:58:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9362C433D2;
        Wed, 28 Dec 2022 16:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246701;
        bh=HO8iz9dzk75WnyUl6gu+4U7P3TnsePG0QkLxdd36rW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=msFNuXb8iReSRSykPsFuiNBV97H9nlzJLo0eHQpKcCj1Zv0uPU5aBSLB9RyrTyCpm
         MdcigvB2/hL08gpHXDDuh+9Vk/z35XkWo7ExPemFOiBAbuUDEfX1KKWgjgT1DC/5qE
         ujNQUrAiCJf8WfEV95FQ87vfbXQ5ab7zx2EyUaN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, David Hildenbrand <david@redhat.com>,
        syzbot+f0b97304ef90f0d0b1dc@syzkaller.appspotmail.com,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Peter Xu <peterx@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 1132/1146] mm/gup: disallow FOLL_FORCE|FOLL_WRITE on hugetlb mappings
Date:   Wed, 28 Dec 2022 15:44:31 +0100
Message-Id: <20221228144400.892274633@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

commit f347454d034184b4f0a2caf6e14daf7848cea01c upstream.

hugetlb does not support fake write-faults (write faults without write
permissions).  However, we are currently able to trigger a
FAULT_FLAG_WRITE fault on a VMA without VM_WRITE.

If we'd ever want to support FOLL_FORCE|FOLL_WRITE, we'd have to teach
hugetlb to:

(1) Leave the page mapped R/O after the fake write-fault, like
    maybe_mkwrite() does.
(2) Allow writing to an exclusive anon page that's mapped R/O when
    FOLL_FORCE is set, like can_follow_write_pte(). E.g.,
    __follow_hugetlb_must_fault() needs adjustment.

For now, it's not clear if that added complexity is really required.
History tolds us that FOLL_FORCE is dangerous and that we better limit its
use to a bare minimum.

--------------------------------------------------------------------------
  #include <stdio.h>
  #include <stdlib.h>
  #include <fcntl.h>
  #include <unistd.h>
  #include <errno.h>
  #include <stdint.h>
  #include <sys/mman.h>
  #include <linux/mman.h>

  int main(int argc, char **argv)
  {
          char *map;
          int mem_fd;

          map = mmap(NULL, 2 * 1024 * 1024u, PROT_READ,
                     MAP_PRIVATE|MAP_ANON|MAP_HUGETLB|MAP_HUGE_2MB, -1, 0);
          if (map == MAP_FAILED) {
                  fprintf(stderr, "mmap() failed: %d\n", errno);
                  return 1;
          }

          mem_fd = open("/proc/self/mem", O_RDWR);
          if (mem_fd < 0) {
                  fprintf(stderr, "open(/proc/self/mem) failed: %d\n", errno);
                  return 1;
          }

          if (pwrite(mem_fd, "0", 1, (uintptr_t) map) == 1) {
                  fprintf(stderr, "write() succeeded, which is unexpected\n");
                  return 1;
          }

          printf("write() failed as expected: %d\n", errno);
          return 0;
  }
--------------------------------------------------------------------------

Fortunately, we have a sanity check in hugetlb_wp() in place ever since
commit 1d8d14641fd9 ("mm/hugetlb: support write-faults in shared
mappings"), that bails out instead of silently mapping a page writable in
a !PROT_WRITE VMA.

Consequently, above reproducer triggers a warning, similar to the one
reported by szsbot:

------------[ cut here ]------------
WARNING: CPU: 1 PID: 3612 at mm/hugetlb.c:5313 hugetlb_wp+0x20a/0x1af0 mm/hugetlb.c:5313
Modules linked in:
CPU: 1 PID: 3612 Comm: syz-executor250 Not tainted 6.1.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/11/2022
RIP: 0010:hugetlb_wp+0x20a/0x1af0 mm/hugetlb.c:5313
Code: ea 03 80 3c 02 00 0f 85 31 14 00 00 49 8b 5f 20 31 ff 48 89 dd 83 e5 02 48 89 ee e8 70 ab b7 ff 48 85 ed 75 5b e8 76 ae b7 ff <0f> 0b 41 bd 40 00 00 00 e8 69 ae b7 ff 48 b8 00 00 00 00 00 fc ff
RSP: 0018:ffffc90003caf620 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000008640070 RCX: 0000000000000000
RDX: ffff88807b963a80 RSI: ffffffff81c4ed2a RDI: 0000000000000007
RBP: 0000000000000000 R08: 0000000000000007 R09: 0000000000000000
R10: 0000000000000000 R11: 000000000008c07e R12: ffff888023805800
R13: 0000000000000000 R14: ffffffff91217f38 R15: ffff88801d4b0360
FS:  0000555555bba300(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fff7a47a1b8 CR3: 000000002378d000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 hugetlb_no_page mm/hugetlb.c:5755 [inline]
 hugetlb_fault+0x19cc/0x2060 mm/hugetlb.c:5874
 follow_hugetlb_page+0x3f3/0x1850 mm/hugetlb.c:6301
 __get_user_pages+0x2cb/0xf10 mm/gup.c:1202
 __get_user_pages_locked mm/gup.c:1434 [inline]
 __get_user_pages_remote+0x18f/0x830 mm/gup.c:2187
 get_user_pages_remote+0x84/0xc0 mm/gup.c:2260
 __access_remote_vm+0x287/0x6b0 mm/memory.c:5517
 ptrace_access_vm+0x181/0x1d0 kernel/ptrace.c:61
 generic_ptrace_pokedata kernel/ptrace.c:1323 [inline]
 ptrace_request+0xb46/0x10c0 kernel/ptrace.c:1046
 arch_ptrace+0x36/0x510 arch/x86/kernel/ptrace.c:828
 __do_sys_ptrace kernel/ptrace.c:1296 [inline]
 __se_sys_ptrace kernel/ptrace.c:1269 [inline]
 __x64_sys_ptrace+0x178/0x2a0 kernel/ptrace.c:1269
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
[...]

So let's silence that warning by teaching GUP code that FOLL_FORCE -- so
far -- does not apply to hugetlb.

Note that FOLL_FORCE for read-access seems to be working as expected.  The
assumption is that this has been broken forever, only ever since above
commit, we actually detect the wrong handling and WARN_ON_ONCE().

I assume this has been broken at least since 2014, when mm/gup.c came to
life.  I failed to come up with a suitable Fixes tag quickly.

Link: https://lkml.kernel.org/r/20221031152524.173644-1-david@redhat.com
Fixes: 1d8d14641fd9 ("mm/hugetlb: support write-faults in shared mappings")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: <syzbot+f0b97304ef90f0d0b1dc@syzkaller.appspotmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/gup.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1065,6 +1065,9 @@ static int check_vma_flags(struct vm_are
 		if (!(vm_flags & VM_WRITE)) {
 			if (!(gup_flags & FOLL_FORCE))
 				return -EFAULT;
+			/* hugetlb does not support FOLL_FORCE|FOLL_WRITE. */
+			if (is_vm_hugetlb_page(vma))
+				return -EFAULT;
 			/*
 			 * We used to let the write,force case do COW in a
 			 * VM_MAYWRITE VM_SHARED !VM_WRITE vma, so ptrace could


