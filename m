Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8322577299
	for <lists+stable@lfdr.de>; Sun, 17 Jul 2022 02:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbiGQAtt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Jul 2022 20:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiGQAts (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 16 Jul 2022 20:49:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B9418E08;
        Sat, 16 Jul 2022 17:49:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CC1960C5E;
        Sun, 17 Jul 2022 00:49:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD93C34114;
        Sun, 17 Jul 2022 00:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658018986;
        bh=03ckahG4RpL5078XVx//YiGFkTjWdle++Sm4anjeOqY=;
        h=Date:To:From:Subject:From;
        b=sqcKJc2Gt3nj4Gf0+AdqYp4BlvxdiV2xT/5YSytF4TlYgg4tZ5ZS3kAUAuyJGvihI
         fGNGWl2doQIYiz8mJHMx0KUXG4EhQ8ypVIWJT3/9UCsV8kMCzJa1gBpkJUKqoTAqLe
         wcJMpHuETNxEuNEqMeyYgTDBegB8+w9kybvLY5kw=
Date:   Sat, 16 Jul 2022 17:49:45 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org, sj@kernel.org,
        niejianglei2021@163.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-reclaim-fix-potential-memory-leak-in-damon_reclaim_init.patch added to mm-unstable branch
Message-Id: <20220717004946.7AD93C34114@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/damon/reclaim: fix potential memory leak in damon_reclaim_init()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-reclaim-fix-potential-memory-leak-in-damon_reclaim_init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-reclaim-fix-potential-memory-leak-in-damon_reclaim_init.patch

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
From: Jianglei Nie <niejianglei2021@163.com>
Subject: mm/damon/reclaim: fix potential memory leak in damon_reclaim_init()
Date: Thu, 14 Jul 2022 14:37:46 +0800

damon_reclaim_init() allocates a memory chunk for ctx with
damon_new_ctx().  When damon_select_ops() fails, ctx is not released,
which will lead to a memory leak.

We should release the ctx with damon_destroy_ctx() when damon_select_ops()
fails to fix the memory leak.

Link: https://lkml.kernel.org/r/20220714063746.2343549-1-niejianglei2021@163.com
Fixes: 4d69c3457821 ("mm/damon/reclaim: use damon_select_ops() instead of damon_{v,p}a_set_operations()")
Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-fix-potential-memory-leak-in-damon_reclaim_init
+++ a/mm/damon/reclaim.c
@@ -435,8 +435,10 @@ static int __init damon_reclaim_init(voi
 	if (!ctx)
 		return -ENOMEM;
 
-	if (damon_select_ops(ctx, DAMON_OPS_PADDR))
+	if (damon_select_ops(ctx, DAMON_OPS_PADDR)) {
+		damon_destroy_ctx(ctx);
 		return -EINVAL;
+	}
 
 	ctx->callback.after_wmarks_check = damon_reclaim_after_wmarks_check;
 	ctx->callback.after_aggregation = damon_reclaim_after_aggregation;
_

Patches currently in -mm which might be from niejianglei2021@163.com are

mm-damon-reclaim-fix-potential-memory-leak-in-damon_reclaim_init.patch

