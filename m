Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C11E64ECA5F
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 19:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244733AbiC3RQJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 13:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349196AbiC3RQJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 13:16:09 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43406369D5
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 10:14:24 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id 125so25555582iov.10
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 10:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=91o5m+5L+PwadXFVD9/3GjV5ZkMW9EJG7Rtl/ZPXSt4=;
        b=o5kMbVqueoRsVErzbYIiMRyjJdOByw+vYjOy91qG1nsJDqy6xVGiq4KyQvcJzQQ6cO
         3x/xLheZ7LvQTvvdRgTwpphXZPOGH7W+/cp8hzRXIDhGN7RzsDLb03fOrrgbi0RXQlBB
         GZ4BRz7oggUy2+kWQPNVO4wAdWL28oM2Grfx9sJ4gspa34F7qVzSDv57lOvwWnIv0HPM
         JYITiYSNkbjcPW9YFCejmwz2V5HTniTmNIFrklOhjIaTwwc761P/w9F6aKK5SIdpT+x6
         FunzBOdh2hhwg92BbRvZrFpuCL+nQv72Q4nlbnWG7l4Dr37RIjtt4wlsRKdQ5SO8pu0J
         vfaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=91o5m+5L+PwadXFVD9/3GjV5ZkMW9EJG7Rtl/ZPXSt4=;
        b=VwvwaoF4VW/50TyYMusNtXvhmpthGRpgGM4jtZPHRd6jmQJcFm2vZUN5J3NGotKa0k
         LfKbM3dqHc2gfbFrgKY3yrtb6cN7D06JH9Cs16/xU1Ce2Y+QOHcePDlO0vfKJSJKmc3A
         os1kXGV310PofdJrmfqlzvQVagB6dDz5CYryqWh3f/7EwdjuXmCPpSREcGyTbvrkNrYw
         hVccX/fVFSJlIkp36RO1fP89WOYPCAaytje9Pblai/7dBs3teYtjs3uzQEYsm1U3c3vh
         dmsoUTuDfmJ889Z9Za2e7ATdSN8WSDcMhxRoayeE2E6u8ijArirCtdbRlZLuM7OKoZu7
         pAYg==
X-Gm-Message-State: AOAM531R7XKE/2/Z8IAXXNBP7CEE2RQcZJfymTQ8Fwcc5qkNGCNgj6Qb
        IFhezohvrKiiKeYmnla/zERv4Q==
X-Google-Smtp-Source: ABdhPJw9XSdohseznmU1S3ZqsBZETJIM/nzyw1QimNNEUup3Eulhh+rFB4Esr7n/h1pws7236ib/Cw==
X-Received: by 2002:a05:6638:3804:b0:323:97d9:95b3 with SMTP id i4-20020a056638380400b0032397d995b3mr434095jav.282.1648660463142;
        Wed, 30 Mar 2022 10:14:23 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id b24-20020a5d8d98000000b006409ad493fbsm11588920ioj.21.2022.03.30.10.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 10:14:22 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org
Subject: [PATCH 3/5] io_uring: don't check req->file in io_fsync_prep()
Date:   Wed, 30 Mar 2022 11:14:14 -0600
Message-Id: <20220330171416.152538-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220330171416.152538-1-axboe@kernel.dk>
References: <20220330171416.152538-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a leftover from the really old days where we weren't able to
track and error early if we need a file and it wasn't assigned. Kill
the check.

Cc: stable@vger.kernel.org # v5.15+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0b89f35378fa..67244ea0af48 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4511,9 +4511,6 @@ static int io_fsync_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	if (!req->file)
-		return -EBADF;
-
 	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 	if (unlikely(sqe->addr || sqe->ioprio || sqe->buf_index ||
-- 
2.35.1

