Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12AE95FCEA4
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 00:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiJLW53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 18:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiJLW5W (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 18:57:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDA0411C27A;
        Wed, 12 Oct 2022 15:57:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 578206164F;
        Wed, 12 Oct 2022 22:57:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0667C433B5;
        Wed, 12 Oct 2022 22:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665615440;
        bh=6BoOH70UzCMoCrpF4dL3Wa+cZO4IkunzOyYriXPjjJI=;
        h=Date:To:From:Subject:From;
        b=Vd6GU6pc95/rkzbb1FHZwfw75Y/THXn3psF5l/Cc34MqGAC4f5wHDCkCa1M41DvCB
         //u21kcUT739nP3fnqf5xjGQ58O8U+lZFkT0diSNvTA0+nA18MdrhN/qmmYamzwWyi
         eTObgjv7bwuo2pm+IasYWT4kFr4owi+xjEVXpIM8=
Date:   Wed, 12 Oct 2022 15:57:19 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        stable@vger.kernel.org, mhocko@suse.com, liam.howlett@oracle.com,
        catalin.marinas@arm.com, brauner@kernel.org, andrii@kernel.org,
        cmllamas@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-undo-mmap-when-arch_validate_flags-fails.patch removed from -mm tree
Message-Id: <20221012225720.B0667C433B5@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap: undo ->mmap() when arch_validate_flags() fails
has been removed from the -mm tree.  Its filename was
     mm-mmap-undo-mmap-when-arch_validate_flags-fails.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -2673,7 +2673,7 @@ cannot_expand:
 	if (!arch_validate_flags(vma->vm_flags)) {
 		error = -EINVAL;
 		if (file)
-			goto unmap_and_free_vma;
+			goto close_and_free_vma;
 		else
 			goto free_vma;
 	}
@@ -2742,6 +2742,9 @@ expanded:
 	validate_mm(mm);
 	return addr;
 
+close_and_free_vma:
+	if (vma->vm_ops && vma->vm_ops->close)
+		vma->vm_ops->close(vma);
 unmap_and_free_vma:
 	fput(vma->vm_file);
 	vma->vm_file = NULL;
_

Patches currently in -mm which might be from cmllamas@google.com are


