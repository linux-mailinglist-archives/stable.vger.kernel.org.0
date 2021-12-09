Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF06446EC68
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 17:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239832AbhLIQDe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 11:03:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235371AbhLIQDd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Dec 2021 11:03:33 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19584C0617A2
        for <stable@vger.kernel.org>; Thu,  9 Dec 2021 08:00:00 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id gf14-20020a17090ac7ce00b001a7a2a0b5c3so7238646pjb.5
        for <stable@vger.kernel.org>; Thu, 09 Dec 2021 08:00:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tSG14DSt7/Tmpz/JNuX2OS/Kqmuhs9FcXFa/pRz5wao=;
        b=mI4wfpVBNpZApZ7mdKX9C4ABPIUnuiPnaHLo2UoBdUt7o2rtMQdqf5EnK0VUe/lVoF
         X2ciDblMVWnvdUl8y8NP6+cKUEvpax3ZYKfQbR89Fk9m/t+7FMVniNsYAdTEmQfEVVhY
         7z+nnjc14GkRrMU3Eb0XKTf1aBV4+KYs/IhXXbzDcSuJRSmqTR8LjYXGWE/xC+ycRnit
         CydLeZnjP4ulibKFZztITGwmxoMh8YjPFz35B386XhOIv24IwB3tekPsXz7gmNDDIlaL
         E7Vva0q4bxBiUoQDXhjGfnOur2302rMwYEUJFWHpqGvauggxnoRxdm6o3dhfcO9cc9h7
         EiJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tSG14DSt7/Tmpz/JNuX2OS/Kqmuhs9FcXFa/pRz5wao=;
        b=AoUB0uc/e69T72BrkoMhfMGEmmwjPwPstyJ/+sxNjGigD1Df+3D3gN3cA7D8oNjRoT
         6wQxGZpp9Y3/UcQ+1d7Lt7T1C339XI63YP0T5nAT+avsqUkZAynuqk2T7OyGPuo4Nhku
         flY75An93bjv3L1U7pujFymnSq0PEFfY96yvVbuRb/HBW+5s995I92NqQhgjZaBW2dLf
         bunwH5qHfPTol4MpVCjGs9nUgVO0Rhi0Pl26vMcg3pxQqDTAYN/PdltZBENrlP9UJLQJ
         Jugy1V7gut9Bxd901hBvDEmmjrU6hdT9dKoc/hj90bt98149p2ZcWBhsluTEfJ/cYDWs
         C6Jw==
X-Gm-Message-State: AOAM530B57lcg2CLGHd3wQTttAhTvm7oGR1CFYAAJZHmBKz7Xo2UYcLY
        ckJ2+zrVQ4urNAelu/valY8vU60VwnpwPA==
X-Google-Smtp-Source: ABdhPJzo02U3Yp+DKsQbLQ21tpfJJWrJgkNZqU7TvOBJnHXN23IzSEbzSzHVey99YMeTVbRiKatEzA==
X-Received: by 2002:a17:902:e74e:b0:142:fa5:49f1 with SMTP id p14-20020a170902e74e00b001420fa549f1mr68249942plf.84.1639065599585;
        Thu, 09 Dec 2021 07:59:59 -0800 (PST)
Received: from localhost.localdomain ([66.185.175.30])
        by smtp.gmail.com with ESMTPSA id q17sm146875pfu.117.2021.12.09.07.59.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 07:59:59 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org
Subject: [PATCH 1/2] io_uring: check tctx->in_idle when decrementing inflight_tracked
Date:   Thu,  9 Dec 2021 08:59:55 -0700
Message-Id: <20211209155956.383317-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211209155956.383317-1-axboe@kernel.dk>
References: <20211209155956.383317-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If we have someone potentially waiting for tracked requests to finish,
ensure that we check in_idle and wake them up appropriately.

Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c4f217613f56..b4d5b8d168bf 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6640,6 +6640,8 @@ static void io_clean_op(struct io_kiocb *req)
 		struct io_uring_task *tctx = req->task->io_uring;
 
 		atomic_dec(&tctx->inflight_tracked);
+		if (unlikely(atomic_read(&tctx->in_idle)))
+			wake_up(&tctx->wait);
 	}
 	if (req->flags & REQ_F_CREDS)
 		put_cred(req->creds);
-- 
2.34.1

