Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77E11B5C79
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729576AbfIRG0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:26:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:48274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730381AbfIRG0o (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:26:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4254A21927;
        Wed, 18 Sep 2019 06:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568788003;
        bh=MTzfv2u6I4W1kbjdjtXIlDgI+1BXx2NM1ZGxnvUDH04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wxxNBA+LW5egQ2CKvjWVemu8y6NJlNJ9Rp5wx1mYopvrRe0Sv17VwJqBoChIhZnHc
         8/gFsPSEeJTeYGM8Hhe/4Lxl7k6m4riNklWGHMhCwwhOLJyg4+zkTY+9fSiKTmGzY2
         JFD4KltUzSjNfZ1swxE1Cor4BnPhtVpZTVxIwVzw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.2 64/85] crypto: talitos - fix CTR alg blocksize
Date:   Wed, 18 Sep 2019 08:19:22 +0200
Message-Id: <20190918061237.424028985@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
References: <20190918061234.107708857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit b9a05b6041cb9810a291315569b2af0d63c3680a upstream.

CTR has a blocksize of 1.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Fixes: 5e75ae1b3cef ("crypto: talitos - add new crypto modes")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/talitos.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -2792,7 +2792,7 @@ static struct talitos_alg_template drive
 		.alg.crypto = {
 			.cra_name = "ctr(aes)",
 			.cra_driver_name = "ctr-aes-talitos",
-			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_blocksize = 1,
 			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
 				     CRYPTO_ALG_ASYNC,
 			.cra_ablkcipher = {


