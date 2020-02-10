Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6EB51579D3
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728952AbgBJNSV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:18:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:60300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728943AbgBJMhy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:54 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC3B424683;
        Mon, 10 Feb 2020 12:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338273;
        bh=dUtKteR2WoIeg1A7CGdtIUOi2x62xV37HKgyFxC3M7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yRJJkec5FXZVrx3TcnJI4QJTe18FTsPky2crQrcF33io1RUYQ7MkGEexKI0pVeOon
         tTAkfODzr/h7mOrm9kwXRC7o6DH1vsMYSc3pitpXgEgTx1Qa4BwRaM+ZoIzEBUK353
         M/E28wIgnxS2hKoigDkQvKQZ5qNBo6K14HZl2WNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.4 158/309] crypto: arm64/ghash-neon - bump priority to 150
Date:   Mon, 10 Feb 2020 04:31:54 -0800
Message-Id: <20200210122421.396536087@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit 5441c6507bc84166e9227e9370a56c57ba13794a upstream.

The SIMD based GHASH implementation for arm64 is typically much faster
than the generic one, and doesn't use any lookup tables, so it is
clearly preferred when available. So bump the priority to reflect that.

Fixes: 5a22b198cd527447 ("crypto: arm64/ghash - register PMULL variants ...")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/crypto/ghash-ce-glue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/crypto/ghash-ce-glue.c
+++ b/arch/arm64/crypto/ghash-ce-glue.c
@@ -261,7 +261,7 @@ static int ghash_setkey(struct crypto_sh
 static struct shash_alg ghash_alg[] = {{
 	.base.cra_name		= "ghash",
 	.base.cra_driver_name	= "ghash-neon",
-	.base.cra_priority	= 100,
+	.base.cra_priority	= 150,
 	.base.cra_blocksize	= GHASH_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct ghash_key),
 	.base.cra_module	= THIS_MODULE,


