Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 961D24769E3
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 06:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbhLPFrh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 00:47:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbhLPFrg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Dec 2021 00:47:36 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD065C061574
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 21:47:36 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id j6-20020a17090a588600b001a78a5ce46aso1476986pji.0
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 21:47:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Nbyp8/6X0WqSNp8jnbDdcxcWoNjO7EJNqsATM51PSEU=;
        b=beyONnShDPGdkCwIBLXX5FMq5EKeTMXNqkOAugot5sbSd+BdLKLwqfj4sXERTHyNZ5
         GO9R0dmIg8BpZ8aBrWl6lxVViHM0IIUdLZezB3q2y72a0jyVNayuelexNvBq6d4jbfdh
         ElYAavuZ0F6kjt4pfy995cyrlHCObGQZ5yTYv9YyJX8i1zjbHPU1yS1UYirAoKPzU4gY
         FXbs5iOyc9cKgAUJwmrRhD44mM3N/xtbHa0eo8eOoYVqemHuNntvGCWZ2xR2oU8OXEE8
         wYDIhHRca5Dv8M815q8npXSFO8hmH2L9OnsphwBPz9pOL0T/5JSY4kxHLf+UJ0lq8XBd
         wXvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Nbyp8/6X0WqSNp8jnbDdcxcWoNjO7EJNqsATM51PSEU=;
        b=B/fDdpp7BkrzHxlNj2dSWdsVDadABo7THV5DWD4wcaOjAURKzBI4Ecn3u9+lAwfUvD
         a9BuVxQiSnWVPVFVtrthULfQPXkVmtPRTDdxyUQXeQRZnqJEjd5RNwc+N7IjkVFB9xx2
         Op8KhS9YVEPHc5GLD9uB5uliQtWS9nNSvdxcRlETjUnvMoVS+ZHRSZjepP/SxY8m9eOe
         M85/Tp+tYJB4Lz/10GGDyLFFz/k4aXsrIoyWsDJd/KW7ZXD6XfpPJ7fj2g9smRVLBYbm
         Tn7XdgjTMrAnn+iklBszohK211I0dFJSyOiYwuivBRvb8mBYaPQ+yszNosLFXAbs5OWQ
         amzA==
X-Gm-Message-State: AOAM532vjQtiVNqHRehtlZGObqTtH783L+iYrXkX6tFtO4AvQFV7pRi7
        o0g2fn0h4sRlJIzQrh4qMNqdJg==
X-Google-Smtp-Source: ABdhPJzhN+Tb6MUEYkSI6aa4ahIbkdNwYYy4GfhTa/B5OkqT0DXMiwTu8XZaJHj8WvpEbFAbWvxBIw==
X-Received: by 2002:a17:90b:4d09:: with SMTP id mw9mr4127162pjb.238.1639633656369;
        Wed, 15 Dec 2021 21:47:36 -0800 (PST)
Received: from localhost.localdomain ([223.178.210.148])
        by smtp.gmail.com with ESMTPSA id o23sm4120195pfp.209.2021.12.15.21.47.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 21:47:35 -0800 (PST)
From:   Sumit Garg <sumit.garg@linaro.org>
To:     op-tee@lists.trustedfirmware.org
Cc:     jens.wiklander@linaro.org, tyhicks@linux.microsoft.com,
        Patrik.Lantz@axis.com, Lars.Persson@axis.com,
        Sumit Garg <sumit.garg@linaro.org>, stable@vger.kernel.org,
        Patrik Lantz <patrik.lantz@axis.com>
Subject: [PATCH v2] tee: optee: Fix incorrect page free bug
Date:   Thu, 16 Dec 2021 11:17:25 +0530
Message-Id: <20211216054725.3873834-1-sumit.garg@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Pointer to the allocated pages (struct page *page) has already
progressed towards the end of allocation. It is incorrect to perform
__free_pages(page, order) using this pointer as we would free any
arbitrary pages. Fix this by stop modifying the page pointer.

Fixes: ec185dd3ab25 ("optee: Fix memory leak when failing to register shm pages")
Cc: stable@vger.kernel.org
Reported-by: Patrik Lantz <patrik.lantz@axis.com>
Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
Reviewed-by: Tyler Hicks <tyhicks@linux.microsoft.com>
---

Changes since v1:
- Added stable CC tag.
- Picked up Tyler's review tag.

 drivers/tee/optee/core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/tee/optee/core.c b/drivers/tee/optee/core.c
index ab2edfcc6c70..2a66a5203d2f 100644
--- a/drivers/tee/optee/core.c
+++ b/drivers/tee/optee/core.c
@@ -48,10 +48,8 @@ int optee_pool_op_alloc_helper(struct tee_shm_pool_mgr *poolm,
 			goto err;
 		}
 
-		for (i = 0; i < nr_pages; i++) {
-			pages[i] = page;
-			page++;
-		}
+		for (i = 0; i < nr_pages; i++)
+			pages[i] = page + i;
 
 		shm->flags |= TEE_SHM_REGISTER;
 		rc = shm_register(shm->ctx, shm, pages, nr_pages,
-- 
2.25.1

