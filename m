Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC8B59D60D
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241190AbiHWIzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241298AbiHWIzI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:55:08 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89EC37F086
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 01:24:20 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id bx38so12785437ljb.10
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 01:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=H4fKbvQy47LJY22TJrPVC0zWABgw1+ITLVe3ov0As3A=;
        b=YzicVcwE+831q/YdyUOPJseZ9D0r1zEXflcFFcy0u5TSYPsqds72r52c9YmYYDetNF
         CFrXEfHo8tD07jYQJvqtgL43B0uxV/fUzjfZPMjN9iQcV3zCV8Nh1SiTdcWyd5/scGui
         p4FBtyzYEWGMXs73D39vcWaa3qPykT3RXEj5EKqnT0CYCz/CJoTVg1snEWBMTZfRxGg4
         WsXlxoKLnyx5tMo5ZH5M+d1TIE9w2L51D3DQi9TkHAuZOLx3XJLkDG2Q5Fts5mjeoayi
         8hsca/L5UG/OKTwYSxUKBRUtQ5bfGRL9l//WuM5sijmgaJ4TYgKlriB58ZNkBqCdC0oj
         zYgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=H4fKbvQy47LJY22TJrPVC0zWABgw1+ITLVe3ov0As3A=;
        b=gdOnWwzlKZF3xekpmYZDMViMWyoMraAMij8epkTwrjpe7nHfUJ8vMkumDMaFTCFTAI
         q1bXqVz399NKkoqfB1b9oIVWn8rWXYdHiq2AvavLK1B0PKsE+s9Y0UqniHvaVsl1vFEq
         Xz5C0CIzib4KPVW13uuZnxatGktKICpdqZPQugQfK7sK2XGdcJv2+WDyLhgb9rJXWQKJ
         IPw7vnDpRLobkBNKvm5FVrqA9axERTmG7CtI7pNBfn5RMxR1aNEYvxtbfnU4+Num4IB7
         j4nPQQcSprA4vSA0Nm+OnBB9rY/IeGQFjsgkWPPbQmNXu/Ta9VZuX6+AFPsMUlY4+X9X
         q0lA==
X-Gm-Message-State: ACgBeo1tgG4Q+jjWMvjVwTD1XyIfBi3d7rwhX6VWoAyA8S2dd2A2YkoK
        wPOQC+oMnWikwELDmlg7azQi08HbjNIs/w==
X-Google-Smtp-Source: AA6agR5NUfiikrGeSA7mf+4N2DaumtJ5L69IDNIygv+rfWjGQ2aGfAru56Eau1Q8CLl5XjqX+ArLpg==
X-Received: by 2002:a05:651c:2127:b0:261:be89:e086 with SMTP id a39-20020a05651c212700b00261be89e086mr5186788ljq.524.1661243009727;
        Tue, 23 Aug 2022 01:23:29 -0700 (PDT)
Received: from jade.urgonet (h-79-136-84-253.A175.priv.bahnhof.se. [79.136.84.253])
        by smtp.gmail.com with ESMTPSA id a9-20020a056512200900b0048a7c86f4e7sm852056lfb.291.2022.08.23.01.23.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 01:23:28 -0700 (PDT)
From:   Jens Wiklander <jens.wiklander@linaro.org>
To:     stable@vger.kernel.org
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Pavel Machek <pavel@denx.de>
Subject: [PATCH for 5.10.y] tee: fix memory leak in tee_shm_register()
Date:   Tue, 23 Aug 2022 10:23:26 +0200
Message-Id: <20220823082326.9155-1-jens.wiklander@linaro.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Moves the access_ok() check for valid memory range from user space from
the function tee_shm_register() to tee_ioctl_shm_register(). With this
we error out early before anything is done that must be undone on error.

Fixes: 578c349570d2 ("tee: add overflow check in register_shm_helper()")
Cc: stable@vger.kernel.org # 5.10
Reported-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
---
Hi,

This patch targets the 5.10.y release to take care of a recently introduced
issue there.

Thanks,
Jens

 drivers/tee/tee_core.c | 3 +++
 drivers/tee/tee_shm.c  | 3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/tee/tee_core.c b/drivers/tee/tee_core.c
index e07f997cf8dd..9cc4a7b63b0d 100644
--- a/drivers/tee/tee_core.c
+++ b/drivers/tee/tee_core.c
@@ -334,6 +334,9 @@ tee_ioctl_shm_register(struct tee_context *ctx,
 	if (data.flags)
 		return -EINVAL;
 
+	if (!access_ok((void __user *)(unsigned long)data.addr, data.length))
+		return -EFAULT;
+
 	shm = tee_shm_register(ctx, data.addr, data.length,
 			       TEE_SHM_DMA_BUF | TEE_SHM_USER_MAPPED);
 	if (IS_ERR(shm))
diff --git a/drivers/tee/tee_shm.c b/drivers/tee/tee_shm.c
index 6e662fb131d5..499fccba3d74 100644
--- a/drivers/tee/tee_shm.c
+++ b/drivers/tee/tee_shm.c
@@ -222,9 +222,6 @@ struct tee_shm *tee_shm_register(struct tee_context *ctx, unsigned long addr,
 		goto err;
 	}
 
-	if (!access_ok((void __user *)addr, length))
-		return ERR_PTR(-EFAULT);
-
 	mutex_lock(&teedev->mutex);
 	shm->id = idr_alloc(&teedev->idr, shm, 1, 0, GFP_KERNEL);
 	mutex_unlock(&teedev->mutex);
-- 
2.31.1

