Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B53FB6AAC3C
	for <lists+stable@lfdr.de>; Sat,  4 Mar 2023 20:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjCDTwo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Mar 2023 14:52:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjCDTwn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Mar 2023 14:52:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7830E11EA6;
        Sat,  4 Mar 2023 11:52:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13F8A60A26;
        Sat,  4 Mar 2023 19:52:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD11C433EF;
        Sat,  4 Mar 2023 19:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677959561;
        bh=HGbhhO/P3yG7Y0pabXpbs6UNLvFIBzIfkN1GnrqGL0k=;
        h=Date:To:From:Subject:From;
        b=Rl9C8DgNGdHi4h/t5kJLh3a95odg2T/Hl90eC40vbawg4rV9ZhXnkIUOzMw/Epdcl
         7HbWkfpdl85bhZfd3HRPoAl95zv7oHNeVTFXwFNizGwMsab8Vobt1r6Gj+PT+4a4ZW
         ycuyeCYawoz9+bi1e+3xwqPa4jvmRvIv205OT4hs=
Date:   Sat, 04 Mar 2023 11:52:40 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, vishal.moola@gmail.com,
        stable@vger.kernel.org, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-paddr-fix-folio_nr_pages-after-folio_put-in-damon_pa_mark_accessed_or_deactivate.patch added to mm-hotfixes-unstable branch
Message-Id: <20230304195241.6DD11C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/damon/paddr: fix folio_nr_pages() after folio_put() in damon_pa_mark_accessed_or_deactivate()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-paddr-fix-folio_nr_pages-after-folio_put-in-damon_pa_mark_accessed_or_deactivate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-paddr-fix-folio_nr_pages-after-folio_put-in-damon_pa_mark_accessed_or_deactivate.patch

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
Subject: mm/damon/paddr: fix folio_nr_pages() after folio_put() in damon_pa_mark_accessed_or_deactivate()
Date: Sat, 4 Mar 2023 19:39:49 +0000

damon_pa_mark_accessed_or_deactivate() is accessing a folio via
folio_nr_pages() after folio_put() for the folio has invoked.  Fix it.

Link: https://lkml.kernel.org/r/20230304193949.296391-3-sj@kernel.org
Fixes: f70da5ee8fe1 ("mm/damon: convert damon_pa_mark_accessed_or_deactivate() to use folios")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: <stable@vger.kernel.org>	[6.2.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/damon/paddr.c~mm-damon-paddr-fix-folio_nr_pages-after-folio_put-in-damon_pa_mark_accessed_or_deactivate
+++ a/mm/damon/paddr.c
@@ -280,8 +280,8 @@ static inline unsigned long damon_pa_mar
 			folio_mark_accessed(folio);
 		else
 			folio_deactivate(folio);
-		folio_put(folio);
 		applied += folio_nr_pages(folio);
+		folio_put(folio);
 	}
 	return applied * PAGE_SIZE;
 }
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-paddr-fix-folio_size-call-after-folio_put-in-damon_pa_young.patch
mm-damon-paddr-fix-folio_nr_pages-after-folio_put-in-damon_pa_mark_accessed_or_deactivate.patch

