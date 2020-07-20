Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59ACC2266D3
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732595AbgGTQGe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:06:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:42934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733064AbgGTQGd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:06:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35F47206E9;
        Mon, 20 Jul 2020 16:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261192;
        bh=IBeX/K7ZLpKlahU1D8dyagLQTR4qxIS1ebDK1Hys0jk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZvrTBVsArLgW5j2xkpx82vIzkEedNHBpQOKbrDvp824Ga6WtZvSj2x/Nq/HtLPlFa
         ZIl1/5r0KaGuXZ/A/9YnCCHbkG/2SwQ9bchAUm8MQZSn7m++cBXgiNWrptCSGUxaUD
         CV6D0goCDbrGjGD6tcs0Bae4ssi13RAru/u0E/kc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+3039ddf6d7b13daf3787@syzkaller.appspotmail.com,
        syzbot+80cad1e3cb4c41cde6ff@syzkaller.appspotmail.com,
        syzbot+736bcbcb11b60d0c0792@syzkaller.appspotmail.com,
        syzbot+520f8704db2b68091d44@syzkaller.appspotmail.com,
        syzbot+c96e4dfb32f8987fdeed@syzkaller.appspotmail.com
Subject: [PATCH 5.7 026/244] genetlink: get rid of family->attrbuf
Date:   Mon, 20 Jul 2020 17:34:57 +0200
Message-Id: <20200720152827.104605282@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit bf64ff4c2aac65d680dc639a511c781cf6b6ec08 ]

genl_family_rcv_msg_attrs_parse() reuses the global family->attrbuf
when family->parallel_ops is false. However, family->attrbuf is not
protected by any lock on the genl_family_rcv_msg_doit() code path.

This leads to several different consequences, one of them is UAF,
like the following:

genl_family_rcv_msg_doit():		genl_start():
					  genl_family_rcv_msg_attrs_parse()
					    attrbuf = family->attrbuf
					    __nlmsg_parse(attrbuf);
  genl_family_rcv_msg_attrs_parse()
    attrbuf = family->attrbuf
    __nlmsg_parse(attrbuf);
					  info->attrs = attrs;
					  cb->data = info;

netlink_unicast_kernel():
 consume_skb()
					genl_lock_dumpit():
					  genl_dumpit_info(cb)->attrs

Note family->attrbuf is an array of pointers to the skb data, once
the skb is freed, any dereference of family->attrbuf will be a UAF.

Maybe we could serialize the family->attrbuf with genl_mutex too, but
that would make the locking more complicated. Instead, we can just get
rid of family->attrbuf and always allocate attrbuf from heap like the
family->parallel_ops==true code path. This may add some performance
overhead but comparing with taking the global genl_mutex, it still
looks better.

Fixes: 75cdbdd08900 ("net: ieee802154: have genetlink code to parse the attrs during dumpit")
Fixes: 057af7071344 ("net: tipc: have genetlink code to parse the attrs during dumpit")
Reported-and-tested-by: syzbot+3039ddf6d7b13daf3787@syzkaller.appspotmail.com
Reported-and-tested-by: syzbot+80cad1e3cb4c41cde6ff@syzkaller.appspotmail.com
Reported-and-tested-by: syzbot+736bcbcb11b60d0c0792@syzkaller.appspotmail.com
Reported-and-tested-by: syzbot+520f8704db2b68091d44@syzkaller.appspotmail.com
Reported-and-tested-by: syzbot+c96e4dfb32f8987fdeed@syzkaller.appspotmail.com
Cc: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/genetlink.h |    2 --
 net/netlink/genetlink.c |   48 +++++++++++++-----------------------------------
 2 files changed, 13 insertions(+), 37 deletions(-)

--- a/include/net/genetlink.h
+++ b/include/net/genetlink.h
@@ -35,7 +35,6 @@ struct genl_info;
  *	do additional, common, filtering and return an error
  * @post_doit: called after an operation's doit callback, it may
  *	undo operations done by pre_doit, for example release locks
- * @attrbuf: buffer to store parsed attributes (private)
  * @mcgrps: multicast groups used by this family
  * @n_mcgrps: number of multicast groups
  * @mcgrp_offset: starting number of multicast group IDs in this family
