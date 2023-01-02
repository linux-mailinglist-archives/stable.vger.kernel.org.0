Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBD965B0EF
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:29:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236092AbjABL3d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:29:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236079AbjABL3B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 06:29:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A65964E9
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 03:28:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D39ABB80D1A
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 11:28:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44753C433EF;
        Mon,  2 Jan 2023 11:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672658893;
        bh=tMJAIonPVg31dWyinuJ+fAMNiUIzYDiOZiuP5WFhTJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j5+Y792egWOGUSU1GfrIVV5SmwPJ012Fh9HUvUjZbSbyqwl+vzONPpkKsjYFq7uDo
         neKmLza9W0UBAG3m48xJWKC86OgG+LZMk9iZzCA2yuEyXMDafvd0wI9jq8hqJvG89R
         dXLDBF8w696cfJ7vXs9C+r+MoXB3LJXpexXdzrOQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tejun Heo <tj@kernel.org>,
        darklight2357@icloud.com, Josef Bacik <josef@toxicpanda.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 09/74] blk-iolatency: Fix memory leak on add_disk() failures
Date:   Mon,  2 Jan 2023 12:21:42 +0100
Message-Id: <20230102110552.435540001@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
References: <20230102110552.061937047@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 813e693023ba10da9e75067780f8378465bf27cc ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index cd682fe46d2f..ee517fb06aa6 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -33,6 +33,7 @@
 #include "blk-cgroup.h"
 #include "blk-ioprio.h"
 #include "blk-throttle.h"
+#include "blk-rq-qos.h"
 
 /*
  * blkcg_pol_mutex protects blkcg_policy[] and policy [de]activation.
@@ -1299,6 +1300,7 @@ int blkcg_init_disk(struct gendisk *disk)
 void blkcg_exit_disk(struct gendisk *disk)
 {
 	blkg_destroy_all(disk);
+	rq_qos_exit(disk->queue);
 	blk_throtl_exit(disk);
 }
 
-- 
2.35.1



