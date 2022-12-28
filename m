Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 130726576CB
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 14:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbiL1NKx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 08:10:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiL1NKw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 08:10:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C223110555
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 05:10:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16846B81643
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 13:10:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6910EC433D2;
        Wed, 28 Dec 2022 13:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672233048;
        bh=+4pY87WhmFWFUtc6kFPeM1r1iJd5p5FPs8jOLu8TqdU=;
        h=Subject:To:Cc:From:Date:From;
        b=rakvpHbHpzfWlRr0vW5e2G8wireTYFxUY4VHjpVHUmEXVq8bZY7qJm/sq22/xqx7a
         Vw3dRCA49UueNX4K949bzKmpRXR2mZ40GDl/Q8s8hZg1blDDCM+iA3M3XWfMtePSm2
         OvNF/p6MjUB+1Tmdjo219UxJxaejIb9tcYELmXGw=
Subject: FAILED: patch "[PATCH] blk-iolatency: Fix memory leak on add_disk() failures" failed to apply to 6.0-stable tree
To:     tj@kernel.org, axboe@kernel.dk, hch@lst.de, josef@toxicpanda.com,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 28 Dec 2022 14:10:45 +0100
Message-ID: <167223304524257@kroah.com>
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


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

813e693023ba ("blk-iolatency: Fix memory leak on add_disk() failures")
00ad6991bbae ("blk-cgroup: pass a gendisk to blkg_destroy_all")
e13793bae659 ("blk-throttle: pass a gendisk to blk_throtl_init and blk_throtl_exit")
9823538fb7ef ("blk-cgroup: pass a gendisk to blkcg_init_queue and blkcg_exit_queue")
4a69f325aa43 ("blk-cgroup: cleanup the blkg_lookup family of functions")
928f6f00a91e ("blk-cgroup: remove blk_queue_root_blkg")
33dc62796cb6 ("blk-cgroup: fix error unwinding in blkcg_init_queue")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 813e693023ba10da9e75067780f8378465bf27cc Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Sat, 10 Dec 2022 08:33:10 -1000
Subject: [PATCH] blk-iolatency: Fix memory leak on add_disk() failures

When a gendisk is successfully initialized but add_disk() fails such as when
a loop device has invalid number of minor device numbers specified,
blkcg_init_disk() is called during init and then blkcg_exit_disk() during
error handling. Unfortunately, iolatency gets initialized in the former but
doesn't get cleaned up in the latter.

This is because, in non-error cases, the cleanup is performed by
del_gendisk() calling rq_qos_exit(), the assumption being that rq_qos
policies, iolatency being one of them, can only be activated once the disk
is fully registered and visible. That assumption is true for wbt and iocost,
but not so for iolatency as it gets initialized before add_disk() is called.

It is desirable to lazy-init rq_qos policies because they are optional
features and add to hot path overhead once initialized - each IO has to walk
all the registered rq_qos policies. So, we want to switch iolatency to lazy
init too. However, that's a bigger change. As a fix for the immediate
problem, let's just add an extra call to rq_qos_exit() in blkcg_exit_disk().
This is safe because duplicate calls to rq_qos_exit() become noop's.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: darklight2357@icloud.com
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Fixes: d70675121546 ("block: introduce blk-iolatency io controller")
Cc: stable@vger.kernel.org # v4.19+
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/Y5TQ5gm3O4HXrXR3@slm.duckdns.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 50ac0dce95b8..ce6a2b7d3dfb 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -33,6 +33,7 @@
 #include "blk-cgroup.h"
 #include "blk-ioprio.h"
 #include "blk-throttle.h"
+#include "blk-rq-qos.h"
 
 /*
  * blkcg_pol_mutex protects blkcg_policy[] and policy [de]activation.
@@ -1322,6 +1323,7 @@ int blkcg_init_disk(struct gendisk *disk)
 void blkcg_exit_disk(struct gendisk *disk)
 {
 	blkg_destroy_all(disk);
+	rq_qos_exit(disk->queue);
 	blk_throtl_exit(disk);
 }
 

