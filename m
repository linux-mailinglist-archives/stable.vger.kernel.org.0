Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B129121834
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 14:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728430AbfEQMd2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 08:33:28 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:47477 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728387AbfEQMd2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 08:33:28 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 189D247A;
        Fri, 17 May 2019 08:33:27 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 17 May 2019 08:33:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=s/ewSG
        b3vxKpJXW3pjhgh1aFk1w/ZvxzZ0kt/90Yi3w=; b=pIhgXxBBkAjzaREUrxfxcc
        LsSX8aQCjKsKMhdEN/3pwKzaKizqF3gtP8w2khQVErI5wmNmrpyYsPh08lAz/lkC
        eoPDqgxKXIIyT7d9+AGAoRfO7mny/tZ91CkAWEEvu/iC2o0lyPfB8eKoSFe6tMiS
        jh7Hsi5SXNtLokSdmBgqLqmicKLA3SIqvU+ImEnE9G6Bc2hJ1lLhBMKVLIOwcAfE
        yUUAeDXJT7VAEWFAH2LsXsUp2PizJmhjZNYWy4SgWqPjtA7Arfw9v7zflFNlsXCN
        sQdB68zF0OLWlOWn5uXVNbI7/o9Scv4lf0unF3NBoIQuVqFxutsiMaZjgXd13kYg
        ==
X-ME-Sender: <xms:FareXOSUPyaec55EcEAF3441zwUVywbwDoLMzozKIy5oIuyjjh58sQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtvddgheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepje
X-ME-Proxy: <xmx:FareXPLTj3tOTxODFdAoiPr3Ydxia-z5eetfMsqB0vmWAMySRjRnyw>
    <xmx:FareXJsu1ms5gvKh6or2_fS7T6CGqiisBzD3lWy1iUbnsx32kymjXg>
    <xmx:FareXFKjEWAEGZ2G0a_HHF5HFSHbpGZln_20l-QitNPuOG07O_kdvA>
    <xmx:FqreXMdlMZstAZY0H_7GlV_7hOkMtJled2MvemfNrLtHCUDxxu9Yvw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7E87E10379;
        Fri, 17 May 2019 08:33:25 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: skcipher - don't WARN on unprocessed data after slow" failed to apply to 4.9-stable tree
To:     ebiggers@google.com, herbert@gondor.apana.org.au,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 17 May 2019 14:33:23 +0200
Message-ID: <15580964033563@kroah.com>
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

