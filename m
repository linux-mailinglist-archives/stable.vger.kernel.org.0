Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEA8E2DA121
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 21:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502885AbgLNUIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 15:08:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502974AbgLNUEU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 15:04:20 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14F7CC061285
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 12:03:17 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id j13so7348437pjz.3
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 12:03:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=K1Ybs+hT1nPIORP2XwYBCL9D0EZYSmN/d5S7S6dnsio=;
        b=g+LNnNxBUNpU7QpFrxNKjl6txTsOOQHzwo1n74/ZGkW1xYEo3ghMx8d8gv17is0vfB
         /IiG6hqy3cl9DDBeK3tJoosmjJiEUDmGeI9BfcZbvS9vg8ZrqrSvMuA9bIc7L2mQY/o6
         CdXgXVvBNUVQu/zEl9PQ+rLiGCdTsRfSZR52IaaLGfGTOISRWVt1+jkbs+JNOZBX23tA
         5Sto69xFCyXCsr4u6S399effMuJiVAZjrI/5TnEaIiwyNXQ8RqImDBA2lMySSN9cfYRX
         AnHuYTIZDQmEFTkoaVN51W2xitoRo9Fbag24kZ/eNeQ0BX70JVm31nDLPaOJZqPhPdZj
         iGjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=K1Ybs+hT1nPIORP2XwYBCL9D0EZYSmN/d5S7S6dnsio=;
        b=g1aIKm+QVjCBHq1E9nxHp53HeiDeokQJFEMQYaMo6uMrmSz71nUcjnhHdYBo47bgqN
         vsdPhWWcNfueMwE7yblDLdtqQQhvXuRXFlE3EH6uuD336suW0bEGrF9SBgJoiZFrtDVo
         pvfHjjrxb7aC8L5YshTsuo34nv6lDQckJQgLCgq9mqIGGByOkypdcNMD7zb1q52IjI7R
         IiTZZ+3j6YsSo5st2aLliMSN+P/VHXIKoGZa/xeiqAYaRswN6hidMYgRzjNT2jN4SYws
         6sFvEgOgF4RFALRJJe2AV4ZALvGusFI6bIcs69dEL6Fj372crRVqjWORzhaVZGjPCAry
         XL2g==
X-Gm-Message-State: AOAM532bwCzowmyOVvFDOLOVB0wlY0s/Kh8zdOqWjsOm5E1gPAQq7DTk
        HE4G3/D5xHvoEOUMNttLLZWWZA==
X-Google-Smtp-Source: ABdhPJxadrTTvMZ1XJcLsGOHcN+QNjm9wpcmYYgls91MdCy9Qa3wTYd/uomMSGJUuJXoDU5RmvPlOA==
X-Received: by 2002:a17:90a:a58f:: with SMTP id b15mr19829282pjq.17.1607976196699;
        Mon, 14 Dec 2020 12:03:16 -0800 (PST)
Received: from localhost.localdomain ([163.172.76.58])
        by smtp.googlemail.com with ESMTPSA id js9sm22434109pjb.2.2020.12.14.12.03.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 12:03:16 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     arnd@arndb.de, davem@davemloft.net, herbert@gondor.apana.org.au,
        jernej.skrabec@siol.net, mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>, stable@vger.kernel.org
Subject: [PATCH v4 4/8] crypto: sun4i-ss: handle BigEndian for cipher
Date:   Mon, 14 Dec 2020 20:02:28 +0000
Message-Id: <20201214200232.17357-5-clabbe@baylibre.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201214200232.17357-1-clabbe@baylibre.com>
References: <20201214200232.17357-1-clabbe@baylibre.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ciphers produce invalid results on BE.
Key and IV need to be written in LE.

Fixes: 6298e948215f2 ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
Cc: <stable@vger.kernel.org>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
index c7bf731dad7b..e097f4c3e68f 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
@@ -52,13 +52,13 @@ static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
 
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
@@ -223,13 +223,13 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 
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
-- 
2.26.2

