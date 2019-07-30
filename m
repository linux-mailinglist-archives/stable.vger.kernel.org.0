Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 833D27B43E
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 22:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387428AbfG3USo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jul 2019 16:18:44 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39793 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387412AbfG3USo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jul 2019 16:18:44 -0400
Received: by mail-pf1-f195.google.com with SMTP id f17so26424170pfn.6
        for <stable@vger.kernel.org>; Tue, 30 Jul 2019 13:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OThpbHHUC3Uzer47hD7L3j/FRmubmQM25l1ctW+M5BU=;
        b=r8dUP1oLoX0rI48nRr1wJzR/hiT/S/F2zl9Bq+7xNScYAqfJx8N3acI3fd/F8rohVa
         GXDj71uXTTj2xTlKFLwVcf6xa8TbbPYVWd8rCCL2gXHooMQM+/OR4GpDKKfZPmdj7cxd
         WIAnWQFero52o3ektOrPJFRzte1MaZobdhlpCz8F2QsuRogS/uqKLcWtICfDyTXRF4W2
         VcyXIGBJgyRIcmONu3tKMwiDG7fa5pxs4motMKoFwH7ZBu6MARvmKRR/siAHqTbiDl5X
         rTIFtdvXX4i6PDi7SHuySl9gZGIl6gO6MztR2nwWiS3ev78DY0Q1iDKB/yQpoj58S/W7
         u0vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=OThpbHHUC3Uzer47hD7L3j/FRmubmQM25l1ctW+M5BU=;
        b=iJpvA3JNx6ZGHAwK9wba1V++vMKduCdAzI9uaAUbCTmt45sSIhkjora5wJ79W7FmA1
         giZZu6LHtxj6mvsA/rNA3j9UmTisAWzL3Kp/SDzcsoPGpA2fAZtmCauaPcsAlUwQBjDJ
         /8gOUVRoRp8K3XmXjcDPJhCHwrpjZRvdgHCgGbF9yh90VDkDsoyzrrHjaUEhsG8navEJ
         7cqx3AKH8ra4kTCtufMxi4d71mAk5f8yGMJv+qQHVvBnXTMIcUfr2bRz9SU6Xatw0an/
         M7DGGMu2ybvPg905IsMkC3ghz32LPYqAm/3U+chKmET6kykC8zl72BBXsJBEBdxUMTfm
         IeMA==
X-Gm-Message-State: APjAAAXao9lus0OGWTNXv4f3Qn8dmMqQYF/yrxZR1jgB7RVKC4v+QpR2
        ayp7s2OfQtfdJvYNnt27ctvZkQ==
X-Google-Smtp-Source: APXvYqxh/tNnp9+tld9wqh2Cu0/n1bKdqZM8RfjA/twu6mGeoX6zASIEKY4T3A6kpX6RGOBRkA8vNQ==
X-Received: by 2002:a62:3c3:: with SMTP id 186mr43545291pfd.21.1564517923708;
        Tue, 30 Jul 2019 13:18:43 -0700 (PDT)
Received: from localhost.localdomain ([49.207.49.136])
        by smtp.gmail.com with ESMTPSA id r75sm88113177pfc.18.2019.07.30.13.18.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 30 Jul 2019 13:18:42 -0700 (PDT)
From:   Amit Pundir <amit.pundir@linaro.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Stable <stable@vger.kernel.org>, Wen Yang <wen.yang99@zte.com.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        Armijn Hemel <armijn@tjaldur.nl>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH for-4.14.y 3/3] crypto: crypto4xx - fix a potential double free in ppc4xx_trng_probe
Date:   Wed, 31 Jul 2019 01:48:33 +0530
Message-Id: <1564517913-17164-3-git-send-email-amit.pundir@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564517913-17164-1-git-send-email-amit.pundir@linaro.org>
References: <1564517913-17164-1-git-send-email-amit.pundir@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Yang <wen.yang99@zte.com.cn>

commit 95566aa75cd6b3b404502c06f66956b5481194b3 upstream.

There is a possible double free issue in ppc4xx_trng_probe():

85:	dev->trng_base = of_iomap(trng, 0);
86:	of_node_put(trng);          ---> released here
87:	if (!dev->trng_base)
88:		goto err_out;
...
110:	ierr_out:
111:		of_node_put(trng);  ---> double released here
...

This issue was detected by using the Coccinelle software.
We fix it by removing the unnecessary of_node_put().

Fixes: 5343e674f32f ("crypto4xx: integrate ppc4xx-rng into crypto4xx")
Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Cc: <stable@vger.kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Allison Randal <allison@lohutok.net>
Cc: Armijn Hemel <armijn@tjaldur.nl>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
---
Cleanly apply on 4.9.y as well.

 drivers/crypto/amcc/crypto4xx_trng.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/amcc/crypto4xx_trng.c b/drivers/crypto/amcc/crypto4xx_trng.c
index 368c5599515e..a194ee0ddbb6 100644
--- a/drivers/crypto/amcc/crypto4xx_trng.c
+++ b/drivers/crypto/amcc/crypto4xx_trng.c
@@ -111,7 +111,6 @@ void ppc4xx_trng_probe(struct crypto4xx_core_device *core_dev)
 	return;
 
 err_out:
-	of_node_put(trng);
 	iounmap(dev->trng_base);
 	kfree(rng);
 	dev->trng_base = NULL;
-- 
2.7.4

