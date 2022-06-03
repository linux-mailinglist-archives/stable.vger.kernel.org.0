Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D15653C9EF
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 14:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233967AbiFCMRg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 08:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232874AbiFCMRf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 08:17:35 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C68B7B17
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 05:17:34 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id f7-20020a1c3807000000b0039c1a10507fso4245398wma.1
        for <stable@vger.kernel.org>; Fri, 03 Jun 2022 05:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G4TcEGaFVmWyUHEntnV608Cy03ftLvLbpTz3muubAr0=;
        b=qRIC7I5DhsJZubTTrLBEjeseq0P6oTkc7GT4/pKdUSr1M2N/cfKq0ZX4NZSehh4Aae
         wXMyU1iZ3x75cqFI20FhUkyPAAMoeFXhVUAS0WVkEMui3+SECEjNQCHr2V4XrG8/QDle
         zQnFpNIhrAZc2B0sB0TVJgwHMzAtE3l2HjiMI2QTHZkeEHUIl02SAFG97cu9yS4mpcSA
         fPlR0NcruieK4eBsWOD0tp9RD3WQQGl6jVV415pRzVpyRPYJ0qimHokuy2sTabpjMP4x
         YoQdtPIrqJWuHZzcgf5b0UWAdcGmO5mD3oRfkSBCYruk3+88HtljvkvKAZJdsa5dGGaW
         FYoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G4TcEGaFVmWyUHEntnV608Cy03ftLvLbpTz3muubAr0=;
        b=RbgcKxMGe6jX/8UIfBgkHbb9FBM2N6LVyHyhYTcULZ8u8OmFTxbImhreRKbd+SYQUP
         4dtGSMrQlfCOMvwfYE0v2VJQAgwnhmoT7E1muLlzbrr110tKT7WTkZSbnhvhshZEZTH3
         XlWDDMIh/dB39XNicp3ByRUNk764qnh7fWdvuMQJss1c2Qp39PZNvKUTSFddAxcV+Dsk
         AOWAFbgJocA7RBNZf5QZWh3LJWTVQiCq8aYQXSucxrdzjjbKb1yKZFkUAMR91B6VoAcw
         m4X/Pa/ef3rdw8ZdZ5HmLPB4eDgV7Yq727j8QbsBFcaLS5X05YNr4WUhCe3jBkLSIwIO
         FAAw==
X-Gm-Message-State: AOAM533GdrGLcOIRTww05njyWNOpJHZj2EslYzA1Y8XcCr8GnP+jzMAC
        /jjZyO9zUphssoRmZ5KLimLobTtT2gKEwA==
X-Google-Smtp-Source: ABdhPJzyDPbatb/xhqSWRb+S4nGKyqxsj3WVKNVLnnpKtVggi/bLWjs4pf7mfXI4HKFOPvLrV452QQ==
X-Received: by 2002:a05:600c:410f:b0:39c:3b1c:309 with SMTP id j15-20020a05600c410f00b0039c3b1c0309mr3917003wmi.1.1654258653039;
        Fri, 03 Jun 2022 05:17:33 -0700 (PDT)
Received: from 127.0.0.fr ([193.52.24.5])
        by smtp.gmail.com with ESMTPSA id c16-20020a056000105000b002100aa69469sm7240362wrx.2.2022.06.03.05.17.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 05:17:32 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 1/2] io_uring: don't re-import iovecs from callbacks
Date:   Fri,  3 Jun 2022 13:17:04 +0100
Message-Id: <34f9e14b1adef255bc205bcb0e6c6d6110646689.1654258554.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1654258554.git.asml.silence@gmail.com>
References: <cover.1654258554.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We can't re-import or modify iterators from iocb callbacks, it's not
safe as it might be reverted and/or reexpanded while unwinding stack.
It's also not safe to resubmit as io-wq thread will race with stack
undwinding for the iterator and other data.

Disallow resubmission from callbacks, it can fail some cases that were
handled before, but the possibility of such a failure was a part of the
API from the beginning and so it should be fine.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 39 ---------------------------------------
 1 file changed, 39 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4330603eae35..aded83f20a15 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2579,45 +2579,6 @@ static void io_complete_rw_common(struct kiocb *kiocb, long res,
 #ifdef CONFIG_BLOCK
 static bool io_resubmit_prep(struct io_kiocb *req, int error)
 {
-	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
-	ssize_t ret = -ECANCELED;
-	struct iov_iter iter;
-	int rw;
-
-	if (error) {
-		ret = error;
-		goto end_req;
-	}
-
-	switch (req->opcode) {
-	case IORING_OP_READV:
-	case IORING_OP_READ_FIXED:
-	case IORING_OP_READ:
-		rw = READ;
-		break;
-	case IORING_OP_WRITEV:
-	case IORING_OP_WRITE_FIXED:
-	case IORING_OP_WRITE:
-		rw = WRITE;
-		break;
-	default:
-		printk_once(KERN_WARNING "io_uring: bad opcode in resubmit %d\n",
-				req->opcode);
-		goto end_req;
-	}
-
-	if (!req->async_data) {
-		ret = io_import_iovec(rw, req, &iovec, &iter, false);
-		if (ret < 0)
-			goto end_req;
-		ret = io_setup_async_rw(req, iovec, inline_vecs, &iter, false);
-		if (!ret)
-			return true;
-		kfree(iovec);
-	} else {
-		return true;
-	}
-end_req:
 	req_set_fail_links(req);
 	return false;
 }
-- 
2.36.1

