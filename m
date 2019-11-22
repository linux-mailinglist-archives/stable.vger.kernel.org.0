Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E582C10631A
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbfKVGBn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:01:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:39918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729024AbfKVGBm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 01:01:42 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E6122070E;
        Fri, 22 Nov 2019 06:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402501;
        bh=kz+3hAKLZGXwy5NFQbtVkx/dpRrkzk30Gq1lot8iM1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TW9ISkfeExVwgzrhbECzV3KB15/M9QaUY2yQ3uPZ1OLz3y8gRabCIdX1tes7jsxGh
         +1yt0qnSUDSgGyOWEmbuEBo0jAWF+1To3QNk3wMJVpX9BzfrbjBupg6nYZSQ6hSuKl
         u2ad+Soi3rYzzcjwJr+090oZJ0h5wQMT9juPB+kA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 11/91] crypto: user - support incremental algorithm dumps
Date:   Fri, 22 Nov 2019 01:00:09 -0500
Message-Id: <20191122060129.4239-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122060129.4239-1-sashal@kernel.org>
References: <20191122060129.4239-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit 0ac6b8fb23c724b015d9ca70a89126e8d1563166 ]

CRYPTO_MSG_GETALG in NLM_F_DUMP mode sometimes doesn't return all
registered crypto algorithms, because it doesn't support incremental
dumps.  crypto_dump_report() only permits itself to be called once, yet
the netlink subsystem allocates at most ~64 KiB for the skb being dumped
to.  Thus only the first recvmsg() returns data, and it may only include
a subset of the crypto algorithms even if the user buffer passed to
recvmsg() is large enough to hold all of them.

Fix this by using one of the arguments in the netlink_callback structure
to keep track of the current position in the algorithm list.  Then
userspace can do multiple recvmsg() on the socket after sending the dump
request.  This is the way netlink dumps work elsewhere in the kernel;
it's unclear why this was different (probably just an oversight).

Also fix an integer overflow when calculating the dump buffer size hint.

Fixes: a38f7907b926 ("crypto: Add userspace configuration API")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/crypto_user.c | 37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index c90a1727cd2c6..60cf7d163731b 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -277,30 +277,33 @@ static int crypto_report(struct sk_buff *in_skb, struct nlmsghdr *in_nlh,
 
 static int crypto_dump_report(struct sk_buff *skb, struct netlink_callback *cb)
 {
-	struct crypto_alg *alg;
+	const size_t start_pos = cb->args[0];
+	size_t pos = 0;
 	struct crypto_dump_info info;
-	int err;
-
-	if (cb->args[0])
-		goto out;
-
-	cb->args[0] = 1;
+	struct crypto_alg *alg;
+	int res;
 
 	info.in_skb = cb->skb;
 	info.out_skb = skb;
 	info.nlmsg_seq = cb->nlh->nlmsg_seq;
 	info.nlmsg_flags = NLM_F_MULTI;
 
+	down_read(&crypto_alg_sem);
 	list_for_each_entry(alg, &crypto_alg_list, cra_list) {
-		err = crypto_report_alg(alg, &info);
-		if (err)
-			goto out_err;
+		if (pos >= start_pos) {
+			res = crypto_report_alg(alg, &info);
+			if (res == -EMSGSIZE)
+				break;
+			if (res)
+				goto out;
+		}
+		pos++;
 	}
-
+	cb->args[0] = pos;
+	res = skb->len;
 out:
-	return skb->len;
-out_err:
-	return err;
+	up_read(&crypto_alg_sem);
+	return res;
 }
 
 static int crypto_dump_report_done(struct netlink_callback *cb)
@@ -483,7 +486,7 @@ static int crypto_user_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	if ((type == (CRYPTO_MSG_GETALG - CRYPTO_MSG_BASE) &&
 	    (nlh->nlmsg_flags & NLM_F_DUMP))) {
 		struct crypto_alg *alg;
-		u16 dump_alloc = 0;
+		unsigned long dump_alloc = 0;
 
 		if (link->dump == NULL)
 			return -EINVAL;
@@ -491,16 +494,16 @@ static int crypto_user_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		down_read(&crypto_alg_sem);
 		list_for_each_entry(alg, &crypto_alg_list, cra_list)
 			dump_alloc += CRYPTO_REPORT_MAXSIZE;
+		up_read(&crypto_alg_sem);
 
 		{
 			struct netlink_dump_control c = {
 				.dump = link->dump,
 				.done = link->done,
-				.min_dump_alloc = dump_alloc,
+				.min_dump_alloc = min(dump_alloc, 65535UL),
 			};
 			err = netlink_dump_start(crypto_nlsk, skb, nlh, &c);
 		}
-		up_read(&crypto_alg_sem);
 
 		return err;
 	}
-- 
2.20.1

