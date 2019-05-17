Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2266B2184B
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 14:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728955AbfEQMjf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 08:39:35 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:60313 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728169AbfEQMje (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 08:39:34 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 7228D31F;
        Fri, 17 May 2019 08:39:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 17 May 2019 08:39:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=bkgbiG
        YpNGLbd0a0OIsZ7YLrYHD+ClO+4o0APQf1CPM=; b=ITHt78KlBV1q4Awnj6yzpI
        qGtVZteQ3KYhLeOZpN6Gpv/9ObemlAa6Ux5JSSY27f/9XcAME7r6xzEPmydwjJHo
        U8TwzvU4NeGmwm6QRWX3S4A5Nsyrt/3TxrBfuQ2UYYZIDYlOPpCKbquOHqOobcFh
        qITvlkBxzS6NomK9pyYC0nm1Wm92vSYPFs3udM0ueVTvgd4A8QZ5GkJ033jJEpQ0
        dNJjr4GXn0MLXDgg81EL+uGzaH1IQCmG/yYzHawsz/YSoL8ER2o7xf+mBkJqufXL
        Xi0himiEMbvUV/LcMi+S+uF3gZ65IyoTBsJ+M7hHr/aY1C4WY7roOIm2U2J74KAg
        ==
X-ME-Sender: <xms:hKveXBOMJQuFzD-SCqhHOX7z0Yd0H4CWTqAAeS7vOc8WF9tFqyrtbQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtvddgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepfe
X-ME-Proxy: <xmx:hKveXNTntwdlRo5-1jF00g3119aQ6jwcNJsFJB21q9Xc9wkATHkj8A>
    <xmx:hKveXISW11z5dLOEm-hs64e0yZ4p2V0EozSV-QHDw0IXrhnyvWLJyQ>
    <xmx:hKveXHYNxbZpt2poCKLx-PKBYFviIgYpqS5Gk8XelPd-_i3jHyBmUg>
    <xmx:haveXIQBVEPRUJmmBHBMTyToOTeVT3DjCLeabWyyyEUXluPeFGbOEA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D4E8280061;
        Fri, 17 May 2019 08:39:31 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: arm/aes-neonbs - don't access already-freed walk.iv" failed to apply to 4.9-stable tree
To:     ebiggers@google.com, herbert@gondor.apana.org.au,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 17 May 2019 14:39:29 +0200
Message-ID: <155809676936131@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 767f015ea0b7ab9d60432ff6cd06b664fd71f50f Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Tue, 9 Apr 2019 23:46:31 -0700
Subject: [PATCH] crypto: arm/aes-neonbs - don't access already-freed walk.iv

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

diff --git a/arch/arm/crypto/aes-neonbs-glue.c b/arch/arm/crypto/aes-neonbs-glue.c
index 07e31941dc67..617c2c99ebfb 100644
--- a/arch/arm/crypto/aes-neonbs-glue.c
+++ b/arch/arm/crypto/aes-neonbs-glue.c
@@ -278,6 +278,8 @@ static int __xts_crypt(struct skcipher_request *req,
 	int err;
 
 	err = skcipher_walk_virt(&walk, req, true);
+	if (err)
+		return err;
 
 	crypto_cipher_encrypt_one(ctx->tweak_tfm, walk.iv, walk.iv);
 

