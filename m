Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEB2221829
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 14:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728409AbfEQMap (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 08:30:45 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:44349 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728365AbfEQMap (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 08:30:45 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 2320B472;
        Fri, 17 May 2019 08:30:44 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 17 May 2019 08:30:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=5C909F
        Ys7W+VJqAKG1+mrOa73YaBemLtFnrKMbxgcoE=; b=Q7hWD9X4zyQaIa8ChKY/o5
        jrPStqybRN1YwN2mF6yan/mvvftaFYe/bbrCdI9wm0z6OzLcv7bMSi4P8dAq/nCd
        lSSNQhKUdgHl260y0fcl+cmGR2HBJvEcL74CYBOxp2GSdQP11jKOn/Avj1vdP3xz
        dNTPXay1tJSZ8hbeWXZh4LrxqXbK6T20Vl/dEAshXkQI/cWTk4HFQJZN1QRjyAcT
        4SRHIg70LJNmz6q+SQGUG8WpIIKKW9OPjGrw0Tik+lPTXh8Qg5rohLZUJKRN+2ZA
        YkVwkfXFVwKNh7ra/HPSEG/nLBsdHSobOn7R0Vq4LNOIWcXQB6EWpphlNron0Shg
        ==
X-ME-Sender: <xms:c6neXIbeVvfzZ3Rm0DActqvCA3-mDXv2Ony6iZF5Cy3Mv0aPGHAhWA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtvddgheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:c6neXAyMMUdt-sPbnRBVoHJrsyXxC4yuomwoLfGOULSZoJwD6Y_U2g>
    <xmx:c6neXMd5bRlkoAjp1ZHUBjKpytfvXPfYnqoA8rmiF2N-pPb648pGFw>
    <xmx:c6neXN5l9I2FTCqpwfiFGPKJ5XcLB3Yqsg1CrXfGo4N7aJVKgzAf2A>
    <xmx:c6neXDxAix2V8zzozu12knHBh_t4w4H_bCtMGX1hrfZrlqgamS8q_Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2BBA480068;
        Fri, 17 May 2019 08:30:43 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: salsa20 - don't access already-freed walk.iv" failed to apply to 4.9-stable tree
To:     ebiggers@google.com, herbert@gondor.apana.org.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 17 May 2019 14:30:33 +0200
Message-ID: <1558096233227191@kroah.com>
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

From edaf28e996af69222b2cb40455dbb5459c2b875a Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Tue, 9 Apr 2019 23:46:30 -0700
Subject: [PATCH] crypto: salsa20 - don't access already-freed walk.iv

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

diff --git a/crypto/salsa20_generic.c b/crypto/salsa20_generic.c
index 443fba09cbed..faed244be316 100644
--- a/crypto/salsa20_generic.c
+++ b/crypto/salsa20_generic.c
@@ -160,7 +160,7 @@ static int salsa20_crypt(struct skcipher_request *req)
 
 	err = skcipher_walk_virt(&walk, req, false);
 
-	salsa20_init(state, ctx, walk.iv);
+	salsa20_init(state, ctx, req->iv);
 
 	while (walk.nbytes > 0) {
 		unsigned int nbytes = walk.nbytes;

