Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC9E35BFBB
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238919AbhDLJGc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:06:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237952AbhDLJED (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:04:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D0BB61390;
        Mon, 12 Apr 2021 09:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218093;
        bh=tRnoM6v1ktSdSVmxxgb634LYj0fuI87XQ1TtfCH3Bm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zJXlb1DT98WHYr/q0W58K4W397XLsy8UV59V3lMVsEmkbejko28Ii/6HCJWoHl0Y5
         LCoicnUGaG68CTmXZjANCOLJ/a9gcFOCklMee557lXMgvMS8w4wMiETQ//xUZfoUIp
         dZ1ch2yFUi6ieT/+ghOnrAF7AXcFJPfb8l35UHRQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.11 069/210] net: sched: fix action overwrite reference counting
Date:   Mon, 12 Apr 2021 10:39:34 +0200
Message-Id: <20210412084018.312272085@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

commit 87c750e8c38bce706eb32e4d8f1e3402f2cebbd4 upstream.

Action init code increments reference counter when it changes an action.
This is the desired behavior for cls API which needs to obtain action
reference for every classifier that points to action. However, act API just
needs to change the action and releases the reference before returning.
This sequence breaks when the requested action doesn't exist, which causes
act API init code to create new action with specified index, but action is
still released before returning and is deleted (unless it was referenced
concurrently by cls API).

Reproduction:

$ sudo tc actions ls action gact
$ sudo tc actions change action gact drop index 1
$ sudo tc actions ls action gact

Extend tcf_action_init() to accept 'init_res' array and initialize it with
action->ops->init() result. In tcf_action_add() remove pointers to created
actions from actions array before passing it to tcf_action_put_many().

Fixes: cae422f379f3 ("net: sched: use reference counting action init")
Reported-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/act_api.h |    5 +++--
 net/sched/act_api.c   |   22 +++++++++++++++-------
 net/sched/cls_api.c   |    9 +++++----
 3 files changed, 23 insertions(+), 13 deletions(-)

--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -185,7 +185,7 @@ int tcf_action_exec(struct sk_buff *skb,
 		    int nr_actions, struct tcf_result *res);
 int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 		    struct nlattr *est, char *name, int ovr, int bind,
-		    struct tc_action *actions[], size_t *attr_size,
+		    struct tc_action *actions[], int init_res[], size_t *attr_size,
 		    bool rtnl_held, struct netlink_ext_ack *extack);
 struct tc_action_ops *tc_action_load_ops(char *name, struct nlattr *nla,
 					 bool rtnl_held,
@@ -193,7 +193,8 @@ struct tc_action_ops *tc_action_load_ops
 struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 				    struct nlattr *nla, struct nlattr *est,
 				    char *name, int ovr, int bind,
-				    struct tc_action_ops *ops, bool rtnl_held,
+				    struct tc_action_ops *a_o, int *init_res,
+				    bool rtnl_held,
 				    struct netlink_ext_ack *extack);
 int tcf_action_dump(struct sk_buff *skb, struct tc_action *actions[], int bind,
 		    int ref, bool terse);
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -992,7 +992,8 @@ struct tc_action_ops *tc_action_load_ops
 struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 				    struct nlattr *nla, struct nlattr *est,
 				    char *name, int ovr, int bind,
-				    struct tc_action_ops *a_o, bool rtnl_held,
+				    struct tc_action_ops *a_o, int *init_res,
+				    bool rtnl_held,
 				    struct netlink_ext_ack *extack)
 {
 	struct nla_bitfield32 flags = { 0, 0 };
@@ -1028,6 +1029,7 @@ struct tc_action *tcf_action_init_1(stru
 	}
 	if (err < 0)
 		goto err_out;
+	*init_res = err;
 
 	if (!name && tb[TCA_ACT_COOKIE])
 		tcf_set_action_cookie(&a->act_cookie, cookie);
@@ -1056,7 +1058,7 @@ err_out:
 
 int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 		    struct nlattr *est, char *name, int ovr, int bind,
-		    struct tc_action *actions[], size_t *attr_size,
+		    struct tc_action *actions[], int init_res[], size_t *attr_size,
 		    bool rtnl_held, struct netlink_ext_ack *extack)
 {
 	struct tc_action_ops *ops[TCA_ACT_MAX_PRIO] = {};
@@ -1084,7 +1086,8 @@ int tcf_action_init(struct net *net, str
 
 	for (i = 1; i <= TCA_ACT_MAX_PRIO && tb[i]; i++) {
 		act = tcf_action_init_1(net, tp, tb[i], est, name, ovr, bind,
-					ops[i - 1], rtnl_held, extack);
+					ops[i - 1], &init_res[i - 1], rtnl_held,
+					extack);
 		if (IS_ERR(act)) {
 			err = PTR_ERR(act);
 			goto err;
@@ -1497,12 +1500,13 @@ static int tcf_action_add(struct net *ne
 			  struct netlink_ext_ack *extack)
 {
 	size_t attr_size = 0;
-	int loop, ret;
+	int loop, ret, i;
 	struct tc_action *actions[TCA_ACT_MAX_PRIO] = {};
+	int init_res[TCA_ACT_MAX_PRIO] = {};
 
 	for (loop = 0; loop < 10; loop++) {
 		ret = tcf_action_init(net, NULL, nla, NULL, NULL, ovr, 0,
-				      actions, &attr_size, true, extack);
+				      actions, init_res, &attr_size, true, extack);
 		if (ret != -EAGAIN)
 			break;
 	}
@@ -1510,8 +1514,12 @@ static int tcf_action_add(struct net *ne
 	if (ret < 0)
 		return ret;
 	ret = tcf_add_notify(net, n, actions, portid, attr_size, extack);
-	if (ovr)
-		tcf_action_put_many(actions);
+
+	/* only put existing actions */
+	for (i = 0; i < TCA_ACT_MAX_PRIO; i++)
+		if (init_res[i] == ACT_P_CREATED)
+			actions[i] = NULL;
+	tcf_action_put_many(actions);
 
 	return ret;
 }
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3039,6 +3039,7 @@ int tcf_exts_validate(struct net *net, s
 {
 #ifdef CONFIG_NET_CLS_ACT
 	{
+		int init_res[TCA_ACT_MAX_PRIO] = {};
 		struct tc_action *act;
 		size_t attr_size = 0;
 
@@ -3050,8 +3051,8 @@ int tcf_exts_validate(struct net *net, s
 				return PTR_ERR(a_o);
 			act = tcf_action_init_1(net, tp, tb[exts->police],
 						rate_tlv, "police", ovr,
-						TCA_ACT_BIND, a_o, rtnl_held,
-						extack);
+						TCA_ACT_BIND, a_o, init_res,
+						rtnl_held, extack);
 			if (IS_ERR(act)) {
 				module_put(a_o->owner);
 				return PTR_ERR(act);
@@ -3066,8 +3067,8 @@ int tcf_exts_validate(struct net *net, s
 
 			err = tcf_action_init(net, tp, tb[exts->action],
 					      rate_tlv, NULL, ovr, TCA_ACT_BIND,
-					      exts->actions, &attr_size,
-					      rtnl_held, extack);
+					      exts->actions, init_res,
+					      &attr_size, rtnl_held, extack);
 			if (err < 0)
 				return err;
 			exts->nr_actions = err;


