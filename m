Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B35553F5DC8
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 14:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbhHXMUK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 08:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237183AbhHXMQZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Aug 2021 08:16:25 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97860C061757
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 05:15:41 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id e5so14438282wrp.8
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 05:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nRPKXuKClzY04XjEratZIV5Uap5YYP0xzzA287afDts=;
        b=UXY/xdKxTAQGATnwURe1Fu5CsMDZU0WNMuCqoU29m0Wxc/iO+P61g9hzrS7SliVmoL
         3v6ZoC9pyUfCwVjPtq/4Adzmy1Qf62wxf4BcoD5GEZRwcniQLVPS2cAj4ygpmF+kfXlJ
         OQKcYi6p3UDBx8on7QIIZt6F1+bRokoEWFQ8wJyoAuVabHhdAaG9LMkEqNuuAyVPF5EA
         5L9K/geCx5rPZtr91RlTvMOs73vHAHlpJMNS/Lv4O4SJ01b4aYyXtjV/BsM4qi4tyhrz
         u+hoJC32TDe5Kc0cqe9kJ9AYllS/+mS9NPZ5BR5xpay/VkPTqS9OXRNIQSNNQij6dNuV
         zlIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nRPKXuKClzY04XjEratZIV5Uap5YYP0xzzA287afDts=;
        b=SbjZRswpFLzqV/tI9gssZ5aEpJLGHvMvN4vSgJ30bOkpylKeNXYbS/FO92kDxZq+PN
         sNxxsaySbkkUeBlnF4EQs88kkZpF0uzSaceddv/2zdmnkL/sE67mKGQlfJomVoH6Vp2V
         xRIen5IfEVK/Dkq2sG+yYMgCPuQGm2Pm+wjhQLoPlxDOmki7JtummLsoc1SP+BksBBXI
         6HbKVif7T+t5bN+88f9eElFg6yUheKWOKDfusMq8RTtZk72WpSDytIs6ibAHffZ6Uvwa
         DT4fEKQ4LBNEVIUbzpDoel7ACfBY0/bZRID81qx/3RBUiwliLExWep5O5EvOzJutbuPY
         ke5A==
X-Gm-Message-State: AOAM5328AIJlup5e5VSw4QJ9TVRMBhfM5wvboNO3Jn3URiAkpsHakHWK
        QA97KFXRKBoVE360Yfv/hvc=
X-Google-Smtp-Source: ABdhPJzQBPKCMBuDPFBwcGUHJ9IyIzohHieTJMG5FUj3aWPjPl9zJv8Jvx/EZCfcuSCMu6nxQjYEVg==
X-Received: by 2002:a05:6000:1b8e:: with SMTP id r14mr19691913wru.251.1629807340229;
        Tue, 24 Aug 2021 05:15:40 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.113])
        by smtp.gmail.com with ESMTPSA id o12sm13629wro.51.2021.08.24.05.15.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 05:15:39 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 backport] io_uring: fix xa_alloc_cycle() error return value check
Date:   Tue, 24 Aug 2021 13:15:01 +0100
Message-Id: <efdf0cfa5a2ffe1fb9e08d3e1918a9a84385384b.1629807216.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ upstream commit a30f895ad3239f45012e860d4f94c1a388b36d14 ]

We currently check for ret != 0 to indicate error, but '1' is a valid
return and just indicates that the allocation succeeded with a wrap.
Correct the check to be for < 0, like it was before the xarray
conversion.

Cc: stable@vger.kernel.org
Fixes: 61cf93700fe6 ("io_uring: Convert personality_idr to XArray")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8492b4e7c4d7..108b0ed31c11 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9602,11 +9602,12 @@ static int io_register_personality(struct io_ring_ctx *ctx)
 
 	ret = xa_alloc_cyclic(&ctx->personalities, &id, (void *)iod,
 			XA_LIMIT(0, USHRT_MAX), &ctx->pers_next, GFP_KERNEL);
-	if (!ret)
-		return id;
-	put_cred(iod->creds);
-	kfree(iod);
-	return ret;
+	if (ret < 0) {
+		put_cred(iod->creds);
+		kfree(iod);
+		return ret;
+	}
+	return id;
 }
 
 static int io_register_restrictions(struct io_ring_ctx *ctx, void __user *arg,
-- 
2.32.0

