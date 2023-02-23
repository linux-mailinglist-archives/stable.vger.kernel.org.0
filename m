Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 838496A1129
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 21:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbjBWUZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 15:25:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBWUZ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 15:25:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C195D45A;
        Thu, 23 Feb 2023 12:25:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9786661783;
        Thu, 23 Feb 2023 20:25:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C97A9C433D2;
        Thu, 23 Feb 2023 20:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677183925;
        bh=WdERPTTVXzKFfMP4dQpq+eis31XgXLUhWltwO2fRdas=;
        h=Date:To:From:Subject:From;
        b=rm6lkdT1bCm29a55VO3XpihuejquPPrjW4dGYPCSOlZTT99smntouZJBTLrgtw4Q1
         Y8bg3GZPF5+SQj0lG+fN0GoB2Kzlah7+69AADiPiL2UfKkdDJmn2olklHr6EoQ8QXQ
         qyvzvxdqwbr3RxKvkNJOdLG/ytNmqszcTIRtzO1Y=
Date:   Thu, 23 Feb 2023 12:25:25 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org, sj@kernel.org,
        andrew.yang@mediatek.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-paddr-fix-missing-folio_put.patch added to mm-unstable branch
Message-Id: <20230223202525.C97A9C433D2@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/damon/paddr: fix missing folio_put()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-paddr-fix-missing-folio_put.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-paddr-fix-missing-folio_put.patch

This patch will later appear in the mm-unstable branch at
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
From: "andrew.yang" <andrew.yang@mediatek.com>
Subject: mm/damon/paddr: fix missing folio_put()
Date: Wed, 22 Feb 2023 14:42:20 +0800

damon_get_folio() would always increase folio _refcount and
folio_isolate_lru() would increase folio _refcount if the folio's lru flag
is set.

If an unevictable folio isolated successfully, there will be two more
_refcount.  The one from folio_isolate_lru() will be decreased in
folio_puback_lru(), but the other one from damon_get_folio() will be left
behind.  This causes a pin page.

Whatever the case, the _refcount from damon_get_folio() should be
decreased.

Link: https://lkml.kernel.org/r/20230222064223.6735-1-andrew.yang@mediatek.com
Fixes: 57223ac29584 ("mm/damon/paddr: support the pageout scheme")
Signed-off-by: andrew.yang <andrew.yang@mediatek.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[5.16.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-fix-missing-folio_put
+++ a/mm/damon/paddr.c
@@ -250,12 +250,11 @@ static unsigned long damon_pa_pageout(st
 			folio_put(folio);
 			continue;
 		}
-		if (folio_test_unevictable(folio)) {
+		if (folio_test_unevictable(folio))
 			folio_putback_lru(folio);
-		} else {
+		else
 			list_add(&folio->lru, &folio_list);
-			folio_put(folio);
-		}
+		folio_put(folio);
 	}
 	applied = reclaim_pages(&folio_list);
 	cond_resched();
_

Patches currently in -mm which might be from andrew.yang@mediatek.com are

mm-damon-paddr-fix-missing-folio_put.patch

