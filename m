Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 242B0271722
	for <lists+stable@lfdr.de>; Sun, 20 Sep 2020 20:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgITShz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Sep 2020 14:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbgITShb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Sep 2020 14:37:31 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97558C0613D6
        for <stable@vger.kernel.org>; Sun, 20 Sep 2020 11:37:29 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id w2so10008816wmi.1
        for <stable@vger.kernel.org>; Sun, 20 Sep 2020 11:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Gd2hvr/SAKzjKtmSl3X2mEioPmDAlGeI7zVBmc2l4K8=;
        b=cxfwt+vj0IMFYW+JQ/I7RatzPtFw1+jGLORAJybIyLwiBbd8P6wU5H00s9S1g4XMCY
         UtVX46Nx5geEh0rX6GT/R1NqCO0wAXNvq3PTMp5xIYww5KxBWgMxCm08fYTjWz8EDRly
         ORI6B+JW2+/ifJ9LxD6u6F21uUfuTr3CMQTPHbky+JTF7baBn+u9aYHI31U0DUYBtoPK
         Gku7/dytrVz3juRK5t7OQNxRwpCr840JqSDM2TwYFdt0VxmmGUHG41RSjfnRWNaCOPDB
         T0dou1BYOe5x7NuYgGSLZ8uaOHyw0lvLaQmG7zhUGOm7By0kKCa6jx/62Q5Gu59Csz3q
         Mhag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Gd2hvr/SAKzjKtmSl3X2mEioPmDAlGeI7zVBmc2l4K8=;
        b=LMqiT4NA7cNGqv7YfvVX9K11Hvhqr2vDKsVSBqkxHRurE4iXbEVD43coSfqEebBrvG
         kCcR0nN48CgXAI62q+I+gxWr78oTYZMcTXM20uCcNPhdq6f8MN2hmUCyykLPwF7Q+oQM
         EsbuTzg44NiMaK/JgdENCtKn57m7cLQBVTFr72p0Ey17T5lYjoLAPs5AwNpMF2OjOp4+
         QwhfTQB69SwH8/kceapl9kww57CkZqbjb7qTeXsMiplgnF4VSbNxeXU+u3ToqpzZVY9c
         n9aDZVbkF7P2au9pCDqAXQZLdCXdhaxzImyHEyP5SrutV4iV8gKRcaN1DAfeHEu6SAmj
         5DyA==
X-Gm-Message-State: AOAM53099mHZUnQV9ZNzGSxxYXAedRaYODggO1Hh5bGyRq66k639r3HP
        RmYkmwBCT8JB/vz4BCIX79gFIljb0XWfKA==
X-Google-Smtp-Source: ABdhPJxFgf7fh7vgfuCj7uPWgYnoR/9rCAgoeOSkNbbVfdIgvzC4Qjnot2R01IIEr2PfqXC84D6//w==
X-Received: by 2002:a1c:f208:: with SMTP id s8mr27172664wmc.85.1600627048332;
        Sun, 20 Sep 2020 11:37:28 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id e18sm16419841wrx.50.2020.09.20.11.37.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Sep 2020 11:37:27 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     arnd@arndb.de, davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>, stable@vger.kernel.org
Subject: [PATCH v2 4/7] crypto: sun4i-ss: handle BigEndian for cipher
Date:   Sun, 20 Sep 2020 18:37:15 +0000
Message-Id: <1600627038-40000-5-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1600627038-40000-1-git-send-email-clabbe@baylibre.com>
References: <1600627038-40000-1-git-send-email-clabbe@baylibre.com>
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
index c6c25204780d..a05889745097 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
@@ -52,13 +52,13 @@ static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
 
 	spin_lock_irqsave(&ss->slock, flags);
 
-	for (i = 0; i < op->keylen; i += 4)
-		writel(*(op->key + i / 4), ss->base + SS_KEY0 + i);
+	for (i = 0; i < op->keylen / 4; i++)
+		writel(cpu_to_le32(op->key[i]), ss->base + SS_KEY0 + i * 4);
 
 	if (areq->iv) {
 		for (i = 0; i < 4 && i < ivsize / 4; i++) {
 			v = *(u32 *)(areq->iv + i * 4);
-			writel(v, ss->base + SS_IV0 + i * 4);
+			writel(cpu_to_le32(v), ss->base + SS_IV0 + i * 4);
 		}
 	}
 	writel(mode, ss->base + SS_CTL);
@@ -225,13 +225,13 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 
 	spin_lock_irqsave(&ss->slock, flags);
 
-	for (i = 0; i < op->keylen; i += 4)
-		writel(*(op->key + i / 4), ss->base + SS_KEY0 + i);
+	for (i = 0; i < op->keylen / 4; i++)
+		writel(cpu_to_le32(op->key[i]), ss->base + SS_KEY0 + i * 4);
 
 	if (areq->iv) {
 		for (i = 0; i < 4 && i < ivsize / 4; i++) {
 			v = *(u32 *)(areq->iv + i * 4);
-			writel(v, ss->base + SS_IV0 + i * 4);
+			writel(cpu_to_le32(v), ss->base + SS_IV0 + i * 4);
 		}
 	}
 	writel(mode, ss->base + SS_CTL);
-- 
2.26.2

