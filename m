Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6753546FEF6
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 11:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238808AbhLJKvX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 05:51:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233090AbhLJKvX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 05:51:23 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D5BDC0617A1
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 02:47:48 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id v11so14168641wrw.10
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 02:47:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tEwwiECBVqL9MjyYGpBFXOXyDU9zb93VSUQWPEXbnfc=;
        b=ZpCb123FKtEXlcNjcJubTiGCAWFoS2XzHAsTdTuYfLZD3b66IBSfsayK/LpvieGqG+
         2KwU2si6c4lkVWWocUH/Z+W6tloNJBA9hmMORaNQ7WvcJyqKzcPh7topnzxSiB9V2PEJ
         0fPgnzsMetvY+kxEGo52QzKbtNMTy9JVNUyReD8Hy6SZPt2gBBd2CdFq+m7GA8TDS8sc
         H0O7EaGGtLrkeCAlxfsDU4Tc2EEjs42LQVGCys/wkCmBQBibBngeFDxqcZSR2gU2Dp8j
         aWSaIPU4WFJAc+aTJkaecO1ujH2jITW/mf8tRsIjWIgx542f12nlIrLrIVyqi8volRjJ
         tOkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tEwwiECBVqL9MjyYGpBFXOXyDU9zb93VSUQWPEXbnfc=;
        b=ziJjbHRx9Ry5iJerZqt5tdLpOmVIxZ1AStyTSo1Oct7/wDNPh8tg5kKZVCT3gYk7oi
         mXXCcAbp6bOpCWdWmHkt0LvtEvKzlOEX/YRoaX086wr9bcrogsZJL9K78M7+EEuZh9kk
         erF/WL4kWKT/apfwXwwEg7qTXQgnIabQOp3GweOim2ve3CYlNN8ZSVYs5Qu7/wFSG7Ct
         nwrzXqZqX9pw1RBzTkLHVcFz+I9aPhh2fMuC8d3YhlPuZ3SJdN6Y/al1nejRS1CkOfax
         z0nFIPUW6ZMvWxM8H65wUN4QQIhZup+vypK3lm+DGfuClHEkTFl/q7yVP/oCL3b4ez2k
         0wPw==
X-Gm-Message-State: AOAM532hCG/GhTD98bo76gRfrvwU5Hc8crqEKgAiEBXqaLPeE3hjEeyE
        jVmdlMs9WkoAlzV2lmjkJ/6r97mdZUs5sw==
X-Google-Smtp-Source: ABdhPJyZ+jciHBqah+Y9PduEiLYZhXqedDCrs7VfhHAtAHDlC/6SqBChWxS5dtHo8YVHIs6k6OSwdQ==
X-Received: by 2002:adf:df89:: with SMTP id z9mr12977990wrl.336.1639133267170;
        Fri, 10 Dec 2021 02:47:47 -0800 (PST)
Received: from localhost.localdomain ([2.31.167.18])
        by smtp.gmail.com with ESMTPSA id m3sm2159507wrv.95.2021.12.10.02.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 02:47:46 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     stable@vger.kernel.org, Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        syzbot+5f229e48cccc804062c0@syzkaller.appspotmail.com
Subject: [PATCH 4.19.y 5/5] net: sched: use Qdisc rcu API instead of relying on rtnl lock
Date:   Fri, 10 Dec 2021 10:47:29 +0000
Message-Id: <20211210104729.582403-5-lee.jones@linaro.org>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
In-Reply-To: <20211210104729.582403-1-lee.jones@linaro.org>
References: <20211210104729.582403-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

[ Upstream commit e368fdb61d8e7c67ac70791b23345b26d7bbc661 ]

