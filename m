Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B134F6AAC3B
	for <lists+stable@lfdr.de>; Sat,  4 Mar 2023 20:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbjCDTwm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Mar 2023 14:52:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjCDTwl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Mar 2023 14:52:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B8612588;
        Sat,  4 Mar 2023 11:52:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 757DA60A26;
        Sat,  4 Mar 2023 19:52:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8DB1C433D2;
        Sat,  4 Mar 2023 19:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677959559;
        bh=VHcrpeofLucQnM7LVkFzm8gAQbQlvjVJjWyQP6ThY3k=;
        h=Date:To:From:Subject:From;
        b=pE2EXyCQwyQ7ko9nKL3IijpVRLFehL6GgyAWCKorgdf4RXLW91yVKNQ/bKNKl+LN1
         r7tqQA5WoCqyIN4OPFNz4Jn5Zd7eoB7hpGmhVvE+p8PB2oUWNQF6uCm2U8kcByIN01
         dcDpamyZwD3HBKHLk/W9S8paInWA2OeW5VDlATIo=
Date:   Sat, 04 Mar 2023 11:52:39 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, vishal.moola@gmail.com,
        stable@vger.kernel.org, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-paddr-fix-folio_size-call-after-folio_put-in-damon_pa_young.patch added to mm-hotfixes-unstable branch
Message-Id: <20230304195239.B8DB1C433D2@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/damon/paddr: fix folio_size() call after folio_put() in damon_pa_young()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-paddr-fix-folio_size-call-after-folio_put-in-damon_pa_young.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-paddr-fix-folio_size-call-after-folio_put-in-damon_pa_young.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/paddr: fix folio_size() call after folio_put() in damon_pa_young()
Date: Sat, 4 Mar 2023 19:39:48 +0000

Patch series "mm/damon/paddr: Fix folio-use-after-put bugs".

There are two folio accesses after folio_put() in mm/damon/paddr.c file. 
Fix those.


This patch (of 2):

damon_pa_young() is accessing a folio via folio_size() after folio_put()
for the folio has invoked.  Fix it.

Link: https://lkml.kernel.org/r/20230304193949.296391-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20230304193949.296391-2-sj@kernel.org
Fixes: 397b0c3a584b ("mm/damon/paddr: remove folio_sz field from damon_pa_access_chk_result")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: <stable@vger.kernel.org>	[6.2.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/damon/paddr.c~mm-damon-paddr-fix-folio_size-call-after-folio_put-in-damon_pa_young
+++ a/mm/damon/paddr.c
@@ -130,7 +130,6 @@ static bool damon_pa_young(unsigned long
 			accessed = false;
 		else
 			accessed = true;
-		folio_put(folio);
 		goto out;
 	}
 
@@ -144,10 +143,10 @@ static bool damon_pa_young(unsigned long
 
 	if (need_lock)
 		folio_unlock(folio);
-	folio_put(folio);
 
 out:
 	*folio_sz = folio_size(folio);
+	folio_put(folio);
 	return accessed;
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-paddr-fix-folio_size-call-after-folio_put-in-damon_pa_young.patch
mm-damon-paddr-fix-folio_nr_pages-after-folio_put-in-damon_pa_mark_accessed_or_deactivate.patch

