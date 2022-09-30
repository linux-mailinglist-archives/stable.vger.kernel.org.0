Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C87495F01DA
	for <lists+stable@lfdr.de>; Fri, 30 Sep 2022 02:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbiI3Aiu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 20:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiI3Ait (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 20:38:49 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE38202897
        for <stable@vger.kernel.org>; Thu, 29 Sep 2022 17:38:48 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id h62-20020a636c41000000b0043cc1874c79so1846727pgc.5
        for <stable@vger.kernel.org>; Thu, 29 Sep 2022 17:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=/+fx+mwCY8+Lc56RPP8V/faepECB7hZCBsaDQg4I+cc=;
        b=ZPIfPk960PYGAaC4JKn3VhKL1eWkgdn15xSuOq0AqzXIKYEmxriwqSGt46TymakdtA
         /88dDki+5epxVvUUdNpksj2JlRcU49C43GAGUYFwoxlMoMMZzcloMxlw0N58WxXjbSF5
         Se1wmsCkfGkQA6wGwZIJVRBo0ov3kcqv0PJ6Mgs46fJroX+CTf5nL6QxeHAqMmNuDhlZ
         ZLXf2tQf5TEofLxvvoOQDpbcPGt8E2VYM2m6hfN5/opHRl41WQOHFZTv60EYrlI+6DWW
         Nsguytj9sRfljVBTavr1oo/pxTS20+TfcaZxA/eALqkcFI2Hr/m+qg9rLTonFipBCh/n
         UdqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=/+fx+mwCY8+Lc56RPP8V/faepECB7hZCBsaDQg4I+cc=;
        b=lx17OhyU+aoiTeEQZCHN69Wa5tZ1EkXE487ElqKSM7HCXpu8M7uWPkcE6xYyF/Go22
         z3qSAt2xALU43P5uprI94V08RqIILLddtttWfO6b/ungsHwykjpzvvZvVtho7S4oVd96
         LJJvdpZ0sIBBP4QKfa/0OrM2U1vSYgX0u5S2AH8VMsF/EH0WvAIipzMO5nL91poehi2z
         tUahS5hvOS0M6tzP0pohOaNRrrbn/pKbTAZbk8bE/YHZiGkHBZQIowo1Y+exB02bYOaS
         EiekVcGyUQZRJXJbFYz/NMUqcK9jh2dZqQ89XuapJGgrAIWqt1o69y2xUXo08o725ZaV
         eZtA==
X-Gm-Message-State: ACrzQf21L2/gVf0RV4o6EZ8oho6Hs3SkPkaXhGovJ1mesDiczwzLt+PH
        SEQ6aTF1vIBxeACI6MOLry1yFJFeabBoEA==
X-Google-Smtp-Source: AMsMyM4lxRMX5F6XPH9FcDGPC4sqDa6OaOIE88Xx7FH+Jf5rB7ppzEvhMHium/cWA0tiotWLWDTX/zXq/h0YZw==
X-Received: from xllamas.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5070])
 (user=cmllamas job=sendgmr) by 2002:a05:6a00:150e:b0:548:d48:5a3c with SMTP
 id q14-20020a056a00150e00b005480d485a3cmr5928693pfu.27.1664498328465; Thu, 29
 Sep 2022 17:38:48 -0700 (PDT)
Date:   Fri, 30 Sep 2022 00:38:43 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20220930003844.1210987-1-cmllamas@google.com>
Subject: [PATCH] mm/mmap: undo ->mmap() when arch_validate_flags() fails
From:   Carlos Llamas <cmllamas@google.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc:     Michal Hocko <mhocko@suse.com>,
        Christian Brauner <brauner@kernel.org>, linux-mm@kvack.org,
        bpf@vger.kernel.org, kernel-team@android.com,
        Carlos Llamas <cmllamas@google.com>,
        Liam Howlett <liam.howlett@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit c462ac288f2c ("mm: Introduce arch_validate_flags()") added a late
check in mmap_region() to let architectures validate vm_flags. The check
needs to happen after calling ->mmap() as the flags can potentially be
modified during this callback.

If arch_validate_flags() check fails we unmap and free the vma. However,
the error path fails to undo the ->mmap() call that previously succeeded
and depending on the specific ->mmap() implementation this translates to
reference increments, memory allocations and other operations what will
not be cleaned up.

There are several places (mainly device drivers) where this is an issue.
However, one specific example is bpf_map_mmap() which keeps count of the
mappings in map->writecnt. The count is incremented on ->mmap() and then
decremented on vm_ops->close(). When arch_validate_flags() fails this
count is off since bpf_map_mmap_close() is never called.

One can reproduce this issue in arm64 devices with MTE support. Here the
vm_flags are checked to only allow VM_MTE if VM_MTE_ALLOWED has been set
previously. From userspace then is enough to pass the PROT_MTE flag to
mmap() syscall to trigger the arch_validate_flags() failure.

The following program reproduces this issue:
---
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
---

By manually adding some log statements to the vm_ops callbacks we can
confirm that when passing PROT_MTE to mmap() the map->writecnt is off
upon ->release():

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
arch_validate_flags() check fails, after this we can proceed to unmap
and free the vma on the error path.

Fixes: c462ac288f2c ("mm: Introduce arch_validate_flags()")
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org> # v5.10+
Signed-off-by: Carlos Llamas <cmllamas@google.com>
---
 mm/mmap.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 9d780f415be3..36c08e2c78da 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1797,7 +1797,7 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 	if (!arch_validate_flags(vma->vm_flags)) {
 		error = -EINVAL;
 		if (file)
-			goto unmap_and_free_vma;
+			goto close_and_free_vma;
 		else
 			goto free_vma;
 	}
@@ -1844,6 +1844,9 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 
 	return addr;
 
+close_and_free_vma:
+	if (vma->vm_ops && vma->vm_ops->close)
+		vma->vm_ops->close(vma);
 unmap_and_free_vma:
 	fput(vma->vm_file);
 	vma->vm_file = NULL;
-- 
2.38.0.rc1.362.ged0d419d3c-goog

