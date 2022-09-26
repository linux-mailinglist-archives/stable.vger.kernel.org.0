Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52DD15EADD6
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 19:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbiIZROr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 13:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbiIZROZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 13:14:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6C84599A;
        Mon, 26 Sep 2022 09:26:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACF6D60F93;
        Mon, 26 Sep 2022 16:26:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0F45C433C1;
        Mon, 26 Sep 2022 16:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664209564;
        bh=/pMO+HkTnGepokq+oqMOrGh3yo5nDjVI+hg23C63v6Y=;
        h=Date:To:From:Subject:From;
        b=D3Gsqz9933T81jfJpRL/LA91Y13JcRBopK5Lr5Oey6K+x8zhxtL8OFww03IY14IKN
         e257yDdHnndCORhjz5xRZ8lTBNdcQyhg6EoauEjYv3WAKiCUKruvRVXOfNmcS1EIzv
         Mhb0SB7h2SSBX3AOTIV/pq4KqxVtTdBsnEPzdPg4=
Date:   Mon, 26 Sep 2022 09:26:02 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org, sj@kernel.org,
        ppbuk5246@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + damon-sysfs-fix-possible-memleak-on-damon_sysfs_add_target.patch added to mm-hotfixes-unstable branch
Message-Id: <20220926162603.E0F45C433C1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: damon/sysfs: fix possible memleak on damon_sysfs_add_target
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     damon-sysfs-fix-possible-memleak-on-damon_sysfs_add_target.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/damon-sysfs-fix-possible-memleak-on-damon_sysfs_add_target.patch

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
From: Levi Yun <ppbuk5246@gmail.com>
Subject: damon/sysfs: fix possible memleak on damon_sysfs_add_target
Date: Mon, 26 Sep 2022 16:06:11 +0000

When damon_sysfs_add_target couldn't find proper task, New allocated
damon_target structure isn't registered yet, So, it's impossible to free
new allocated one by damon_sysfs_destroy_targets.

By calling daemon_add_target as soon as allocating new target, Fix this
possible memory leak.

Link: https://lkml.kernel.org/r/20220926160611.48536-1-sj@kernel.org
Fixes: a61ea561c871 ("mm/damon/sysfs: link DAMON for virtual address spaces monitoring")
Signed-off-by: Levi Yun <ppbuk5246@gmail.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[5.17.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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

damon-sysfs-fix-possible-memleak-on-damon_sysfs_add_target.patch

