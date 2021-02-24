Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AADD323CB7
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234111AbhBXMxv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 07:53:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:50301 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232746AbhBXMwd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 07:52:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1D4864F15;
        Wed, 24 Feb 2021 12:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171065;
        bh=HF84UwZ0abikhsS6ww7lKnzi8JNPGkQuP+2U4pdT06U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MS8kone9uqLL1JwG5CD2NdQbj36X4l5ObuK8acDySG+znts916GZOUJxhOm3qO6oW
         DtFRJZ9DkNSRr+/qLy3OD8zD7TIwuazUlDPyfWB0SD7fInJpk7BVyyC6uWZEIl1eh+
         p0DpD6LIy1ak00kAGrEKAQuKPr6i1vCRxqGZ0/rAtlb3XD63CfBX8tIIiXfrR1ochf
         cjJwlhRmNTHkJ0J4txDGoKYoU9YsPdLD+czvDACB0GnTaIYhuyo/JCe+UbD2V+czTE
         NpiKl3Jo6KqKag507GZcc2Ucu3hVp3+JXlSGu+l3hOQr9u1wOq8W1ZMTyipeAe65n3
         q3p7zQgm/+wrw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 28/67] crypto: tcrypt - avoid signed overflow in byte count
Date:   Wed, 24 Feb 2021 07:49:46 -0500
Message-Id: <20210224125026.481804-28-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125026.481804-1-sashal@kernel.org>
References: <20210224125026.481804-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 303fd3e1c771077e32e96e5788817f025f0067e2 ]

The signed long type used for printing the number of bytes processed in
tcrypt benchmarks limits the range to -/+ 2 GiB, which is not sufficient
to cover the performance of common accelerated ciphers such as AES-NI
when benchmarked with sec=1. So switch to u64 instead.

While at it, fix up a missing printk->pr_cont conversion in the AEAD
benchmark.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/tcrypt.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index a647bb298fbce..a4a11d2b57bd8 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -199,8 +199,8 @@ static int test_mb_aead_jiffies(struct test_mb_aead_data *data, int enc,
 			goto out;
 	}
 
-	pr_cont("%d operations in %d seconds (%ld bytes)\n",
-		bcount * num_mb, secs, (long)bcount * blen * num_mb);
+	pr_cont("%d operations in %d seconds (%llu bytes)\n",
+		bcount * num_mb, secs, (u64)bcount * blen * num_mb);
 
 out:
 	kfree(rc);
@@ -471,8 +471,8 @@ static int test_aead_jiffies(struct aead_request *req, int enc,
 			return ret;
 	}
 
-	printk("%d operations in %d seconds (%ld bytes)\n",
-	       bcount, secs, (long)bcount * blen);
+	pr_cont("%d operations in %d seconds (%llu bytes)\n",
+	        bcount, secs, (u64)bcount * blen);
 	return 0;
 }
 
@@ -764,8 +764,8 @@ static int test_mb_ahash_jiffies(struct test_mb_ahash_data *data, int blen,
 			goto out;
 	}
 
-	pr_cont("%d operations in %d seconds (%ld bytes)\n",
-		bcount * num_mb, secs, (long)bcount * blen * num_mb);
+	pr_cont("%d operations in %d seconds (%llu bytes)\n",
+		bcount * num_mb, secs, (u64)bcount * blen * num_mb);
 
 out:
 	kfree(rc);
@@ -1201,8 +1201,8 @@ static int test_mb_acipher_jiffies(struct test_mb_skcipher_data *data, int enc,
 			goto out;
 	}
 
-	pr_cont("%d operations in %d seconds (%ld bytes)\n",
-		bcount * num_mb, secs, (long)bcount * blen * num_mb);
+	pr_cont("%d operations in %d seconds (%llu bytes)\n",
+		bcount * num_mb, secs, (u64)bcount * blen * num_mb);
 
 out:
 	kfree(rc);
@@ -1441,8 +1441,8 @@ static int test_acipher_jiffies(struct skcipher_request *req, int enc,
 			return ret;
 	}
 
-	pr_cont("%d operations in %d seconds (%ld bytes)\n",
-		bcount, secs, (long)bcount * blen);
+	pr_cont("%d operations in %d seconds (%llu bytes)\n",
+		bcount, secs, (u64)bcount * blen);
 	return 0;
 }
 
-- 
2.27.0

