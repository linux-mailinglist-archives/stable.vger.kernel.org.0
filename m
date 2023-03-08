Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD9B6AFBBB
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 02:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbjCHBFx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 20:05:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjCHBFo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 20:05:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FAC1A90BB;
        Tue,  7 Mar 2023 17:05:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5CF8B81B4F;
        Wed,  8 Mar 2023 01:05:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A0CC433EF;
        Wed,  8 Mar 2023 01:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678237537;
        bh=dYYn4a2lT6nxiPkxxJPnp39TVtltB1r6i1JaXQjx9/U=;
        h=Date:To:From:Subject:From;
        b=suosglbxbAFD5eRMjUQp1VHMyvWF2sBDrPX6PgH2nuSvpd4qVAh7o94YkJW7rsEsD
         1C4WnrNv353mLywXzEg+uVGf1dTAHoc31f1ASdhW7pZinXKEUGwXQ0CGXpNvl8a2RE
         /z0IwNBYT8pDlLHkddZVvOuZSuaZa32PDiQuTroY=
Date:   Tue, 07 Mar 2023 17:05:36 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, vishal.moola@gmail.com,
        stable@vger.kernel.org, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-paddr-fix-folio_size-call-after-folio_put-in-damon_pa_young.patch removed from -mm tree
Message-Id: <20230308010537.68A0CC433EF@smtp.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/paddr: fix folio_size() call after folio_put() in damon_pa_young()
has been removed from the -mm tree.  Its filename was
     mm-damon-paddr-fix-folio_size-call-after-folio_put-in-damon_pa_young.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
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


