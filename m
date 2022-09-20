Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 202AC5BDC6C
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 07:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbiITF1l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 01:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiITF1e (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 01:27:34 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 301D85AA08
        for <stable@vger.kernel.org>; Mon, 19 Sep 2022 22:27:10 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id cg5-20020a056a00290500b0053511889856so1035959pfb.18
        for <stable@vger.kernel.org>; Mon, 19 Sep 2022 22:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=ZQtNQlc3ZqVv1pbQxIAbS3ed/BnkNBoPEsqSokh2HNM=;
        b=H4E6gT5zG8vw9EGy88SSEmRWdX4hZ3QWaisPMoFI03UGCGuwJ0hZRCvFXkCtngq8cL
         JVJEbJ652Rcbg1bagt82h9IjajSvk5XPuPPEGXtO/va9QQ3nnLeMDYek0egHBp463ceN
         tUEOA4ErxmyLLswXfmwevF5I+1y9A9tO/xEITavR2XltSK5lzRgo7yBKDdMqtUbfzzbi
         DorZwvaWU3aQDwfRpbIC5YriZWvSZpgzQoIrs7IdCama/pHhSgDlTuxDnUxfBVyNu7xB
         gKGoeIerj2H+5usmCjzsfbK7KskyYNu2kZw0afl6ew+jqyG/xo4v4dxh/n2Sw0nHxjhE
         c/+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=ZQtNQlc3ZqVv1pbQxIAbS3ed/BnkNBoPEsqSokh2HNM=;
        b=FJZ6UqqSplYf9EsaT+p7ExaBdgr8wFqiaXEiGbE7IZ6GbBVfDJNHyjjWkFYEWG2vMw
         O7IYfGs69IMV/eQ+dHIR4INrnHr3xwDOmATPzlNYmvTAj21uCEon8KABe2gKarqiieZZ
         gGlzqThe4XXYc0OKSsJReoGy8XDUNJdprnE22pydPg5NALAsaEYV9LNq5kGzdJJUH5c9
         3Z6Vvo5bFTWWURQW/tbR9mb1OgnOzUJHDZrkdAPs5DcRyzJZldGaFB3AGJHxYuc1Sgna
         BzI0fxbnyZ288EXlvodGIb6PWIV6QeO2E8zX/5q4CgklxDntbw3rqJYpvgHRC+yjnhQz
         zOwA==
X-Gm-Message-State: ACrzQf2SpDwjEV5VA+UKSHN3smrZ1nsOoiM6aTq2DiMnHMJNSyAqmxKe
        G9zT0bYr4tGnjb8uUdtEA/NjqrvJJY+IxQ==
X-Google-Smtp-Source: AMsMyM7blhgRPKlUNjPfMpAMQknKvD4VR5Ox0ipX6yzbzLIDVXiNSZwjIH222XJhCic4Q+j5JTaJpP12Ko84IQ==
X-Received: from xllamas.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5070])
 (user=cmllamas job=sendgmr) by 2002:a17:90b:38c5:b0:202:67d9:7337 with SMTP
 id nn5-20020a17090b38c500b0020267d97337mr2030137pjb.158.1663651627612; Mon,
 19 Sep 2022 22:27:07 -0700 (PDT)
Date:   Tue, 20 Sep 2022 05:24:43 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920052444.2148424-1-cmllamas@google.com>
Subject: [PATCH 5.15] binder: remove inaccurate mmap_assert_locked()
From:   Carlos Llamas <cmllamas@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "=?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?=" <arve@android.com>,
        Todd Kjos <tkjos@android.com>,
        Martijn Coenen <maco@android.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Christian Brauner <christian@brauner.io>,
        Hridya Valsaraju <hridya@google.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Liam Howlett <liam.howlett@oracle.com>
Cc:     kernel-team@android.com, Carlos Llamas <cmllamas@google.com>,
        stable@vger.kernel.org, Todd Kjos <tkjos@google.com>
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

