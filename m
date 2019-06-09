Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 212CB3A9EC
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732614AbfFIQ4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:56:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:59174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733010AbfFIQ4f (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:56:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7ED8206BB;
        Sun,  9 Jun 2019 16:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099394;
        bh=R/yjFv/0UjcudjWxHx6PQ67vPOHjbVxpIqZDivmGaY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bXcNENVNUEOaUxXfC+ztkgBFUqZ5IQ8KV+NMU9NtnEtyauplo9YJuwoK+Em+ZQk05
         8C+L870OVfP/xVaOoqiaeGrytkalxHvhAk827XCqV1JeXRIdrLTKhzOZji4HXhlxA6
         yOePE4Wq03LBfPntNxVL9EkXL/wSIUpKjUzpB9Hc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.4 026/241] crypto: arm/aes-neonbs - dont access already-freed walk.iv
Date:   Sun,  9 Jun 2019 18:39:28 +0200
Message-Id: <20190609164148.534219882@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 767f015ea0b7ab9d60432ff6cd06b664fd71f50f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 arch/arm/crypto/aesbs-glue.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/arm/crypto/aesbs-glue.c
+++ b/arch/arm/crypto/aesbs-glue.c
@@ -259,6 +259,8 @@ static int aesbs_xts_encrypt(struct blkc
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt_block(desc, &walk, 8 * AES_BLOCK_SIZE);
+	if (err)
+		return err;
 
 	/* generate the initial tweak */
 	AES_encrypt(walk.iv, walk.iv, &ctx->twkey);
@@ -283,6 +285,8 @@ static int aesbs_xts_decrypt(struct blkc
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt_block(desc, &walk, 8 * AES_BLOCK_SIZE);
+	if (err)
+		return err;
 
 	/* generate the initial tweak */
 	AES_encrypt(walk.iv, walk.iv, &ctx->twkey);


