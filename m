Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89D4427171D
	for <lists+stable@lfdr.de>; Sun, 20 Sep 2020 20:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbgITShs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Sep 2020 14:37:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbgITShc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Sep 2020 14:37:32 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 787CBC0613DA
        for <stable@vger.kernel.org>; Sun, 20 Sep 2020 11:37:30 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id c18so10491747wrm.9
        for <stable@vger.kernel.org>; Sun, 20 Sep 2020 11:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3OyGuodJwZo3ZuRGej7X4SpPtHUnPs0FAyD9Ejylqzc=;
        b=RoIaqdq+e0795nGzWShgL380T4BXMnZSXrHw09SiRa8w9HbuTKl71pGS0QgH/OJ3xK
         nLUahSLe8gAbMiJimVsCuqjkAPxybtlKWXzXixZbr2Myp59+9ee+ARC/T9sJLR269Grf
         YhL0XBMnfoUH72cjtkCVwLHAVmm9Aa13p+VoKPslqNNKo6tgFyUPJdOXA+Qf9sEuWJwJ
         es9/Ow95Iv+UGuomjo0eIflGjp6rwtMR+XVH3bUXTMxrBYwpk7wSVf8WsHxI91tCWA+h
         eYJuF5rHLUkAnnf8k7Hq9BetVFQopgZa6ZhTg+t0hnd1J2hDjnekRp0WHbh0hOhsSEZw
         If7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3OyGuodJwZo3ZuRGej7X4SpPtHUnPs0FAyD9Ejylqzc=;
        b=jFaEpAVR2PF1Gf8IzAx9nJN8qHZQBLq8viqWnXc5W0QBTDoB1SpZyHVyDOQLW7uglS
         QDF/OgmGKlIE7KiCNkmfKf+RRUdhBMGtOo0ExnowzargjcMheKLbFyPeCfCKxyEA5n3i
         p7g+hLPaN1CUh/1IHhuGyQ72yDKKtVj9fRoe05q0RyuXhrDrzKJZBOxZRPITkAV6wAMY
         ooi0AbRSC/yGgxFDiXgs+ZD3XDbDq86rcAH7m9I3ZpJat7fI3RZcqLK1X70oMh3Vmetl
         q8XNaieAeGo+i1agQH9wp2CLTwGhthSYF0iKc/eptp/ct5J+nyXainLfLGaTfWxWp0Yp
         52wg==
X-Gm-Message-State: AOAM5335u2xrlYnHWtSXFPc13QAAffZe6zSF61Epz34mInDGxaCCyCSr
        xjqReyZnE7dJuU2pAcA8JrcK9A==
X-Google-Smtp-Source: ABdhPJww+6NOi8GJs7+7r6z4gKijDA+FXf0aSA2CdHowZYjtNN8SgZILS8uTKvVlG8N477QqbY45ew==
X-Received: by 2002:a5d:4591:: with SMTP id p17mr48173433wrq.408.1600627049213;
        Sun, 20 Sep 2020 11:37:29 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id e18sm16419841wrx.50.2020.09.20.11.37.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Sep 2020 11:37:28 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     arnd@arndb.de, davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>, stable@vger.kernel.org
Subject: [PATCH v2 5/7] crypto: sun4i-ss: initialize need_fallback
Date:   Sun, 20 Sep 2020 18:37:16 +0000
Message-Id: <1600627038-40000-6-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1600627038-40000-1-git-send-email-clabbe@baylibre.com>
References: <1600627038-40000-1-git-send-email-clabbe@baylibre.com>
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
index a05889745097..f3bdf465b02e 100644
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

