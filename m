Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D63335F187B
	for <lists+stable@lfdr.de>; Sat,  1 Oct 2022 03:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232019AbiJABr2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Sep 2022 21:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232005AbiJABrZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Sep 2022 21:47:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7403A154448;
        Fri, 30 Sep 2022 18:47:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B467612A8;
        Sat,  1 Oct 2022 01:47:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE2AC433D6;
        Sat,  1 Oct 2022 01:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664588842;
        bh=DeBLxbIpPtxVmsBxKFWKd+ojGmB4geCZ9LSXG/k8C1E=;
        h=Date:To:From:Subject:From;
        b=hJvjcco4xB4oZDVGRXxP8LIimb4u/9z5h+Shm73/cRbmazxWJGgwk9fuwc3qjYlpZ
         kygowNe9Sjgt7oA41YW+7x6PKlkFQP4E5tP2j4hCKbDh+WLcGR0IEiIdX8RcTw5neb
         AvGBbv1SkYkU/7XuPzukqo3xfePqM3sKLd1L+Flo=
Date:   Fri, 30 Sep 2022 18:47:21 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org, sj@kernel.org,
        ppbuk5246@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] damon-sysfs-fix-possible-memleak-on-damon_sysfs_add_target.patch removed from -mm tree
Message-Id: <20221001014722.5FE2AC433D6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: damon/sysfs: fix possible memleak on damon_sysfs_add_target
has been removed from the -mm tree.  Its filename was
     damon-sysfs-fix-possible-memleak-on-damon_sysfs_add_target.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Levi Yun <ppbuk5246@gmail.com>
Subject: damon/sysfs: fix possible memleak on damon_sysfs_add_target
Date: Mon, 26 Sep 2022 16:06:11 +0000

When damon_sysfs_add_target couldn't find proper task, New allocated
damon_target structure isn't registered yet, So, it's impossible to free
new allocated one by damon_sysfs_destroy_targets.

By calling damon_add_target as soon as allocating new target, Fix this
possible memory leak.

Link: https://lkml.kernel.org/r/20220926160611.48536-1-sj@kernel.org
Fixes: a61ea561c871 ("mm/damon/sysfs: link DAMON for virtual address spaces monitoring")
Signed-off-by: Levi Yun <ppbuk5246@gmail.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[5.17.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/sysfs.c~damon-sysfs-fix-possible-memleak-on-damon_sysfs_add_target
+++ a/mm/damon/sysfs.c
@@ -2182,12 +2182,12 @@ static int damon_sysfs_add_target(struct
 
 	if (!t)
 		return -ENOMEM;
+	damon_add_target(ctx, t);
 	if (damon_target_has_pid(ctx)) {
 		t->pid = find_get_pid(sys_target->pid);
 		if (!t->pid)
 			goto destroy_targets_out;
 	}
-	damon_add_target(ctx, t);
 	err = damon_sysfs_set_regions(t, sys_target->regions);
 	if (err)
 		goto destroy_targets_out;
_

Patches currently in -mm which might be from ppbuk5246@gmail.com are


