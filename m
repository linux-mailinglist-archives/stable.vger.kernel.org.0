Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7644F2C71
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354065AbiDEKLT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347180AbiDEJZT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:25:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAAD8DBD0B;
        Tue,  5 Apr 2022 02:14:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95CDCB81B62;
        Tue,  5 Apr 2022 09:14:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C32C385A4;
        Tue,  5 Apr 2022 09:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150055;
        bh=WEzZA7KphCwxsPg16crtXDZyTJfB5qhlsaeZdSfVPQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dyEsZoFfM6QUfo6HyhO622O0UnLQFesA43KetCXMM8lA2a7qeODrD6jqUPOeXlEOy
         6T6/RO+EOW6V1PeZjla+R0vEUNixnEvflcb3jIcvof+qMj0Gt1mlO4yExn1C4mhU4V
         oZA8/FA+m00C+HtZ2+tj3HxN1NTd1OU47hITSxSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.16 0938/1017] crypto: arm/aes-neonbs-cbc - Select generic cbc and aes
Date:   Tue,  5 Apr 2022 09:30:51 +0200
Message-Id: <20220405070422.057549347@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

commit c8bd296cca3434b13b28b074eaeb78a23284de77 upstream.

The algorithm __cbc-aes-neonbs requires a fallback so we need
to select the config options for them or otherwise it will fail
to register on boot-up.

Fixes: 00b99ad2bac2 ("crypto: arm/aes-neonbs - Use generic cbc...")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/crypto/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -102,6 +102,8 @@ config CRYPTO_AES_ARM_BS
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_SKCIPHER
 	select CRYPTO_LIB_AES
+	select CRYPTO_AES
+	select CRYPTO_CBC
 	select CRYPTO_SIMD
 	help
 	  Use a faster and more secure NEON based implementation of AES in CBC,


