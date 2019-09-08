Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 829D1ACE01
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731472AbfIHMt2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:49:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:39420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731431AbfIHMt1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:49:27 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3CD1218AF;
        Sun,  8 Sep 2019 12:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567946967;
        bh=bJ0k3ILoIt5GOaVgDgkaBUsemy5WapQCN3Gaw5S1tgs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h1/eR6f0mA0VdqhLAJJsOSuGUhEPlZ2wuMYXCHiY3ijkF7nVaKTf80CLaxuTTECTs
         M6Nnxm4lGoeLbj5J/4sOHKoqh2sIIxeemcB/3nexl1bnQw0f4m+6RTwTU9kloywsbW
         1s/9beeTpvI1RVt+hzwgnJugeeR6vT7dtwLawqvQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlad Buslov <vladbu@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 03/94] net: sched: act_sample: fix psample group handling on overwrite
Date:   Sun,  8 Sep 2019 13:40:59 +0100
Message-Id: <20190908121150.529366497@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121150.420989666@linuxfoundation.org>
References: <20190908121150.420989666@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

[ Upstream commit dbf47a2a094edf58983265e323ca4bdcdb58b5ee ]

Action sample doesn't properly handle psample_group pointer in overwrite
case. Following issues need to be fixed:

- In tcf_sample_init() function RCU_INIT_POINTER() is used to set
  s->psample_group, even though we neither setting the pointer to NULL, nor
  preventing concurrent readers from accessing the pointer in some way.
  Use rcu_swap_protected() instead to safely reset the pointer.

- Old value of s->psample_group is not released or deallocated in any way,
  which results resource leak. Use psample_group_put() on non-NULL value
  obtained with rcu_swap_protected().

- The function psample_group_put() that released reference to struct
  psample_group pointed by rcu-pointer s->psample_group doesn't respect rcu
  grace period when deallocating it. Extend struct psample_group with rcu
  head and use kfree_rcu when freeing it.

Fixes: 5c5670fae430 ("net/sched: Introduce sample tc action")
Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/psample.h  |    1 +
 net/psample/psample.c  |    2 +-
 net/sched/act_sample.c |    6 +++++-
 3 files changed, 7 insertions(+), 2 deletions(-)

--- a/include/net/psample.h
+++ b/include/net/psample.h
@@ -11,6 +11,7 @@ struct psample_group {
 	u32 group_num;
 	u32 refcount;
 	u32 seq;
+	struct rcu_head rcu;
 };
 
 struct psample_group *psample_group_get(struct net *net, u32 group_num);
--- a/net/psample/psample.c
+++ b/net/psample/psample.c
@@ -154,7 +154,7 @@ static void psample_group_destroy(struct
 {
 	psample_group_notify(group, PSAMPLE_CMD_DEL_GROUP);
 	list_del(&group->list);
-	kfree(group);
+	kfree_rcu(group, rcu);
 }
 
 static struct psample_group *
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -102,13 +102,17 @@ static int tcf_sample_init(struct net *n
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
 	s->rate = rate;
 	s->psample_group_num = psample_group_num;
-	RCU_INIT_POINTER(s->psample_group, psample_group);
+	rcu_swap_protected(s->psample_group, psample_group,
+			   lockdep_is_held(&s->tcf_lock));
 
 	if (tb[TCA_SAMPLE_TRUNC_SIZE]) {
 		s->truncate = true;
 		s->trunc_size = nla_get_u32(tb[TCA_SAMPLE_TRUNC_SIZE]);
 	}
 	spin_unlock_bh(&s->tcf_lock);
+
+	if (psample_group)
+		psample_group_put(psample_group);
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
 


