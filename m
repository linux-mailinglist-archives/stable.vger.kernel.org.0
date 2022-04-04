Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5C2F4F20E4
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 06:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiDECOk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 22:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiDECOj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 22:14:39 -0400
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26DA13FC198
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 18:09:11 -0700 (PDT)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-df0940c4eeso12806111fac.8
        for <stable@vger.kernel.org>; Mon, 04 Apr 2022 18:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r1zL7etsFWAjTL7k30RuIcl4I9NBAzusOAZ5H2Xv0MQ=;
        b=EoIQUdrqi++Lki235St3D85KQks6Lz/CMO/UpRT8fZ3GG9Q//mzfV2jk6JRB+D+Jj0
         +75d3sJPPO6ypOlwcv2GJE+Yd7OXBMsLjbfqZkKnzbL0qxaU5mdZO8Mn7/tBHlOkHqSj
         3T63UGSaodmOjnT01hDDJPd9iAnU92lEhkDAaaOPwbn4MED2BFam2gtIRSqfuoZUbUNN
         7snnoBwl7dgAZ7FX35EfDelX5KMNxwYgui8UrxiXC5Rq6OqEVEvwalSDEDCQuAr/ygbQ
         KYhmdXSGnSl98zdvCRTfwgM0T9D0MJNIjyknWl+YIjIaZNe9OJque3dxIMSVFQ9tyYlk
         eu+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r1zL7etsFWAjTL7k30RuIcl4I9NBAzusOAZ5H2Xv0MQ=;
        b=hbLqSToUQfHY5Y9wJU5iDFbaPj/+SOviC8UyEbb8x6wqLNGHZaH6Rt5ftb/Q4BU8n+
         h4IV0OBL9sMPPKqKAx55q+JOUNWCPOeFhHTn4IRaQna8Vifuwd2PvEWFBiwhDTctSgIJ
         M9M7sFl4JjkqHohbrPp/RRuDcHl64p1TaFrN1tXl50TCp5nn9SijLuUOUROMoXbcKz9J
         TqT93qSt4ZJNogVRg9Fv4tsRu2Q9poeRuQIqYEYs4/92gpIh6w2vbJDS8VD3E7621V1c
         Q1skJMPdU0Rq7PGxeCYIdfVlc/s78WWvR4Tatu6GDb9GxC7AHJqDnCcX9MS1P7UE40Q1
         Sxdw==
X-Gm-Message-State: AOAM5305vIf1VKeeykE9ASDYunzxOig8rGLTvRLRoLx/SXqgxiHcuQDX
        PxgCpiBo8y9+dZiKoTJes5F3G30l0nWtgQ==
X-Google-Smtp-Source: ABdhPJxlHxaTfay/FsjsJGa0g/3dMmc7Vo350CI1dwQiyIn61sBvw3UFf86Aqf/afiHkqhc/z9yvXA==
X-Received: by 2002:a17:90a:e2c3:b0:1ca:75b7:63d5 with SMTP id fr3-20020a17090ae2c300b001ca75b763d5mr798533pjb.111.1649116595258;
        Mon, 04 Apr 2022 16:56:35 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id i7-20020a628707000000b004fa6eb33b02sm13157977pfe.49.2022.04.04.16.56.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 16:56:34 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org
Subject: [PATCH 1/6] io_uring: don't check req->file in io_fsync_prep()
Date:   Mon,  4 Apr 2022 17:56:21 -0600
Message-Id: <20220404235626.374753-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220404235626.374753-1-axboe@kernel.dk>
References: <20220404235626.374753-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
index a8413f006417..9108c56bff5b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4513,9 +4513,6 @@ static int io_fsync_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
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

