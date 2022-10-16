Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6147360034B
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 22:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbiJPUfo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 16:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiJPUfm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 16:35:42 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8392A37185
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 13:35:40 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id q19so13419552edd.10
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 13:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v5p3ls7a95j/Xm/VPo1ZiS4xr6kNoTn5XKcpb9DaVrA=;
        b=C90LunFTaaz6W8lUF0S0t+1fKuH8/3Dmwb8DMaAZtye23MdfPlrzC7XKTjxFIYGKte
         l2+LnFFqo+d/NRQKJkAUamhaFzFy/cXgTWuJUfcytCNuXu9HS7oYuiK/WdYf90Kpd4rg
         eLQxByxXno+WXsqgN2l8j5DZZmXvPECKpoaFfR1spdqgib4dnSmkygwRwE+FaG3DKfUc
         g3k0NXQdEblpW43QvEqnpOXQ9emb+9cYHFVIMLh4OCNdm/FAXhxdeHRmKiaFElkWnsNh
         W0SGWcET7Ga/oGzfrBh3LCiudLBsJYczH2RTWbwNWcCG6SZ0txNxkKkRCmUkDDbZiv7z
         z98w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v5p3ls7a95j/Xm/VPo1ZiS4xr6kNoTn5XKcpb9DaVrA=;
        b=t5OzzSuhceC4d1fXQtYtjAwRGlvLEHPJDgMhN/seOveMYDTtPJ0FwLPqXj28rcwxgD
         OAv1IzA7fYOsCJIOrpdlFk9+EY+Piqy9u7ees06DzTfvmhLZeWKTpHNxAY71FBZemVJV
         8ObnWIH3fSgGXBCEjIZ1E6pGamqok5yjhqD7WYhMlKoEBSCLpQrfRAaXnBY/TlJJy6yy
         daPbqwwkiGw4NPwb4R2fiQpmXDGEZ1K3aC236J/K9RlQrExCr4RXZtk759OVs7mfQaE5
         c3C+5eSAVGIY5FmqYDalstTSwGrNEVjHFIZeH0Zn0sxm0fPcG3k1oYVmAaXk+RoANJIK
         8Ohw==
X-Gm-Message-State: ACrzQf3PlFP8tjG9W96GaDQ+XEE8ta7O0ZzU6ymuic4/T8JZ1HS4nwL8
        8/XEW/4lE7UKl5/GbdLnUBy3NPDhkow=
X-Google-Smtp-Source: AMsMyM6FcIVo9KJw5V45PAnmPHN75phKA/NSJxDmt7vLRWL1PbLg8ixSw3jQhNLoyiggCmoc7Qi2SQ==
X-Received: by 2002:a05:6402:ea0:b0:454:38bf:aa3d with SMTP id h32-20020a0564020ea000b0045438bfaa3dmr7449045eda.291.1665952538335;
        Sun, 16 Oct 2022 13:35:38 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.234.149.threembb.co.uk. [94.196.234.149])
        by smtp.gmail.com with ESMTPSA id m3-20020a170906160300b0078194737761sm5008083ejd.124.2022.10.16.13.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Oct 2022 13:35:37 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH stable-6.0 2/6] io_uring/net: use io_sr_msg for sendzc
Date:   Sun, 16 Oct 2022 21:33:26 +0100
Message-Id: <b76d955ed29df5670f47dbc6bbb581a1b22ffdb3.1665951939.git.asml.silence@gmail.com>
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

[ upstream commit ac9e5784bbe72f4f603d1af84760ec09bc0b5ccd ]

Reuse struct io_sr_msg for zerocopy sends, which is handy. There is
only one zerocopy specific field, namely .notif, and we have enough
space for it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/408c5b1b2d8869e1a12da5f5a78ed72cac112149.1662639236.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index bd9f686ba0a1..3e9ab7a1abec 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -59,15 +59,7 @@ struct io_sr_msg {
 	unsigned			done_io;
 	unsigned			msg_flags;
 	u16				flags;
-};
-
-struct io_sendzc {
-	struct file			*file;
-	void __user			*buf;
-	unsigned			len;
-	unsigned			done_io;
-	unsigned			msg_flags;
-	u16				flags;
+	/* used only for sendzc */
 	u16				addr_len;
 	void __user			*addr;
 	struct io_kiocb 		*notif;
@@ -184,7 +176,7 @@ static int io_sendmsg_copy_hdr(struct io_kiocb *req,
 
 int io_sendzc_prep_async(struct io_kiocb *req)
 {
-	struct io_sendzc *zc = io_kiocb_to_cmd(req, struct io_sendzc);
+	struct io_sr_msg *zc = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr *io;
 	int ret;
 
@@ -881,7 +873,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 
 void io_sendzc_cleanup(struct io_kiocb *req)
 {
-	struct io_sendzc *zc = io_kiocb_to_cmd(req, struct io_sendzc);
+	struct io_sr_msg *zc = io_kiocb_to_cmd(req, struct io_sr_msg);
 
 	zc->notif->flags |= REQ_F_CQE_SKIP;
 	io_notif_flush(zc->notif);
@@ -890,7 +882,7 @@ void io_sendzc_cleanup(struct io_kiocb *req)
 
 int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_sendzc *zc = io_kiocb_to_cmd(req, struct io_sendzc);
+	struct io_sr_msg *zc = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_kiocb *notif;
 
@@ -996,7 +988,7 @@ static int io_sg_from_iter(struct sock *sk, struct sk_buff *skb,
 int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct sockaddr_storage __address, *addr = NULL;
-	struct io_sendzc *zc = io_kiocb_to_cmd(req, struct io_sendzc);
+	struct io_sr_msg *zc = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct msghdr msg;
 	struct iovec iov;
 	struct socket *sock;
-- 
2.38.0

