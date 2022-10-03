Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA975F2954
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbiJCHRs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbiJCHQw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:16:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F164646625;
        Mon,  3 Oct 2022 00:13:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D2DF60F9D;
        Mon,  3 Oct 2022 07:13:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F08DC433C1;
        Mon,  3 Oct 2022 07:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781235;
        bh=ICoUNowOuD5gwjloT5nuRQeI+kxe38qBkwjQbhHvGqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q9kCsHIJFejxAe3v/ITTN2WJdTp6/lBFODm7ZTEW7SZZnaSLkWO7J9pFa5otaDyf2
         eTBQTezHoYD/6uMycD+Xc/SRgBlm1P9/vL9u5PegrmBcHxlXSc8C19+B8vJ1c0JrCF
         +EdmdMZt6n7H23EqKiKKZIDi6P1ykkJiCkAwyynw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuai Xue <xueshuai@linux.alibaba.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Huang Ying <ying.huang@intel.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Bixuan Cui <cuibixuan@linux.alibaba.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.19 046/101] mm,hwpoison: check mm when killing accessing process
Date:   Mon,  3 Oct 2022 09:10:42 +0200
Message-Id: <20221003070725.603747728@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
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

From: Shuai Xue <xueshuai@linux.alibaba.com>

commit 77677cdbc2aa4b5d5d839562793d3d126201d18d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory-failure.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -697,6 +697,9 @@ static int kill_accessing_process(struct
 	};
 	priv.tk.tsk = p;
 
+	if (!p->mm)
+		return -EFAULT;
+
 	mmap_read_lock(p->mm);
 	ret = walk_page_range(p->mm, 0, TASK_SIZE, &hwp_walk_ops,
 			      (void *)&priv);


