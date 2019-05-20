Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA521235CC
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387431AbfETMjD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:39:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:51678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390091AbfETMeX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:34:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C4F8204FD;
        Mon, 20 May 2019 12:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355662;
        bh=e0wQ/Or/KATeiOfZ/Wp3Ts3mjkNeCXdisU7ebNssEb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GXWW69w+TJNSXTH3a+owcjcHdHqtF2k4tqDjFxWUJDc9H01NpSbiaHvP/MsBqa1Cp
         llKYudFGU/RUc6p69kViMwbVPz1XhCE3ycWm/5wXCblUII/292HIs768ge60Hwt1Oa
         h1kuhPkxEHiY2pQMUwcc7gCDioOZw0j87vRQW53U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.1 041/128] crypto: arm/aes-neonbs - dont access already-freed walk.iv
Date:   Mon, 20 May 2019 14:13:48 +0200
Message-Id: <20190520115252.502974135@linuxfoundation.org>
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
 arch/arm/crypto/aes-neonbs-glue.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm/crypto/aes-neonbs-glue.c
+++ b/arch/arm/crypto/aes-neonbs-glue.c
@@ -278,6 +278,8 @@ static int __xts_crypt(struct skcipher_r
 	int err;
 
 	err = skcipher_walk_virt(&walk, req, true);
+	if (err)
+		return err;
 
 	crypto_cipher_encrypt_one(ctx->tweak_tfm, walk.iv, walk.iv);
 


