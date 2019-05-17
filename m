Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1B7421853
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 14:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728169AbfEQMju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 08:39:50 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:43215 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728990AbfEQMjt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 08:39:49 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id C1B6244A;
        Fri, 17 May 2019 08:39:48 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 17 May 2019 08:39:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=wKv1xk
        oLrQsDqfTaFyQUwSjD25sGAS4IvsuURgTZDrU=; b=dO4Ek6+UCd2TloqmTjHy4V
        t78YaR4lJgLov4/kBqs9t+9pPtTNgpE7LDuihLqUW3pxeZ2sYpZXHPMkzBTax+Tm
        CLpy6YYE8lysCWu0TfBP+BCHdEKtZ7O60/yE6OH6LR9vavmwLM0XJEA+0jvFpQgb
        Td/IZUxANWO4VBhV1LwQlU+fHT/S/RjZwkqszfATF+gHEfeaxCJ+k8eDWPa44W+p
        lRvcvhLixo1cwNXceNmdSD0HfyEwsxDbnN5hkD/zShSeQ+k+ZK+pftLjmQ8g4be2
        Kxku22dbZuT4QAzgqYCLPq/PoN5qtObYT+fzD5bzRl9jBbJBHMOWhId4XyDFCCDA
        ==
X-ME-Sender: <xms:lKveXAYaIhsitoM4ZkviyVw2j0tvQoiWg7RUA1y0N0XYSuXoOAqtaA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtvddgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgephe
X-ME-Proxy: <xmx:lKveXCPejgbNI-7JrxGBquN2_ZrBxEbdhQZgja1CuW0WestaGSvRng>
    <xmx:lKveXD6dOSYPR9kfDK5ZzwQsedR9k5mZBsJdBXPagAVyNCZi5nQrug>
    <xmx:lKveXNdy99pMuZCU5w48L9iy4y9XHB9ldx_Iid_pItO0XdLQsIZNZA>
    <xmx:lKveXGZAfTSb4EOo0biCKARqQLv7aVmJolM4UCImHTxa21E3kG1TBQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D12F48005B;
        Fri, 17 May 2019 08:39:47 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: arm64/aes-neonbs - don't access already-freed walk.iv" failed to apply to 4.14-stable tree
To:     ebiggers@google.com, herbert@gondor.apana.org.au,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 17 May 2019 14:39:46 +0200
Message-ID: <1558096786211204@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4a8108b70508df0b6c4ffa4a3974dab93dcbe851 Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Tue, 9 Apr 2019 23:46:32 -0700
Subject: [PATCH] crypto: arm64/aes-neonbs - don't access already-freed walk.iv

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

diff --git a/arch/arm64/crypto/aes-neonbs-glue.c b/arch/arm64/crypto/aes-neonbs-glue.c
index 4737b6c6c5cf..514455117733 100644
--- a/arch/arm64/crypto/aes-neonbs-glue.c
+++ b/arch/arm64/crypto/aes-neonbs-glue.c
@@ -304,6 +304,8 @@ static int __xts_crypt(struct skcipher_request *req,
 	int err;
 
 	err = skcipher_walk_virt(&walk, req, false);
+	if (err)
+		return err;
 
 	kernel_neon_begin();
 	neon_aes_ecb_encrypt(walk.iv, walk.iv, ctx->twkey, ctx->key.rounds, 1);

