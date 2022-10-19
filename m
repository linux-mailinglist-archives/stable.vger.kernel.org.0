Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7762F603C2F
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbiJSIog (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbiJSIn7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:43:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F2DC7E812;
        Wed, 19 Oct 2022 01:41:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD7FE617FE;
        Wed, 19 Oct 2022 08:41:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D06A9C433C1;
        Wed, 19 Oct 2022 08:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666168882;
        bh=dpVcpzHt1fIFRVKlgbYHP6miojOg+vDegfBehVXCHZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F0SG/Xhwt5Ms0bQKK1Lwg9BIBySuo32lJMygkCO3nnv9x/shG/V95C9obWf7ylErV
         X6d06LQxCcttmFs/DvpzckG4wQ7cCh17Q5hA2NyMUKtZW33xr5A5gJBxkgLup7qvwl
         tRMB4Dy4wO56G1UiZoSatnC38js0y5gJF8EIf5b4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Carlos Llamas <cmllamas@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Liam Howlett <liam.howlett@oracle.com>,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.0 086/862] mm/mmap: undo ->mmap() when arch_validate_flags() fails
Date:   Wed, 19 Oct 2022 10:22:53 +0200
Message-Id: <20221019083253.727286986@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Carlos Llamas <cmllamas@google.com>

commit deb0f6562884b5b4beb883d73e66a7d3a1b96d99 upstream.

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
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Liam Howlett <liam.howlett@oracle.com>
Cc: Christian Brauner (Microsoft) <brauner@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>	[5.10+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mmap.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/mmap.c
+++ b/mm/mmap.c
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


