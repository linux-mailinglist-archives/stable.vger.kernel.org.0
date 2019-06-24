Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B14FE507B4
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730238AbfFXKJI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:09:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:42864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730564AbfFXKIz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:08:55 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CCB3205C9;
        Mon, 24 Jun 2019 10:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370934;
        bh=vRC8nGd9BZ6q8TZ5jkEnycT++YcDV6a94y6g05XjZcE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cq647VavDFH6J8NuY3Vg9F2fJksDqwVwuoijRamGa8QtMFFTw4FzVOzlojBe1rLmX
         H0HLiRBj1OxqKAOwSNA0gwDSKdJGdNnxoYr7E//rm9sr+mcc4vPwnUn0ZIzx4KIwUi
         BHaD0JHqL93ubb9/t5Jy0e5mrTSzpkSJIF4DfaP4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 055/121] crypto: hmac - fix memory leak in hmac_init_tfm()
Date:   Mon, 24 Jun 2019 17:56:27 +0800
Message-Id: <20190624092323.522420091@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



