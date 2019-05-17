Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 147A621835
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 14:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728781AbfEQMdf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 08:33:35 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:33127 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728387AbfEQMdf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 08:33:35 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 71F66474;
        Fri, 17 May 2019 08:33:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 17 May 2019 08:33:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=dI3Gb1
        Vy3HDZT+hufMW7BhJ0IEI2EcAReOxKKo+50Vk=; b=2tF54OwSUQI4p566kl14Ox
        C9smG2a7NVHfwUfrgg5ycQGFARRmQc7C3maSf/ef4Qg8n6u5ljiIGkdRT44+oSR7
        D8tRg0oQFu81bv5ud/djqr/01nY8B1Or6FXv7YCSY8nLAU8MWlq+T4kaZvNcf5EP
        SRWlB8lqhMe8xqq5xvKMat1AuUULGj2jdhBuj3nGnTO1/EKdYI+qkwAV/teshMnz
        pVXW1pPFp/o+AG2tueJ9K37vg+249zGVHXQHr/3dMgNB+a6vCXNHjd+j+Onoi5aP
        B1hOqQNDlhLZUo10GFWhFp7mmyiZzsreMUh344t+jKHMTgRxk++SvM1+5Lh0OyBw
        ==
X-ME-Sender: <xms:HareXIevZA8Vl44-28jZRpJe3dxVQzrZGBM923kdD4yLrj8vfrtDrQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtvddgheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepke
X-ME-Proxy: <xmx:HareXMRJ2jUNzqYhpLzmHJgppjXYU-Vo5Tf4BJ7d4-7UYKGRRcW4dA>
    <xmx:HareXHqGvH2bqDdCZpxMfOGvpuCd_sqzppKtQSXo-DvRkW-V4Vg4-g>
    <xmx:HareXC5SZFq8nHjKLH4gRWIYk-ZF9wstButCSUxsJqQAbJ49scQxJg>
    <xmx:HqreXLTBaYzbihrxnI70nqgEp9KpoX1DfA7XnvXgEeFtid7HZiy2zQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8A5C08005B;
        Fri, 17 May 2019 08:33:33 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: skcipher - don't WARN on unprocessed data after slow" failed to apply to 4.4-stable tree
To:     ebiggers@google.com, herbert@gondor.apana.org.au,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 17 May 2019 14:33:24 +0200
Message-ID: <1558096404118107@kroah.com>
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

From dcaca01a42cc2c425154a13412b4124293a6e11e Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Sun, 31 Mar 2019 13:04:15 -0700
Subject: [PATCH] crypto: skcipher - don't WARN on unprocessed data after slow
 walk step

skcipher_walk_done() assumes it's a bug if, after the "slow" path is
executed where the next chunk of data is processed via a bounce buffer,
the algorithm says it didn't process all bytes.  Thus it WARNs on this.

However, this can happen legitimately when the message needs to be
evenly divisible into "blocks" but isn't, and the algorithm has a
'walksize' greater than the block size.  For example, ecb-aes-neonbs
sets 'walksize' to 128 bytes and only supports messages evenly divisible
into 16-byte blocks.  If, say, 17 message bytes remain but they straddle
scatterlist elements, the skcipher_walk code will take the "slow" path
and pass the algorithm all 17 bytes in the bounce buffer.  But the
algorithm will only be able to process 16 bytes, triggering the WARN.

Fix this by just removing the WARN_ON().  Returning -EINVAL, as the code
already does, is the right behavior.

This bug was detected by my patches that improve testmgr to fuzz
algorithms against their generic implementation.

Fixes: b286d8b1a690 ("crypto: skcipher - Add skcipher walk interface")
Cc: <stable@vger.kernel.org> # v4.10+
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index bcf13d95f54a..2e66f312e2c4 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -131,8 +131,13 @@ int skcipher_walk_done(struct skcipher_walk *walk, int err)
 		memcpy(walk->dst.virt.addr, walk->page, n);
 		skcipher_unmap_dst(walk);
 	} else if (unlikely(walk->flags & SKCIPHER_WALK_SLOW)) {
-		if (WARN_ON(err)) {
-			/* unexpected case; didn't process all bytes */
+		if (err) {
+			/*
+			 * Didn't process all bytes.  Either the algorithm is
+			 * broken, or this was the last step and it turned out
+			 * the message wasn't evenly divisible into blocks but
+			 * the algorithm requires it.
+			 */
 			err = -EINVAL;
 			goto finish;
 		}