As a preparation from removing rtnl lock dependency from rules update path,
use Qdisc rcu and reference counting capabilities instead of relying on
rtnl lock while working with Qdiscs. Create new tcf_block_release()
function, and use it to free resources taken by tcf_block_find().
Currently, this function only releases Qdisc and it is extended in next
patches in this series.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[Lee: Sent to Stable]
Link: https://syzkaller.appspot.com/bug?id=d7e411c5472dd5da33d8cc921ccadc747743a568
Reported-by: syzbot+5f229e48cccc804062c0@syzkaller.appspotmail.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 net/sched/cls_api.c | 79 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 64 insertions(+), 15 deletions(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 4413aa8d4e829..b5da2c7a8092b 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -539,6 +539,7 @@ static struct tcf_block *tcf_block_find(struct net *net, struct Qdisc **q,
 					struct netlink_ext_ack *extack)
 {
 	struct tcf_block *block;
+	int err = 0;
 
 	if (ifindex == TCM_IFINDEX_MAGIC_BLOCK) {
 		block = tcf_block_lookup(net, block_index);
@@ -550,55 +551,93 @@ static struct tcf_block *tcf_block_find(struct net *net, struct Qdisc **q,
 		const struct Qdisc_class_ops *cops;
 		struct net_device *dev;
 
+		rcu_read_lock();
+
 		/* Find link */
-		dev = __dev_get_by_index(net, ifindex);
-		if (!dev)
+		dev = dev_get_by_index_rcu(net, ifindex);
+		if (!dev) {
+			rcu_read_unlock();
 			return ERR_PTR(-ENODEV);
+		}
 
 		/* Find qdisc */
 		if (!*parent) {
 			*q = dev->qdisc;
 			*parent = (*q)->handle;
 		} else {
-			*q = qdisc_lookup(dev, TC_H_MAJ(*parent));
+			*q = qdisc_lookup_rcu(dev, TC_H_MAJ(*parent));
 			if (!*q) {
 				NL_SET_ERR_MSG(extack, "Parent Qdisc doesn't exists");
-				return ERR_PTR(-EINVAL);
+				err = -EINVAL;
+				goto errout_rcu;
 			}
 		}
 
+		*q = qdisc_refcount_inc_nz(*q);
+		if (!*q) {
+			NL_SET_ERR_MSG(extack, "Parent Qdisc doesn't exists");
+			err = -EINVAL;
+			goto errout_rcu;
+		}
+
 		/* Is it classful? */
 		cops = (*q)->ops->cl_ops;
 		if (!cops) {
 			NL_SET_ERR_MSG(extack, "Qdisc not classful");
-			return ERR_PTR(-EINVAL);
+			err = -EINVAL;
+			goto errout_rcu;
 		}
 
 		if (!cops->tcf_block) {
 			NL_SET_ERR_MSG(extack, "Class doesn't support blocks");
-			return ERR_PTR(-EOPNOTSUPP);
+			err = -EOPNOTSUPP;
+			goto errout_rcu;
 		}
 
+		/* At this point we know that qdisc is not noop_qdisc,
+		 * which means that qdisc holds a reference to net_device
+		 * and we hold a reference to qdisc, so it is safe to release
+		 * rcu read lock.
+		 */
+		rcu_read_unlock();
+
 		/* Do we search for filter, attached to class? */
 		if (TC_H_MIN(*parent)) {
 			*cl = cops->find(*q, *parent);
 			if (*cl == 0) {
 				NL_SET_ERR_MSG(extack, "Specified class doesn't exist");
-				return ERR_PTR(-ENOENT);
+				err = -ENOENT;
+				goto errout_qdisc;
 			}
 		}
 
 		/* And the last stroke */
 		block = cops->tcf_block(*q, *cl, extack);
-		if (!block)
-			return ERR_PTR(-EINVAL);
+		if (!block) {
+			err = -EINVAL;
+			goto errout_qdisc;
+		}
 		if (tcf_block_shared(block)) {
 			NL_SET_ERR_MSG(extack, "This filter block is shared. Please use the block index to manipulate the filters");
-			return ERR_PTR(-EOPNOTSUPP);
+			err = -EOPNOTSUPP;
+			goto errout_qdisc;
 		}
 	}
 
 	return block;
+
+errout_rcu:
+	rcu_read_unlock();
+errout_qdisc:
+	if (*q)
+		qdisc_put(*q);
+	return ERR_PTR(err);
+}
+
+static void tcf_block_release(struct Qdisc *q, struct tcf_block *block)
+{
+	if (q)
+		qdisc_put(q);
 }
 
 struct tcf_block_owner_item {
@@ -1336,6 +1375,7 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 errout:
 	if (chain)
 		tcf_chain_put(chain);
+	tcf_block_release(q, block);
 	if (err == -EAGAIN)
 		/* Replay the request. */
 		goto replay;
@@ -1457,6 +1497,7 @@ static int tc_del_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 errout:
 	if (chain)
 		tcf_chain_put(chain);
+	tcf_block_release(q, block);
 	return err;
 }
 
@@ -1542,6 +1583,7 @@ static int tc_get_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 errout:
 	if (chain)
 		tcf_chain_put(chain);
+	tcf_block_release(q, block);
 	return err;
 }
 
@@ -1858,7 +1900,8 @@ static int tc_ctl_chain(struct sk_buff *skb, struct nlmsghdr *n,
 	chain_index = tca[TCA_CHAIN] ? nla_get_u32(tca[TCA_CHAIN]) : 0;
 	if (chain_index > TC_ACT_EXT_VAL_MASK) {
 		NL_SET_ERR_MSG(extack, "Specified chain index exceeds upper limit");
-		return -EINVAL;
+		err = -EINVAL;
+		goto errout_block;
 	}
 	chain = tcf_chain_lookup(block, chain_index);
 	if (n->nlmsg_type == RTM_NEWCHAIN) {
@@ -1870,23 +1913,27 @@ static int tc_ctl_chain(struct sk_buff *skb, struct nlmsghdr *n,
 				tcf_chain_hold(chain);
 			} else {
 				NL_SET_ERR_MSG(extack, "Filter chain already exists");
-				return -EEXIST;
+				err = -EEXIST;
+				goto errout_block;
 			}
 		} else {
 			if (!(n->nlmsg_flags & NLM_F_CREATE)) {
 				NL_SET_ERR_MSG(extack, "Need both RTM_NEWCHAIN and NLM_F_CREATE to create a new chain");
-				return -ENOENT;
+				err = -ENOENT;
+				goto errout_block;
 			}
 			chain = tcf_chain_create(block, chain_index);
 			if (!chain) {
 				NL_SET_ERR_MSG(extack, "Failed to create filter chain");
-				return -ENOMEM;
+				err = -ENOMEM;
+				goto errout_block;
 			}
 		}
 	} else {
 		if (!chain || tcf_chain_held_by_acts_only(chain)) {
 			NL_SET_ERR_MSG(extack, "Cannot find specified filter chain");
-			return -EINVAL;
+			err = -EINVAL;
+			goto errout_block;
 		}
 		tcf_chain_hold(chain);
 	}
@@ -1930,6 +1977,8 @@ static int tc_ctl_chain(struct sk_buff *skb, struct nlmsghdr *n,
 
 errout:
 	tcf_chain_put(chain);
+errout_block:
+	tcf_block_release(q, block);
 	if (err == -EAGAIN)
 		/* Replay the request. */
 		goto replay;
-- 
2.34.1.173.g76aa8bc2d0-goog

