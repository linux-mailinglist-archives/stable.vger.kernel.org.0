Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C4A20E715
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732916AbgF2Vxe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:53:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:56890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726592AbgF2Sfe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DB842417F;
        Mon, 29 Jun 2020 15:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443950;
        bh=+w3tag92/3T0o050FpKjOJpFcrV35hzPqXlbW4nZDR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QJDDLdeye3QLksI4PCTe/D4Ri+PHNgZ1X9cp2j3MezWR6yIJ3YbTRlBef8BlC65bb
         y+Uiv+dErmY8MqOYZSrfJiaL+hBAFkMdQSct/6PuLW4P9Q2iEIfvW5yMLYcXUfDN8/
         2HqewSGQ693+QbWL+dGF1drfwMq6vfovYxeQKWAE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 052/265] genetlink: clean up family attributes allocations
Date:   Mon, 29 Jun 2020 11:14:45 -0400
Message-Id: <20200629151818.2493727-53-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit b65ce380b754e77fbfdcfc83fd6e29c8ceedf431 ]

genl_family_rcv_msg_attrs_parse() and genl_family_rcv_msg_attrs_free()
take a boolean parameter to determine whether allocate/free the family
attrs. This is unnecessary as we can just check family->parallel_ops.
More importantly, callers would not need to worry about pairing these
parameters correctly after this patch.

And this fixes a memory leak, as after commit c36f05559104
("genetlink: fix memory leaks in genl_family_rcv_msg_dumpit()")
we call genl_family_rcv_msg_attrs_parse() for both parallel and
non-parallel cases.

Fixes: c36f05559104 ("genetlink: fix memory leaks in genl_family_rcv_msg_dumpit()")
Reported-by: Ido Schimmel <idosch@idosch.org>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Ido Schimmel <idosch@mellanox.com>
Tested-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/genetlink.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index bcbba0bef1c2a..9c1c27f3a0894 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -474,8 +474,7 @@ genl_family_rcv_msg_attrs_parse(const struct genl_family *family,
 				struct netlink_ext_ack *extack,
 				const struct genl_ops *ops,
 				int hdrlen,
-				enum genl_validate_flags no_strict_flag,
-				bool parallel)
+				enum genl_validate_flags no_strict_flag)
 {
 	enum netlink_validation validate = ops->validate & no_strict_flag ?
 					   NL_VALIDATE_LIBERAL :
@@ -486,7 +485,7 @@ genl_family_rcv_msg_attrs_parse(const struct genl_family *family,
 	if (!family->maxattr)
 		return NULL;
 
-	if (parallel) {
+	if (family->parallel_ops) {
 		attrbuf = kmalloc_array(family->maxattr + 1,
 					sizeof(struct nlattr *), GFP_KERNEL);
 		if (!attrbuf)
@@ -498,7 +497,7 @@ genl_family_rcv_msg_attrs_parse(const struct genl_family *family,
 	err = __nlmsg_parse(nlh, hdrlen, attrbuf, family->maxattr,
 			    family->policy, validate, extack);
 	if (err) {
-		if (parallel)
+		if (family->parallel_ops)
 			kfree(attrbuf);
 		return ERR_PTR(err);
 	}
@@ -506,10 +505,9 @@ genl_family_rcv_msg_attrs_parse(const struct genl_family *family,
 }
 
 static void genl_family_rcv_msg_attrs_free(const struct genl_family *family,
-					   struct nlattr **attrbuf,
-					   bool parallel)
+					   struct nlattr **attrbuf)
 {
-	if (parallel)
+	if (family->parallel_ops)
 		kfree(attrbuf);
 }
 
@@ -537,15 +535,14 @@ static int genl_start(struct netlink_callback *cb)
 
 	attrs = genl_family_rcv_msg_attrs_parse(ctx->family, ctx->nlh, ctx->extack,
 						ops, ctx->hdrlen,
-						GENL_DONT_VALIDATE_DUMP_STRICT,
-						true);
+						GENL_DONT_VALIDATE_DUMP_STRICT);
 	if (IS_ERR(attrs))
 		return PTR_ERR(attrs);
 
 no_attrs:
 	info = genl_dumpit_info_alloc();
 	if (!info) {
-		kfree(attrs);
+		genl_family_rcv_msg_attrs_free(ctx->family, attrs);
 		return -ENOMEM;
 	}
 	info->family = ctx->family;
@@ -562,7 +559,7 @@ no_attrs:
 	}
 
 	if (rc) {
-		kfree(attrs);
+		genl_family_rcv_msg_attrs_free(info->family, info->attrs);
 		genl_dumpit_info_free(info);
 		cb->data = NULL;
 	}
@@ -591,7 +588,7 @@ static int genl_lock_done(struct netlink_callback *cb)
 		rc = ops->done(cb);
 		genl_unlock();
 	}
-	genl_family_rcv_msg_attrs_free(info->family, info->attrs, false);
+	genl_family_rcv_msg_attrs_free(info->family, info->attrs);
 	genl_dumpit_info_free(info);
 	return rc;
 }
@@ -604,7 +601,7 @@ static int genl_parallel_done(struct netlink_callback *cb)
 
 	if (ops->done)
 		rc = ops->done(cb);
-	genl_family_rcv_msg_attrs_free(info->family, info->attrs, true);
+	genl_family_rcv_msg_attrs_free(info->family, info->attrs);
 	genl_dumpit_info_free(info);
 	return rc;
 }
@@ -671,8 +668,7 @@ static int genl_family_rcv_msg_doit(const struct genl_family *family,
 
 	attrbuf = genl_family_rcv_msg_attrs_parse(family, nlh, extack,
 						  ops, hdrlen,
-						  GENL_DONT_VALIDATE_STRICT,
-						  family->parallel_ops);
+						  GENL_DONT_VALIDATE_STRICT);
 	if (IS_ERR(attrbuf))
 		return PTR_ERR(attrbuf);
 
@@ -698,7 +694,7 @@ static int genl_family_rcv_msg_doit(const struct genl_family *family,
 		family->post_doit(ops, skb, &info);
 
 out:
-	genl_family_rcv_msg_attrs_free(family, attrbuf, family->parallel_ops);
+	genl_family_rcv_msg_attrs_free(family, attrbuf);
 
 	return err;
 }
-- 
2.25.1

