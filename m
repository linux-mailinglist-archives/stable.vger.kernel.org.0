Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80FA126E40F
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 20:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbgIQSiO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 14:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726648AbgIQSgO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Sep 2020 14:36:14 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 222E4C061788
        for <stable@vger.kernel.org>; Thu, 17 Sep 2020 11:36:14 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id g4so3119254wrs.5
        for <stable@vger.kernel.org>; Thu, 17 Sep 2020 11:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=95zSQXucA3JVtCyytHmj0YY6t7Txi03VIMdUw17K6OY=;
        b=dy8qrGfBrIm415C/AKe+zhxMSYXEPCm5p9tVIbpQLxrIuNdaArcxZmfXZ2+/RjNVSr
         cePOmHKnEe8/oekKxsYVXhS0ri5fv0JFc85DA/dP2bKxJfQfndLjhVb+x/+zOD/HXyMn
         rj45ayusWqqcbZXaaPYBr297PIQka5gcTb11rNycGtej9/l27rxbt4x+xnzUFOmN+/6d
         QBYEM6og75J3XUgMb306Mumrb7sSofApnV8jTGgGvhykwNDPRHl3XBZwxQ9j+n/b/U/i
         rkWlL9qDydk04KgRl65sEpqnbosBla5cYMC5Mom2JtamY9zp/HfqYT1X2z+PJDfr6d5F
         Umlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=95zSQXucA3JVtCyytHmj0YY6t7Txi03VIMdUw17K6OY=;
        b=kBe21Q+U2vA7z2HKGbLIqmsz8f82IUTF95Kb2FLib9I17qvDttFPu6qckiR3p2JT1L
         FNlBDzOh4Jidq3+Jnjo98xxh7ATvx5mhQnimGwVKo6W2fzQ9lBsWoCGW/bYgg5Gpy8qg
         YtzxO9sMYtuOQGTg9aOIYkfuqO7cd5tv5glRDAJ27SDCyzfl+hWgOwlhQsAkOqTG5dzA
         Yn1nx3hN2dEGYAzCFwsh3D1cFgGVEW/qxMtdrIVUErwIS5mu2r1t/PC8GQQh2zbBk/2H
         RnDapQX9TSS/FdJjr8hlZl2rjI/9ZWkS6G/aPcs/a292Hx90bQ9vh/BlSL1tP2Z8v1at
         p+JQ==
X-Gm-Message-State: AOAM530JWJ7lYs3DDedvr5z2Z/FV+iy7owH91OpJFuwn/pfnmOINyAxg
        49U8kWvxgxWW5e7lLshitEzIKw==
X-Google-Smtp-Source: ABdhPJyOLICoWIu3123UpyJexAwTB9qPRSR1qGn78IXm3kL9cpE2LR7gh5Zt/pUtPXnwu2PxLEAwlQ==
X-Received: by 2002:a5d:5261:: with SMTP id l1mr33249298wrc.193.1600367772844;
        Thu, 17 Sep 2020 11:36:12 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id x16sm571901wrq.62.2020.09.17.11.36.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2020 11:36:12 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     arnd@arndb.de, davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>, stable@vger.kernel.org
Subject: [PATCH 5/7] crypto: sun4i-ss: initialize need_fallback
Date:   Thu, 17 Sep 2020 18:35:56 +0000
Message-Id: <1600367758-28589-6-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1600367758-28589-1-git-send-email-clabbe@baylibre.com>
References: <1600367758-28589-1-git-send-email-clabbe@baylibre.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The need_fallback is never initialized and seem to be always true at runtime.
So all hardware operations are always bypassed.

Fixes: 0ae1f46c55f87 ("crypto: sun4i-ss - fallback when length is not multiple of blocksize")
Cc: <stable@vger.kernel.org>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
index d66bb9cf657c..c21a1a0a8b16 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
@@ -181,7 +181,7 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 	unsigned int obo = 0;	/* offset in bufo*/
 	unsigned int obl = 0;	/* length of data in bufo */
 	unsigned long flags;
-	bool need_fallback;
+	bool need_fallback = false;
 
 	if (!areq->cryptlen)
 		return 0;
-- 
2.26.2

