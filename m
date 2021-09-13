Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2119E4093C5
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344841AbhIMOXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:23:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:39704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346225AbhIMOVT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:21:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40DD561B2D;
        Mon, 13 Sep 2021 13:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540829;
        bh=6AkgcefdX8RMUOHmbdDoRVQalXnWARQVGajw38GXG2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rCKwGLaxn9y4dJU8sXXCclFRpitHKQabUqou1vOSMhIc+Xz7qZBYN0fFkVMf/FqLp
         Yy1jah2RY0hyY9HkpmbKatLec2Vxi8bQzAuXu0ZIyfE/G10mo6/oIFDy0qMrXfY+0s
         /iVnJbGE5n7WnOZtRJ6SFH5gOYL+r7P0SGg8cQTI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        syzbot <syzbot+5d1bad8042a8f0e8117a@syzkaller.appspotmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 051/334] crypto: x86/aes-ni - add missing error checks in XTS code
Date:   Mon, 13 Sep 2021 15:11:45 +0200
Message-Id: <20210913131115.153292424@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 821720b9f34ec54106ebf012a712ba73bbcf47c2 ]

The updated XTS code fails to check the return code of skcipher_walk_virt,
which may lead to skcipher_walk_abort() or skcipher_walk_done() being called
while the walk argument is in an inconsistent state.

So check the return value after each such call, and bail on errors.

Fixes: 2481104fe98d ("crypto: x86/aes-ni-xts - rewrite and drop indirections via glue helper")
Reported-by: Dave Hansen <dave.hansen@intel.com>
Reported-by: syzbot <syzbot+5d1bad8042a8f0e8117a@syzkaller.appspotmail.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/crypto/aesni-intel_glue.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 2144e54a6c89..388643ca2177 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -849,6 +849,8 @@ static int xts_crypt(struct skcipher_request *req, bool encrypt)
 		return -EINVAL;
 
 	err = skcipher_walk_virt(&walk, req, false);
+	if (err)
+		return err;
 
 	if (unlikely(tail > 0 && walk.nbytes < walk.total)) {
 		int blocks = DIV_ROUND_UP(req->cryptlen, AES_BLOCK_SIZE) - 2;
@@ -862,7 +864,10 @@ static int xts_crypt(struct skcipher_request *req, bool encrypt)
 		skcipher_request_set_crypt(&subreq, req->src, req->dst,
 					   blocks * AES_BLOCK_SIZE, req->iv);
 		req = &subreq;
+
 		err = skcipher_walk_virt(&walk, req, false);
+		if (err)
+			return err;
 	} else {
 		tail = 0;
 	}
-- 
2.30.2



