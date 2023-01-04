Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E792D65D8BB
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239884AbjADQRf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:17:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239883AbjADQRc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:17:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6864B167CF
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:17:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 017BD617A9
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:17:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E6DC433EF;
        Wed,  4 Jan 2023 16:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849050;
        bh=scUS75onR2KFU/u0/I8GBilWvW5VJ6Ac1LkMBjnP7hQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jlLI5leoTXEvXocpmFsN+AkUPbeg6X7KOhjyK7GZ0TysTb0T+jCLT1CYdT4Qf+bZW
         QtVUw8mpbvBWiVlnFxY539zdqb5dM4b0Aeju0Xjeavy7b+KHdSw53kmup3efts6kLy
         JzC82XCGWfEFJ95uULL4k34g/4PweirabbMKKQBM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1 125/207] crypto: ccree,hisilicon - Fix dependencies to correct algorithm
Date:   Wed,  4 Jan 2023 17:06:23 +0100
Message-Id: <20230104160515.873105666@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

commit 2ae6feb1a1f6678fe11864f1b6920ed10b09ad6a upstream.

Commit d2825fa9365d ("crypto: sm3,sm4 - move into crypto directory") moves
the SM3 and SM4 stand-alone library and the algorithm implementation for
the Crypto API into the same directory, and the corresponding relationship
of Kconfig is modified, CONFIG_CRYPTO_SM3/4 corresponds to the stand-alone
library of SM3/4, and CONFIG_CRYPTO_SM3/4_GENERIC corresponds to the
algorithm implementation for the Crypto API. Therefore, it is necessary
for this module to depend on the correct algorithm.

Fixes: d2825fa9365d ("crypto: sm3,sm4 - move into crypto directory")
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: stable@vger.kernel.org # v5.19+
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/Kconfig           |    4 ++--
 drivers/crypto/hisilicon/Kconfig |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -790,8 +790,8 @@ config CRYPTO_DEV_CCREE
 	select CRYPTO_ECB
 	select CRYPTO_CTR
 	select CRYPTO_XTS
-	select CRYPTO_SM4
-	select CRYPTO_SM3
+	select CRYPTO_SM4_GENERIC
+	select CRYPTO_SM3_GENERIC
 	help
 	  Say 'Y' to enable a driver for the REE interface of the Arm
 	  TrustZone CryptoCell family of processors. Currently the
--- a/drivers/crypto/hisilicon/Kconfig
+++ b/drivers/crypto/hisilicon/Kconfig
@@ -26,7 +26,7 @@ config CRYPTO_DEV_HISI_SEC2
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
-	select CRYPTO_SM4
+	select CRYPTO_SM4_GENERIC
 	depends on PCI && PCI_MSI
 	depends on UACCE || UACCE=n
 	depends on ARM64 || (COMPILE_TEST && 64BIT)


