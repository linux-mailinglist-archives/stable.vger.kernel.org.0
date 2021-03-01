Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF0132895D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238779AbhCARzn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:55:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:43366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238513AbhCARtg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:49:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52478650EF;
        Mon,  1 Mar 2021 17:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618003;
        bh=ZTXcQ/HgkGLx7GOqLgNFOnRAvJ4AQ4FcdaC5wFNq3J0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PO717kT5n03DbR0+Jfpvc+T90s/JBfBv8Pjo84OKso32vQQFIXttl1k7S2O25lf4h
         ObrO3nq58/gRcspDqgnRPzYglVGdUGu9hyXs+fKpDMa50Bp+FSB1FNc34Qw6Gl5q4x
         szOxNAC2/kWkZQEoNExg10uVWFtK2KDhb1farNAI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.4 274/340] crypto: sun4i-ss - initialize need_fallback
Date:   Mon,  1 Mar 2021 17:13:38 +0100
Message-Id: <20210301161101.774009706@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
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
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
@@ -196,7 +196,7 @@ static int sun4i_ss_cipher_poll(struct s
 	unsigned int obo = 0;	/* offset in bufo*/
 	unsigned int obl = 0;	/* length of data in bufo */
 	unsigned long flags;
-	bool need_fallback;
+	bool need_fallback = false;
 
 	if (!areq->cryptlen)
 		return 0;


