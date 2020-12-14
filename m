Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEAB62DA11B
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 21:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502979AbgLNUEU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 15:04:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502969AbgLNUEP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 15:04:15 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 574B2C0617B0
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 12:03:10 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id r4so9377734pls.11
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 12:03:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mhauqzte4SJbuo85PM/RZAliMy73/eGjDvxrpH1oQU4=;
        b=l9xgQyB5zjgkCGjyqAVgK6gxKFbynKpwdZlSE6VMtp0Ch6cMS4ZsJBmrItSuYyXFNq
         /Gp9X1j8UHNFm2juKHYalJ5aZT0wb+T++K52CaecvviwslaHIkL4iH3CUPVe+ggV3KUT
         Um1SUlUVGCY4GJxGsMA9OA30UiMmTMT4ypJ8LNSYR4QzmgR1cY7RA7nkRrxUekRleFQq
         eBQ5h91fT3Pf6mB0k9RVpM3WozqV10YxtdEermLD2WCz1ZYTny+FLFL/1UvJN+ipjTzw
         ZsUU92hzfUruPFSp/RXA+OxB4TeAzj9NgYxD//7mN4Dmi7VQQLVvZOW8bNCerEH0wAVW
         8CTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mhauqzte4SJbuo85PM/RZAliMy73/eGjDvxrpH1oQU4=;
        b=uM1v24xbM9+FQQha8UHbZGv+TXcJqjXMCMn31juIEPnuYz0KSqCnBoDn7fb2eyuCkg
         DbmZHywpW7s5Y+W3s73nveVoebPVGMDlzRRE21kFWoo2oJ0+eY5JgkeenDc4HDzJ7Q+4
         eva0bl6WYrZFVyCOOjUsJoQePtGUoYYbpo0MOsn+KErdjs+0uoxosod2UMIpOjvZabrS
         yv1tDPwAW0P77WU23bAISsq22r1HutvdGJ5jlVMCEvbaxPaFSeO5FrNxaT7tX3ZwUcBT
         OFzZurKHrGb+GltVozFos+UR3nP1s3xkmmBOPLoI1QKxZQUFWhu0R6/h6QtUxx+Ci0xl
         WKhw==
X-Gm-Message-State: AOAM532DqfeFfdhULBY9qst10NzV3S6GCEr3InGuHy6TltdrPWRAJijE
        PpaEsF01dz6s3l1gk20owcheOg==
X-Google-Smtp-Source: ABdhPJy/trSmJp3u3Ah+OXevgu0p8lTfXgL2QEj3S7UmptY3EDmKUPahfnHf5Luy82j4ghyIoSFWHw==
X-Received: by 2002:a17:90b:2317:: with SMTP id mt23mr27087120pjb.2.1607976189937;
        Mon, 14 Dec 2020 12:03:09 -0800 (PST)
Received: from localhost.localdomain ([163.172.76.58])
        by smtp.googlemail.com with ESMTPSA id js9sm22434109pjb.2.2020.12.14.12.03.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 12:03:08 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     arnd@arndb.de, davem@davemloft.net, herbert@gondor.apana.org.au,
        jernej.skrabec@siol.net, mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>, stable@vger.kernel.org
Subject: [PATCH v4 3/8] crypto: sun4i-ss: IV register does not work on A10 and A13
Date:   Mon, 14 Dec 2020 20:02:27 +0000
Message-Id: <20201214200232.17357-4-clabbe@baylibre.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201214200232.17357-1-clabbe@baylibre.com>
References: <20201214200232.17357-1-clabbe@baylibre.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Allwinner A10 and A13 SoC have a version of the SS which produce
invalid IV in IVx register.

Instead of adding a variant for those, let's convert SS to produce IV
directly from data.
Fixes: 6298e948215f2 ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
Cc: <stable@vger.kernel.org>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 .../allwinner/sun4i-ss/sun4i-ss-cipher.c      | 34 +++++++++++++++----
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
index f49797588329..c7bf731dad7b 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
@@ -20,6 +20,7 @@ static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
 	unsigned int ivsize = crypto_skcipher_ivsize(tfm);
 	struct sun4i_cipher_req_ctx *ctx = skcipher_request_ctx(areq);
 	u32 mode = ctx->mode;
+	void *backup_iv = NULL;
 	/* when activating SS, the default FIFO space is SS_RX_DEFAULT(32) */
 	u32 rx_cnt = SS_RX_DEFAULT;
 	u32 tx_cnt = 0;
@@ -42,6 +43,13 @@ static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
 		return -EINVAL;
 	}
 
+	if (areq->iv && ivsize > 0 && mode & SS_DECRYPTION) {
+		backup_iv = kzalloc(ivsize, GFP_KERNEL);
+		if (!backup_iv)
+			return -ENOMEM;
+		scatterwalk_map_and_copy(backup_iv, areq->src, areq->cryptlen - ivsize, ivsize, 0);
+	}
+
 	spin_lock_irqsave(&ss->slock, flags);
 
 	for (i = 0; i < op->keylen; i += 4)
@@ -102,9 +110,12 @@ static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
 	} while (oleft);
 
 	if (areq->iv) {
-		for (i = 0; i < 4 && i < ivsize / 4; i++) {
-			v = readl(ss->base + SS_IV0 + i * 4);
-			*(u32 *)(areq->iv + i * 4) = v;
+		if (mode & SS_DECRYPTION) {
+			memcpy(areq->iv, backup_iv, ivsize);
+			kfree_sensitive(backup_iv);
+		} else {
+			scatterwalk_map_and_copy(areq->iv, areq->dst, areq->cryptlen - ivsize,
+						 ivsize, 0);
 		}
 	}
 
@@ -161,6 +172,7 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 	unsigned int ileft = areq->cryptlen;
 	unsigned int oleft = areq->cryptlen;
 	unsigned int todo;
+	void *backup_iv = NULL;
 	struct sg_mapping_iter mi, mo;
 	unsigned int oi, oo;	/* offset for in and out */
 	unsigned int ob = 0;	/* offset in buf */
@@ -202,6 +214,13 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 	if (need_fallback)
 		return sun4i_ss_cipher_poll_fallback(areq);
 
+	if (areq->iv && ivsize > 0 && mode & SS_DECRYPTION) {
+		backup_iv = kzalloc(ivsize, GFP_KERNEL);
+		if (!backup_iv)
+			return -ENOMEM;
+		scatterwalk_map_and_copy(backup_iv, areq->src, areq->cryptlen - ivsize, ivsize, 0);
+	}
+
 	spin_lock_irqsave(&ss->slock, flags);
 
 	for (i = 0; i < op->keylen; i += 4)
@@ -322,9 +341,12 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 		}
 	}
 	if (areq->iv) {
-		for (i = 0; i < 4 && i < ivsize / 4; i++) {
-			v = readl(ss->base + SS_IV0 + i * 4);
-			*(u32 *)(areq->iv + i * 4) = v;
+		if (mode & SS_DECRYPTION) {
+			memcpy(areq->iv, backup_iv, ivsize);
+			kfree_sensitive(backup_iv);
+		} else {
+			scatterwalk_map_and_copy(areq->iv, areq->dst, areq->cryptlen - ivsize,
+						 ivsize, 0);
 		}
 	}
 
-- 
2.26.2

