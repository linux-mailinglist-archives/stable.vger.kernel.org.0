Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA6BA226B9C
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729204AbgGTPm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:42:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:35346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730068AbgGTPmZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:42:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A915120773;
        Mon, 20 Jul 2020 15:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259745;
        bh=cUT6ml9QtOqvlLfbMNEBKAVIA9b3PkIIl2rBuDmt58A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XiHiuAxjYx8zkn9B4YnEatVEG8bXieE3LpTNsN5vZ8OTFmAEOeczjsriKC7Jc7ln7
         44mL1FNi9zzfSZ3YLPDm7F1BvljqZ+B3fLBaSaSRgtzFecwE2F75O1WvoWuCczQmKw
         X0nzxzQQ40tRAtzAaPurOx3Tyhfta0NJkdxcGCPE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        kernel test robot <lkp@intel.com>,
        Sean Tranchetti <stranche@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 34/86] genetlink: remove genl_bind
Date:   Mon, 20 Jul 2020 17:36:30 +0200
Message-Id: <20200720152754.869489049@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152753.138974850@linuxfoundation.org>
References: <20200720152753.138974850@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Tranchetti <stranche@codeaurora.org>

[ Upstream commit 1e82a62fec613844da9e558f3493540a5b7a7b67 ]

A potential deadlock can occur during registering or unregistering a
new generic netlink family between the main nl_table_lock and the
cb_lock where each thread wants the lock held by the other, as
demonstrated below.

1) Thread 1 is performing a netlink_bind() operation on a socket. As part
   of this call, it will call netlink_lock_table(), incrementing the
   nl_table_users count to 1.
2) Thread 2 is registering (or unregistering) a genl_family via the
   genl_(un)register_family() API. The cb_lock semaphore will be taken for
   writing.
3) Thread 1 will call genl_bind() as part of the bind operation to handle
   subscribing to GENL multicast groups at the request of the user. It will
   attempt to take the cb_lock semaphore for reading, but it will fail and
   be scheduled away, waiting for Thread 2 to finish the write.
4) Thread 2 will call netlink_table_grab() during the (un)registration
   call. However, as Thread 1 has incremented nl_table_users, it will not
   be able to proceed, and both threads will be stuck waiting for the
   other.

genl_bind() is a noop, unless a genl_family implements the mcast_bind()
function to handle setting up family-specific multicast operations. Since
no one in-tree uses this functionality as Cong pointed out, simply removing
the genl_bind() function will remove the possibility for deadlock, as there
is no attempt by Thread 1 above to take the cb_lock semaphore.

Fixes: c380d9a7afff ("genetlink: pass multicast bind/unbind to families")
Suggested-by: Cong Wang <xiyou.wangcong@gmail.com>
Acked-by: Johannes Berg <johannes.berg@intel.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Sean Tranchetti <stranche@codeaurora.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/genetlink.h |    8 -------
 net/netlink/genetlink.c |   52 ------------------------------------------------
 2 files changed, 60 deletions(-)

--- a/include/net/genetlink.h
+++ b/include/net/genetlink.h
@@ -33,12 +33,6 @@ struct genl_info;
  *	do additional, common, filtering and return an error
  * @post_doit: called after an operation's doit callback, it may
  *	undo operations done by pre_doit, for example release locks
- * @mcast_bind: a socket bound to the given multicast group (which
- *	is given as the offset into the groups array)
- * @mcast_unbind: a socket was unbound from the given multicast group.
- *	Note that unbind() will not be called symmetrically if the
- *	generic netlink family is removed while there are still open
- *	sockets.
  * @attrbuf: buffer to store parsed attributes
  * @family_list: family list
  * @mcgrps: multicast groups used by this family (private)
@@ -61,8 +55,6 @@ struct genl_family {
 	void			(*post_doit)(const struct genl_ops *ops,
 					     struct sk_buff *skb,
 					     struct genl_info *info);
-	int			(*mcast_bind)(struct net *net, int group);
-	void			(*mcast_unbind)(struct net *net, int group);
 	struct nlattr **	attrbuf;	/* private */
 	const struct genl_ops *	ops;		/* private */
 	const struct genl_multicast_group *mcgrps; /* private */
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -992,63 +992,11 @@ static const struct genl_multicast_group
 	{ .name = "notify", },
 };
 
-static int genl_bind(struct net *net, int group)
-{
-	int i, err = -ENOENT;
-
-	down_read(&cb_lock);
-	for (i = 0; i < GENL_FAM_TAB_SIZE; i++) {
-		struct genl_family *f;
-
-		list_for_each_entry(f, genl_family_chain(i), family_list) {
-			if (group >= f->mcgrp_offset &&
-			    group < f->mcgrp_offset + f->n_mcgrps) {
-				int fam_grp = group - f->mcgrp_offset;
-
-				if (!f->netnsok && net != &init_net)
-					err = -ENOENT;
-				else if (f->mcast_bind)
-					err = f->mcast_bind(net, fam_grp);
-				else
-					err = 0;
-				break;
-			}
-		}
-	}
-	up_read(&cb_lock);
-
-	return err;
-}
-
-static void genl_unbind(struct net *net, int group)
-{
-	int i;
-
-	down_read(&cb_lock);
-	for (i = 0; i < GENL_FAM_TAB_SIZE; i++) {
-		struct genl_family *f;
-
-		list_for_each_entry(f, genl_family_chain(i), family_list) {
-			if (group >= f->mcgrp_offset &&
-			    group < f->mcgrp_offset + f->n_mcgrps) {
-				int fam_grp = group - f->mcgrp_offset;
-
-				if (f->mcast_unbind)
-					f->mcast_unbind(net, fam_grp);
-				break;
-			}
-		}
-	}
-	up_read(&cb_lock);
-}
-
 static int __net_init genl_pernet_init(struct net *net)
 {
 	struct netlink_kernel_cfg cfg = {
 		.input		= genl_rcv,
 		.flags		= NL_CFG_F_NONROOT_RECV,
-		.bind		= genl_bind,
-		.unbind		= genl_unbind,
 	};
 
 	/* we'll bump the group number right afterwards */


