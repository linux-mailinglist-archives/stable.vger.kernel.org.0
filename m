Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C464C4997F0
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449997AbiAXVRk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:17:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1448767AbiAXVNq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:13:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F423C09F48F;
        Mon, 24 Jan 2022 12:11:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 360C4B81229;
        Mon, 24 Jan 2022 20:11:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66800C340E5;
        Mon, 24 Jan 2022 20:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055064;
        bh=CJ40P4ApaPT+yCkIt+R5SbXdg418MmTbXEyQxB9sxMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ekvRSSrmktBXuhiQiXLkk3eUU4AdxXm4XC/CdNrsf9K9JB0u7EwFs3Z8AjWLTd+2E
         iNjXWYnRyAzTGChBzRBtmquEo7Z7GQZomT+qhEFhmZV/i0J9rBHO36xVrqfALBqMUa
         nwqOaNmQ+C3DgwPhtWH/wFsBWEsPit4TkWzgQjNs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.15 029/846] crypto: x86/aesni - dont require alignment of data
Date:   Mon, 24 Jan 2022 19:32:26 +0100
Message-Id: <20220124184101.923485350@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

commit d480a26bdf872529919e7c30e17f79d0d7b8c4da upstream.

x86 AES-NI routines can deal with unaligned data. Crypto context
(key, iv etc.) have to be aligned but we take care of that separately
by copying it onto the stack. We were feeding unaligned data into
crypto routines up until commit 83c83e658863 ("crypto: aesni -
refactor scatterlist processing") switched to use the full
skcipher API which uses cra_alignmask to decide data alignment.

This fixes 21% performance regression in kTLS.

Tested by booting with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y
(and running thru various kTLS packets).

CC: stable@vger.kernel.org # 5.15+
Fixes: 83c83e658863 ("crypto: aesni - refactor scatterlist processing")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/crypto/aesni-intel_glue.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -1107,7 +1107,7 @@ static struct aead_alg aesni_aeads[] = {
 		.cra_flags		= CRYPTO_ALG_INTERNAL,
 		.cra_blocksize		= 1,
 		.cra_ctxsize		= sizeof(struct aesni_rfc4106_gcm_ctx),
-		.cra_alignmask		= AESNI_ALIGN - 1,
+		.cra_alignmask		= 0,
 		.cra_module		= THIS_MODULE,
 	},
 }, {
@@ -1124,7 +1124,7 @@ static struct aead_alg aesni_aeads[] = {
 		.cra_flags		= CRYPTO_ALG_INTERNAL,
 		.cra_blocksize		= 1,
 		.cra_ctxsize		= sizeof(struct generic_gcmaes_ctx),
-		.cra_alignmask		= AESNI_ALIGN - 1,
+		.cra_alignmask		= 0,
 		.cra_module		= THIS_MODULE,
 	},
 } };


