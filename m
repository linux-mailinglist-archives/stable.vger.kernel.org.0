Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7A9A5EB11C
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 21:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiIZTP5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 15:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbiIZTPx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 15:15:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33138985BC;
        Mon, 26 Sep 2022 12:15:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFC47B80D91;
        Mon, 26 Sep 2022 19:15:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95968C433B5;
        Mon, 26 Sep 2022 19:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664219741;
        bh=ZEiqkD3lqVEC6iD4R4IATLWf2ke1pEozDwLdSvG3wtY=;
        h=Date:To:From:Subject:From;
        b=Mkr03xIVy55P1ol5FzB8wCZfYRwG5UhoOZqjP1b+G1MUV6CwsaMYNhqVZwDUEd4kz
         9gUKMASX7oZU74yz6SuGwIZ3HIy1838aH1SIK81TS3bZy5xPbj+lWf38GKcD2mmZyl
         u6yNkMhb40VujfKBZPAkSnW65OFgmIhEHMFu3NOA=
Date:   Mon, 26 Sep 2022 12:15:40 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        stable@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, cuibixuan@linux.alibaba.com,
        baolin.wang@linux.alibaba.com, xueshuai@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mmhwpoison-check-mm-when-killing-accessing-process.patch removed from -mm tree
Message-Id: <20220926191541.95968C433B5@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm,hwpoison: check mm when killing accessing process
has been removed from the -mm tree.  Its filename was
     mmhwpoison-check-mm-when-killing-accessing-process.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[akpm@linux-foundation.org: remove unrelated whitespace alteration]
Link: https://lkml.kernel.org/r/20220914064935.7851-1-xueshuai@linux.alibaba.com
Fixes: a3f5d80ea401 ("mm,hwpoison: send SIGBUS with error virutal address")
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Bixuan Cui <cuibixuan@linux.alibaba.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    3 +++
 1 file changed, 3 insertions(+)

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
_

Patches currently in -mm which might be from xueshuai@linux.alibaba.com are


