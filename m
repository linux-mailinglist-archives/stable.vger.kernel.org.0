Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D34917389D
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388229AbfGXTbZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:31:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:52188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388468AbfGXTbV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:31:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD8CE229F4;
        Wed, 24 Jul 2019 19:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996680;
        bh=CsWXcgn08I4mWMWGsG8L3PA7QZFTJ2l3Vf4NjxU9boE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h2JaDDMlD+1d34fLH8CuryzvcFvjMO19PqPYIBw4Zs8b7XKw8qSNvUG5GvOm876/S
         1ycLGxA7QNECMEzZLlYYCGvo+oM839QcoI5S/7PM5wW0z9+DvlasOE6rPdfqN4KH2/
         wMNaGj6QDRF5sxJs+zapYW8q74SI+kAhAPsVdGgA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 181/413] crypto: asymmetric_keys - select CRYPTO_HASH where needed
Date:   Wed, 24 Jul 2019 21:17:52 +0200
Message-Id: <20190724191747.763814357@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 90acc0653d2bee203174e66d519fbaaa513502de ]

Build testing with some core crypto options disabled revealed
a few modules that are missing CRYPTO_HASH:

crypto/asymmetric_keys/x509_public_key.o: In function `x509_get_sig_params':
x509_public_key.c:(.text+0x4c7): undefined reference to `crypto_alloc_shash'
x509_public_key.c:(.text+0x5e5): undefined reference to `crypto_shash_digest'
crypto/asymmetric_keys/pkcs7_verify.o: In function `pkcs7_digest.isra.0':
pkcs7_verify.c:(.text+0xab): undefined reference to `crypto_alloc_shash'
pkcs7_verify.c:(.text+0x1b2): undefined reference to `crypto_shash_digest'
pkcs7_verify.c:(.text+0x3c1): undefined reference to `crypto_shash_update'
pkcs7_verify.c:(.text+0x411): undefined reference to `crypto_shash_finup'

This normally doesn't show up in randconfig tests because there is
a large number of other options that select CRYPTO_HASH.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/asymmetric_keys/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
index be70ca6c85d3..1f1f004dc757 100644
--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -15,6 +15,7 @@ config ASYMMETRIC_PUBLIC_KEY_SUBTYPE
 	select MPILIB
 	select CRYPTO_HASH_INFO
 	select CRYPTO_AKCIPHER
+	select CRYPTO_HASH
 	help
 	  This option provides support for asymmetric public key type handling.
 	  If signature generation and/or verification are to be used,
@@ -65,6 +66,7 @@ config TPM_KEY_PARSER
 config PKCS7_MESSAGE_PARSER
 	tristate "PKCS#7 message parser"
 	depends on X509_CERTIFICATE_PARSER
+	select CRYPTO_HASH
 	select ASN1
 	select OID_REGISTRY
 	help
@@ -87,6 +89,7 @@ config SIGNED_PE_FILE_VERIFICATION
 	bool "Support for PE file signature verification"
 	depends on PKCS7_MESSAGE_PARSER=y
 	depends on SYSTEM_DATA_VERIFICATION
+	select CRYPTO_HASH
 	select ASN1
 	select OID_REGISTRY
 	help
-- 
2.20.1



