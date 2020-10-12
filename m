Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8DD328B913
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390613AbgJLN5Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:57:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389350AbgJLNnk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:43:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A3CD2222A;
        Mon, 12 Oct 2020 13:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510203;
        bh=WEB9VMgY/VEEjDjKqWEgNqEwcUNc+sZt4BZ3JpYFK+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iet9zbsPzBsb6xCp5I5Cf3dWQpgmlXandfP12F7taXuJoS9DJ58o850FhWlEnofu7
         E7KF/rLX4hRpwudzRTmoDl1HL8+XxSQiUkIMq+TOvrDCOt28qxioB4S2HBzmIk5nNT
         RsFkvGkkjGr7Xapvzi7NVd45tNtoYDh9L2xYs79E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlad Buslov <vladbu@mellanox.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+2287853d392e4b42374a@syzkaller.appspotmail.com
Subject: [PATCH 5.4 85/85] net_sched: commit action insertions together
Date:   Mon, 12 Oct 2020 15:27:48 +0200
Message-Id: <20201012132636.916549718@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132632.846779148@linuxfoundation.org>
References: <20201012132632.846779148@linuxfoundation.org>
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
@@ -303,6 +303,8 @@ static int tcf_del_walker(struct tcf_idr
 
 	mutex_lock(&idrinfo->lock);
 	idr_for_each_entry_ul(idr, p, tmp, id) {
+		if (IS_ERR(p))
+			continue;
 		ret = tcf_idr_release_unsafe(p);
 		if (ret == ACT_P_DELETED) {
 			module_put(ops->owner);
@@ -828,14 +830,24 @@ static const struct nla_policy tcf_actio
 	[TCA_ACT_OPTIONS]	= { .type = NLA_NESTED },
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
@@ -927,9 +939,6 @@ struct tc_action *tcf_action_init_1(stru
 		return ERR_PTR(-EINVAL);
 	}
 
-	if (err == ACT_P_CREATED)
-		tcf_idr_insert(a);
-
 	if (!name && tb[TCA_ACT_COOKIE])
 		tcf_set_action_cookie(&a->act_cookie, cookie);
 
@@ -983,6 +992,11 @@ int tcf_action_init(struct net *net, str
 		actions[i - 1] = act;
 	}
 
+	/* We have to commit them all together, because if any error happened in
+	 * between, we could not handle the failure gracefully.
+	 */
+	tcf_idr_insert_many(actions);
+
 	*attr_size = tcf_action_full_attrs_size(sz);
 	return i - 1;
 


