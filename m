Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E73D329171
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242145AbhCAU0S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:26:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:45774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243206AbhCAUSx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:18:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53D2464FA9;
        Mon,  1 Mar 2021 18:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621804;
        bh=dv+/Cy2DJ4Wi5jF9nImoCJKLn5m3zhQIDaSwmsOEuDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WXvgNVyAP39wSnrrUiOlFcvxJHY4id/Zys988GUgqVx9prD9MZi5GRmAixJW/veYJ
         hqMdyN7HVHklRDkc+PCf8auiauVj3rvT6gXrHs52bijMpxBaPOesmznN4mBy1R/sRu
         qooIlSdgTfX1yAP83L2rLyZHT+rs7LTpd/o91Yn8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.11 650/775] crypto: sun4i-ss - handle BigEndian for cipher
Date:   Mon,  1 Mar 2021 17:13:38 +0100
Message-Id: <20210301161233.506899526@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corentin Labbe <clabbe@baylibre.com>

commit 5ab6177fa02df15cd8a02a1f1fb361d2d5d8b946 upstream.

Ciphers produce invalid results on BE.
Key and IV need to be written in LE.

Fixes: 6298e948215f2 ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
Cc: <stable@vger.kernel.org>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
@@ -54,13 +54,13 @@ static int noinline_for_stack sun4i_ss_o
 
 	spin_lock_irqsave(&ss->slock, flags);
 
-	for (i = 0; i < op->keylen; i += 4)
-		writel(*(op->key + i / 4), ss->base + SS_KEY0 + i);
+	for (i = 0; i < op->keylen / 4; i++)
+		writesl(ss->base + SS_KEY0 + i * 4, &op->key[i], 1);
 
 	if (areq->iv) {
 		for (i = 0; i < 4 && i < ivsize / 4; i++) {
 			v = *(u32 *)(areq->iv + i * 4);
-			writel(v, ss->base + SS_IV0 + i * 4);
+			writesl(ss->base + SS_IV0 + i * 4, &v, 1);
 		}
 	}
 	writel(mode, ss->base + SS_CTL);
@@ -238,13 +238,13 @@ static int sun4i_ss_cipher_poll(struct s
 
 	spin_lock_irqsave(&ss->slock, flags);
 
-	for (i = 0; i < op->keylen; i += 4)
-		writel(*(op->key + i / 4), ss->base + SS_KEY0 + i);
+	for (i = 0; i < op->keylen / 4; i++)
+		writesl(ss->base + SS_KEY0 + i * 4, &op->key[i], 1);
 
 	if (areq->iv) {
 		for (i = 0; i < 4 && i < ivsize / 4; i++) {
 			v = *(u32 *)(areq->iv + i * 4);
-			writel(v, ss->base + SS_IV0 + i * 4);
+			writesl(ss->base + SS_IV0 + i * 4, &v, 1);
 		}
 	}
 	writel(mode, ss->base + SS_CTL);


