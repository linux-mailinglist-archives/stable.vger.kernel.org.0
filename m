Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D211B5D22
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728970AbfIRGbt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:31:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726937AbfIRGXJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:23:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E994521925;
        Wed, 18 Sep 2019 06:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787789;
        bh=1eNGzwi11Oob47SHEzl9EQNO8r30vb6BlsWp3ZXAwUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y1XFjN3i6Z4YLINehxZPE88dKaJxUfvEX4be75fJmkcNbwdXjABVabwrqjOjZ/FM1
         dG8OT0pfhPWYH/nB99AosCMfe1YVYPLWEBC6m/eknvZxmlCmJ1XcqB1QuBhbVWO+z2
         yeSG9ZAEr4DljO+Lj0hqlwe23Vk6dCw7Odbcn17Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.19 35/50] crypto: talitos - fix CTR alg blocksize
Date:   Wed, 18 Sep 2019 08:19:18 +0200
Message-Id: <20190918061227.243434422@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061223.116178343@linuxfoundation.org>
References: <20190918061223.116178343@linuxfoundation.org>
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
@@ -2728,7 +2728,7 @@ static struct talitos_alg_template drive
 		.alg.crypto = {
 			.cra_name = "ctr(aes)",
 			.cra_driver_name = "ctr-aes-talitos",
-			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_blocksize = 1,
 			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
 				     CRYPTO_ALG_ASYNC,
 			.cra_ablkcipher = {


