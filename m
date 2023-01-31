Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94D016835D9
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 19:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231931AbjAaS55 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 13:57:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231897AbjAaS5z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 13:57:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8051568A1;
        Tue, 31 Jan 2023 10:57:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99628B81E57;
        Tue, 31 Jan 2023 18:57:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45CF1C433D2;
        Tue, 31 Jan 2023 18:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675191455;
        bh=NGEBB5KFeZVNfVCgYw9Hzm+OxcfJtqrtVIA6k3kFzK8=;
        h=Date:To:From:Subject:From;
        b=aZ6MagE7W/J/0brL75YoKMPpdCl6B1EkIeTQr86AMZpl6pTKrjPcfk0t+W04IlOZW
         iVzL1bdx1LEN1uCKW5PymHYQBS5uvdlGO1gN/zipZvYQ22jR4k9NwecKaOBY/lJiDB
         88OWJ5gY3fIl5OmWMBADf89wplOxlC0EZn4s4LY4=
Date:   Tue, 31 Jan 2023 10:57:34 -0800
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
        stable@vger.kernel.org, hughd@google.com, chenwandun@huawei.com,
        xialonglong1@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swapfile-add-cond_resched-in-get_swap_pages.patch added to mm-hotfixes-unstable branch
Message-Id: <20230131185735.45CF1C433D2@smtp.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/swapfile: add cond_resched() in get_swap_pages()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-swapfile-add-cond_resched-in-get_swap_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swapfile-add-cond_resched-in-get_swap_pages.patch

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

mm-swapfile-add-cond_resched-in-get_swap_pages.patch

