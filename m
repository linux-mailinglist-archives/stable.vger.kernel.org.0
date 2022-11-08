Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5704D620DCC
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 11:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233694AbiKHKxM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 05:53:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232911AbiKHKxM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 05:53:12 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F15845EC3
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 02:53:11 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id 130so684648pgc.5
        for <stable@vger.kernel.org>; Tue, 08 Nov 2022 02:53:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cgfqpz+qWE1QdvFfSX/U7yr3LOPeMHUv9Uef5mfoW4E=;
        b=VFCiPtKP88x+XK6sVYmvdE8tLCkGVo5m1vNi8sJNjLu4UW7r0xJy5aCJcqvbTpyR2S
         b0o8nr2AMfFM7ZNPpa6gqw3x+kHsOcVi3T4ojOaJ5o+xtKFRnZ0eD8lrTPeAFHf+79f6
         sR3nJWQHzjtKn4QgfT7UdKVN2dWuV1B8GwghVhODUBwLkkWDX+/gNWN3lGpUbMDJ1MV9
         pLnl5Y6VERvW783H0TWb3g/qEQjFPpHrHrdWWLt3ExWs85H6XJqvh+ygYipg2TqIqO3f
         hcyO1lk1wjwxw0fq7uev0/hkgK+7OO0G5Gldc9rzJRA9eAOLztsLmmom7+Pj81IeSC3K
         W1Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cgfqpz+qWE1QdvFfSX/U7yr3LOPeMHUv9Uef5mfoW4E=;
        b=0ou6vOnZI0LK+4b/si3zvF4ilTTjAc+xJwIbQGG/IlXRcwZzeTvN3YPW+zrWRc7HFh
         G3nNfDiLMDr99Mi5sakhAlrOzOs7edYixVooz61RHjWfcVzB6J537VSFfS9bTIxvQZeu
         Bm/EscuZbono2QD97L/8tuBFOnGmDAcjyDOjWJHoRZEFb1BufB6Cs7XBvfO4da4t7W3Q
         pZDY0y5iBWSwqe4Fvmy5VMESTPWBENvGo2i3yyDFuaFqCd08h7+YRERH7R2GqC0il7ma
         cfFR2IarRlWTPyNRUwp5cUWLerAMwcW28YyGGqyF46S6mRZJEN59XejGY1cj7eSOmpU3
         fclg==
X-Gm-Message-State: ACrzQf0PFS/d/OA4gPYxnq0I7ZOLktOR9K+isNi3YTcuaS8uIVmL6FTb
        AGas4i4lsXbT5P+kjFHcFc3tK5vOzq2b0g==
X-Google-Smtp-Source: AMsMyM7m2FDYu2EEcnBqvDk0q5GIcufVfYsNOqhRkPWM7PeL75R0aM7vM+rVTTb5SbeLGYvMKwL1pQ==
X-Received: by 2002:a63:66c3:0:b0:470:8fd:7bae with SMTP id a186-20020a6366c3000000b0047008fd7baemr29241905pgc.277.1667904790527;
        Tue, 08 Nov 2022 02:53:10 -0800 (PST)
Received: from sumit-X1.. ([223.178.212.236])
        by smtp.gmail.com with ESMTPSA id l5-20020a170903120500b0018863dbf3b0sm2129564plh.45.2022.11.08.02.53.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 02:53:09 -0800 (PST)
From:   Sumit Garg <sumit.garg@linaro.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, jens.wiklander@linaro.org,
        jerome.forissier@linaro.org, Sumit Garg <sumit.garg@linaro.org>,
        Sahil Malhotra <sahil.malhotra@nxp.com>
Subject: [PATCH] tee: Fix tee_shm_register() for kernel TEE drivers
Date:   Tue,  8 Nov 2022 16:23:01 +0530
Message-Id: <20221108105301.1925751-1-sumit.garg@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 056d3fed3d1f ("tee: add tee_shm_register_{user,kernel}_buf()")
refactored tee_shm_register() into corresponding user and kernel space
functions named tee_shm_register_{user,kernel}_buf(). The upstream fix
commit 573ae4f13f63 ("tee: add overflow check in register_shm_helper()")
only applied to tee_shm_register_user_buf().

But the stable kernel 4.19, 5.4, 5.10 and 5.15 don't have the above
mentioned tee_shm_register() refactoring commit. Hence a direct backport
wasn't possible and the fix has to be rather applied to
tee_ioctl_shm_register().

Somehow the fix was correctly backported to 4.19 and 5.4 stable kernels
but the backports for 5.10 and 5.15 stable kernels were broken as fix
was applied to common tee_shm_register() function which broke its kernel
space users such as trusted keys driver.

Fortunately the backport for 5.10 stable kernel was incidently fixed by:
commit 606fe84a4185 ("tee: fix memory leak in tee_shm_register()"). So
fix the backport for 5.15 stable kernel as well.

Fixes: 578c349570d2 ("tee: add overflow check in register_shm_helper()")
Cc: stable@vger.kernel.org # 5.15
Reported-by: Sahil Malhotra <sahil.malhotra@nxp.com>
Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
---
 drivers/tee/tee_core.c | 3 +++
 drivers/tee/tee_shm.c  | 3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/tee/tee_core.c b/drivers/tee/tee_core.c
index 3fc426dad2df..a44e5b53e7a9 100644
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
index bd96ebb82c8e..6fb4400333fb 100644
--- a/drivers/tee/tee_shm.c
+++ b/drivers/tee/tee_shm.c
@@ -223,9 +223,6 @@ struct tee_shm *tee_shm_register(struct tee_context *ctx, unsigned long addr,
 		goto err;
 	}
 
-	if (!access_ok((void __user *)addr, length))
-		return ERR_PTR(-EFAULT);
-
 	mutex_lock(&teedev->mutex);
 	shm->id = idr_alloc(&teedev->idr, shm, 1, 0, GFP_KERNEL);
 	mutex_unlock(&teedev->mutex);
-- 
2.34.1

