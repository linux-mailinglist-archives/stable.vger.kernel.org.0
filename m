Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19C31685C5C
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 01:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbjBAApx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 19:45:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbjBAApc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 19:45:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ABB551C7E;
        Tue, 31 Jan 2023 16:45:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 350096174D;
        Wed,  1 Feb 2023 00:45:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DCEAC433EF;
        Wed,  1 Feb 2023 00:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675212324;
        bh=eGVzkrbLdW9WwkkOs8UpswFuL/hxkX8KPq+KMdgppA8=;
        h=Date:To:From:Subject:From;
        b=2oo8xM0uOioc2lnYKlyY5M6P7zhUbvjEhMM5mor5FwFjlpUV8aRRb1wkWg0iJMTxD
         dYD7h9H1sPCl6DjGDQAJctreEt3l1iQapNjsM++UB4JR8cASRh22L3vNrgoq+NsXcN
         NVNaGJp4dlw0p6hBkpXdqORcq0JIIsBdA3A74lFQ=
Date:   Tue, 31 Jan 2023 16:45:24 -0800
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
        stable@vger.kernel.org, hughd@google.com, chenwandun@huawei.com,
        xialonglong1@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-swapfile-add-cond_resched-in-get_swap_pages.patch removed from -mm tree
Message-Id: <20230201004524.8DCEAC433EF@smtp.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/swapfile: add cond_resched() in get_swap_pages()
has been removed from the -mm tree.  Its filename was
     mm-swapfile-add-cond_resched-in-get_swap_pages.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Longlong Xia <xialonglong1@huawei.com>
Subject: mm/swapfile: add cond_resched() in get_swap_pages()
Date: Sat, 28 Jan 2023 09:47:57 +0000

The softlockup still occurs in get_swap_pages() under memory pressure.  64
CPU cores, 64GB memory, and 28 zram devices, the disksize of each zram
device is 50MB with same priority as si.  Use the stress-ng tool to
increase memory pressure, causing the system to oom frequently.

The plist_for_each_entry_safe() loops in get_swap_pages() could reach tens
of thousands of times to find available space (extreme case:
cond_resched() is not called in scan_swap_map_slots()).  Let's add
cond_resched() into get_swap_pages() when failed to find available space
to avoid softlockup.

Link: https://lkml.kernel.org/r/20230128094757.1060525-1-xialonglong1@huawei.com
Signed-off-by: Longlong Xia <xialonglong1@huawei.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Chen Wandun <chenwandun@huawei.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/swapfile.c~mm-swapfile-add-cond_resched-in-get_swap_pages
+++ a/mm/swapfile.c
@@ -1100,6 +1100,7 @@ start_over:
 			goto check_out;
 		pr_debug("scan_swap_map of si %d failed to find offset\n",
 			si->type);
+		cond_resched();
 
 		spin_lock(&swap_avail_lock);
 nextsi:
_

Patches currently in -mm which might be from xialonglong1@huawei.com are

mm-swapfile-remove-pr_debug-in-get_swap_pages.patch