Acquiring the mmap_lock during exit_mmap() was only added recently in
v5.17 by commit 64591e8605d6 ("mm: protect free_pgtables with mmap_lock
write lock in exit_mmap"). Soon after, asserts for holding this lock
were added to the binder_alloc_set_vma() callback by the following two
fix commits in mainline: commit b0cab80ecd54 ("android: binder: fix
lockdep check on clearing vma") and commit a43cfc87caaf ("android:
binder: stop saving a pointer to the VMA").

These two fix commits were picked for stable trees including v5.15 were
unfortunately the mmap_lock is not held during exit_mmap() yet and this
unmet dependency leads to the following BUG report:

  ------------[ cut here ]------------
  kernel BUG at include/linux/mmap_lock.h:156!
  Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
  Modules linked in:
  CPU: 3 PID: 437 Comm: binder Not tainted 5.15.68 #5
  Hardware name: linux,dummy-virt (DT)
  pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
  pc : binder_alloc_vma_close+0x6c/0x70
  lr : binder_alloc_vma_close+0x6c/0x70
  sp : ffff800008687a70
  x29: ffff800008687a70 x28: ffff02a7ccf89d00 x27: ffff02a7c92f99e8
  x26: 000000000000012a x25: ffff02a7c6284740 x24: ffff02a7ccf8a360
  x23: ffff02a7c92f9980 x22: 1ffff000010d0f6c x21: ffff02a7c92f99e8
  x20: ffff02a7c92f9980 x19: ffff02a7d16b79a8 x18: 0000ffffe1702d20
  x17: 3334373239343932 x16: 34206e6163735f74 x15: 78656e5f616d756e
  x14: 0a30303030303030 x13: 7366666f5f6e6163 x12: ffff60550564a12b
  x11: 1fffe0550564a12a x10: ffff60550564a12a x9 : dfff800000000000
  x8 : ffff02a82b250957 x7 : 0000000000000001 x6 : ffff60550564a12a
  x5 : ffff02a82b250950 x4 : dfff800000000000 x3 : 0000000000000000
  x2 : 0000000000000000 x1 : ffff02a7ccf89d00 x0 : 0000000000000374
  Call trace:
   binder_alloc_vma_close+0x6c/0x70
   binder_vma_close+0x38/0xf4
   remove_vma+0x4c/0x94
   exit_mmap+0x14c/0x2bc
   __mmput+0x70/0x19c
   mmput+0x68/0x80
   do_exit+0x484/0xeb0
   do_group_exit+0x5c/0x100
   [...]

This patch removes the inaccurate assert specifically from v5.15 since
it's the only release with such issue. Note the mmap_lock is technically
not needed here as the mm->mm_users has dropped to zero at this point.
More context: https://lore.kernel.org/all/YxpQaio7xm3z9TUw@google.com/.

Fixes: b0cab80ecd54 ("android: binder: fix lockdep check on clearing vma")
Fixes: a43cfc87caaf ("android: binder: stop saving a pointer to the VMA")
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org> # v5.15
Signed-off-by: Carlos Llamas <cmllamas@google.com>
---
 drivers/android/binder_alloc.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
index 849f8dff0be1..8ed450125c92 100644
--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -315,16 +315,9 @@ static inline void binder_alloc_set_vma(struct binder_alloc *alloc,
 {
 	unsigned long vm_start = 0;
 
-	/*
-	 * Allow clearing the vma with holding just the read lock to allow
-	 * munmapping downgrade of the write lock before freeing and closing the
-	 * file using binder_alloc_vma_close().
-	 */
 	if (vma) {
 		vm_start = vma->vm_start;
 		mmap_assert_write_locked(alloc->vma_vm_mm);
-	} else {
-		mmap_assert_locked(alloc->vma_vm_mm);
 	}
 
 	alloc->vma_addr = vm_start;
-- 
2.37.3.968.ga6b4b080e4-goog

