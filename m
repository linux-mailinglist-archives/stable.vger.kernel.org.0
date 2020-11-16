Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F172B453A
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 14:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729771AbgKPNye (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 08:54:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729770AbgKPNyd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 08:54:33 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C21F3C0613D1
        for <stable@vger.kernel.org>; Mon, 16 Nov 2020 05:54:32 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id y22so8430444plr.6
        for <stable@vger.kernel.org>; Mon, 16 Nov 2020 05:54:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mVzZeX/xHmC7db3jb+d+RTV9mPod+mGCeVwxUA/QzHc=;
        b=khITfdpV7TkpTI3z7ek6WPFVnE/hkdUS1kE3iVr+zubshbicRf3ouAsQNOcAGmsXFR
         aZVJP1dw8wraRpfHz05MmqGSK0WgIJnQ/oaLCI9/zHAHO+skG9QQFuDHQcTYmCCsiWRR
         bkM5pajDBxam1DhN9q6MaPj8L8mUPxWadt5A3M/xtnLXo0byO2upaIcjoTgK5oP60RKu
         mGR5ZB/HXca1A+3cbn6Y8chlsZtyNx8qgLI7hrBxZyDCg2SPFmDvzg0t537yHMT3EysE
         RgW3wgZtmZ/ApXOOXn1kTXICBOoL3JK+ZQEWnRgDvBiEh7K0AUAOWzLxD8qJPueWapu1
         uj3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mVzZeX/xHmC7db3jb+d+RTV9mPod+mGCeVwxUA/QzHc=;
        b=s8s6KrNPP758ogdmIBZ96kpquFosD9HxyWkeSeIgjZ9qsT4df0aK5lFcLkDqNmVh6k
         IOW+DYRXMaskmHKHkbaQyWNVxhfpac//fappbPOWGUMFBmFSpnsAdm3O7w2f5aRoyXBA
         b4ic7gkPd5Y5i7+Etxdh7W4OxyHqBr+kz9MHz4BDB75bXpBpv/Yy0lCdbWU/CpzfW9ah
         SWl3YnxiyRNMyCsJ9o3jaVN5te9VpoplplhE4QjrPk9kF+KDOSrrzsETDXCFhfs3/Kpt
         Fbuo5VphaZz44SaMkTVU/hUorZlcWgFLbEsp5gGQcvU3SjQTArlzZh9YO/fd/h7kfsHa
         gkxw==
X-Gm-Message-State: AOAM532Vd7wcsyvy3XgzIstgGHhE4FvoyjtsMYU7lg3Dwssd8YdAGo5J
        t+oEldqItWoYoypM9k8Ff4S4lA==
X-Google-Smtp-Source: ABdhPJycsJpsHxxQgUQikdHZHQq+B46p3AfeivU5IrTPRF+X2sx8pQsUDBuZgBM8ImvHOT/pMe+oCA==
X-Received: by 2002:a17:902:70cc:b029:d7:e8ad:26d4 with SMTP id l12-20020a17090270ccb02900d7e8ad26d4mr13298602plt.33.1605534872355;
        Mon, 16 Nov 2020 05:54:32 -0800 (PST)
Received: from localhost.localdomain ([163.172.76.58])
        by smtp.googlemail.com with ESMTPSA id u22sm15864031pgf.24.2020.11.16.05.54.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 05:54:31 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     arnd@arndb.de, davem@davemloft.net, herbert@gondor.apana.org.au,
        jernej.skrabec@siol.net, mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>, stable@vger.kernel.org
Subject: [PATCH v3 3/7] crypto: sun4i-ss: IV register does not work on A10 and A13
Date:   Mon, 16 Nov 2020 13:53:41 +0000
Message-Id: <20201116135345.11834-4-clabbe@baylibre.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201116135345.11834-1-clabbe@baylibre.com>
References: <20201116135345.11834-1-clabbe@baylibre.com>
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
index 4dd736ee5a4d..53478c3feca6 100644
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

