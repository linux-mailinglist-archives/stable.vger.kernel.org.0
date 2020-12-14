Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A097C2DA108
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 21:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502973AbgLNUEU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 15:04:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502970AbgLNUEP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 15:04:15 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5155BC0617A6
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 12:03:03 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id w5so12594430pgj.3
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 12:03:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BdxMVC3y5nlR7LDMxIQSz3qWj9jrWm9Nsf2wISBO6pc=;
        b=LFVHg2rNbEt02LLPnkWOohGk8VIhywesyIxgHiqAVoru6cI75unOmiStz32cZ6y+5B
         GL+mJ6YH7mTcGxudEG3o5arOqjNvAQrUwRWzSPqM3W3iJv9O34xi9vG3w41FH5zMUvN1
         3ADDsOv8n7jI+sQAcZBmLufNtQsEwc1/LoOT/1hVCz/kru0CHAKgtKnTGlmeHskONmo+
         CEAoXXJ3X+2jP2fcKovBAXjO4XiHWndTM5VjpJcyjYGp+eqkdDH2c+691UZpMUAAERWu
         8ScMA0Hp3TEsajRGKrtzklh2DM7t/Vu5rGcrKy+t2aRigykj3BF+P0iSSeHgZ4TQ6FQ/
         93bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BdxMVC3y5nlR7LDMxIQSz3qWj9jrWm9Nsf2wISBO6pc=;
        b=XptBxARpRDDz5V47rmvhWNmMcR9pBv2m0VT4h6EdTLSSkZEH0K0iqE/PDALdSQzxWM
         MlkkiA2Ca6ZxBS4MKGzwAxU+JEx2tLer9TqDwkqVbITiElMzrSGTwbS1wFpqeHn1QPDp
         UIDu8p6TYQCNeUaAmUzihF2TmcNnB9DD0y27kBZV+buptsMHdkS+FnAM4wgOKOQf3saZ
         6ZQAuvjvtEm7kWGlry+cg8VOu+qEkdj+BmaA4v/URvjwore3dWTB/tsL7tAulG7/rTsk
         +gshitgqhU9oRv1vFfOE9jUsoYoo5WRdt2+aRniETjF6m2nBB8cycAWvVHP9kflTJSps
         v3jg==
X-Gm-Message-State: AOAM532Vyg3Ev8Ufl8TYciHXwE4TyKdaZzD3tTtyFWwiWyCphmWl9ntx
        VMbN6320Z/PWyyggCWi/AM3bEQ==
X-Google-Smtp-Source: ABdhPJzKh8HJaK54TRvEM5Wt0CA7yuq8pZy4BPn2IMdwD95gbsiCsgLgHhwTk/FqSplATiFqAetjqw==
X-Received: by 2002:a63:c04b:: with SMTP id z11mr25034328pgi.74.1607976182932;
        Mon, 14 Dec 2020 12:03:02 -0800 (PST)
Received: from localhost.localdomain ([163.172.76.58])
        by smtp.googlemail.com with ESMTPSA id js9sm22434109pjb.2.2020.12.14.12.02.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 12:03:02 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     arnd@arndb.de, davem@davemloft.net, herbert@gondor.apana.org.au,
        jernej.skrabec@siol.net, mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>, stable@vger.kernel.org
Subject: [PATCH v4 2/8] crypto: sun4i-ss: checking sg length is not sufficient
Date:   Mon, 14 Dec 2020 20:02:26 +0000
Message-Id: <20201214200232.17357-3-clabbe@baylibre.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201214200232.17357-1-clabbe@baylibre.com>
References: <20201214200232.17357-1-clabbe@baylibre.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The optimized cipher function need length multiple of 4 bytes.
But it get sometimes odd length.
This is due to SG data could be stored with an offset.

So the fix is to check also if the offset is aligned with 4 bytes.
Fixes: 6298e948215f2 ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
Cc: <stable@vger.kernel.org>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
index 19f1aa577ed4..f49797588329 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
@@ -186,12 +186,12 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 	 * we can use the SS optimized function
 	 */
 	while (in_sg && no_chunk == 1) {
-		if (in_sg->length % 4)
+		if ((in_sg->length | in_sg->offset) & 3u)
 			no_chunk = 0;
 		in_sg = sg_next(in_sg);
 	}
 	while (out_sg && no_chunk == 1) {
-		if (out_sg->length % 4)
+		if ((out_sg->length | out_sg->offset) & 3u)
 			no_chunk = 0;
 		out_sg = sg_next(out_sg);
 	}
-- 
2.26.2

