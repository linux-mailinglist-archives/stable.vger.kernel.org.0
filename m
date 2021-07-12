Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7EB3C5369
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352391AbhGLHyn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:54:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350312AbhGLHuu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:50:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C06B1619B9;
        Mon, 12 Jul 2021 07:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075864;
        bh=4dzgCyh8BYXAmzhq/UXO6qhbFFREt8XwUHGT9V8zmVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qHg3jPbTv1caFLCxOk4GpyhvBNgVxyYonxcTrVV5lrKlCZeTgaOtyXO5b0aCMHAIC
         bYF1LQw6V/bUDuDDvSAUqUByeHupFi6Ock2HY56a48YP+3tvtnaAtbLQlIAiR5LmYo
         Hdex2ZtQB5s2Z8gX981xQKXlmzlH/0av29b8FmfY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        Cong Wang <cong.wang@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+7d941e89dd48bcf42573@syzkaller.appspotmail.com
Subject: [PATCH 5.13 398/800] rtnetlink: avoid RCU read lock when holding RTNL
Date:   Mon, 12 Jul 2021 08:07:01 +0200
Message-Id: <20210712061009.507557079@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

[ Upstream commit a100243d95a60d74ae9bb9df1f5f2192e9aed6a7 ]

When we call af_ops->set_link_af() we hold a RCU read lock
as we retrieve af_ops from the RCU protected list, but this
is unnecessary because we already hold RTNL lock, which is
the writer lock for protecting rtnl_af_ops, so it is safer
than RCU read lock. Similar for af_ops->validate_link_af().

This was not a problem until we begin to take mutex lock
down the path of ->set_link_af() in __ipv6_dev_mc_dec()
recently. We can just drop the RCU read lock there and
assert RTNL lock.

Reported-and-tested-by: syzbot+7d941e89dd48bcf42573@syzkaller.appspotmail.com
Fixes: 63ed8de4be81 ("mld: add mc_lock for protecting per-interface mld data")
Tested-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/rtnetlink.c | 26 +++++++-------------------
 net/ipv4/devinet.c   |  4 ++--
 2 files changed, 9 insertions(+), 21 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index ec931b080156..c6e75bd0035d 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -543,7 +543,9 @@ static const struct rtnl_af_ops *rtnl_af_lookup(const int family)
 {
 	const struct rtnl_af_ops *ops;
 
-	list_for_each_entry_rcu(ops, &rtnl_af_ops, list) {
+	ASSERT_RTNL();
+
+	list_for_each_entry(ops, &rtnl_af_ops, list) {
 		if (ops->family == family)
 			return ops;
 	}
@@ -2274,27 +2276,18 @@ static int validate_linkmsg(struct net_device *dev, struct nlattr *tb[])
 		nla_for_each_nested(af, tb[IFLA_AF_SPEC], rem) {
 			const struct rtnl_af_ops *af_ops;
 
-			rcu_read_lock();
 			af_ops = rtnl_af_lookup(nla_type(af));
-			if (!af_ops) {
-				rcu_read_unlock();
+			if (!af_ops)
 				return -EAFNOSUPPORT;
-			}
 
-			if (!af_ops->set_link_af) {
-				rcu_read_unlock();
+			if (!af_ops->set_link_af)
 				return -EOPNOTSUPP;
-			}
 
 			if (af_ops->validate_link_af) {
 				err = af_ops->validate_link_af(dev, af);
-				if (err < 0) {
-					rcu_read_unlock();
+				if (err < 0)
 					return err;
-				}
 			}
-
-			rcu_read_unlock();
 		}
 	}
 
@@ -2868,17 +2861,12 @@ static int do_setlink(const struct sk_buff *skb,
 		nla_for_each_nested(af, tb[IFLA_AF_SPEC], rem) {
 			const struct rtnl_af_ops *af_ops;
 
-			rcu_read_lock();
-
 			BUG_ON(!(af_ops = rtnl_af_lookup(nla_type(af))));
 
 			err = af_ops->set_link_af(dev, af, extack);
-			if (err < 0) {
-				rcu_read_unlock();
+			if (err < 0)
 				goto errout;
-			}
 
-			rcu_read_unlock();
 			status |= DO_SETLINK_NOTIFY;
 		}
 	}
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 1c6429c353a9..73721a4448bd 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1955,7 +1955,7 @@ static int inet_validate_link_af(const struct net_device *dev,
 	struct nlattr *a, *tb[IFLA_INET_MAX+1];
 	int err, rem;
 
-	if (dev && !__in_dev_get_rcu(dev))
+	if (dev && !__in_dev_get_rtnl(dev))
 		return -EAFNOSUPPORT;
 
 	err = nla_parse_nested_deprecated(tb, IFLA_INET_MAX, nla,
@@ -1981,7 +1981,7 @@ static int inet_validate_link_af(const struct net_device *dev,
 static int inet_set_link_af(struct net_device *dev, const struct nlattr *nla,
 			    struct netlink_ext_ack *extack)
 {
-	struct in_device *in_dev = __in_dev_get_rcu(dev);
+	struct in_device *in_dev = __in_dev_get_rtnl(dev);
 	struct nlattr *a, *tb[IFLA_INET_MAX+1];
 	int rem;
 
-- 
2.30.2



