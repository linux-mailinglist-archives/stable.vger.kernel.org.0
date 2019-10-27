Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EED5AE674E
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731545AbfJ0VTs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:19:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:40180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731536AbfJ0VTr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:19:47 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1F052070B;
        Sun, 27 Oct 2019 21:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211186;
        bh=bfE3j9WG2MLWzwj/dh+/9ZfvZT9LYRjHBw34pc406Dc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aQXVpK3a8q9cIMNotl34uXNWVUfvwt2zP3r6eCJA34Ygmhh/ny4SvTsO+JU3ZWXDJ
         OYD/wp3gzt8N9hai7BYwYsVDn/3CKHOsIWYtGw1x6/W67WE86zTpyvNgnB/BAnLUra
         ONz55Yl4z74L9bs9QTfNJ35e9NlBbZV8dVkWdaCo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 062/197] net_sched: fix backward compatibility for TCA_KIND
Date:   Sun, 27 Oct 2019 21:59:40 +0100
Message-Id: <20191027203355.012807270@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit 6f96c3c6904c26cea9ca2726d5d8a9b0b8205b3c ]

Marcelo noticed a backward compatibility issue of TCA_KIND
after we move from NLA_STRING to NLA_NUL_STRING, so it is probably
too late to change it.

Instead, to make everyone happy, we can just insert a NUL to
terminate the string with nla_strlcpy() like we do for TC actions.

Fixes: 62794fc4fbf5 ("net_sched: add max len check for TCA_KIND")
Reported-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_api.c | 36 +++++++++++++++++++++++++++++++++---
 net/sched/sch_api.c |  3 +--
 2 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 9aef93300f1c1..6b12883e04b8f 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -160,11 +160,22 @@ static inline u32 tcf_auto_prio(struct tcf_proto *tp)
 	return TC_H_MAJ(first);
 }
 
+static bool tcf_proto_check_kind(struct nlattr *kind, char *name)
+{
+	if (kind)
+		return nla_strlcpy(name, kind, IFNAMSIZ) >= IFNAMSIZ;
+	memset(name, 0, IFNAMSIZ);
+	return false;
+}
+
 static bool tcf_proto_is_unlocked(const char *kind)
 {
 	const struct tcf_proto_ops *ops;
 	bool ret;
 
+	if (strlen(kind) == 0)
+		return false;
+
 	ops = tcf_proto_lookup_ops(kind, false, NULL);
 	/* On error return false to take rtnl lock. Proto lookup/create
 	 * functions will perform lookup again and properly handle errors.
@@ -1976,6 +1987,7 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 {
 	struct net *net = sock_net(skb->sk);
 	struct nlattr *tca[TCA_MAX + 1];
+	char name[IFNAMSIZ];
 	struct tcmsg *t;
 	u32 protocol;
 	u32 prio;
@@ -2032,13 +2044,19 @@ replay:
 	if (err)
 		return err;
 
+	if (tcf_proto_check_kind(tca[TCA_KIND], name)) {
+		NL_SET_ERR_MSG(extack, "Specified TC filter name too long");
+		err = -EINVAL;
+		goto errout;
+	}
+
 	/* Take rtnl mutex if rtnl_held was set to true on previous iteration,
 	 * block is shared (no qdisc found), qdisc is not unlocked, classifier
 	 * type is not specified, classifier is not unlocked.
 	 */
 	if (rtnl_held ||
 	    (q && !(q->ops->cl_ops->flags & QDISC_CLASS_OPS_DOIT_UNLOCKED)) ||
-	    !tca[TCA_KIND] || !tcf_proto_is_unlocked(nla_data(tca[TCA_KIND]))) {
+	    !tcf_proto_is_unlocked(name)) {
 		rtnl_held = true;
 		rtnl_lock();
 	}
@@ -2196,6 +2214,7 @@ static int tc_del_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 {
 	struct net *net = sock_net(skb->sk);
 	struct nlattr *tca[TCA_MAX + 1];
+	char name[IFNAMSIZ];
 	struct tcmsg *t;
 	u32 protocol;
 	u32 prio;
@@ -2235,13 +2254,18 @@ static int tc_del_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 	if (err)
 		return err;
 
+	if (tcf_proto_check_kind(tca[TCA_KIND], name)) {
+		NL_SET_ERR_MSG(extack, "Specified TC filter name too long");
+		err = -EINVAL;
+		goto errout;
+	}
 	/* Take rtnl mutex if flushing whole chain, block is shared (no qdisc
 	 * found), qdisc is not unlocked, classifier type is not specified,
 	 * classifier is not unlocked.
 	 */
 	if (!prio ||
 	    (q && !(q->ops->cl_ops->flags & QDISC_CLASS_OPS_DOIT_UNLOCKED)) ||
-	    !tca[TCA_KIND] || !tcf_proto_is_unlocked(nla_data(tca[TCA_KIND]))) {
+	    !tcf_proto_is_unlocked(name)) {
 		rtnl_held = true;
 		rtnl_lock();
 	}
@@ -2349,6 +2373,7 @@ static int tc_get_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 {
 	struct net *net = sock_net(skb->sk);
 	struct nlattr *tca[TCA_MAX + 1];
+	char name[IFNAMSIZ];
 	struct tcmsg *t;
 	u32 protocol;
 	u32 prio;
@@ -2385,12 +2410,17 @@ static int tc_get_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 	if (err)
 		return err;
 
+	if (tcf_proto_check_kind(tca[TCA_KIND], name)) {
+		NL_SET_ERR_MSG(extack, "Specified TC filter name too long");
+		err = -EINVAL;
+		goto errout;
+	}
 	/* Take rtnl mutex if block is shared (no qdisc found), qdisc is not
 	 * unlocked, classifier type is not specified, classifier is not
 	 * unlocked.
 	 */
 	if ((q && !(q->ops->cl_ops->flags & QDISC_CLASS_OPS_DOIT_UNLOCKED)) ||
-	    !tca[TCA_KIND] || !tcf_proto_is_unlocked(nla_data(tca[TCA_KIND]))) {
+	    !tcf_proto_is_unlocked(name)) {
 		rtnl_held = true;
 		rtnl_lock();
 	}
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 81d58b2806122..1047825d9f48d 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1390,8 +1390,7 @@ check_loop_fn(struct Qdisc *q, unsigned long cl, struct qdisc_walker *w)
 }
 
 const struct nla_policy rtm_tca_policy[TCA_MAX + 1] = {
-	[TCA_KIND]		= { .type = NLA_NUL_STRING,
-				    .len = IFNAMSIZ - 1 },
+	[TCA_KIND]		= { .type = NLA_STRING },
 	[TCA_RATE]		= { .type = NLA_BINARY,
 				    .len = sizeof(struct tc_estimator) },
 	[TCA_STAB]		= { .type = NLA_NESTED },
-- 
2.20.1



