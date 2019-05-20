Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 702A223667
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388704AbfETMpl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:45:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:41990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388920AbfETM0e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:26:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AD2D20645;
        Mon, 20 May 2019 12:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355193;
        bh=rmffEHAhueVbENrjSXU8HS106ZhLz6ZVTjAObWH7Cp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qn8gG3jvLTEFlyaFJ9DdhrcZlmWwsYLqwewLZwpkRYmf/ti/EHoFhW4+89AqM0i9u
         neYa9Lwzh4aCQHMJu0psHkCCuKew3EP8Q+quAdECFdoEfF0S9MejkOZ37YArPPdVHK
         B7d6AjOXn8ni97vAm9Ij3QvHAdK0n6ZQpwmd3JJw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.0 027/123] crypto: salsa20 - dont access already-freed walk.iv
Date:   Mon, 20 May 2019 14:13:27 +0200
Message-Id: <20190520115246.604854229@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115245.439864225@linuxfoundation.org>
References: <20190520115245.439864225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit edaf28e996af69222b2cb40455dbb5459c2b875a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/salsa20_generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/crypto/salsa20_generic.c
+++ b/crypto/salsa20_generic.c
@@ -161,7 +161,7 @@ static int salsa20_crypt(struct skcipher
 
 	err = skcipher_walk_virt(&walk, req, false);
 
-	salsa20_init(state, ctx, walk.iv);
+	salsa20_init(state, ctx, req->iv);
 
 	while (walk.nbytes > 0) {
 		unsigned int nbytes = walk.nbytes;


