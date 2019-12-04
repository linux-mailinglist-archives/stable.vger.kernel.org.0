Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB323113146
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 18:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728382AbfLDR5s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 12:57:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:59026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728342AbfLDR5r (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 12:57:47 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A3A52073B;
        Wed,  4 Dec 2019 17:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482265;
        bh=/K/y9mAFLO3ZbgIplQfPISm5p8dbTxWJd7YRFmLmcso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O01ZZF1VWDqeRUz7CTc8BGrYN5aeiHJIPOvMkWj6lTi8W3/fuqrNw0Trzjzeuk7gN
         NxdzmWfptDo5+0p38lXnLs+Ds6boISagSWYTYxRnffaeShEfoSQ+tMSow5//NOr6jT
         qSoxKglg8DQl1mRYWXzXPY6fBb4C4XqKfS7D1RjE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 18/92] crypto: user - support incremental algorithm dumps
Date:   Wed,  4 Dec 2019 18:49:18 +0100
Message-Id: <20191204174330.692685903@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204174327.215426506@linuxfoundation.org>
References: <20191204174327.215426506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index b93c6db18ed3a..f18dc2d045c2a 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -257,30 +257,33 @@ drop_alg:
 
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
@@ -498,7 +501,7 @@ static int crypto_user_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	if ((type == (CRYPTO_MSG_GETALG - CRYPTO_MSG_BASE) &&
 	    (nlh->nlmsg_flags & NLM_F_DUMP))) {
 		struct crypto_alg *alg;
-		u16 dump_alloc = 0;
+		unsigned long dump_alloc = 0;
 
 		if (link->dump == NULL)
 			return -EINVAL;
@@ -506,16 +509,16 @@ static int crypto_user_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
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



