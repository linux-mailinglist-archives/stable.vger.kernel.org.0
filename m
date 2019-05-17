Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 713BC2184C
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 14:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728958AbfEQMjm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 08:39:42 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:38291 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728957AbfEQMjl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 08:39:41 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id C3F27319;
        Fri, 17 May 2019 08:39:40 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 17 May 2019 08:39:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=bLKhmD
        0tegxFqbCnevJeTl8p/003o/8yrZR8Q6vR1XM=; b=YT2HxZQ8t7RLGhH60JYXeP
        EbK/Lp7O/dAOrdownvSK4R4x2JOL8O8XxkpvYB5J0utDaVawBdHSXpMBQvTEP8Wl
        eqJd41kgo+DEwKX7/+45JK57Di6+inhnhPK/iaklZCrwEni8uDQ0E9Zc4vXOYSky
        yCusdqNyP8VbN81ocdZvjqQJH2LD0BKhK2GldNZXRVVLMi4Ok4kEFNw5qeE9YBTy
        HAheaoknFkkVoYBnNnJDXEu82YT3g5bw2Umqm+k0l+AB2Injcy1I/REeUpX2HH8z
        kr/PuPDGKquYOB85VyXhUAcwouPVmiIzHMHuh/hrz1KPwx/cdY/axzRP0hYfm5Yw
        ==
X-ME-Sender: <xms:jKveXLqY3aoxblMylo0zR25OfabPieRZ4RLYytvn26QArUz_fjckqQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtvddgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepge
X-ME-Proxy: <xmx:jKveXPoRqQQ8w3hM5fV2ZDYzxUIvkbQcqHH2EK9OCsh0lFJZ-RM-7Q>
    <xmx:jKveXCRCbeM45K2sswu11uoZULPs85hjLI-12ubKl9RdgT9MaY7yDQ>
    <xmx:jKveXApXY0puPcbOP4LpUOA83uzbBh8c_6ZNG-QD1KzvS941E7MeXw>
    <xmx:jKveXMO7CmMRLjj1_Ujaog6MIAxF2-BHU--2lvA3XmV9_KhuKV5aDg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id CAD7D10379;
        Fri, 17 May 2019 08:39:39 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: arm/aes-neonbs - don't access already-freed walk.iv" failed to apply to 4.4-stable tree
To:     ebiggers@google.com, herbert@gondor.apana.org.au,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 17 May 2019 14:39:30 +0200
Message-ID: <15580967703179@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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
 

