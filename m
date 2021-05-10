Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFFC3782EC
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbhEJKlP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:41:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:48344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232561AbhEJKho (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:37:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DF6A614A5;
        Mon, 10 May 2021 10:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642585;
        bh=syKh//1zBxW2bsse+MyJ23bGnmI1eRoX+g3ccSSI15E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NGpyv9B6TZLqZcT5ahX/h62NaMi3m1L/mx76AmOzJEPsuWGTiot24Lz56Ner0F8q9
         7vRqMmIZvy68hz51lbQnCCYWn8N02kUDr1v1PlLVYpo4EEGr+CD8KDfKDA21+tMl04
         00DiQAjb13cdqMER1C78G+cF+fAw1lp4SLNjjpJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.4 153/184] crypto: rng - fix crypto_rng_reset() refcounting when !CRYPTO_STATS
Date:   Mon, 10 May 2021 12:20:47 +0200
Message-Id: <20210510101955.134007028@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510101950.200777181@linuxfoundation.org>
References: <20210510101950.200777181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 30d0f6a956fc74bb2e948398daf3278c6b08c7e9 upstream.

crypto_stats_get() is a no-op when the kernel is compiled without
CONFIG_CRYPTO_STATS, so pairing it with crypto_alg_put() unconditionally
(as crypto_rng_reset() does) is wrong.

Fix this by moving the call to crypto_stats_get() to just before the
actual algorithm operation which might need it.  This makes it always
paired with crypto_stats_rng_seed().

Fixes: eed74b3eba9e ("crypto: rng - Fix a refcounting bug in crypto_rng_reset()")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/rng.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -34,22 +34,18 @@ int crypto_rng_reset(struct crypto_rng *
 	u8 *buf = NULL;
 	int err;
 
-	crypto_stats_get(alg);
 	if (!seed && slen) {
 		buf = kmalloc(slen, GFP_KERNEL);
-		if (!buf) {
-			crypto_alg_put(alg);
+		if (!buf)
 			return -ENOMEM;
-		}
 
 		err = get_random_bytes_wait(buf, slen);
-		if (err) {
-			crypto_alg_put(alg);
+		if (err)
 			goto out;
-		}
 		seed = buf;
 	}
 
+	crypto_stats_get(alg);
 	err = crypto_rng_alg(tfm)->seed(tfm, seed, slen);
 	crypto_stats_rng_seed(alg, err);
 out:


