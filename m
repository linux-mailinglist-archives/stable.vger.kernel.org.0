Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86442472564
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235445AbhLMJnh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:43:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235200AbhLMJka (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:40:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFAABC07E5F7;
        Mon, 13 Dec 2021 01:38:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F4E8B80E1D;
        Mon, 13 Dec 2021 09:38:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F18C341C5;
        Mon, 13 Dec 2021 09:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388335;
        bh=evDyZY0PEbn0zu2pJ6eXH17/EwKIPcm2iyDgQmHT1M4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yECPkkNx1jwy0rE7Y/COGM8he7pF301/mGQeS9QBhhpWJT5UYTZNF+p2zfk2RIK5D
         Vao1x0dmo8oWEtDapPyVqHTFkJxL9Y3nAQXGL5riahAuA5/P7MNn4T9o0S1t+6z5Pw
         sSiGkRT/wM3fEC4XT0ck345X/7Nda/oqD0VHzSNc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, lee.jones@linaro.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+5f229e48cccc804062c0@syzkaller.appspotmail.com
Subject: [PATCH 4.19 14/74] net: sched: use Qdisc rcu API instead of relying on rtnl lock
Date:   Mon, 13 Dec 2021 10:29:45 +0100
Message-Id: <20211213092931.262028851@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092930.763200615@linuxfoundation.org>
References: <20211213092930.763200615@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/cls_api.c |   79 ++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 64 insertions(+), 15 deletions(-)

--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -539,6 +539,7 @@ static struct tcf_block *tcf_block_find(
 					struct netlink_ext_ack *extack)
 {
 	struct tcf_block *block;
+	int err = 0;
 
 	if (ifindex == TCM_IFINDEX_MAGIC_BLOCK) {
 		block = tcf_block_lookup(net, block_index);
@@ -550,55 +551,93 @@ static struct tcf_block *tcf_block_find(
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
@@ -1336,6 +1375,7 @@ replay:
 errout:
 	if (chain)
 		tcf_chain_put(chain);
+	tcf_block_release(q, block);
 	if (err == -EAGAIN)
 		/* Replay the request. */
 		goto replay;
@@ -1457,6 +1497,7 @@ static int tc_del_tfilter(struct sk_buff
 errout:
 	if (chain)
 		tcf_chain_put(chain);
+	tcf_block_release(q, block);
 	return err;
 }
 
@@ -1542,6 +1583,7 @@ static int tc_get_tfilter(struct sk_buff
 errout:
 	if (chain)
 		tcf_chain_put(chain);
+	tcf_block_release(q, block);
 	return err;
 }
 
@@ -1858,7 +1900,8 @@ replay:
 	chain_index = tca[TCA_CHAIN] ? nla_get_u32(tca[TCA_CHAIN]) : 0;
 	if (chain_index > TC_ACT_EXT_VAL_MASK) {
 		NL_SET_ERR_MSG(extack, "Specified chain index exceeds upper limit");
-		return -EINVAL;
+		err = -EINVAL;
+		goto errout_block;
 	}
 	chain = tcf_chain_lookup(block, chain_index);
 	if (n->nlmsg_type == RTM_NEWCHAIN) {
@@ -1870,23 +1913,27 @@ replay:
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
@@ -1930,6 +1977,8 @@ replay:
 
 errout:
 	tcf_chain_put(chain);
+errout_block:
+	tcf_block_release(q, block);
 	if (err == -EAGAIN)
 		/* Replay the request. */
 		goto replay;


