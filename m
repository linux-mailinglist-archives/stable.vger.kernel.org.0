Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 069803BB033
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbhGDXHu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:07:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:46010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230251AbhGDXHo (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:07:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EFA4613E9;
        Sun,  4 Jul 2021 23:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625439908;
        bh=pPLf09bznnh5Ya+pQxtgRec8xjljCOa6ntnWrxzZKDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mYg5aYREUHIPkR5zgoxoDW+XtOuCCmWWjRo756zVKcTXaSazDxyuhLJaolClguJXe
         uSb+4vO4J59pGyklanm6fMm0PgIDx15P1t9YcsCy549kZ4lA538MOwEr0uWhumpRYT
         tmt8xYuu3AW3Rau+iLjSqK1rQbeRZvPFRrERH/gvW9Gd4XdAGTbrDuYRmLPRQ3+Hwd
         CHMGWqNjq/f49ah/PI3sOWsXWaELFCtJsh/5PiuRU626jHMAsvjawo0260C9NGCdlz
         KxDS8HffAf9Dr7XTpWl5+WpU5kJtRUcHvFipopDzFO81yIDKzy91mQEILqXrwl0Fw6
         IWB+PHMOosTZg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hui Tang <tanghui20@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 34/85] crypto: ecdh - fix ecdh-nist-p192's entry in testmgr
Date:   Sun,  4 Jul 2021 19:03:29 -0400
Message-Id: <20210704230420.1488358-34-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230420.1488358-1-sashal@kernel.org>
References: <20210704230420.1488358-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

