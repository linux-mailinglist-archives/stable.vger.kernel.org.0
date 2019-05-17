Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A48C21901
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 15:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728351AbfEQNSh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 09:18:37 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:34885 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726628AbfEQNSh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 09:18:37 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 4A577203;
        Fri, 17 May 2019 09:18:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 17 May 2019 09:18:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=/t0NvL
        dEfklBAvbetI4go2DKj4hSShLIaVgxFk/vikE=; b=GfcT6Fn96JQ0SYcxaVrWMx
        8buXBuiMLF71cHc72Od4UTt5TU23JGPFfjG0D/TsyRzn+NH7k8yNJ4WgzR0Mxgwc
        Tl5AvQbXI4omEkVfGPfLZh216iCiDMIZe49ZiAXCu/dT4McdiOZw97lWwWXiiX+e
        dg49XBCcHAl/KzJCgujFVQVcT68lWtagh43D/GEc6miGKBlzXl9Jz7kHYmrsUOGt
        8yJvlnAeRIWlXj1CO3D44Tl5fnhz11yA3oMkUCUoLvOtHzX2+ht11vTBUPsh3dso
        dxc2SdYKMpxjvd/qzijzSzYozFZCrnnSQjQE0c+k6zrVwwerGKeOXXihZN1OakFQ
        ==
X-ME-Sender: <xms:qrTeXDYe4WGh1joU6mv7ks2oRMomH0jzYE6sWoONMt1YyuVczrGB5A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtvddgieefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:qrTeXGpW6zw00KofcrIEpR4Akh0jij0LiEXyztRPar9N-GO5gSpbNQ>
    <xmx:qrTeXA_0Obf2pvgWKHl2AInZfHE9y_bMzrX563CTdaoidybAv21ZGg>
    <xmx:qrTeXN9txSP0UUqCg37m-q8hml-uxZUo77cI_BT9noE5rp2rhxchCA>
    <xmx:q7TeXKr44LuX5k2OXDZ4fjlsQqR0yJ8L_2cLi0lQDzz29bDB3VNgYA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4349B103D0;
        Fri, 17 May 2019 09:18:34 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: chacha20poly1305 - set cra_name correctly" failed to apply to 4.4-stable tree
To:     ebiggers@google.com, herbert@gondor.apana.org.au,
        martin@strongswan.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 17 May 2019 15:18:32 +0200
Message-ID: <1558099112162172@kroah.com>
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

From 5e27f38f1f3f45a0c938299c3a34a2d2db77165a Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Sun, 31 Mar 2019 13:04:16 -0700
Subject: [PATCH] crypto: chacha20poly1305 - set cra_name correctly

If the rfc7539 template is instantiated with specific implementations,
e.g. "rfc7539(chacha20-generic,poly1305-generic)" rather than
"rfc7539(chacha20,poly1305)", then the implementation names end up
included in the instance's cra_name.  This is incorrect because it then
prevents all users from allocating "rfc7539(chacha20,poly1305)", if the
highest priority implementations of chacha20 and poly1305 were selected.
Also, the self-tests aren't run on an instance allocated in this way.

Fix it by setting the instance's cra_name from the underlying
algorithms' actual cra_names, rather than from the requested names.
This matches what other templates do.

Fixes: 71ebc4d1b27d ("crypto: chacha20poly1305 - Add a ChaCha20-Poly1305 AEAD construction, RFC7539")
Cc: <stable@vger.kernel.org> # v4.2+
Cc: Martin Willi <martin@strongswan.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Martin Willi <martin@strongswan.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/chacha20poly1305.c b/crypto/chacha20poly1305.c
index ed2e12e26dd8..279d816ab51d 100644
--- a/crypto/chacha20poly1305.c
+++ b/crypto/chacha20poly1305.c
@@ -645,8 +645,8 @@ static int chachapoly_create(struct crypto_template *tmpl, struct rtattr **tb,
 
 	err = -ENAMETOOLONG;
 	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
-		     "%s(%s,%s)", name, chacha_name,
-		     poly_name) >= CRYPTO_MAX_ALG_NAME)
+		     "%s(%s,%s)", name, chacha->base.cra_name,
+		     poly->cra_name) >= CRYPTO_MAX_ALG_NAME)
 		goto out_drop_chacha;
 	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
 		     "%s(%s,%s)", name, chacha->base.cra_driver_name,

