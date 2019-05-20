Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 245A623664
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388942AbfETM0k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:26:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:42022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388017AbfETM0h (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:26:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 254C121479;
        Mon, 20 May 2019 12:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355196;
        bh=8wo6OfwoxBhKFRN2XsFLYEb1OgS1BAfDkVDQKopJ80A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j6YY194Q9axogROGSaVpEvkdMOR3WDtbhpN91u1iI+4y9uc5dZZ2YDQF11fFu2NVM
         pOzP/IN/UOwZSDNTkM/ZK1emdYKD3+s88GSv6R4SycTUJX2FfC2ciOBaK0i5j7HsaD
         PVdXh9MCgUkRxc/RofTe9JGjFAITI5LmfcW6IKsg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.0 028/123] crypto: lrw - dont access already-freed walk.iv
Date:   Mon, 20 May 2019 14:13:28 +0200
Message-Id: <20190520115246.657720313@linuxfoundation.org>
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

commit aec286cd36eacfd797e3d5dab8d5d23c15d1bb5e upstream.

If the user-provided IV needs to be aligned to the algorithm's
alignmask, then skcipher_walk_virt() copies the IV into a new aligned
buffer walk.iv.  But skcipher_walk_virt() can fail afterwards, and then
if the caller unconditionally accesses walk.iv, it's a use-after-free.

Fix this in the LRW template by checking the return value of
skcipher_walk_virt().

This bug was detected by my patches that improve testmgr to fuzz
algorithms against their generic implementation.  When the extra
self-tests were run on a KASAN-enabled kernel, a KASAN use-after-free
splat occured during lrw(aes) testing.

Fixes: c778f96bf347 ("crypto: lrw - Optimize tweak computation")
Cc: <stable@vger.kernel.org> # v4.20+
Cc: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/lrw.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -162,8 +162,10 @@ static int xor_tweak(struct skcipher_req
 	}
 
 	err = skcipher_walk_virt(&w, req, false);
-	iv = (__be32 *)w.iv;
+	if (err)
+		return err;
 
+	iv = (__be32 *)w.iv;
 	counter[0] = be32_to_cpu(iv[3]);
 	counter[1] = be32_to_cpu(iv[2]);
 	counter[2] = be32_to_cpu(iv[1]);


