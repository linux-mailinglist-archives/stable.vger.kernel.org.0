Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10D3E21CC4
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 19:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbfEQRqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 13:46:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:47794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbfEQRqg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 May 2019 13:46:36 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09B6220848;
        Fri, 17 May 2019 17:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558115195;
        bh=/UdeNLzzUtcGnPoJK/QKdak2Jz/errYOGKQrhPH1zH8=;
        h=From:To:Cc:Subject:Date:From;
        b=vacxOagJ1ZDNw1xHYb+6EZkI3mV4NZ4nWnc6WevZXCANMJzGeQzn1mQnxhAuFOvzi
         uXMiN0PzdLLXtjUjzemN3QRl0I3WdUZpE7cZZEAfzFcTdAk4y32Y4xkUxoXzCmuiHh
         sA9aFcqJBUwqQu7DHRFQ2mbndcM1Q5MKwlaDIMjE=
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-crypto@vger.kernel.org
Subject: [PATCH 4.4,4.9] crypto: arm/aes-neonbs - don't access already-freed walk.iv
Date:   Fri, 17 May 2019 10:44:58 -0700
Message-Id: <20190517174458.93755-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 767f015ea0b7ab9d60432ff6cd06b664fd71f50f upstream.
[Please apply to 4.9-stable and earlier.]

If the user-provided IV needs to be aligned to the algorithm's
alignmask, then skcipher_walk_virt() copies the IV into a new aligned
buffer walk.iv.  But skcipher_walk_virt() can fail afterwards, and then
if the caller unconditionally accesses walk.iv, it's a use-after-free.

arm32 xts-aes-neonbs doesn't set an alignmask, so currently it isn't
affected by this despite unconditionally accessing walk.iv.  However
this is more subtle than desired, and it was actually broken prior to
the alignmask being removed by commit cc477bf64573 ("crypto: arm/aes -
replace bit-sliced OpenSSL NEON code").  Thus, update xts-aes-neonbs to
start checking the return value of skcipher_walk_virt().

Fixes: e4e7f10bfc40 ("ARM: add support for bit sliced AES using NEON instructions")
Cc: <stable@vger.kernel.org> # v3.13+
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/arm/crypto/aesbs-glue.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/crypto/aesbs-glue.c b/arch/arm/crypto/aesbs-glue.c
index 5d934a0039d76..cb2486a526e66 100644
--- a/arch/arm/crypto/aesbs-glue.c
+++ b/arch/arm/crypto/aesbs-glue.c
@@ -265,6 +265,8 @@ static int aesbs_xts_encrypt(struct blkcipher_desc *desc,
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt_block(desc, &walk, 8 * AES_BLOCK_SIZE);
+	if (err)
+		return err;
 
 	/* generate the initial tweak */
 	AES_encrypt(walk.iv, walk.iv, &ctx->twkey);
@@ -289,6 +291,8 @@ static int aesbs_xts_decrypt(struct blkcipher_desc *desc,
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt_block(desc, &walk, 8 * AES_BLOCK_SIZE);
+	if (err)
+		return err;
 
 	/* generate the initial tweak */
 	AES_encrypt(walk.iv, walk.iv, &ctx->twkey);
-- 
2.21.0.1020.gf2820cf01a-goog

