Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5531621C70
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 19:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbfEQR1o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 13:27:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:39398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbfEQR1o (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 May 2019 13:27:44 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FDA420848;
        Fri, 17 May 2019 17:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558114063;
        bh=Xga6mR5QWud1vIhJKDo3wcSdq0YO+At9wb1Myjxo9Os=;
        h=From:To:Cc:Subject:Date:From;
        b=TxhM730wg0Ht9HH5QQOjK4KEtQrIQ2uOS4LU7Xt8cyCD8Cm5TiHMaEF6r3I9LBBHz
         VQxtwxq9a5Xh1+3n6dOb56WDvBNQnQ6snA/SA1O5Nd+t15dQd4tUi7VEzQIzL+B4WG
         v4bnyxFYlmdFiSWXJFOuApueD3TMieg+4Xc7prrg=
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-crypto@vger.kernel.org
Subject: [PATCH 4.4,4.9,4.14] crypto: salsa20 - don't access already-freed walk.iv
Date:   Fri, 17 May 2019 10:25:58 -0700
Message-Id: <20190517172558.56229-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit edaf28e996af69222b2cb40455dbb5459c2b875a upstream.
[Please apply to 4.14-stable and earlier.]

If the user-provided IV needs to be aligned to the algorithm's
alignmask, then skcipher_walk_virt() copies the IV into a new aligned
buffer walk.iv.  But skcipher_walk_virt() can fail afterwards, and then
if the caller unconditionally accesses walk.iv, it's a use-after-free.

salsa20-generic doesn't set an alignmask, so currently it isn't affected
by this despite unconditionally accessing walk.iv.  However this is more
subtle than desired, and it was actually broken prior to the alignmask
being removed by commit b62b3db76f73 ("crypto: salsa20-generic - cleanup
and convert to skcipher API").

Since salsa20-generic does not update the IV and does not need any IV
alignment, update it to use req->iv instead of walk.iv.

Fixes: 2407d60872dd ("[CRYPTO] salsa20: Salsa20 stream cipher")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/salsa20_generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/salsa20_generic.c b/crypto/salsa20_generic.c
index d7da0eea5622a..319d9962552e1 100644
--- a/crypto/salsa20_generic.c
+++ b/crypto/salsa20_generic.c
@@ -186,7 +186,7 @@ static int encrypt(struct blkcipher_desc *desc,
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt_block(desc, &walk, 64);
 
-	salsa20_ivsetup(ctx, walk.iv);
+	salsa20_ivsetup(ctx, desc->info);
 
 	while (walk.nbytes >= 64) {
 		salsa20_encrypt_bytes(ctx, walk.dst.virt.addr,
-- 
2.21.0.1020.gf2820cf01a-goog

