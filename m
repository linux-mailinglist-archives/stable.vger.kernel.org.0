Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86C915FBE8D
	for <lists+stable@lfdr.de>; Wed, 12 Oct 2022 02:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiJLAB3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 20:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiJLABY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 20:01:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C078F40000;
        Tue, 11 Oct 2022 17:01:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CFD661324;
        Wed, 12 Oct 2022 00:01:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C70C433D6;
        Wed, 12 Oct 2022 00:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665532881;
        bh=exdEhF4y/l85yuJ6qxRzk54i/JFkIggec/w7FrZE2sg=;
        h=Date:To:From:Subject:From;
        b=i1UULji56HuLf8Aaq0A3cd8NCDxs6GSFZIxYNoG6YxmU0e3shFGhgX7iFpZ7bsJAV
         ayBbFgRtSmtEvIRFE1n3iH92tt+/rc1LBneXUnyrfW/AjcaJza9MuzpSoEuMg4DlgI
         jfH/Vh/MG5TlUsWI0UBMdUBd9pBVKEVATsL0OVmg=
Date:   Tue, 11 Oct 2022 17:01:20 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        stable@vger.kernel.org, mhocko@suse.com, liam.howlett@oracle.com,
        catalin.marinas@arm.com, brauner@kernel.org, andrii@kernel.org,
        cmllamas@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-undo-mmap-when-arch_validate_flags-fails.patch added to mm-hotfixes-unstable branch
Message-Id: <20221012000121.90C70C433D6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/mmap: undo ->mmap() when arch_validate_flags() fails
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mmap-undo-mmap-when-arch_validate_flags-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-undo-mmap-when-arch_validate_flags-fails.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Carlos Llamas <cmllamas@google.com>
Subject: mm/mmap: undo ->mmap() when arch_validate_flags() fails
Date: Fri, 30 Sep 2022 00:38:43 +0000

Commit c462ac288f2c ("mm: Introduce arch_validate_flags()") added a late
check in mmap_region() to let architectures validate vm_flags.  The check
needs to happen after calling ->mmap() as the flags can potentially be
modified during this callback.

If arch_validate_flags() check fails we unmap and free the vma.  However,
the error path fails to undo the ->mmap() call that previously succeeded
and depending on the specific ->mmap() implementation this translates to
reference increments, memory allocations and other operations what will
not be cleaned up.

There are several places (mainly device drivers) where this is an issue. 
However, one specific example is bpf_map_mmap() which keeps count of the
mappings in map->writecnt.  The count is incremented on ->mmap() and then
decremented on vm_ops->close().  When arch_validate_flags() fails this
count is off since bpf_map_mmap_close() is never called.

One can reproduce this issue in arm64 devices with MTE support.  Here the
vm_flags are checked to only allow VM_MTE if VM_MTE_ALLOWED has been set
previously.  From userspace then is enough to pass the PROT_MTE flag to
mmap() syscall to trigger the arch_validate_flags() failure.

The following program reproduces this issue:

  #include <stdio.h>
  #include <unistd.h>
  #include <linux/unistd.h>
  #include <linux/bpf.h>
  #include <sys/mman.h>

  int main(void)
  {
	union bpf_attr attr = {
		.map_type = BPF_MAP_TYPE_ARRAY,
		.key_size = sizeof(int),
		.value_size = sizeof(long long),
		.max_entries = 256,
		.map_flags = BPF_F_MMAPABLE,
	};
	int fd;

	fd = syscall(__NR_bpf, BPF_MAP_CREATE, &attr, sizeof(attr));
	mmap(NULL, 4096, PROT_WRITE | PROT_MTE, MAP_SHARED, fd, 0);

	return 0;
  }

By manually adding some log statements to the vm_ops callbacks we can
confirm that when passing PROT_MTE to mmap() the map->writecnt is off upon
->release():

With PROT_MTE flag:
  root@debian:~# ./bpf-test
  [  111.263874] bpf_map_write_active_inc: map=9 writecnt=1
  [  111.288763] bpf_map_release: map=9 writecnt=1

Without PROT_MTE flag:
  root@debian:~# ./bpf-test
  [  157.816912] bpf_map_write_active_inc: map=10 writecnt=1
  [  157.830442] bpf_map_write_active_dec: map=10 writecnt=0
  [  157.832396] bpf_map_release: map=10 writecnt=0

This patch fixes the above issue by calling vm_ops->close() when the
arch_validate_flags() check fails, after this we can proceed to unmap and
free the vma on the error path.

Link: https://lkml.kernel.org/r/20220930003844.1210987-1-cmllamas@google.com
Fixes: c462ac288f2c ("mm: Introduce arch_validate_flags()")
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Liam Howlett <liam.howlett@oracle.com>
Cc: Christian Brauner (Microsoft) <brauner@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>	[5.10+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/mmap.c~mm-mmap-undo-mmap-when-arch_validate_flags-fails
+++ a/mm/mmap.c
@@ -1797,7 +1797,7 @@ unsigned long mmap_region(struct file *f
 	if (!arch_validate_flags(vma->vm_flags)) {
 		error = -EINVAL;
 		if (file)
-			goto unmap_and_free_vma;
+			goto close_and_free_vma;
 		else
 			goto free_vma;
 	}
@@ -1844,6 +1844,9 @@ out:
 
 	return addr;
 
+close_and_free_vma:
+	if (vma->vm_ops && vma->vm_ops->close)
+		vma->vm_ops->close(vma);
 unmap_and_free_vma:
 	fput(vma->vm_file);
 	vma->vm_file = NULL;
_

Patches currently in -mm which might be from cmllamas@google.com are

mm-mmap-undo-mmap-when-arch_validate_flags-fails.patch

