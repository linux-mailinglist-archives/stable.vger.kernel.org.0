Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 179CC2266D6
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733071AbgGTQGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:06:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:43098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733069AbgGTQGj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:06:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BFC42065E;
        Mon, 20 Jul 2020 16:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261198;
        bh=xjqHvRsj41feq6PMcwsFzgXHYe9N9dC9EE5odDGu2pg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UMdhJDuxcFptwgOrBVO74EopLhYKbqzVWHWtMHmMkshFE7X2oAIXwl0KiR6bh8l4t
         sH/AjQpsbCadDIutRz7ePZpwRWt3rrOc4ljtgw9LUZrFwXHsytGd5TB0e6aeyUGXVl
         zj+75rBJ9LmxBvUN5MNDKzDH+/SmilDXEnzwJqTk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 028/244] ethtool: fix genlmsg_put() failure handling in ethnl_default_dumpit()
Date:   Mon, 20 Jul 2020 17:34:59 +0200
Message-Id: <20200720152827.204316158@linuxfoundation.org>
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

From: Michal Kubecek <mkubecek@suse.cz>

[ Upstream commit 365f9ae4ee36037e2a9268fe7296065356840b4c ]

If the genlmsg_put() call in ethnl_default_dumpit() fails, we bail out
without checking if we already have some messages in current skb like we do
with ethnl_default_dump_one() failure later. Therefore if existing messages
almost fill up the buffer so that there is not enough space even for
netlink and genetlink header, we lose all prepared messages and return and
error.

Rather than duplicating the skb->len check, move the genlmsg_put(),
genlmsg_cancel() and genlmsg_end() calls into ethnl_default_dump_one().
This is also more logical as all message composition will be in
ethnl_default_dump_one() and only iteration logic will be left in
ethnl_default_dumpit().

Fixes: 728480f12442 ("ethtool: default handlers for GET requests")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ethtool/netlink.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -376,10 +376,17 @@ err_dev:
 }
 
 static int ethnl_default_dump_one(struct sk_buff *skb, struct net_device *dev,
-				  const struct ethnl_dump_ctx *ctx)
+				  const struct ethnl_dump_ctx *ctx,
+				  struct netlink_callback *cb)
 {
+	void *ehdr;
 	int ret;
 
+	ehdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
+			   &ethtool_genl_family, 0, ctx->ops->reply_cmd);
+	if (!ehdr)
+		return -EMSGSIZE;
+
 	ethnl_init_reply_data(ctx->reply_data, ctx->ops, dev);
 	rtnl_lock();
 	ret = ctx->ops->prepare_data(ctx->req_info, ctx->reply_data, NULL);
@@ -395,6 +402,10 @@ out:
 	if (ctx->ops->cleanup_data)
 		ctx->ops->cleanup_data(ctx->reply_data);
 	ctx->reply_data->dev = NULL;
+	if (ret < 0)
+		genlmsg_cancel(skb, ehdr);
+	else
+		genlmsg_end(skb, ehdr);
 	return ret;
 }
 
@@ -411,7 +422,6 @@ static int ethnl_default_dumpit(struct s
 	int s_idx = ctx->pos_idx;
 	int h, idx = 0;
 	int ret = 0;
-	void *ehdr;
 
 	rtnl_lock();
 	for (h = ctx->pos_hash; h < NETDEV_HASHENTRIES; h++, s_idx = 0) {
@@ -431,26 +441,15 @@ restart_chain:
 			dev_hold(dev);
 			rtnl_unlock();
 
-			ehdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid,
-					   cb->nlh->nlmsg_seq,
-					   &ethtool_genl_family, 0,
-					   ctx->ops->reply_cmd);
-			if (!ehdr) {
-				dev_put(dev);
-				ret = -EMSGSIZE;
-				goto out;
-			}
-			ret = ethnl_default_dump_one(skb, dev, ctx);
+			ret = ethnl_default_dump_one(skb, dev, ctx, cb);
 			dev_put(dev);
 			if (ret < 0) {
-				genlmsg_cancel(skb, ehdr);
 				if (ret == -EOPNOTSUPP)
 					goto lock_and_cont;
 				if (likely(skb->len))
 					ret = skb->len;
 				goto out;
 			}
-			genlmsg_end(skb, ehdr);
 lock_and_cont:
 			rtnl_lock();
 			if (net->dev_base_seq != seq) {


