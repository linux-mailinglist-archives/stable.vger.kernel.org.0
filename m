Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 381B417FD1C
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729270AbgCJM4W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:56:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:35506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729261AbgCJM4U (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:56:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C68892467D;
        Tue, 10 Mar 2020 12:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844980;
        bh=Oy+lx+C1FH8Pn1YwPuWLa0OFRoIc6I4rO1gKpk1oFWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=na+Rq8+/eyAWggfa7xxue71HNP4iD7822iQDQnOvn2kstjzeCCWan62KQ6bEZ7cOz
         ikjy8zBOTMKuSQQkHBnb3RWqgNxcZbG/1v3M9qIVoi0CCvhXgITXrlSAm8E9PoAxOK
         fSq8DzxJMb+ruA5tkhlG30j3ChPMRTbMnRVJ2UYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Chris Evich <cevich@redhat.com>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 002/189] block, bfq: get a ref to a group when adding it to a service tree
Date:   Tue, 10 Mar 2020 13:37:19 +0100
Message-Id: <20200310123639.841517948@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Valente <paolo.valente@linaro.org>

[ Upstream commit db37a34c563bf4692b36990ae89005c031385e52 ]

BFQ schedules generic entities, which may represent either bfq_queues
or groups of bfq_queues. When an entity is inserted into a service
tree, a reference must be taken, to make sure that the entity does not
disappear while still referred in the tree. Unfortunately, such a
reference is mistakenly taken only if the entity represents a
bfq_queue. This commit takes a reference also in case the entity
represents a group.

Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Tested-by: Chris Evich <cevich@redhat.com>
Signed-off-by: Paolo Valente <paolo.valente@linaro.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-cgroup.c  |  2 +-
 block/bfq-iosched.h |  1 +
 block/bfq-wf2q.c    | 12 ++++++++++--
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index e1419edde2ec5..e7919e76a27c2 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -332,7 +332,7 @@ static void bfqg_put(struct bfq_group *bfqg)
 		kfree(bfqg);
 }
 
-static void bfqg_and_blkg_get(struct bfq_group *bfqg)
+void bfqg_and_blkg_get(struct bfq_group *bfqg)
 {
 	/* see comments in bfq_bic_update_cgroup for why refcounting bfqg */
 	bfqg_get(bfqg);
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index 8526f20c53bc1..144bc544be568 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -984,6 +984,7 @@ struct bfq_group *bfq_find_set_group(struct bfq_data *bfqd,
 struct blkcg_gq *bfqg_to_blkg(struct bfq_group *bfqg);
 struct bfq_group *bfqq_group(struct bfq_queue *bfqq);
 struct bfq_group *bfq_create_group_hierarchy(struct bfq_data *bfqd, int node);
+void bfqg_and_blkg_get(struct bfq_group *bfqg);
 void bfqg_and_blkg_put(struct bfq_group *bfqg);
 
 #ifdef CONFIG_BFQ_GROUP_IOSCHED
diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
index 05f0bf4a1144d..44079147e396e 100644
--- a/block/bfq-wf2q.c
+++ b/block/bfq-wf2q.c
@@ -536,7 +536,9 @@ static void bfq_get_entity(struct bfq_entity *entity)
 		bfqq->ref++;
 		bfq_log_bfqq(bfqq->bfqd, bfqq, "get_entity: %p %d",
 			     bfqq, bfqq->ref);
-	}
+	} else
+		bfqg_and_blkg_get(container_of(entity, struct bfq_group,
+					       entity));
 }
 
 /**
@@ -650,8 +652,14 @@ static void bfq_forget_entity(struct bfq_service_tree *st,
 
 	entity->on_st = false;
 	st->wsum -= entity->weight;
-	if (bfqq && !is_in_service)
+	if (is_in_service)
+		return;
+
+	if (bfqq)
 		bfq_put_queue(bfqq);
+	else
+		bfqg_and_blkg_put(container_of(entity, struct bfq_group,
+					       entity));
 }
 
 /**
-- 
2.20.1



