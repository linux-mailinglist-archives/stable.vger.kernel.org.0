Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B74EC60034E
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 22:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiJPUfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 16:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiJPUfp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 16:35:45 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5304236DF8
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 13:35:44 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id r17so20838580eja.7
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 13:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t63sjkrtKkAI4FXWOySaFfdoqn8gJRWeZjNDrZbk9ug=;
        b=NP2HYwvfrL3iZHXgy0o5S5bG84Oyj+D9ltHIymReAaF4nOyhFmaq9MOLr9jzDQYZvm
         EVZhRzIe9d+fEVaJOqkfKaHhgxz5cJIF3CRDPXGIrkHB243n/u9HF5nmKZgJzwqQJErT
         D4o/8ZX1VtaGYclYBB9lVQRh1qJudym3LE0P8K4LR4qRvGRf34aAZp6E9dOMgBwzUbO7
         vZIluIcvCU7AdZUtjClIYuxVFHAxsl/UC8LIFp2Wb7XSmD8cCnPKxcn356chk08D8svh
         Og5iT2b/1Z9Sd7k7XeA3fCFFPDzY12tWkJK1ecf3BRe4RBipBWgKz61t5pB03kH93NDn
         nLdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t63sjkrtKkAI4FXWOySaFfdoqn8gJRWeZjNDrZbk9ug=;
        b=KLMY42KPix3PkwRO5NFSu2f1zWiH+wx7T2uF4892bRm9p7nL7InyZnlwRuja7rN7iP
         R5LIFu7l/2IQCnv05+v5EiKm+WYGHx+ssEukutfiaghFvnVAlnBNn96R3Jk7ea18jI+W
         0IEM5TDKMUKsV/VLHKFjk6dwt3dD3J1J5dVlOa9J9Qj4M/7kONS8jDcngtGTGzIiO/01
         G2cC/8/tEU0FaNPf8sGQ5/9D0GlLrdUh5vev4kEyP1MITQidO1Bg3TXuGrUs+CJ0EGLe
         RH2c1Ej/1AuH/BoNpUdU2R3BZ7wBwwVt32NDq1tkOJr42VNB+mVqjRzQ5+8oCSJc1Et/
         3zWw==
X-Gm-Message-State: ACrzQf23aGySAX5hzPFjD32jBRPK6uCs1pKeACkr0CkQDMheCApHSXJf
        UD+OpdAGDiIXZz95vQlMnwD0QxH9W+4=
X-Google-Smtp-Source: AMsMyM5yE8OECxou+4FQf6+sE5TFcWoJYQROh9RdYlYri3gncisWl0WYOhCqlzDGs1UbL6GZUwiuBg==
X-Received: by 2002:a17:907:3f92:b0:78e:2eb5:6aec with SMTP id hr18-20020a1709073f9200b0078e2eb56aecmr6189019ejc.85.1665952542593;
        Sun, 16 Oct 2022 13:35:42 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.234.149.threembb.co.uk. [94.196.234.149])
        by smtp.gmail.com with ESMTPSA id m3-20020a170906160300b0078194737761sm5008083ejd.124.2022.10.16.13.35.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Oct 2022 13:35:42 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH stable-6.0 6/6] io_uring/net: fix notif cqe reordering
Date:   Sun, 16 Oct 2022 21:33:30 +0100
Message-Id: <54ecb468aac60ed3f6165be94144044cf62bbe58.1665951939.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1665951939.git.asml.silence@gmail.com>
References: <cover.1665951939.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ upstream commit 108893ddcc4d3aa0a4a02aeb02d478e997001227 ]

send zc is not restricted to !IO_URING_F_UNLOCKED anymore and so
we can't use task-tw ordering trick to order notification cqes
with requests completions. In this case leave it alone and let
io_send_zc_cleanup() flush it.

Cc: stable@vger.kernel.org
Fixes: 53bdc88aac9a2 ("io_uring/notif: order notif vs send CQEs")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/0031f3a00d492e814a4a0935a2029a46d9c9ba06.1664486545.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index b0324775e6ce..d2912c1550d4 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1069,8 +1069,14 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 	else if (zc->done_io)
 		ret = zc->done_io;
 
-	io_notif_flush(zc->notif);
-	req->flags &= ~REQ_F_NEED_CLEANUP;
+	/*
+	 * If we're in io-wq we can't rely on tw ordering guarantees, defer
+	 * flushing notif to io_send_zc_cleanup()
+	 */
+	if (!(issue_flags & IO_URING_F_UNLOCKED)) {
+		io_notif_flush(zc->notif);
+		req->flags &= ~REQ_F_NEED_CLEANUP;
+	}
 	io_req_set_res(req, ret, IORING_CQE_F_MORE);
 	return IOU_OK;
 }
-- 
2.38.0