@@ -58,7 +57,6 @@ struct genl_family {
 	void			(*post_doit)(const struct genl_ops *ops,
 					     struct sk_buff *skb,
 					     struct genl_info *info);
-	struct nlattr **	attrbuf;	/* private */
 	const struct genl_ops *	ops;
 	const struct genl_multicast_group *mcgrps;
 	unsigned int		n_ops;
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -351,22 +351,11 @@ int genl_register_family(struct genl_fam
 		start = end = GENL_ID_VFS_DQUOT;
 	}
 
-	if (family->maxattr && !family->parallel_ops) {
-		family->attrbuf = kmalloc_array(family->maxattr + 1,
-						sizeof(struct nlattr *),
-						GFP_KERNEL);
-		if (family->attrbuf == NULL) {
-			err = -ENOMEM;
-			goto errout_locked;
-		}
-	} else
-		family->attrbuf = NULL;
-
 	family->id = idr_alloc_cyclic(&genl_fam_idr, family,
 				      start, end + 1, GFP_KERNEL);
 	if (family->id < 0) {
 		err = family->id;
-		goto errout_free;
+		goto errout_locked;
 	}
 
 	err = genl_validate_assign_mc_groups(family);
@@ -385,8 +374,6 @@ int genl_register_family(struct genl_fam
 
 errout_remove:
 	idr_remove(&genl_fam_idr, family->id);
-errout_free:
-	kfree(family->attrbuf);
 errout_locked:
 	genl_unlock_all();
 	return err;
@@ -419,8 +406,6 @@ int genl_unregister_family(const struct
 		   atomic_read(&genl_sk_destructing_cnt) == 0);
 	genl_unlock();
 
-	kfree(family->attrbuf);
-
 	genl_ctrl_event(CTRL_CMD_DELFAMILY, family, NULL, 0);
 
 	return 0;
@@ -485,30 +470,23 @@ genl_family_rcv_msg_attrs_parse(const st
 	if (!family->maxattr)
 		return NULL;
 
-	if (family->parallel_ops) {
-		attrbuf = kmalloc_array(family->maxattr + 1,
-					sizeof(struct nlattr *), GFP_KERNEL);
-		if (!attrbuf)
-			return ERR_PTR(-ENOMEM);
-	} else {
-		attrbuf = family->attrbuf;
-	}
+	attrbuf = kmalloc_array(family->maxattr + 1,
+				sizeof(struct nlattr *), GFP_KERNEL);
+	if (!attrbuf)
+		return ERR_PTR(-ENOMEM);
 
 	err = __nlmsg_parse(nlh, hdrlen, attrbuf, family->maxattr,
 			    family->policy, validate, extack);
 	if (err) {
-		if (family->parallel_ops)
-			kfree(attrbuf);
+		kfree(attrbuf);
 		return ERR_PTR(err);
 	}
 	return attrbuf;
 }
 
-static void genl_family_rcv_msg_attrs_free(const struct genl_family *family,
-					   struct nlattr **attrbuf)
+static void genl_family_rcv_msg_attrs_free(struct nlattr **attrbuf)
 {
-	if (family->parallel_ops)
-		kfree(attrbuf);
+	kfree(attrbuf);
 }
 
 struct genl_start_context {
@@ -542,7 +520,7 @@ static int genl_start(struct netlink_cal
 no_attrs:
 	info = genl_dumpit_info_alloc();
 	if (!info) {
-		genl_family_rcv_msg_attrs_free(ctx->family, attrs);
+		genl_family_rcv_msg_attrs_free(attrs);
 		return -ENOMEM;
 	}
 	info->family = ctx->family;
@@ -559,7 +537,7 @@ no_attrs:
 	}
 
 	if (rc) {
-		genl_family_rcv_msg_attrs_free(info->family, info->attrs);
+		genl_family_rcv_msg_attrs_free(info->attrs);
 		genl_dumpit_info_free(info);
 		cb->data = NULL;
 	}
@@ -588,7 +566,7 @@ static int genl_lock_done(struct netlink
 		rc = ops->done(cb);
 		genl_unlock();
 	}
-	genl_family_rcv_msg_attrs_free(info->family, info->attrs);
+	genl_family_rcv_msg_attrs_free(info->attrs);
 	genl_dumpit_info_free(info);
 	return rc;
 }
@@ -601,7 +579,7 @@ static int genl_parallel_done(struct net
 
 	if (ops->done)
 		rc = ops->done(cb);
-	genl_family_rcv_msg_attrs_free(info->family, info->attrs);
+	genl_family_rcv_msg_attrs_free(info->attrs);
 	genl_dumpit_info_free(info);
 	return rc;
 }
@@ -694,7 +672,7 @@ static int genl_family_rcv_msg_doit(cons
 		family->post_doit(ops, skb, &info);
 
 out:
-	genl_family_rcv_msg_attrs_free(family, attrbuf);
+	genl_family_rcv_msg_attrs_free(attrbuf);
 
 	return err;
 }


