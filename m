Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3A01800E2
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 15:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgCJO5U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 10:57:20 -0400
Received: from mail.itouring.de ([188.40.134.68]:51338 "EHLO mail.itouring.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727717AbgCJO5U (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 10:57:20 -0400
Received: from tux.applied-asynchrony.com (p5B07E2B3.dip0.t-ipconnect.de [91.7.226.179])
        by mail.itouring.de (Postfix) with ESMTPSA id D39C94161A07;
        Tue, 10 Mar 2020 15:57:17 +0100 (CET)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
        by tux.applied-asynchrony.com (Postfix) with ESMTP id 96A53F01606;
        Tue, 10 Mar 2020 15:57:17 +0100 (CET)
Subject: Re: [PATCH 5.4 000/168] 5.4.25-stable review
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, linux@roeck-us.net, shuah@kernel.org,
        stable@vger.kernel.org, Paolo Valente <paolo.valente@linaro.org>
References: <20200310123635.322799692@linuxfoundation.org>
 <d97347d3-4eea-f5e1-8a3c-a12410e9ad5f@applied-asynchrony.com>
 <20200310143527.GB3376131@kroah.com>
 <daf30758-fe28-0709-7908-91bb99ee5e39@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <98d45686-66fd-7a0d-dfc0-48d631b3cc04@applied-asynchrony.com>
Date:   Tue, 10 Mar 2020 15:57:17 +0100
MIME-Version: 1.0
In-Reply-To: <daf30758-fe28-0709-7908-91bb99ee5e39@applied-asynchrony.com>
Content-Type: multipart/mixed;
 boundary="------------C83E17AA918EF88B0541897E"
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------C83E17AA918EF88B0541897E
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/10/20 3:51 PM, Holger Hoffstätte wrote:
> On 3/10/20 3:35 PM, Greg Kroah-Hartman wrote:
>> On Tue, Mar 10, 2020 at 03:02:37PM +0100, Holger Hoffstätte wrote:
>>> On 3/10/20 1:37 PM, Greg Kroah-Hartman wrote:
>>>> This is the start of the stable review cycle for the 5.4.25 release.
>>>
>>> This fails to compile due to broken patch 001/168:
>>> "block, bfq: get a ref to a group when adding it to a service tree":
>>>
>>> ..
>>> block/bfq-wf2q.c: In function 'bfq_get_entity':
>>> ./include/linux/kernel.h:994:51: error: 'struct bfq_group' has no member named 'entity'
>>> ..
>>>
>>> The calls to bfq_get_entity::bfqg_and_blkg_get and bfq_forget_entity::bfqg_and_blkg_put
>>> in bfq-wf2q.c need to be wrapped in #ifdef CONFIG_BFQ_GROUP_IOSCHED, otherwise
>>> the build will fail when CONFIG_BFQ_GROUP_IOSCHED is not enabled.
>>> This horribly error-prone #ifdef mess was finally removed in upstream commit
>>> 4d8340d0d4d9. For 5.4 we'll either need that as well or add them back.
>>
>> Ick, that's a mess.
>>
>> I'll go drop that patch now, odd that it passed my build tests...
> 
> Uh, please no? It fixes a rather nasty UAF when cgroups are in use.
> Please just add the other upstream commit as well, I confirmed it applies
> cleanly and fixes the problem.
> 

Alternatively I've appended the version originally sent to the mailing list,
with those #ifdefs intact. That's what I had in my tree so far, you could
consider it a 5.4 backport. Other than that there's no functional difference
to the upstream version.

hth,
Holger

--------------C83E17AA918EF88B0541897E
Content-Type: text/x-patch;
 name="block-20200131-get-a-ref-to-a-group-when-adding-it-to-a-service-tree.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="block-20200131-get-a-ref-to-a-group-when-adding-it-to-a-serv";
 filename*1="ice-tree.patch"

From: Paolo Valente <paolo.valente@linaro.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, bfq-iosched@googlegroups.com,
    oleksandr@natalenko.name, patdung100@gmail.com, cevich@redhat.com, Paolo Valente <paolo.valente@linaro.org>
Subject: [PATCH BUGFIX 5/6] block, bfq: get a ref to a group when adding it to a service tree
Date: Fri, 31 Jan 2020 10:24:08 +0100

BFQ schedules generic entities, which may represent either bfq_queues
or groups of bfq_queues. When an entity is inserted into a service
tree, a reference must be taken, to make sure that the entity does not
disappear while still referred in the tree. Unfortunately, such a
reference is mistakenly taken only if the entity represents a
bfq_queue. This commit takes a reference also in case the entity
represents a group.

Tested-by: Chris Evich <cevich@redhat.com>
Signed-off-by: Paolo Valente <paolo.valente@linaro.org>
---
 block/bfq-cgroup.c  |  2 +-
 block/bfq-iosched.h |  1 +
 block/bfq-wf2q.c    | 16 +++++++++++++++-
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index c818c64766e5..f85b25fd06f2 100644
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
index f1cb89def7f8..b9627ec7007b 100644
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
index 26776bdbdf36..ef06e0d34b5b 100644
--- a/block/bfq-wf2q.c
+++ b/block/bfq-wf2q.c
@@ -533,7 +533,13 @@ static void bfq_get_entity(struct bfq_entity *entity)
 		bfqq->ref++;
 		bfq_log_bfqq(bfqq->bfqd, bfqq, "get_entity: %p %d",
 			     bfqq, bfqq->ref);
+#ifdef CONFIG_BFQ_GROUP_IOSCHED
+	} else
+		bfqg_and_blkg_get(container_of(entity, struct bfq_group,
+					       entity));
+#else
 	}
+#endif
 }
 
 /**
@@ -647,8 +653,16 @@ static void bfq_forget_entity(struct bfq_service_tree *st,
 
 	entity->on_st_or_in_serv = false;
 	st->wsum -= entity->weight;
-	if (bfqq && !is_in_service)
+	if (is_in_service)
+		return;
+
+	if (bfqq)
 		bfq_put_queue(bfqq);
+#ifdef CONFIG_BFQ_GROUP_IOSCHED
+	else
+		bfqg_and_blkg_put(container_of(entity, struct bfq_group,
+					       entity));
+#endif
 }
 
 /**
-- 
2.20.1



--------------C83E17AA918EF88B0541897E--
