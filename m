Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51DCC47FC84
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 13:14:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233755AbhL0MOq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 07:14:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233695AbhL0MOq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 07:14:46 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0177DC06173E
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 04:14:45 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id l10so13422734pgm.7
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 04:14:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i74iqWhBJENtOvuw3K6D2opqyt58hJwnKN+RDkhJDg8=;
        b=tgFCejzHrIl30djpscJMLP1qjS8quRfsRdgRBwdoeB4zrcwM+rR9fA3TIbq6A4NSzv
         lOhTLCFRgJVhp07PwGRiqqP8iPrlsZhovO6uoJh197b7OPRSRjlMZqZMAS/xtyB/ZNhH
         TNPezFGI7ZWQqjM4keiVao44yqBxc+xUyxnHybusQkoFteHv15O5i21y5lwSxebnsdbe
         sDHKJDgngHnrzSPGRVx+nhXc3TVzM+KqcvHV5Wo/z7MHGvOHAkP5MSRRAdTw/AF3YpR+
         cuquDegVUm1wnfVxoBzwgzH43Sr9ulec8g2cH1FSoNdicDIr1B7l4HU3wDJqA6hy4dM4
         0OAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i74iqWhBJENtOvuw3K6D2opqyt58hJwnKN+RDkhJDg8=;
        b=kzj9BcOQ6JMRQ+6HG7n+bJMyqzGbp1CY7UY4p411VpfceaK17iUU8P27Mqugkvn8oY
         tv6DNZ9SZLv+fznl9rUjdG0oSJtqTVP3sJvAy+dnHF0Cp1JNk90uPlksxHqzOU2QExai
         1X3iXJXtGPcDO/2fFZUI+JEn6fkSJYY8vUUFRnJ8W3an4GyI4NJBFhuzDX10Xp8eVP42
         ppwvyxavpJVT5iRITw3wF2jgAUuKRIsLb6v73hpTzYPgJKiVLGHPKWMFQ5FuofF7nPVl
         GZidMsFXeV2BNM6p1NadD9HmmDHU9V+KK0DBa0OKYwz1a893y5+ZGIIHeddsACY39EBF
         fqcw==
X-Gm-Message-State: AOAM530wpTz0RRWby6/pr2/89Me6Cu2kKMlQD/HiEYzK21ENJH1Jxpez
        V6Q49nq0rpQQfX64F2Xlt4/qXmByyVMo8w==
X-Google-Smtp-Source: ABdhPJx+KbKaDlrd8gaVx7QdB4ZLCda9d3GV66wqqi6p5OlGepPH9BPWvCwNzHyrcmZ5VTTXL6wVaQ==
X-Received: by 2002:a63:1748:: with SMTP id 8mr15245668pgx.33.1640607284988;
        Mon, 27 Dec 2021 04:14:44 -0800 (PST)
Received: from localhost.localdomain ([223.178.210.143])
        by smtp.gmail.com with ESMTPSA id lp17sm17459535pjb.15.2021.12.27.04.14.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Dec 2021 04:14:44 -0800 (PST)
From:   Sumit Garg <sumit.garg@linaro.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, jens.wiklander@linaro.org,
        patrik.lantz@axis.com, tyhicks@linux.microsoft.com,
        Sumit Garg <sumit.garg@linaro.org>
Subject: [PATCH backport for 5.4/5.10/5.15] tee: optee: Fix incorrect page free bug
Date:   Mon, 27 Dec 2021 17:44:32 +0530
Message-Id: <20211227121432.2694129-1-sumit.garg@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 18549bf4b21c739a9def39f27dcac53e27286ab5 upstream.

Pointer to the allocated pages (struct page *page) has already
progressed towards the end of allocation. It is incorrect to perform
__free_pages(page, order) using this pointer as we would free any
arbitrary pages. Fix this by stop modifying the page pointer.

Fixes: ec185dd3ab25 ("optee: Fix memory leak when failing to register shm pages")
Cc: stable@vger.kernel.org
Reported-by: Patrik Lantz <patrik.lantz@axis.com>
Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
Reviewed-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
[SG: Backport for stable kernels]
Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
---
 drivers/tee/optee/shm_pool.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/tee/optee/shm_pool.c b/drivers/tee/optee/shm_pool.c
index d167039af519..1aa843f2ecc7 100644
--- a/drivers/tee/optee/shm_pool.c
+++ b/drivers/tee/optee/shm_pool.c
@@ -41,10 +41,8 @@ static int pool_op_alloc(struct tee_shm_pool_mgr *poolm,
 			goto err;
 		}
 
-		for (i = 0; i < nr_pages; i++) {
-			pages[i] = page;
-			page++;
-		}
+		for (i = 0; i < nr_pages; i++)
+			pages[i] = page + i;
 
 		shm->flags |= TEE_SHM_REGISTER;
 		rc = optee_shm_register(shm->ctx, shm, pages, nr_pages,
-- 
2.25.1

