Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5B403C51C6
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349538AbhGLHna (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:43:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347819AbhGLHkN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:40:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFEFE61622;
        Mon, 12 Jul 2021 07:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075383;
        bh=pPLf09bznnh5Ya+pQxtgRec8xjljCOa6ntnWrxzZKDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SzzpgRN4ECDmDOGWDToA7xpkSACEhR0L+Yo9bHAMZDFcODoGprblv5s0YmbRUNbb2
         3mGGshIThqCFErC2yLtsmz/KAKs3Sk3+LYFvT+bI13/O/UYVyZu0mT4Pp2k/cfIjRY
         2BEHxkpIIPRZpdyB938P20AyDisurKNoUUmDi1o4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Tang <tanghui20@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 159/800] crypto: ecdh - fix ecdh-nist-p192s entry in testmgr
Date:   Mon, 12 Jul 2021 08:03:02 +0200
Message-Id: <20210712060935.370050378@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Tang <tanghui20@huawei.com>

[ Upstream commit 6889fc2104e5d20899b91e61daf07a7524b2010d ]

Add a comment that p192 will fail to register in FIPS mode.

Fix ecdh-nist-p192's entry in testmgr by removing the ifdefs
and not setting fips_allowed.

Signed-off-by: Hui Tang <tanghui20@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/ecdh.c    | 1 +
 crypto/testmgr.c | 3 ---
 crypto/testmgr.h | 2 --
 3 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/crypto/ecdh.c b/crypto/ecdh.c
index 04a427b8c956..4227d35f5485 100644
--- a/crypto/ecdh.c
+++ b/crypto/ecdh.c
@@ -179,6 +179,7 @@ static int ecdh_init(void)
 {
 	int ret;
 
+	/* NIST p192 will fail to register in FIPS mode */
 	ret = crypto_register_kpp(&ecdh_nist_p192);
 	ecdh_nist_p192_registered = ret == 0;
 
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 10c5b3b01ec4..26e40dba9ad2 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4899,15 +4899,12 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 #endif
-#ifndef CONFIG_CRYPTO_FIPS
 		.alg = "ecdh-nist-p192",
 		.test = alg_test_kpp,
-		.fips_allowed = 1,
 		.suite = {
 			.kpp = __VECS(ecdh_p192_tv_template)
 		}
 	}, {
-#endif
 		.alg = "ecdh-nist-p256",
 		.test = alg_test_kpp,
 		.fips_allowed = 1,
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 34e4a3db3991..fe1e59da59ff 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -2685,7 +2685,6 @@ static const struct kpp_testvec curve25519_tv_template[] = {
 }
 };
 
-#ifndef CONFIG_CRYPTO_FIPS
 static const struct kpp_testvec ecdh_p192_tv_template[] = {
 	{
 	.secret =
@@ -2725,7 +2724,6 @@ static const struct kpp_testvec ecdh_p192_tv_template[] = {
 	.expected_ss_size = 24
 	}
 };
-#endif
 
 static const struct kpp_testvec ecdh_p256_tv_template[] = {
 	{
-- 
2.30.2



