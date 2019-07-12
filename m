Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29AC366EB2
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbfGLMZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:25:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727624AbfGLMZ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:25:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2D8C216B7;
        Fri, 12 Jul 2019 12:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934329;
        bh=Ise7hNeluUyWS2rzd+m7obAgIjz8DDTBbGfFLWoQ8V4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NlyRBD2oMFWKYxhLVJbMk7QnPfpjM3mFModGIQoA7GihoyAsURXZ0bMD9oXgbRp3E
         1/9WnRxS9FOSC5stjlZeA1moWgAmCEIS5SPZ1d1AuNVBDsa13Dpnc/JkYU4QZhTtcF
         c1U7YrhEiqvWHv39fLucvhgvRd5qCOXeY/SHipic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.1 002/138] crypto: lrw - use correct alignmask
Date:   Fri, 12 Jul 2019 14:17:46 +0200
Message-Id: <20190712121628.831649607@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
References: <20190712121628.731888964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 20a0f9761343fba9b25ea46bd3a3e5e533d974f8 upstream.

Commit c778f96bf347 ("crypto: lrw - Optimize tweak computation")
incorrectly reduced the alignmask of LRW instances from
'__alignof__(u64) - 1' to '__alignof__(__be32) - 1'.

However, xor_tweak() and setkey() assume that the data and key,
respectively, are aligned to 'be128', which has u64 alignment.

Fix the alignmask to be at least '__alignof__(be128) - 1'.

Fixes: c778f96bf347 ("crypto: lrw - Optimize tweak computation")
Cc: <stable@vger.kernel.org> # v4.20+
Cc: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/lrw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -388,7 +388,7 @@ static int create(struct crypto_template
 	inst->alg.base.cra_priority = alg->base.cra_priority;
 	inst->alg.base.cra_blocksize = LRW_BLOCK_SIZE;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask |
-				       (__alignof__(__be32) - 1);
+				       (__alignof__(be128) - 1);
 
 	inst->alg.ivsize = LRW_BLOCK_SIZE;
 	inst->alg.min_keysize = crypto_skcipher_alg_min_keysize(alg) +


