Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECE32B4541
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 14:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729833AbgKPNys (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 08:54:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729827AbgKPNys (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 08:54:48 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2217C0613D2
        for <stable@vger.kernel.org>; Mon, 16 Nov 2020 05:54:47 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id c66so14206468pfa.4
        for <stable@vger.kernel.org>; Mon, 16 Nov 2020 05:54:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LA6HiyjtrQWg93rXzUxCKFCbWr20SEsMu/GK7GDnTM4=;
        b=iblwlVcd2lUD/gwKL5jWgNtBU8xtXkfkke8Of+1dHqmGyy37nax0rkrq4lAXptvJVb
         AXqrTry0jNdofQ+ymr26F5xvtaGj2ALrfbMCnUWvEynp27GBSifY99vEi2dweI6enESU
         vy36OwiE+cI6m+WwQAamyl1AOUTuLz4liMHynQe16YSSqU+JdC4W2cKigHXBhsY+lJfD
         df9hu4J1U6K00TDaQluTa930RJUmRhNzpxugl2rmno4CG3ZBTDMbYQWTfAJdDl9Vm86E
         zQDaMD03Wj8qHlYlgW3jmyS7s2L/bHD9blRaKnd4GVwAh71hLJPRRdAdhXjqbvQRg633
         0j2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LA6HiyjtrQWg93rXzUxCKFCbWr20SEsMu/GK7GDnTM4=;
        b=C0xE59d0DHDxWW/IPPSYVs0mMgb8E4rXbWpwW3JcRQph+1DGl2bXYEDbLg/bigAcAg
         f7X392WyAQ+LMcPRJqCxRcTFl1IXABsBof4INEWgwXk+a0ShSq8cEk0I1qOJUMVfPmHY
         gdfMhVBCLGVMgvQ4UKwzaZRx5bwmSjHYMT/pfHWFnr27oYsjo9px3My8R4zUGhpAmHxW
         7BpAVE2S9iwpxblARIvjSdhEFEdRg+U31/YG5EyGAIQRl1c8sJT0GJg919VqeSlafA80
         IhX6gSXT7BH4TPsytgOH55CDBeKmXrtvhlkWwU6GpKDJP6bOjQRHZko2FqlLHkIEAJKd
         aEeQ==
X-Gm-Message-State: AOAM5307TG8NJrXFW5n7gsVf6nwpgVt4L73AYLLooTut8foZ59QAC/mD
        cw/cdLnJbhpuRVS7DUNyIiCfww==
X-Google-Smtp-Source: ABdhPJxtV8S3t14TtRMP1LjRfXosxCQyIdl5lzyfHOzvv6zyR1P0pO6Y21nlXDj/H4LetTS7oza29Q==
X-Received: by 2002:a17:90b:4c0b:: with SMTP id na11mr3329213pjb.0.1605534887618;
        Mon, 16 Nov 2020 05:54:47 -0800 (PST)
Received: from localhost.localdomain ([163.172.76.58])
        by smtp.googlemail.com with ESMTPSA id u22sm15864031pgf.24.2020.11.16.05.54.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 05:54:47 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     arnd@arndb.de, davem@davemloft.net, herbert@gondor.apana.org.au,
        jernej.skrabec@siol.net, mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>, stable@vger.kernel.org
Subject: [PATCH v3 5/7] crypto: sun4i-ss: initialize need_fallback
Date:   Mon, 16 Nov 2020 13:53:43 +0000
Message-Id: <20201116135345.11834-6-clabbe@baylibre.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201116135345.11834-1-clabbe@baylibre.com>
References: <20201116135345.11834-1-clabbe@baylibre.com>
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
index 8f4621826330..7f4c97cc9627 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
@@ -179,7 +179,7 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 	unsigned int obo = 0;	/* offset in bufo*/
 	unsigned int obl = 0;	/* length of data in bufo */
 	unsigned long flags;
-	bool need_fallback;
+	bool need_fallback = false;
 
 	if (!areq->cryptlen)
 		return 0;
-- 
2.26.2

