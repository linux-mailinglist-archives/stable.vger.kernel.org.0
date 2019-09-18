Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4628EB5CC0
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbfIRG26 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:28:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729122AbfIRG0t (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:26:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6F5B21D56;
        Wed, 18 Sep 2019 06:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568788009;
        bh=bPu+3/4phbDt9hZkGJVn6zyvmoiw/xdIracbcaOFdgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IALmzrmgBAYXJBHg2Ad3NLWI/IYfUfXZ+O8oWUwJe3nuIKuqNAO3X5u26QavuAS0M
         8qoEWAyuMScH7JSz/V3C7/yjZdkfBkav6eAelCoCBmtHpzRn17XXgclqMJ9F4Lu1e/
         sgjSlnhSUaS1r5D9VjLWbEy+1zFhhyLr5f9BdwJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.2 66/85] crypto: talitos - fix ECB algs ivsize
Date:   Wed, 18 Sep 2019 08:19:24 +0200
Message-Id: <20190918061237.504666613@linuxfoundation.org>
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

commit d84cc9c9524ec5973a337533e6d8ccd3e5f05f2b upstream.

ECB's ivsize must be 0.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Fixes: 5e75ae1b3cef ("crypto: talitos - add new crypto modes")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/talitos.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -2814,7 +2814,6 @@ static struct talitos_alg_template drive
 			.cra_ablkcipher = {
 				.min_keysize = AES_MIN_KEY_SIZE,
 				.max_keysize = AES_MAX_KEY_SIZE,
-				.ivsize = AES_BLOCK_SIZE,
 				.setkey = ablkcipher_aes_setkey,
 			}
 		},
@@ -2849,7 +2848,6 @@ static struct talitos_alg_template drive
 			.cra_ablkcipher = {
 				.min_keysize = DES_KEY_SIZE,
 				.max_keysize = DES_KEY_SIZE,
-				.ivsize = DES_BLOCK_SIZE,
 				.setkey = ablkcipher_des_setkey,
 			}
 		},
@@ -2885,7 +2883,6 @@ static struct talitos_alg_template drive
 			.cra_ablkcipher = {
 				.min_keysize = DES3_EDE_KEY_SIZE,
 				.max_keysize = DES3_EDE_KEY_SIZE,
-				.ivsize = DES3_EDE_BLOCK_SIZE,
 				.setkey = ablkcipher_des3_setkey,
 			}
 		},


