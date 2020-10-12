Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F131728B806
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389418AbgJLNsu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:48:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731994AbgJLNsc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:48:32 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38D34206D9;
        Mon, 12 Oct 2020 13:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510511;
        bh=YSsYICUfP4/I9lYXIaaa1C27+E6Yrl01Yk2dNT5Dgsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eg5uOFu84jSo0UH/defQZmE6eHcoN746Yb4Br5Woqb4VXzGBdaMx6EJgZqbtL+KX8
         robXm/gSZQ7O1JzcCqpAvQ3FuiVWjss/K2uCd5YQ6uBMzjutwQuEt9gcWknYO9r0uT
         MhbDy4JQahczMbE+B2+pWuyr4o0CzUYQYhSWmaE4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlad Buslov <vladbu@mellanox.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+2287853d392e4b42374a@syzkaller.appspotmail.com
Subject: [PATCH 5.8 124/124] net_sched: commit action insertions together
Date:   Mon, 12 Oct 2020 15:32:08 +0200
Message-Id: <20201012133152.858233775@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

commit 0fedc63fadf0404a729e73a35349481c8009c02f upstream.

syzbot is able to trigger a failure case inside the loop in
tcf_action_init(), and when this happens we clean up with
tcf_action_destroy(). But, as these actions are already inserted
into the global IDR, other parallel process could free them
before tcf_action_destroy(), then we will trigger a use-after-free.

Fix this by deferring the insertions even later, after the loop,
and committing all the insertions in a separate loop, so we will
never fail in the middle of the insertions any more.

One side effect is that the window between alloction and final
insertion becomes larger, now it is more likely that the loop in
tcf_del_walker() sees the placeholder -EBUSY pointer. So we have
to check for error pointer in tcf_del_walker().

Reported-and-tested-by: syzbot+2287853d392e4b42374a@syzkaller.appspotmail.com
Fixes: 0190c1d452a9 ("net: sched: atomically check-allocate action")
Cc: Vlad Buslov <vladbu@mellanox.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sched/act_api.c |   32 +++++++++++++++++++++++---------
 1 file changed, 23 insertions(+), 9 deletions(-)

--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -307,6 +307,8 @@ static int tcf_del_walker(struct tcf_idr
 
 	mutex_lock(&idrinfo->lock);
 	idr_for_each_entry_ul(idr, p, tmp, id) {
+		if (IS_ERR(p))
+			continue;
 		ret = tcf_idr_release_unsafe(p);
 		if (ret == ACT_P_DELETED) {
 			module_put(ops->owner);
@@ -891,14 +893,24 @@ static const struct nla_policy tcf_actio
 	[TCA_ACT_HW_STATS]	= NLA_POLICY_BITFIELD32(TCA_ACT_HW_STATS_ANY),
 };
 
-static void tcf_idr_insert(struct tc_action *a)
+static void tcf_idr_insert_many(struct tc_action *actions[])
 {
-	struct tcf_idrinfo *idrinfo = a->idrinfo;
+	int i;
 
-	mutex_lock(&idrinfo->lock);
-	/* Replace ERR_PTR(-EBUSY) allocated by tcf_idr_check_alloc */
-	WARN_ON(!IS_ERR(idr_replace(&idrinfo->action_idr, a, a->tcfa_index)));
-	mutex_unlock(&idrinfo->lock);
+	for (i = 0; i < TCA_ACT_MAX_PRIO; i++) {
+		struct tc_action *a = actions[i];
+		struct tcf_idrinfo *idrinfo;
+
+		if (!a)
+			continue;
+		idrinfo = a->idrinfo;
+		mutex_lock(&idrinfo->lock);
+		/* Replace ERR_PTR(-EBUSY) allocated by tcf_idr_check_alloc if
+		 * it is just created, otherwise this is just a nop.
+		 */
+		idr_replace(&idrinfo->action_idr, a, a->tcfa_index);
+		mutex_unlock(&idrinfo->lock);
+	}
 }
 
 struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
@@ -995,9 +1007,6 @@ struct tc_action *tcf_action_init_1(stru
 		return ERR_PTR(-EINVAL);
 	}
 
-	if (err == ACT_P_CREATED)
-		tcf_idr_insert(a);
-
 	if (!name && tb[TCA_ACT_COOKIE])
 		tcf_set_action_cookie(&a->act_cookie, cookie);
 
@@ -1053,6 +1062,11 @@ int tcf_action_init(struct net *net, str
 		actions[i - 1] = act;
 	}
 
+	/* We have to commit them all together, because if any error happened in
+	 * between, we could not handle the failure gracefully.
+	 */
+	tcf_idr_insert_many(actions);
+
 	*attr_size = tcf_action_full_attrs_size(sz);
 	return i - 1;
 


