Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F40D2355A
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390168AbfETMej (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:34:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:52084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390961AbfETMei (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:34:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C403920815;
        Mon, 20 May 2019 12:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355678;
        bh=qFmpTGVLbRz4mBAxDSw8NvsVt8gaTA3Jkk/yCGfbfOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zxZukvHpB3yOw8q2J/Szab1VZ0U7MQiEeMz7SQFpHmShPhWtBBaYpOzPgE8FCo9XM
         5kvHPrAJJI6XqC6fJo/xn1ctGsNEtEr5UhyIA/2JPkLISsGg5KR6Wo2aqIVqkp3WRZ
         xfwtXAYJbtlXj7TAphXFHXGvcCdfbIJJI21dwHfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.1 042/128] crypto: arm64/aes-neonbs - dont access already-freed walk.iv
Date:   Mon, 20 May 2019 14:13:49 +0200
Message-Id: <20190520115252.564916767@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115249.449077487@linuxfoundation.org>
References: <20190520115249.449077487@linuxfoundation.org>
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


