Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F34CC32EA7A
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233038AbhCEMis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:38:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:52080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233035AbhCEMi1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:38:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E073A6501E;
        Fri,  5 Mar 2021 12:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947907;
        bh=LnCYH0ucP9V04qC80BtfOoEd8k9sEqLeitH81aqb1z8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SYytswZOx7YMsgRzN+n9Oi6jnAjtYuIyaSSYocx46fnn73SWdM9+r4b4PiBRnhQQW
         Yotjnpe2PtFi1VwDV9tPBtOKLq59AOy5whlADSF2owBizXdIACqHVVnytSSSo8Y8MV
         ghnmcV0JFexMBJJCnTz/d5trXYz2VOj78gSH+r+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 31/52] crypto: tcrypt - avoid signed overflow in byte count
Date:   Fri,  5 Mar 2021 13:22:02 +0100
Message-Id: <20210305120855.193376479@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120853.659441428@linuxfoundation.org>
References: <20210305120853.659441428@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index d332988eb8de..bf797c613ba2 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -202,8 +202,8 @@ static int test_mb_aead_jiffies(struct test_mb_aead_data *data, int enc,
 			goto out;
 	}
 
-	pr_cont("%d operations in %d seconds (%ld bytes)\n",
-		bcount * num_mb, secs, (long)bcount * blen * num_mb);
+	pr_cont("%d operations in %d seconds (%llu bytes)\n",
+		bcount * num_mb, secs, (u64)bcount * blen * num_mb);
 
 out:
 	kfree(rc);
@@ -472,8 +472,8 @@ static int test_aead_jiffies(struct aead_request *req, int enc,
 			return ret;
 	}
 
-	printk("%d operations in %d seconds (%ld bytes)\n",
-	       bcount, secs, (long)bcount * blen);
+	pr_cont("%d operations in %d seconds (%llu bytes)\n",
+	        bcount, secs, (u64)bcount * blen);
 	return 0;
 }
 
@@ -763,8 +763,8 @@ static int test_mb_ahash_jiffies(struct test_mb_ahash_data *data, int blen,
 			goto out;
 	}
 
-	pr_cont("%d operations in %d seconds (%ld bytes)\n",
-		bcount * num_mb, secs, (long)bcount * blen * num_mb);
+	pr_cont("%d operations in %d seconds (%llu bytes)\n",
+		bcount * num_mb, secs, (u64)bcount * blen * num_mb);
 
 out:
 	kfree(rc);
@@ -1200,8 +1200,8 @@ static int test_mb_acipher_jiffies(struct test_mb_skcipher_data *data, int enc,
 			goto out;
 	}
 
-	pr_cont("%d operations in %d seconds (%ld bytes)\n",
-		bcount * num_mb, secs, (long)bcount * blen * num_mb);
+	pr_cont("%d operations in %d seconds (%llu bytes)\n",
+		bcount * num_mb, secs, (u64)bcount * blen * num_mb);
 
 out:
 	kfree(rc);
@@ -1438,8 +1438,8 @@ static int test_acipher_jiffies(struct skcipher_request *req, int enc,
 			return ret;
 	}
 
-	pr_cont("%d operations in %d seconds (%ld bytes)\n",
-		bcount, secs, (long)bcount * blen);
+	pr_cont("%d operations in %d seconds (%llu bytes)\n",
+		bcount, secs, (u64)bcount * blen);
 	return 0;
 }
 
-- 
2.30.1



