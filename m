Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D223226A56
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732138AbgGTQdO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:33:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:55754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731789AbgGTP4U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:56:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4945C22BEF;
        Mon, 20 Jul 2020 15:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260579;
        bh=dsu5b9IIjFUsGX50qBLDgmJ2Ketn/JuBNyJ68a8xfzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2iapsulwR8of0jvVl2uFjjpLgG1OiQESS9u3q3wIqy9pUTaZ9iV9UzKx/ldnQWAi4
         dkkrjEmkB/yVhXyYmwRXyGA/EV1ZC85OlDe4+vRojdAq8lQRYCyWtDHZnBh5V4q0Rx
         tt2tCTS54YNxs3mtEbOqn7RWEL+1fEIYFZJ6suko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        YueHaibing <yuehaibing@huawei.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH 5.4 002/215] crypto: atmel - Fix build error of CRYPTO_AUTHENC
Date:   Mon, 20 Jul 2020 17:34:44 +0200
Message-Id: <20200720152820.257058678@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

commit aee1f9f3c30e1e20e7f74729ced61eac7d74ca68 upstream.

If CRYPTO_DEV_ATMEL_AUTHENC is m, CRYPTO_DEV_ATMEL_SHA is m,
but CRYPTO_DEV_ATMEL_AES is y, building will fail:

drivers/crypto/atmel-aes.o: In function `atmel_aes_authenc_init_tfm':
atmel-aes.c:(.text+0x670): undefined reference to `atmel_sha_authenc_get_reqsize'
atmel-aes.c:(.text+0x67a): undefined reference to `atmel_sha_authenc_spawn'
drivers/crypto/atmel-aes.o: In function `atmel_aes_authenc_setkey':
atmel-aes.c:(.text+0x7e5): undefined reference to `atmel_sha_authenc_setkey'

Make CRYPTO_DEV_ATMEL_AUTHENC depend on CRYPTO_DEV_ATMEL_AES,
and select CRYPTO_DEV_ATMEL_SHA and CRYPTO_AUTHENC for it under there.

Reported-by: Hulk Robot <hulkci@huawei.com>
Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Fixes: 89a82ef87e01 ("crypto: atmel-authenc - add support to...")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/crypto/Kconfig |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -491,10 +491,9 @@ if CRYPTO_DEV_UX500
 endif # if CRYPTO_DEV_UX500
 
 config CRYPTO_DEV_ATMEL_AUTHENC
-	tristate "Support for Atmel IPSEC/SSL hw accelerator"
+	bool "Support for Atmel IPSEC/SSL hw accelerator"
 	depends on ARCH_AT91 || COMPILE_TEST
-	select CRYPTO_DEV_ATMEL_AES
-	select CRYPTO_DEV_ATMEL_SHA
+	depends on CRYPTO_DEV_ATMEL_AES
 	help
 	  Some Atmel processors can combine the AES and SHA hw accelerators
 	  to enhance support of IPSEC/SSL.
@@ -507,7 +506,8 @@ config CRYPTO_DEV_ATMEL_AES
 	select CRYPTO_AES
 	select CRYPTO_AEAD
 	select CRYPTO_BLKCIPHER
-	select CRYPTO_AUTHENC
+	select CRYPTO_AUTHENC if CRYPTO_DEV_ATMEL_AUTHENC
+	select CRYPTO_DEV_ATMEL_SHA if CRYPTO_DEV_ATMEL_AUTHENC
 	help
 	  Some Atmel processors have AES hw accelerator.
 	  Select this if you want to use the Atmel module for


