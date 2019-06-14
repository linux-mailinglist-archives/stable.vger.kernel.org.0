Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB04D46A82
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 22:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbfFNUhw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 16:37:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:50956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726762AbfFNU3F (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 16:29:05 -0400
Received: from sasha-vm.mshome.net (unknown [131.107.159.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8F7821872;
        Fri, 14 Jun 2019 20:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560544144;
        bh=1UHtruAhcIKtbxyrI9yPCM/Ec1ZsP54ZaoOnGt4gJt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RZ9TzDrh0rZq9lMzmld85Jz8N/6bxUAsD6kG3LtefVhq9ay/jY+5U0OCsnJ2yJoVw
         Ysj9iJ7F0j5jc50y3O/m4O9wvqOpyI53o1YUdVMbtmq0HzvWYLLf4v5X9Cy1VfV9aA
         h/cJfDZCte7kwV4ZoKU+e4dt/rz3iUous+XPtcdI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 26/59] crypto: hmac - fix memory leak in hmac_init_tfm()
Date:   Fri, 14 Jun 2019 16:28:10 -0400
Message-Id: <20190614202843.26941-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190614202843.26941-1-sashal@kernel.org>
References: <20190614202843.26941-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit 7829a0c1cb9c80debfb4fdb49b4d90019f2ea1ac ]

When I added the sanity check of 'descsize', I missed that the child
hash tfm needs to be freed if the sanity check fails.  Of course this
should never happen, hence the use of WARN_ON(), but it should be fixed.

Fixes: e1354400b25d ("crypto: hash - fix incorrect HASH_MAX_DESCSIZE")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/hmac.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/crypto/hmac.c b/crypto/hmac.c
index 4b8c8ee8f15c..c623778b36ba 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -168,8 +168,10 @@ static int hmac_init_tfm(struct crypto_tfm *tfm)
 
 	parent->descsize = sizeof(struct shash_desc) +
 			   crypto_shash_descsize(hash);
-	if (WARN_ON(parent->descsize > HASH_MAX_DESCSIZE))
+	if (WARN_ON(parent->descsize > HASH_MAX_DESCSIZE)) {
+		crypto_free_shash(hash);
 		return -EINVAL;
+	}
 
 	ctx->hash = hash;
 	return 0;
-- 
2.20.1

