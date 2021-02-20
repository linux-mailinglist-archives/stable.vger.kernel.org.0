Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB9DA3202AA
	for <lists+stable@lfdr.de>; Sat, 20 Feb 2021 02:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbhBTBod (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Feb 2021 20:44:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbhBTBod (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Feb 2021 20:44:33 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAED6C06178A;
        Fri, 19 Feb 2021 17:43:52 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id l17so8509368wmq.2;
        Fri, 19 Feb 2021 17:43:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FYBarikwV1Yze5t65acElvgiT8V84oWK6ytr04KyxP0=;
        b=MH8aAhcGXY7DqSh7aoWco8F4EKL/RSRsQegjuDYdk1T0fw7/94mRrUFROU2VF1oJyz
         v5ciOw0k+hMNFCxQVxhpZCio5UsfNVXA3Fg+Jk+Okx0tpxAbooESc37DXJsrPftxZqPy
         vlAcWJBee5FkLunbYMJgxZ6keqXm0GfG1Jw4OYRqm4LyJekgMPmyBX6BeyoqZ9fAOWBB
         rxp8lqFgCszFKwj6sEIR0PUSg1Yziq8oXHI4V6j2HKh/i9s5Mr6QqhXH2oFbLRwh+twS
         GMRRe8ltZ44AHRg5kkN2D2r5w/yhiTl1jxYAmQKuR9n8YIfZh6KEpGFc3nS/8+O03DAm
         MsUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FYBarikwV1Yze5t65acElvgiT8V84oWK6ytr04KyxP0=;
        b=pYRO2JqPMerlZeaoozUyhekOtfrKsgKutjwiGZ+tBF7ZDXkIGJMn1LE1u4SbTTgKW6
         DcaefRXWYsSX/38Jp38VTRyWtdyRzlO6YlpWFP/48Ma77vExHckUXj+5gF+D/hh9nxaU
         F+sZ1wmJfQvPNz+MnRcE58Bdp16K4UWZwf1Ce6B3OYjwsVjBydOZc0HpBg9ElhSQhVN8
         MJb8SVyo+mzL5S4R5OmjS4z7e5S/UAys5wGt1ONk30I6WTh8X0Lfu88nz8RGZtNaV645
         Dj+7lGOMdedVS4XnoCOFj8JnSFm2UJakuQLqG/LogYVoFjqwMRF/smV8oFcBteaIKsC6
         oECg==
X-Gm-Message-State: AOAM5322k5hbtbY7aRh5Ej/1f2448RWBVmMEbZca84K8NloYYpYomoBr
        nwykMv9ExsR0ce3FDGJFVK3aTPQrqC8vDQ==
X-Google-Smtp-Source: ABdhPJzCIDNZccAD7IJ/7I2Ojod1e26nzwZ6MYJ/LBaSO9u0RMs5wFrq5iMKRsgmFlklZLtQ13cM7A==
X-Received: by 2002:a05:600c:1991:: with SMTP id t17mr10535446wmq.118.1613785430366;
        Fri, 19 Feb 2021 17:43:50 -0800 (PST)
Received: from localhost.localdomain ([85.255.236.139])
        by smtp.gmail.com with ESMTPSA id f7sm16056595wrm.92.2021.02.19.17.43.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 17:43:50 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 1/2] io_uring: wait potential ->release() on resurrect
Date:   Sat, 20 Feb 2021 01:39:52 +0000
Message-Id: <75e1c94aff46a5bc409f50e50207f4d9a01ff9a0.1613785076.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613785076.git.asml.silence@gmail.com>
References: <cover.1613785076.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There is a short window where percpu_refs are already turned zero, but
we try to do resurrect(). Play nicer and wait for all users to leave RCU
section.

Cc: <stable@vger.kernel.org> # 5.5+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f3af499b12a9..ce5fccf00367 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7351,6 +7351,7 @@ static int io_rsrc_ref_quiesce(struct fixed_rsrc_data *data,
 			break;
 
 		percpu_ref_resurrect(&data->refs);
+		synchronize_rcu();
 		io_sqe_rsrc_set_node(ctx, data, backup_node);
 		reinit_completion(&data->done);
 		mutex_unlock(&ctx->uring_lock);
@@ -10089,6 +10090,7 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 
 		if (ret) {
 			percpu_ref_resurrect(&ctx->refs);
+			synchronize_rcu();
 			goto out_quiesce;
 		}
 	}
-- 
2.24.0

