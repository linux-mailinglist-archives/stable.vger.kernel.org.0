Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED23E2596B8
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgIAQGU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:06:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730608AbgIAPlH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:41:07 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61C69206EB;
        Tue,  1 Sep 2020 15:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974866;
        bh=UVzxvQqECI0c3lW/jfDcS64vkLl5fPgJcQN8hVTfuBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FKJ+jRXH1c1Gl8BZ9TYSvhUaiwaM14tLZLMQUKoiGcAAgLlBqPQx1FMJPixxBpbI0
         rqPaHEErOqZfFCOm5VNsP8U13laU7MLf1s7bPFPsBdarQbfbMtBZzXNz07qWWTaw5c
         4V6RIoZq1ULK+DvqoaUaEHqw3umVH8WyB1pu0ZNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 090/255] bfq: fix blkio cgroup leakage v4
Date:   Tue,  1 Sep 2020 17:09:06 +0200
Message-Id: <20200901151005.035966488@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>

[ Upstream commit 2de791ab4918969d8108f15238a701968375f235 ]

Changes from v1:
    - update commit description with proper ref-accounting justification

commit db37a34c563b ("block, bfq: get a ref to a group when adding it to a service tree")
introduce leak forbfq_group and blkcg_gq objects because of get/put
imbalance.
In fact whole idea of original commit is wrong because bfq_group entity
can not dissapear under us because it is referenced by child bfq_queue's
entities from here:
 -> bfq_init_entity()
    ->bfqg_and_blkg_get(bfqg);
    ->entity->parent = bfqg->my_entity

 -> bfq_put_queue(bfqq)
    FINAL_PUT
    ->bfqg_and_blkg_put(bfqq_group(bfqq))
    ->kmem_cache_free(bfq_pool, bfqq);

So parent entity can not disappear while child entity is in tree,
and child entities already has proper protection.
This patch revert commit db37a34c563b ("block, bfq: get a ref to a group when adding it to a service tree")

bfq_group leak trace caused by bad commit:
-> blkg_alloc
   -> bfq_pq_alloc
     -> bfqg_get (+1)
->bfq_activate_bfqq
  ->bfq_activate_requeue_entity
    -> __bfq_activate_entity
       ->bfq_get_entity
         ->bfqg_and_blkg_get (+1)  <==== : Note1
->bfq_del_bfqq_busy
  ->bfq_deactivate_entity+0x53/0xc0 [bfq]
    ->__bfq_deactivate_entity+0x1b8/0x210 [bfq]
      -> bfq_forget_entity(is_in_service = true)
	 entity->on_st_or_in_serv = false   <=== :Note2
	 if (is_in_service)
	     return;  ==> do not touch reference
-> blkcg_css_offline
 -> blkcg_destroy_blkgs
  -> blkg_destroy
   -> bfq_pd_offline
    -> __bfq_deactivate_entity
         if (!entity->on_st_or_in_serv) /* true, because (Note2)
		return false;
 -> bfq_pd_free
    -> bfqg_put() (-1, byt bfqg->ref == 2) because of (Note2)
So bfq_group and blkcg_gq  will leak forever, see test-case below.

##TESTCASE_BEGIN:
#!/bin/bash

max_iters=${1:-100}
#prep cgroup mounts
mount -t tmpfs cgroup_root /sys/fs/cgroup
mkdir /sys/fs/cgroup/blkio
mount -t cgroup -o blkio none /sys/fs/cgroup/blkio

# Prepare blkdev
grep blkio /proc/cgroups
truncate -s 1M img
losetup /dev/loop0 img
echo bfq > /sys/block/loop0/queue/scheduler

grep blkio /proc/cgroups
for ((i=0;i<max_iters;i++))
do
    mkdir -p /sys/fs/cgroup/blkio/a
    echo 0 > /sys/fs/cgroup/blkio/a/cgroup.procs
    dd if=/dev/loop0 bs=4k count=1 of=/dev/null iflag=direct 2> /dev/null
    echo 0 > /sys/fs/cgroup/blkio/cgroup.procs
    rmdir /sys/fs/cgroup/blkio/a
    grep blkio /proc/cgroups
done
##TESTCASE_END:

Fixes: db37a34c563b ("block, bfq: get a ref to a group when adding it to a service tree")
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Signed-off-by: Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-cgroup.c  |  2 +-
 block/bfq-iosched.h |  1 -
 block/bfq-wf2q.c    | 12 ++----------
 3 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 68882b9b8f11f..b791e2041e49b 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -332,7 +332,7 @@ static void bfqg_put(struct bfq_group *bfqg)
 		kfree(bfqg);
 }
 
-void bfqg_and_blkg_get(struct bfq_group *bfqg)
+static void bfqg_and_blkg_get(struct bfq_group *bfqg)
 {
 	/* see comments in bfq_bic_update_cgroup for why refcounting bfqg */
 	bfqg_get(bfqg);
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index cd224aaf9f52a..703895224562c 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -986,7 +986,6 @@ struct bfq_group *bfq_find_set_group(struct bfq_data *bfqd,
 struct blkcg_gq *bfqg_to_blkg(struct bfq_group *bfqg);
 struct bfq_group *bfqq_group(struct bfq_queue *bfqq);
 struct bfq_group *bfq_create_group_hierarchy(struct bfq_data *bfqd, int node);
-void bfqg_and_blkg_get(struct bfq_group *bfqg);
 void bfqg_and_blkg_put(struct bfq_group *bfqg);
 
 #ifdef CONFIG_BFQ_GROUP_IOSCHED
diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
index eb0e2a6daabe6..26776bdbdf360 100644
--- a/block/bfq-wf2q.c
+++ b/block/bfq-wf2q.c
@@ -533,9 +533,7 @@ static void bfq_get_entity(struct bfq_entity *entity)
 		bfqq->ref++;
 		bfq_log_bfqq(bfqq->bfqd, bfqq, "get_entity: %p %d",
 			     bfqq, bfqq->ref);
-	} else
-		bfqg_and_blkg_get(container_of(entity, struct bfq_group,
-					       entity));
+	}
 }
 
 /**
@@ -649,14 +647,8 @@ static void bfq_forget_entity(struct bfq_service_tree *st,
 
 	entity->on_st_or_in_serv = false;
 	st->wsum -= entity->weight;
-	if (is_in_service)
-		return;
-
-	if (bfqq)
+	if (bfqq && !is_in_service)
 		bfq_put_queue(bfqq);
-	else
-		bfqg_and_blkg_put(container_of(entity, struct bfq_group,
-					       entity));
 }
 
 /**
-- 
2.25.1



