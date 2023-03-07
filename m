Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 107AB6AF0E2
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbjCGSgn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:36:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232858AbjCGSfB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:35:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F610B8637
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:27:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 372CB61537
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:25:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43955C433D2;
        Tue,  7 Mar 2023 18:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213551;
        bh=rzg7BVZ1+2ddEgchxYHTuhivV8y45kBXO6IVvQs2qaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Styfg59tQXESTOCnRQyLO/bKjwQ+f8ViQ7uvtvzZiVqk+QSa+yue0xW+VRc8ydUQH
         oN/xBUdKVAbXGgJ+Y4Yy2joskFTTruJkCsZUJukHqfHFdgaSYPv73WqgV71BeluP/r
         2O/qjiPKj4MYKmNB/GChmGAGFm4uO2gbK+7I+opQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yu Kuai <yukuai3@huawei.com>,
        Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 535/885] blk-cgroup: dropping parent refcount after pd_free_fn() is done
Date:   Tue,  7 Mar 2023 17:57:49 +0100
Message-Id: <20230307170025.731691648@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
index 7c91d9195da8d..8d1b7757f1e4f 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -93,6 +93,8 @@ static void blkg_free_workfn(struct work_struct *work)
 		if (blkg->pd[i])
 			blkcg_policy[i]->pd_free_fn(blkg->pd[i]);
 
+	if (blkg->parent)
+		blkg_put(blkg->parent);
 	if (blkg->q)
 		blk_put_queue(blkg->q);
 	free_percpu(blkg->iostat_cpu);
@@ -127,8 +129,6 @@ static void __blkg_release(struct rcu_head *rcu)
 
 	/* release the blkcg and parent blkg refs this blkg has been holding */
 	css_put(&blkg->blkcg->css);
-	if (blkg->parent)
-		blkg_put(blkg->parent);
 	blkg_free(blkg);
 }
 
-- 
2.39.2



