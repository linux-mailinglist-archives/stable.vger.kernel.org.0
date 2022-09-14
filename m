Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E15D5B9085
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 00:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbiINWhZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 18:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiINWhY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 18:37:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C2527F0AC;
        Wed, 14 Sep 2022 15:37:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5DF961F5A;
        Wed, 14 Sep 2022 22:37:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 271EDC433D6;
        Wed, 14 Sep 2022 22:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663195042;
        bh=a4RZr0FQ4tnf1CzhQbojpzKLCa5ArBFSGtEauNiRakA=;
        h=Date:To:From:Subject:From;
        b=b5wUqSxHGLFU/5DYoDcM7emrlT4W2vGPYCFsRzzMsWEzAF8uSBOQ5JqhCt/8ijPyP
         ocpEYg6mj0RMX3L/Sj1LBgtGDRlSOeYnAhZnegoCfZVDup9KmkN9vgwVwk9R1GToHd
         LiugLrWfq3aGMfLEb/F50bCZj218Ut+Cfrnhb/QQ=
Date:   Wed, 14 Sep 2022 15:37:21 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        stable@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, cuibixuan@linux.alibaba.com,
        baolin.wang@linux.alibaba.com, xueshuai@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mmhwpoison-check-mm-when-killing-accessing-process.patch added to mm-hotfixes-unstable branch
Message-Id: <20220914223722.271EDC433D6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: check mm when killing accessing process
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mmhwpoison-check-mm-when-killing-accessing-process.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmhwpoison-check-mm-when-killing-accessing-process.patch

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
From: Shuai Xue <xueshuai@linux.alibaba.com>
Subject: mm,hwpoison: check mm when killing accessing process
Date: Wed, 14 Sep 2022 14:49:35 +0800

The GHES code calls memory_failure_queue() from IRQ context to queue work
into workqueue and schedule it on the current CPU.  Then the work is
processed in memory_failure_work_func() by kworker and calls
memory_failure().

When a page is already poisoned, commit a3f5d80ea401 ("mm,hwpoison: send
SIGBUS with error virutal address") make memory_failure() call
kill_accessing_process() that:

    - holds mmap locking of current->mm
    - does pagetable walk to find the error virtual address
    - and sends SIGBUS to the current process with error info.

However, the mm of kworker is not valid, resulting in a null-pointer
dereference.  So check mm when killing the accessing process.

Link: https://lkml.kernel.org/r/20220914064935.7851-1-xueshuai@linux.alibaba.com
Fixes: a3f5d80ea401 ("mm,hwpoison: send SIGBUS with error virutal address")
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Bixuan Cui <cuibixuan@linux.alibaba.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/memory-failure.c~mmhwpoison-check-mm-when-killing-accessing-process
+++ a/mm/memory-failure.c
@@ -745,6 +745,9 @@ static int kill_accessing_process(struct
 	};
 	priv.tk.tsk = p;
 
+	if (!p->mm)
+		return -EFAULT;
+
 	mmap_read_lock(p->mm);
 	ret = walk_page_range(p->mm, 0, TASK_SIZE, &hwp_walk_ops,
 			      (void *)&priv);
@@ -753,6 +756,7 @@ static int kill_accessing_process(struct
 	else
 		ret = 0;
 	mmap_read_unlock(p->mm);
+
 	return ret > 0 ? -EHWPOISON : -EFAULT;
 }
 
_

Patches currently in -mm which might be from xueshuai@linux.alibaba.com are

mmhwpoison-check-mm-when-killing-accessing-process.patch

