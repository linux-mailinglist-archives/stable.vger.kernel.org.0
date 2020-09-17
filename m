Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA3A826E409
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 20:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbgIQSiT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 14:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726633AbgIQSgL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Sep 2020 14:36:11 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 081B6C06178C
        for <stable@vger.kernel.org>; Thu, 17 Sep 2020 11:36:10 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id w5so3111911wrp.8
        for <stable@vger.kernel.org>; Thu, 17 Sep 2020 11:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=IhTFOXooJMFxAaaEHQf3e3fIzkNVzwZdrWDdh3u1EUQ=;
        b=Tc51LgthYrtN/C0RNoGrtu6I9ssV8h9UwKdz0ft8yPntVgsb8RwIMw2tQjkL6VvUpx
         3eWnFSDstKy+8h4FEmzSZWfBbdwSOxyvMAtKCO15lX8oQo0DLMpCcJMNkbzNdDP6KAi3
         QJLSWItKrjv+Cm4ONO+v1GJ+LqrcYZVhQmFHXkhyR7kyAU2SCYQxnB4x0eSoWWZ3uiel
         1g3XKPSUC1UWr6V9dk92C5vQKtCam+DPIaXUx+A2es6eobd/bm7rpS5BTk/1C2vUiO9U
         u2SfduQvAoDYEuIWH8kTUHfKZsnO/Z/9zSYmF07TWFeb8C0GQ6qEKJcYdgBjjtdcs0f4
         w79A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=IhTFOXooJMFxAaaEHQf3e3fIzkNVzwZdrWDdh3u1EUQ=;
        b=VcV65lHPYRR7tTJsB+HzkNwzhY0gD7URmRzEqG8yx+IqZz5KACcJcQqJ2q0K/1qAw3
         6w5IEjUqbMMIdnCoMmbfWVK/Oxu7KZMdBW1JQGq8c1KD06pzxoY4K0Whaby+t++NYS/d
         rQZUCADTxRhev3Js/2bi6Y6ezw2riudCyV2Y1xYvDiar0MAj2z+KqSYOKTAzyPW5Z/z5
         lde4SZ70PNgAORSjFFVKvQ2n4oFYHqsiH6g0QtvD0dwbtwv37IrAR80cpUwlD0KLciqP
         3yxhOQZBzsVr2SZyELKvd2+W/7KEn2+pCMa9jvzoKd63ZKPzdJz+cYj9v6zBTvKZyxpD
         Ry1A==
X-Gm-Message-State: AOAM531Qe1ta1EIuSuF/YRXLHtcVRaqe6gsG4MBBUIby8l10qss5NpNB
        4WiPRhWu5eZEd9qDpELbWd2xfw==
X-Google-Smtp-Source: ABdhPJwhXuvQa4gIHPDoUqZX+gQkmzaq030R+3DLkq1LnXlJRD7XmKmH+Ir4Od2FNbCImmKLAMzpSg==
X-Received: by 2002:a5d:6cb1:: with SMTP id a17mr30001488wra.386.1600367769682;
        Thu, 17 Sep 2020 11:36:09 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id x16sm571901wrq.62.2020.09.17.11.36.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2020 11:36:09 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     arnd@arndb.de, davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>, stable@vger.kernel.org
Subject: [PATCH 2/7] crypto: sun4i-ss: checking sg length is not sufficient
Date:   Thu, 17 Sep 2020 18:35:53 +0000
Message-Id: <1600367758-28589-3-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1600367758-28589-1-git-send-email-clabbe@baylibre.com>
References: <1600367758-28589-1-git-send-email-clabbe@baylibre.com>
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
index b92d175b5d2a..2614640231dc 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
@@ -188,12 +188,12 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 	 * we can use the SS optimized function
 	 */
 	while (in_sg && no_chunk == 1) {
-		if (in_sg->length % 4)
+		if (in_sg->length % 4 || !IS_ALIGNED(in_sg->offset, sizeof(u32)))
 			no_chunk = 0;
 		in_sg = sg_next(in_sg);
 	}
 	while (out_sg && no_chunk == 1) {
-		if (out_sg->length % 4)
+		if (out_sg->length % 4 || !IS_ALIGNED(out_sg->offset, sizeof(u32)))
 			no_chunk = 0;
 		out_sg = sg_next(out_sg);
 	}
-- 
2.26.2

