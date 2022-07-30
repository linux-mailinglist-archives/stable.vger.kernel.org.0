Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 197CC5857B3
	for <lists+stable@lfdr.de>; Sat, 30 Jul 2022 03:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239516AbiG3BIl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 21:08:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239645AbiG3BIc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 21:08:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 971C582F81;
        Fri, 29 Jul 2022 18:08:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40BB5B82922;
        Sat, 30 Jul 2022 01:08:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE148C433C1;
        Sat, 30 Jul 2022 01:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143305;
        bh=tHEGa8mazQJPWNnxEBc8I/W8u2gQ35FZyowey+91he0=;
        h=Date:To:From:Subject:From;
        b=ejJkKV7Tyt2GdfVgYxfKT7xJHXZsWtH4nyDgtExJj+qLyrOWz0AiUWw1QOiIJLFBz
         L7JXHkzAsHEhuZmMNfPpUemPBQgy904lfqRJvXeYS6CIsffXhFtmFleHJ2uPEQIngH
         cndNc6enM/4IU7FdQuPVinqrTm72RiVMioLhLQ9k=
Date:   Fri, 29 Jul 2022 18:08:25 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org, sj@kernel.org,
        niejianglei2021@163.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-reclaim-fix-potential-memory-leak-in-damon_reclaim_init.patch removed from -mm tree
Message-Id: <20220730010825.CE148C433C1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/reclaim: fix potential memory leak in damon_reclaim_init()
has been removed from the -mm tree.  Its filename was
     mm-damon-reclaim-fix-potential-memory-leak-in-damon_reclaim_init.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


