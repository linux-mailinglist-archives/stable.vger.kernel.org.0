Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF622328E00
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241352AbhCATWa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:22:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:43898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241335AbhCATRl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:17:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0993165256;
        Mon,  1 Mar 2021 17:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619697;
        bh=/FSxBGnA2Olc9paa9qY+7DY8GR4LqnorU27kcoDcJFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lfwxogrm1i5dHVllos8v8peSmLc0tR9xsHF2PQ1NMohoryiQBu74Sdy8l1aRtgxbJ
         S4hXzskrWnGgjaYYCu1Ub3t0nG+8G456hfzYvG6QMcYC62Kwj8C5aJAZo21s2csoXV
         uTZa1sabekM/WHSVWSdSMj5P0yJAuEHeyWmNaB+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.10 548/663] crypto: sun4i-ss - initialize need_fallback
Date:   Mon,  1 Mar 2021 17:13:16 +0100
Message-Id: <20210301161208.985907212@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corentin Labbe <clabbe@baylibre.com>

commit 4ec8977b921fd9d512701e009ce8082cb94b5c1c upstream.

The need_fallback is never initialized and seem to be always true at runtime.
So all hardware operations are always bypassed.

Fixes: 0ae1f46c55f87 ("crypto: sun4i-ss - fallback when length is not multiple of blocksize")
Cc: <stable@vger.kernel.org>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
@@ -194,7 +194,7 @@ static int sun4i_ss_cipher_poll(struct s
 	unsigned int obo = 0;	/* offset in bufo*/
 	unsigned int obl = 0;	/* length of data in bufo */
 	unsigned long flags;
-	bool need_fallback;
+	bool need_fallback = false;
 
 	if (!areq->cryptlen)
 		return 0;


