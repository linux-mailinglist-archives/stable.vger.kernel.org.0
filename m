Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFC463C4ED2
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241374AbhGLHVt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:21:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:55898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239190AbhGLHTJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:19:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 511B461621;
        Mon, 12 Jul 2021 07:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074172;
        bh=dUnfEYdCnzav6JuAymT1HVAkcNz9jqlKCpblGKHx1hA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W4YNYuA/FRg3ktBOvC290MgAOYPqlTszIAxZ7B091nABKQzCNhUapLoEQZeHyAL2B
         hnGu31EgdS/NGD3mRFRPxMnUGadNXop8GU4avU1U22IASQk5NiH9UUq++qnXW3c7rm
         WBVkkEX9utlQJwuyn0DMYIN5S1CoPXgWDLLz3x9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 447/700] selftests: tls: fix chacha+bidir tests
Date:   Mon, 12 Jul 2021 08:08:50 +0200
Message-Id: <20210712061024.092009687@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 291c53e4dacd3a2cc3152d8af37f07f8496c594a ]

ChaCha support did not adjust the bidirectional test.
We need to set up KTLS in reverse direction correctly,
otherwise these two cases will fail:

  tls.12_chacha.bidir
  tls.13_chacha.bidir

Fixes: 4f336e88a870 ("selftests/tls: add CHACHA20-POLY1305 to tls selftests")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Vadim Fedorenko <vfedorenko@novek.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/tls.c | 67 ++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 28 deletions(-)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index 58fea6eb588d..112d41d01b12 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -25,6 +25,35 @@
 #define TLS_PAYLOAD_MAX_LEN 16384
 #define SOL_TLS 282
 
+struct tls_crypto_info_keys {
+	union {
+		struct tls12_crypto_info_aes_gcm_128 aes128;
+		struct tls12_crypto_info_chacha20_poly1305 chacha20;
+	};
+	size_t len;
+};
+
+static void tls_crypto_info_init(uint16_t tls_version, uint16_t cipher_type,
+				 struct tls_crypto_info_keys *tls12)
+{
+	memset(tls12, 0, sizeof(*tls12));
+
+	switch (cipher_type) {
+	case TLS_CIPHER_CHACHA20_POLY1305:
+		tls12->len = sizeof(struct tls12_crypto_info_chacha20_poly1305);
+		tls12->chacha20.info.version = tls_version;
+		tls12->chacha20.info.cipher_type = cipher_type;
+		break;
+	case TLS_CIPHER_AES_GCM_128:
+		tls12->len = sizeof(struct tls12_crypto_info_aes_gcm_128);
+		tls12->aes128.info.version = tls_version;
+		tls12->aes128.info.cipher_type = cipher_type;
+		break;
+	default:
+		break;
+	}
+}
+
 static void memrnd(void *s, size_t n)
 {
 	int *dword = s;
@@ -145,33 +174,16 @@ FIXTURE_VARIANT_ADD(tls, 13_chacha)
 
 FIXTURE_SETUP(tls)
 {
-	union {
-		struct tls12_crypto_info_aes_gcm_128 aes128;
-		struct tls12_crypto_info_chacha20_poly1305 chacha20;
-	} tls12;
+	struct tls_crypto_info_keys tls12;
 	struct sockaddr_in addr;
 	socklen_t len;
 	int sfd, ret;
-	size_t tls12_sz;
 
 	self->notls = false;
 	len = sizeof(addr);
 
-	memset(&tls12, 0, sizeof(tls12));
-	switch (variant->cipher_type) {
-	case TLS_CIPHER_CHACHA20_POLY1305:
-		tls12_sz = sizeof(struct tls12_crypto_info_chacha20_poly1305);
-		tls12.chacha20.info.version = variant->tls_version;
-		tls12.chacha20.info.cipher_type = variant->cipher_type;
-		break;
-	case TLS_CIPHER_AES_GCM_128:
-		tls12_sz = sizeof(struct tls12_crypto_info_aes_gcm_128);
-		tls12.aes128.info.version = variant->tls_version;
-		tls12.aes128.info.cipher_type = variant->cipher_type;
-		break;
-	default:
-		tls12_sz = 0;
-	}
+	tls_crypto_info_init(variant->tls_version, variant->cipher_type,
+			     &tls12);
 
 	addr.sin_family = AF_INET;
 	addr.sin_addr.s_addr = htonl(INADDR_ANY);
@@ -199,7 +211,7 @@ FIXTURE_SETUP(tls)
 
 	if (!self->notls) {
 		ret = setsockopt(self->fd, SOL_TLS, TLS_TX, &tls12,
-				 tls12_sz);
+				 tls12.len);
 		ASSERT_EQ(ret, 0);
 	}
 
@@ -212,7 +224,7 @@ FIXTURE_SETUP(tls)
 		ASSERT_EQ(ret, 0);
 
 		ret = setsockopt(self->cfd, SOL_TLS, TLS_RX, &tls12,
-				 tls12_sz);
+				 tls12.len);
 		ASSERT_EQ(ret, 0);
 	}
 
@@ -854,18 +866,17 @@ TEST_F(tls, bidir)
 	int ret;
 
 	if (!self->notls) {
-		struct tls12_crypto_info_aes_gcm_128 tls12;
+		struct tls_crypto_info_keys tls12;
 
-		memset(&tls12, 0, sizeof(tls12));
-		tls12.info.version = variant->tls_version;
-		tls12.info.cipher_type = TLS_CIPHER_AES_GCM_128;
+		tls_crypto_info_init(variant->tls_version, variant->cipher_type,
+				     &tls12);
 
 		ret = setsockopt(self->fd, SOL_TLS, TLS_RX, &tls12,
-				 sizeof(tls12));
+				 tls12.len);
 		ASSERT_EQ(ret, 0);
 
 		ret = setsockopt(self->cfd, SOL_TLS, TLS_TX, &tls12,
-				 sizeof(tls12));
+				 tls12.len);
 		ASSERT_EQ(ret, 0);
 	}
 
-- 
2.30.2



