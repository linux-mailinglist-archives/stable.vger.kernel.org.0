Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5357D6A2D63
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 04:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbjBZDmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Feb 2023 22:42:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjBZDmZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Feb 2023 22:42:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF251499E;
        Sat, 25 Feb 2023 19:42:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8E74B80956;
        Sun, 26 Feb 2023 03:42:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 949EBC433EF;
        Sun, 26 Feb 2023 03:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677382928;
        bh=wIxrbEEwnFfaJvMynzycEda876cjmIna9fqqyIIB3hI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jWlxQ45u1g51Jrr8QbNvRCV9WXuN11ITpZSl5PaEQ7nX6042uaCOWdUno4+0oHccv
         bbv1urv9eHDEstD9W6CeU74JJauBTEhNUa7AEOjjk5OLOoPCM3CXopTi0iIJ51bBYZ
         mBPVzKHQPuslrWtSSTMzrfuYQ9LVRK2pDTOrxclRNZ5niiGnzEvVRUafW/MhugzuCL
         D+q4ElFH2Yccyh6tUSBr8pPUl9ZzSAfafnBX47EHHH7q1fkksxRPlQ7UasoFGNIft1
         J8MeBgTFJF7tgl1HQiVCv1CAx9ntrqfqK2NByh6KqKMiP4rQI8aMCwJRs3bfX/Lh7q
         EzyDWn5NB5z9Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yu Kuai <yukuai3@huawei.com>, Tejun Heo <tj@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, josef@toxicpanda.com,
        cgroups@vger.kernel.org, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 09/21] blk-cgroup: dropping parent refcount after pd_free_fn() is done
Date:   Sat, 25 Feb 2023 22:41:38 -0500
Message-Id: <20230226034150.771411-9-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226034150.771411-1-sashal@kernel.org>
References: <20230226034150.771411-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit c7241babf0855d8a6180cd1743ff0ec34de40b4e ]

Some cgroup policies will access parent pd through child pd even
after pd_offline_fn() is done. If pd_free_fn() for parent is called
before child, then UAF can be triggered. Hence it's better to guarantee
the order of pd_free_fn().

Currently refcount of parent blkg is dropped in __blkg_release(), which
is before pd_free_fn() is called in blkg_free_work_fn() while
blkg_free_work_fn() is called asynchronously.

This patch make sure pd_free_fn() called from removing cgroup is ordered
by delaying dropping parent refcount after calling pd_free_fn() for
child.

BTW, pd_free_fn() will also be called from blkcg_deactivate_policy()
from deleting device, and following patches will guarantee the order.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20230119110350.2287325-2-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 9ac1efb053e08..aa890e3e4e509 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -124,6 +124,8 @@ static void blkg_free_workfn(struct work_struct *work)
 		if (blkg->pd[i])
 			blkcg_policy[i]->pd_free_fn(blkg->pd[i]);
 
+	if (blkg->parent)
+		blkg_put(blkg->parent);
 	if (blkg->q)
 		blk_put_queue(blkg->q);
 	free_percpu(blkg->iostat_cpu);
@@ -158,8 +160,6 @@ static void __blkg_release(struct rcu_head *rcu)
 
 	/* release the blkcg and parent blkg refs this blkg has been holding */
 	css_put(&blkg->blkcg->css);
-	if (blkg->parent)
-		blkg_put(blkg->parent);
 	blkg_free(blkg);
 }
 
-- 
2.39.0

