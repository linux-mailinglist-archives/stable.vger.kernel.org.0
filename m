Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA351FBAE2
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731605AbgFPPmF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:42:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731602AbgFPPmE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:42:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2419C21475;
        Tue, 16 Jun 2020 15:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322123;
        bh=xHNThwycT2mB04bLrAmNaSzszSiGQNOOjv31QwYQJNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r+xILbgysp1/GD/8B8JUIZV9BtiBuP2PKRu9y2N6VAwM1WIkpB6b9+nqbEBJeAQRz
         U5HbXliivQelR06jFDDfmhGTRhiD/zEz0hjRBbR3DMXl+Rpjgqxo5mIj3LYDkmF97m
         57slOmOIn+HCIM4APGS9H9BJ84R1ecw4WorkfayU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+21f04f481f449c8db840@syzkaller.appspotmail.com,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jiri Pirko <jiri@mellanox.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Shaochun Chen <cscnull@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 010/163] genetlink: fix memory leaks in genl_family_rcv_msg_dumpit()
Date:   Tue, 16 Jun 2020 17:33:04 +0200
Message-Id: <20200616153107.358375030@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit c36f05559104b66bcd7f617e931e38c680227b74 ]

There are two kinds of memory leaks in genl_family_rcv_msg_dumpit():

1. Before we call ops->start(), whenever an error happens, we forget
   to free the memory allocated in genl_family_rcv_msg_dumpit().

2. When ops->start() fails, the 'info' has been already installed on
   the per socket control block, so we should not free it here. More
   importantly, nlk->cb_running is still false at this point, so
   netlink_sock_destruct() cannot free it either.

The first kind of memory leaks is easier to resolve, but the second
one requires some deeper thoughts.

After reviewing how netfilter handles this, the most elegant solution
I find is just to use a similar way to allocate the memory, that is,
moving memory allocations from caller into ops->start(). With this,
we can solve both kinds of memory leaks: for 1), no memory allocation
happens before ops->start(); for 2), ops->start() handles its own
failures and 'info' is installed to the socket control block only
when success. The only ugliness here is we have to pass all local
variables on stack via a struct, but this is not hard to understand.

Alternatively, we can introduce a ops->free() to solve this too,
but it is overkill as only genetlink has this problem so far.

Fixes: 1927f41a22a0 ("net: genetlink: introduce dump info struct to be available during dumpit op")
Reported-by: syzbot+21f04f481f449c8db840@syzkaller.appspotmail.com
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jiri Pirko <jiri@mellanox.com>
Cc: YueHaibing <yuehaibing@huawei.com>
Cc: Shaochun Chen <cscnull@gmail.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netlink/genetlink.c |   94 +++++++++++++++++++++++++++++-------------------
 1 file changed, 58 insertions(+), 36 deletions(-)

--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -513,15 +513,58 @@ static void genl_family_rcv_msg_attrs_fr
 		kfree(attrbuf);
 }
 
-static int genl_lock_start(struct netlink_callback *cb)
+struct genl_start_context {
+	const struct genl_family *family;
+	struct nlmsghdr *nlh;
+	struct netlink_ext_ack *extack;
+	const struct genl_ops *ops;
+	int hdrlen;
+};
+
+static int genl_start(struct netlink_callback *cb)
 {
-	const struct genl_ops *ops = genl_dumpit_info(cb)->ops;
+	struct genl_start_context *ctx = cb->data;
+	const struct genl_ops *ops = ctx->ops;
+	struct genl_dumpit_info *info;
+	struct nlattr **attrs = NULL;
 	int rc = 0;
 
+	if (ops->validate & GENL_DONT_VALIDATE_DUMP)
+		goto no_attrs;
+
+	if (ctx->nlh->nlmsg_len < nlmsg_msg_size(ctx->hdrlen))
+		return -EINVAL;
+
+	attrs = genl_family_rcv_msg_attrs_parse(ctx->family, ctx->nlh, ctx->extack,
+						ops, ctx->hdrlen,
+						GENL_DONT_VALIDATE_DUMP_STRICT,
+						true);
+	if (IS_ERR(attrs))
+		return PTR_ERR(attrs);
+
+no_attrs:
+	info = genl_dumpit_info_alloc();
+	if (!info) {
+		kfree(attrs);
+		return -ENOMEM;
+	}
+	info->family = ctx->family;
+	info->ops = ops;
+	info->attrs = attrs;
+
+	cb->data = info;
 	if (ops->start) {
-		genl_lock();
+		if (!ctx->family->parallel_ops)
+			genl_lock();
 		rc = ops->start(cb);
-		genl_unlock();
+		if (!ctx->family->parallel_ops)
+			genl_unlock();
+	}
+
+	if (rc) {
+		kfree(attrs);
+		genl_dumpit_info_free(info);
+		cb->data = NULL;
 	}
 	return rc;
 }
@@ -548,7 +591,7 @@ static int genl_lock_done(struct netlink
 		rc = ops->done(cb);
 		genl_unlock();
 	}
-	genl_family_rcv_msg_attrs_free(info->family, info->attrs, true);
+	genl_family_rcv_msg_attrs_free(info->family, info->attrs, false);
 	genl_dumpit_info_free(info);
 	return rc;
 }
@@ -573,43 +616,23 @@ static int genl_family_rcv_msg_dumpit(co
 				      const struct genl_ops *ops,
 				      int hdrlen, struct net *net)
 {
-	struct genl_dumpit_info *info;
-	struct nlattr **attrs = NULL;
+	struct genl_start_context ctx;
 	int err;
 
 	if (!ops->dumpit)
 		return -EOPNOTSUPP;
 
-	if (ops->validate & GENL_DONT_VALIDATE_DUMP)
-		goto no_attrs;
-
-	if (nlh->nlmsg_len < nlmsg_msg_size(hdrlen))
-		return -EINVAL;
-
-	attrs = genl_family_rcv_msg_attrs_parse(family, nlh, extack,
-						ops, hdrlen,
-						GENL_DONT_VALIDATE_DUMP_STRICT,
-						true);
-	if (IS_ERR(attrs))
-		return PTR_ERR(attrs);
-
-no_attrs:
-	/* Allocate dumpit info. It is going to be freed by done() callback. */
-	info = genl_dumpit_info_alloc();
-	if (!info) {
-		genl_family_rcv_msg_attrs_free(family, attrs, true);
-		return -ENOMEM;
-	}
-
-	info->family = family;
-	info->ops = ops;
-	info->attrs = attrs;
+	ctx.family = family;
+	ctx.nlh = nlh;
+	ctx.extack = extack;
+	ctx.ops = ops;
+	ctx.hdrlen = hdrlen;
 
 	if (!family->parallel_ops) {
 		struct netlink_dump_control c = {
 			.module = family->module,
-			.data = info,
-			.start = genl_lock_start,
+			.data = &ctx,
+			.start = genl_start,
 			.dump = genl_lock_dumpit,
 			.done = genl_lock_done,
 		};
@@ -617,12 +640,11 @@ no_attrs:
 		genl_unlock();
 		err = __netlink_dump_start(net->genl_sock, skb, nlh, &c);
 		genl_lock();
-
 	} else {
 		struct netlink_dump_control c = {
 			.module = family->module,
-			.data = info,
-			.start = ops->start,
+			.data = &ctx,
+			.start = genl_start,
 			.dump = ops->dumpit,
 			.done = genl_parallel_done,
 		};


