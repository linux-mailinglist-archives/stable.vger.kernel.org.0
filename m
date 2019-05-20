Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 296E02372B
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 15:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388307AbfETMWI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:22:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:36056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387846AbfETMWH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:22:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 956C421019;
        Mon, 20 May 2019 12:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354927;
        bh=qFmpTGVLbRz4mBAxDSw8NvsVt8gaTA3Jkk/yCGfbfOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T+vYmI8MIREEDV/D/I1/PAj8KjVpkAq7+xXjFFH100czZLvYDqKoNJkTJB/CI0mDu
         6KvX6k5gUFJ+2ULUA3WHmvhcPlkvJSYRjc+8stwhuG5jkM5PmhAyncgaUAKe3ZzcXZ
         t9vpUBl0gTQg51jlZHwOL6selaZzh0LjnXKmXQLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.19 031/105] crypto: arm64/aes-neonbs - dont access already-freed walk.iv
Date:   Mon, 20 May 2019 14:13:37 +0200
Message-Id: <20190520115249.201384561@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115247.060821231@linuxfoundation.org>
References: <20190520115247.060821231@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 4a8108b70508df0b6c4ffa4a3974dab93dcbe851 upstream.

If the user-provided IV needs to be aligned to the algorithm's
alignmask, then skcipher_walk_virt() copies the IV into a new aligned
buffer walk.iv.  But skcipher_walk_virt() can fail afterwards, and then
if the caller unconditionally accesses walk.iv, it's a use-after-free.

xts-aes-neonbs doesn't set an alignmask, so currently it isn't affected
by this despite unconditionally accessing walk.iv.  However this is more
subtle than desired, and unconditionally accessing walk.iv has caused a
real problem in other algorithms.  Thus, update xts-aes-neonbs to start
checking the return value of skcipher_walk_virt().

Fixes: 1abee99eafab ("crypto: arm64/aes - reimplement bit-sliced ARM/NEON implementation for arm64")
Cc: <stable@vger.kernel.org> # v4.11+
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/crypto/aes-neonbs-glue.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/crypto/aes-neonbs-glue.c
+++ b/arch/arm64/crypto/aes-neonbs-glue.c
@@ -304,6 +304,8 @@ static int __xts_crypt(struct skcipher_r
 	int err;
 
 	err = skcipher_walk_virt(&walk, req, false);
+	if (err)
+		return err;
 
 	kernel_neon_begin();
 	neon_aes_ecb_encrypt(walk.iv, walk.iv, ctx->twkey, ctx->key.rounds, 1);


