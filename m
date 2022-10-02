Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 563435F225E
	for <lists+stable@lfdr.de>; Sun,  2 Oct 2022 11:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbiJBJuk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 05:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiJBJuj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 05:50:39 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 933CC41D19
        for <stable@vger.kernel.org>; Sun,  2 Oct 2022 02:50:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 77176CE09F9
        for <stable@vger.kernel.org>; Sun,  2 Oct 2022 09:50:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECDC7C433C1;
        Sun,  2 Oct 2022 09:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664704234;
        bh=Qb0coT/pIlLxX05fVJGzpCNe9uWqJz5ehrVy+znBHFM=;
        h=Subject:To:Cc:From:Date:From;
        b=lBkmkNDPrMunqqTLUyaWSKqO+4HKeTB4USfhjDCIBgzkhc5pC4io5+/17RhsOkJhb
         bX07vgr6DPisQD6XfSRP5B6VHqN5cOOd0/yWFFedHzwmcCupzyrDO3DnRiuebVjxgo
         D74BLhqDsxOWkJvkjBPtLLXlPCLO6p1uTZu9wapE=
Subject: FAILED: patch "[PATCH] damon/sysfs: fix possible memleak on damon_sysfs_add_target" failed to apply to 5.19-stable tree
To:     ppbuk5246@gmail.com, akpm@linux-foundation.org, sj@kernel.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 02 Oct 2022 11:51:11 +0200
Message-ID: <166470427121860@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

1c8e2349f2d0 ("damon/sysfs: fix possible memleak on damon_sysfs_add_target")
c9e124e0382d ("mm/damon/{dbgfs,sysfs}: move target_has_pid() from dbgfs to damon.h")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1c8e2349f2d033f634d046063b704b2ca6c46972 Mon Sep 17 00:00:00 2001
From: Levi Yun <ppbuk5246@gmail.com>
Date: Mon, 26 Sep 2022 16:06:11 +0000
Subject: [PATCH] damon/sysfs: fix possible memleak on damon_sysfs_add_target

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

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 7488e27c87c3..bdef9682d0a0 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2182,12 +2182,12 @@ static int damon_sysfs_add_target(struct damon_sysfs_target *sys_target,
 
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

