Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C870206340
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388697AbgFWUUO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:20:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:37468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388937AbgFWUUN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:20:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1AFC2073E;
        Tue, 23 Jun 2020 20:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943613;
        bh=wDtFrapsnioZClbXOoiJVnqKh7rXYEFcysXwDAhr9fg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BF1Rm/DjHzwrnnOl31P4BLzWs9KrUuzyUFyefTnzniTimNv0d/gnfpvFj4r9/Ql7c
         AMrvjFKem8lRqRLxc0FtEPNyEmH3HpuOqh2Y9NgG6ElH136GALu8PE7PKuBaaUnkwR
         VY83e1jeY3TO+n6JYUFSqWzsjrxDZD+iMOhDJZdg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 5.7 460/477] crypto: algif_skcipher - Cap recv SG list at ctx->used
Date:   Tue, 23 Jun 2020 21:57:37 +0200
Message-Id: <20200623195429.292966212@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 7cf81954705b7e5b057f7dc39a7ded54422ab6e1 upstream.

Somewhere along the line the cap on the SG list length for receive
was lost.  This patch restores it and removes the subsequent test
which is now redundant.

Fixes: 2d97591ef43d ("crypto: af_alg - consolidation of...")
Cc: <stable@vger.kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Reviewed-by: Stephan Mueller <smueller@chronox.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/algif_skcipher.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -74,14 +74,10 @@ static int _skcipher_recvmsg(struct sock
 		return PTR_ERR(areq);
 
 	/* convert iovecs of output buffers into RX SGL */
-	err = af_alg_get_rsgl(sk, msg, flags, areq, -1, &len);
+	err = af_alg_get_rsgl(sk, msg, flags, areq, ctx->used, &len);
 	if (err)
 		goto free;
 
-	/* Process only as much RX buffers for which we have TX data */
-	if (len > ctx->used)
-		len = ctx->used;
-
 	/*
 	 * If more buffers are to be expected to be processed, process only
 	 * full block size buffers.


