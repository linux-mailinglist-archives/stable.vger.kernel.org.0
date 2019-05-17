Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 987472182A
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 14:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728474AbfEQMar (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 08:30:47 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:38433 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728365AbfEQMar (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 08:30:47 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 04F07477;
        Fri, 17 May 2019 08:30:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 17 May 2019 08:30:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=72Wjvv
        Cq0FQeOYJ8t3sJqUbKHwwrTlPiEzweXvL7AOQ=; b=pFrKtfiRYB0x750uDihaVF
        j9EfE3A8+OqHVCkAi7uLumQD/4aRTA/QIk/eaX221/jE/D5h4BIKE0iWxIJyLJrS
        A2N4XnwUvJWzUVWSm8vUWN2NyyDHzZz5E5HBTioUeSXQj87Vx+uJZM7pfkTjplDJ
        i4UQ3qDoplnYDhJlm6/snx6SNTqGR6b3ko7pcLr5P2wozfylkLd8bN+eQF/iUWpN
        6iHMoLYdqcq61w9fv9vRwyTBPcHvzw2nbUVJ5NmtqYOdbZ49jdiB70lYzNujzuMx
        i69UHdbBzKstRhaq85hOWEUngyKV0eccFVvaj8PIXCzC+MQa5u8UccpK4imSY4/A
        ==
X-ME-Sender: <xms:daneXAz2HoxxL_KY3OzSwW9XuZlA86bVOGxxWsEMrqp-XOjHEj0OzQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtvddgheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:daneXIiAclYpPTdUxqO4Yk1Y2ztHDB_sXd-FWv5baX_D4knQOXwB2w>
    <xmx:daneXNXWRd0dfJGeP9inlx284hmxEHGEptoNHqwd-A-QXc4Jatx7pw>
    <xmx:daneXC3gGsdaNrHYOaLScbjRIuQf7kW4t49Z65bQklcFtMbhT10wXw>
    <xmx:daneXDVKo8dOChF3vme8w6w3OM6BLLCR1_hXHjqNTvOPyU3mAARHDw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 01E5880068;
        Fri, 17 May 2019 08:30:44 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: salsa20 - don't access already-freed walk.iv" failed to apply to 4.4-stable tree
To:     ebiggers@google.com, herbert@gondor.apana.org.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 17 May 2019 14:30:34 +0200
Message-ID: <1558096234113132@kroah.com>
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

