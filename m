Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 265FC35BE2B
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238801AbhDLI5Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:57:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:45830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238957AbhDLIzP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:55:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA32C6124C;
        Mon, 12 Apr 2021 08:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217645;
        bh=6iBbWvHhdhlb8UIhzGvGKcukXjPizj1NWq6+8AoL3No=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kCHAEo+L6j0wMg4Zv7zX7qKIcoqfV+oLpaEGXjbF0AcHpJCZO/3GtqrXzwsHlCXtA
         8EhmDqpOViz/DNzJLUo4faN16sdVLKS+Sk5gDVhAGX35amnLIulQmqe98EM91qdVIn
         I0NmQQQUv13fG/FBV3pn3li4/QLc0eYCnyk0NYZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 091/188] net: sched: fix err handler in tcf_action_init()
Date:   Mon, 12 Apr 2021 10:40:05 +0200
Message-Id: <20210412084016.671987663@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

[ Upstream commit b3650bf76a32380d4d80a3e21b5583e7303f216c ]

With recent changes that separated action module load from action
initialization tcf_action_init() function error handling code was modified
to manually release the loaded modules if loading/initialization of any
further action in same batch failed. For the case when all modules
successfully loaded and some of the actions were initialized before one of
them failed in init handler. In this case for all previous actions the
module will be released twice by the error handler: First time by the loop
that manually calls module_put() for all ops, and second time by the action
destroy code that puts the module after destroying the action.

Reproduction:

$ sudo tc actions add action simple sdata \"2\" index 2
$ sudo tc actions add action simple sdata \"1\" index 1 \
                      action simple sdata \"2\" index 2
RTNETLINK answers: File exists
We have an error talking to the kernel
$ sudo tc actions ls action simple
total acts 1

        action order 0: Simple <"2">
         index 2 ref 1 bind 0
$ sudo tc actions flush action simple
$ sudo tc actions ls action simple
$ sudo tc actions add action simple sdata \"2\" index 2
Error: Failed to load TC action module.
We have an error talking to the kernel
$ lsmod | grep simple
act_simple             20480  -1

Fix the issue by modifying module reference counting handling in action
initialization code:

- Get module reference in tcf_idr_create() and put it in tcf_idr_release()
instead of taking over the reference held by the caller.

- Modify users of tcf_action_init_1() to always release the module
reference which they obtain before calling init function instead of
assuming that created action takes over the reference.

- Finally, modify tcf_action_init_1() to not release the module reference
when overwriting existing action as this is no longer necessary since both
upper and lower layers obtain and manage their own module references
independently.

Fixes: d349f9976868 ("net_sched: fix RTNL deadlock again caused by request_module()")
Suggested-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/act_api.h |  7 +------
 net/sched/act_api.c   | 26 ++++++++++++++++----------
 net/sched/cls_api.c   |  5 ++---
 3 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 27786090ae8e..2c88b8af3cdb 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -170,12 +170,7 @@ void tcf_idr_insert_many(struct tc_action *actions[]);
 void tcf_idr_cleanup(struct tc_action_net *tn, u32 index);
 int tcf_idr_check_alloc(struct tc_action_net *tn, u32 *index,
 			struct tc_action **a, int bind);
-int __tcf_idr_release(struct tc_action *a, bool bind, bool strict);
-
-static inline int tcf_idr_release(struct tc_action *a, bool bind)
-{
-	return __tcf_idr_release(a, bind, false);
-}
+int tcf_idr_release(struct tc_action *a, bool bind);
 
 int tcf_register_action(struct tc_action_ops *a, struct pernet_operations *ops);
 int tcf_unregister_action(struct tc_action_ops *a,
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index df1e494574d8..88e14cfeb5d5 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -142,7 +142,7 @@ static int __tcf_action_put(struct tc_action *p, bool bind)
 	return 0;
 }
 
-int __tcf_idr_release(struct tc_action *p, bool bind, bool strict)
+static int __tcf_idr_release(struct tc_action *p, bool bind, bool strict)
 {
 	int ret = 0;
 
@@ -168,7 +168,18 @@ int __tcf_idr_release(struct tc_action *p, bool bind, bool strict)
 
 	return ret;
 }
-EXPORT_SYMBOL(__tcf_idr_release);
+
+int tcf_idr_release(struct tc_action *a, bool bind)
+{
+	const struct tc_action_ops *ops = a->ops;
+	int ret;
+
+	ret = __tcf_idr_release(a, bind, false);
+	if (ret == ACT_P_DELETED)
+		module_put(ops->owner);
+	return ret;
+}
+EXPORT_SYMBOL(tcf_idr_release);
 
 static size_t tcf_action_shared_attrs_size(const struct tc_action *act)
 {
@@ -445,6 +456,7 @@ int tcf_idr_create(struct tc_action_net *tn, u32 index, struct nlattr *est,
 	}
 
 	p->idrinfo = idrinfo;
+	__module_get(ops->owner);
 	p->ops = ops;
 	*a = p;
 	return 0;
@@ -1017,13 +1029,6 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 	if (!name)
 		a->hw_stats = hw_stats;
 
-	/* module count goes up only when brand new policy is created
-	 * if it exists and is only bound to in a_o->init() then
-	 * ACT_P_CREATED is not returned (a zero is).
-	 */
-	if (err != ACT_P_CREATED)
-		module_put(a_o->owner);
-
 	return a;
 
 err_out:
@@ -1083,7 +1088,8 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 	tcf_idr_insert_many(actions);
 
 	*attr_size = tcf_action_full_attrs_size(sz);
-	return i - 1;
+	err = i - 1;
+	goto err_mod;
 
 err:
 	tcf_action_destroy(actions, bind);
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index b45eb7f6cd49..d48ba4dee9a5 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3065,10 +3065,9 @@ int tcf_exts_validate(struct net *net, struct tcf_proto *tp, struct nlattr **tb,
 						rate_tlv, "police", ovr,
 						TCA_ACT_BIND, a_o, init_res,
 						rtnl_held, extack);
-			if (IS_ERR(act)) {
-				module_put(a_o->owner);
+			module_put(a_o->owner);
+			if (IS_ERR(act))
 				return PTR_ERR(act);
-			}
 
 			act->type = exts->type = TCA_OLD_COMPAT;
 			exts->actions[0] = act;
-- 
2.30.2



