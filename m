Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D668D4090C5
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244553AbhIMNze (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:55:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:34352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244057AbhIMNwo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:52:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5F06617E1;
        Mon, 13 Sep 2021 13:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540066;
        bh=ApwTNw57Xn5wd0hDAzN4+R9h7oL8Q3f2/lpZI7iL3iA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2kU+smX3Ag7NRofRVmUVHdVa4n70zn0wT6Rs0/1mKMdLFBMhOidiV1ELWhmy2J7W8
         zUaq/e/ylpT/b8hwH0Zp81qOA+SGUa2tg7/YeXyJgfU2C0x1y3qE1z65MKHMgBgQVB
         DNDOHDzd9ZQDjX74wm39OzMD5L8UaOLFW8l0Exw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Vitaly Chikunov <vt@altlinux.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 037/300] crypto: tcrypt - Fix missing return value check
Date:   Mon, 13 Sep 2021 15:11:38 +0200
Message-Id: <20210913131110.577991902@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

[ Upstream commit 7b3d52683b3a47c0ba1dfd6b5994a3a795b06972 ]

There are several places where the return value check of crypto_aead_setkey
and crypto_aead_setauthsize were lost. It is necessary to add these checks.

At the same time, move the crypto_aead_setauthsize() call out of the loop,
and only need to call it once after load transform.

Fixee: 53f52d7aecb4 ("crypto: tcrypt - Added speed tests for AEAD crypto alogrithms in tcrypt test suite")
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Reviewed-by: Vitaly Chikunov <vt@altlinux.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/tcrypt.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 6b7c158dc508..f9c00875bc0e 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -290,6 +290,11 @@ static void test_mb_aead_speed(const char *algo, int enc, int secs,
 	}
 
 	ret = crypto_aead_setauthsize(tfm, authsize);
+	if (ret) {
+		pr_err("alg: aead: Failed to setauthsize for %s: %d\n", algo,
+		       ret);
+		goto out_free_tfm;
+	}
 
 	for (i = 0; i < num_mb; ++i)
 		if (testmgr_alloc_buf(data[i].xbuf)) {
@@ -315,7 +320,7 @@ static void test_mb_aead_speed(const char *algo, int enc, int secs,
 	for (i = 0; i < num_mb; ++i) {
 		data[i].req = aead_request_alloc(tfm, GFP_KERNEL);
 		if (!data[i].req) {
-			pr_err("alg: skcipher: Failed to allocate request for %s\n",
+			pr_err("alg: aead: Failed to allocate request for %s\n",
 			       algo);
 			while (i--)
 				aead_request_free(data[i].req);
@@ -567,13 +572,19 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 	sgout = &sg[9];
 
 	tfm = crypto_alloc_aead(algo, 0, 0);
-
 	if (IS_ERR(tfm)) {
 		pr_err("alg: aead: Failed to load transform for %s: %ld\n", algo,
 		       PTR_ERR(tfm));
 		goto out_notfm;
 	}
 
+	ret = crypto_aead_setauthsize(tfm, authsize);
+	if (ret) {
+		pr_err("alg: aead: Failed to setauthsize for %s: %d\n", algo,
+		       ret);
+		goto out_noreq;
+	}
+
 	crypto_init_wait(&wait);
 	printk(KERN_INFO "\ntesting speed of %s (%s) %s\n", algo,
 			get_driver_name(crypto_aead, tfm), e);
@@ -611,8 +622,13 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 					break;
 				}
 			}
+
 			ret = crypto_aead_setkey(tfm, key, *keysize);
-			ret = crypto_aead_setauthsize(tfm, authsize);
+			if (ret) {
+				pr_err("setkey() failed flags=%x: %d\n",
+					crypto_aead_get_flags(tfm), ret);
+				goto out;
+			}
 
 			iv_len = crypto_aead_ivsize(tfm);
 			if (iv_len)
@@ -622,15 +638,8 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 			printk(KERN_INFO "test %u (%d bit key, %d byte blocks): ",
 					i, *keysize * 8, bs);
 
-
 			memset(tvmem[0], 0xff, PAGE_SIZE);
 
-			if (ret) {
-				pr_err("setkey() failed flags=%x\n",
-						crypto_aead_get_flags(tfm));
-				goto out;
-			}
-
 			sg_init_aead(sg, xbuf, bs + (enc ? 0 : authsize),
 				     assoc, aad_size);
 
-- 
2.30.2



