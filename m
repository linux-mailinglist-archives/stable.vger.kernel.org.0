Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 797121B3F70
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731411AbgDVKhl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:37:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:58616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729971AbgDVKW0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:22:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DA7121582;
        Wed, 22 Apr 2020 10:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550940;
        bh=qwp1kwgWdt0eV95GZl9VFWbIEj3NYzkRBOqFjzHMJ5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ivzU4h+nnKmEkkz8Uf3KSsJTbsN1/Ofa9X9U4g/8cpORVoGafrCGxHEof/rjKiiR7
         x0rTY30k1E9UAL8dEr14LccwKglBMN0CaOi6vi48MbdNYej2UoZMM4CBqruJeuek6Q
         VfVNdc+NzO0yYwLaEQRPtp/JYTcAOSLSaRL/d39o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, cki-project@redhat.com,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.6 037/166] block, bfq: make reparent_leaf_entity actually work only on leaf entities
Date:   Wed, 22 Apr 2020 11:56:04 +0200
Message-Id: <20200422095052.823317575@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Valente <paolo.valente@linaro.org>

commit 576682fa52cbd95deb3773449566274f206acc58 upstream.

bfq_reparent_leaf_entity() reparents the input leaf entity (a leaf
entity represents just a bfq_queue in an entity tree). Yet, the input
entity is guaranteed to always be a leaf entity only in two-level
entity trees. In this respect, because of the error fixed by
commit 14afc5936197 ("block, bfq: fix overwrite of bfq_group pointer
in bfq_find_set_group()"), all (wrongly collapsed) entity trees happened
to actually have only two levels. After the latter commit, this does not
hold any longer.

This commit fixes this problem by modifying
bfq_reparent_leaf_entity(), so that it searches an active leaf entity
down the path that stems from the input entity. Such a leaf entity is
guaranteed to exist when bfq_reparent_leaf_entity() is invoked.

Tested-by: cki-project@redhat.com
Signed-off-by: Paolo Valente <paolo.valente@linaro.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/bfq-cgroup.c |   48 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 17 deletions(-)

--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -815,39 +815,53 @@ static void bfq_flush_idle_tree(struct b
 /**
  * bfq_reparent_leaf_entity - move leaf entity to the root_group.
  * @bfqd: the device data structure with the root group.
- * @entity: the entity to move.
+ * @entity: the entity to move, if entity is a leaf; or the parent entity
+ *	    of an active leaf entity to move, if entity is not a leaf.
  */
 static void bfq_reparent_leaf_entity(struct bfq_data *bfqd,
-				     struct bfq_entity *entity)
+				     struct bfq_entity *entity,
+				     int ioprio_class)
 {
-	struct bfq_queue *bfqq = bfq_entity_to_bfqq(entity);
+	struct bfq_queue *bfqq;
+	struct bfq_entity *child_entity = entity;
 
+	while (child_entity->my_sched_data) { /* leaf not reached yet */
+		struct bfq_sched_data *child_sd = child_entity->my_sched_data;
+		struct bfq_service_tree *child_st = child_sd->service_tree +
+			ioprio_class;
+		struct rb_root *child_active = &child_st->active;
+
+		child_entity = bfq_entity_of(rb_first(child_active));
+
+		if (!child_entity)
+			child_entity = child_sd->in_service_entity;
+	}
+
+	bfqq = bfq_entity_to_bfqq(child_entity);
 	bfq_bfqq_move(bfqd, bfqq, bfqd->root_group);
 }
 
 /**
- * bfq_reparent_active_entities - move to the root group all active
- *                                entities.
+ * bfq_reparent_active_queues - move to the root group all active queues.
  * @bfqd: the device data structure with the root group.
  * @bfqg: the group to move from.
- * @st: the service tree with the entities.
+ * @st: the service tree to start the search from.
  */
-static void bfq_reparent_active_entities(struct bfq_data *bfqd,
-					 struct bfq_group *bfqg,
-					 struct bfq_service_tree *st)
+static void bfq_reparent_active_queues(struct bfq_data *bfqd,
+				       struct bfq_group *bfqg,
+				       struct bfq_service_tree *st,
+				       int ioprio_class)
 {
 	struct rb_root *active = &st->active;
-	struct bfq_entity *entity = NULL;
-
-	if (!RB_EMPTY_ROOT(&st->active))
-		entity = bfq_entity_of(rb_first(active));
+	struct bfq_entity *entity;
 
-	for (; entity ; entity = bfq_entity_of(rb_first(active)))
-		bfq_reparent_leaf_entity(bfqd, entity);
+	while ((entity = bfq_entity_of(rb_first(active))))
+		bfq_reparent_leaf_entity(bfqd, entity, ioprio_class);
 
 	if (bfqg->sched_data.in_service_entity)
 		bfq_reparent_leaf_entity(bfqd,
-			bfqg->sched_data.in_service_entity);
+					 bfqg->sched_data.in_service_entity,
+					 ioprio_class);
 }
 
 /**
@@ -898,7 +912,7 @@ static void bfq_pd_offline(struct blkg_p
 		 * There is no need to put the sync queues, as the
 		 * scheduler has taken no reference.
 		 */
-		bfq_reparent_active_entities(bfqd, bfqg, st);
+		bfq_reparent_active_queues(bfqd, bfqg, st, i);
 	}
 
 	__bfq_deactivate_entity(entity, false);


