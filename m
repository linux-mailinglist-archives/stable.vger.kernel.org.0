Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 704B54E5567
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 16:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238031AbiCWPlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 11:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238021AbiCWPlW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 11:41:22 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 430D828999
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 08:39:53 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id b16so2139492ioz.3
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 08:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=82awc4+lc7Pq8oAOmw2he/PW9wn3kweNTWPMOiu34w0=;
        b=t3hFSUK28GjtNMQjKA453fmZjEtRVNguT+grMfKNeLS070meljxK+Ho8HeIHNhFeba
         76BWiHeR3Z3LYh27f9r/e6y2xQv4H2OYTltjzdqLiL4ie07x9pOuM2YdBiMPkeQA2NnL
         2zy+DeF39pKyv14Pu5m669cN3zg+eZ0Ixu0M5RXczswa1/LExkeR7UHXALO2sKQzLNga
         ICBw+9yc6B38DAIL46Q9AX0/zTqQb/gFm/XtWWIIR6vOaRoyupJqWI5zv6tO12vOlaKM
         qIlWa5cA1lgHikm9reM2+SBcI6ccvyvbI33u8hJ/oL8QqKBVv4Id+aJ8r/aIjy4Qu/p0
         3aZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=82awc4+lc7Pq8oAOmw2he/PW9wn3kweNTWPMOiu34w0=;
        b=cIFrkbK/s4lrLh9vzD4wwPJ8X2IuS56lgeGVAv7JI3BzylSlKv2HuVdCHwRJAg7Feh
         k+nEe74FTDXcPQXihKJxiXHjYFv5zWFAkrgtif9e3B8N9mEXYlMq9cQdWSHu85kkIC0k
         NA3IYqnpA796F03Yqozgekf0iBNd9UFLN9NtGdcl9FkBxgOaLLYGS0daXWbSDRs7N9JV
         QxqmzLHZVwGs91jskxltVknipJ4yXdUlJSKVFQogrFupK0s4tfjbZwnUjmbLFvD81Geq
         5g76PSkYJutxCBrtuIQA8WVPqrvpg6n9RuPH/EQcDUJY89KzKgfhSSIJ9dZfbDrwOikM
         qqNQ==
X-Gm-Message-State: AOAM530zg8dUnZKt53Ppk3lmBJ0LS8uuKkVf29ppxMUluLlKJONYSHX9
        EYOd+A5mef6R2YqyJuF55VWdRw==
X-Google-Smtp-Source: ABdhPJzZVcDsiSfy3yRRRkp5o8xa2PBrPWGvwzebsz5tbS13d0mAbT7lkiEvBoq2NEV9b5xwQi8E9A==
X-Received: by 2002:a02:2106:0:b0:31a:2c91:f36e with SMTP id e6-20020a022106000000b0031a2c91f36emr247620jaa.192.1648049992537;
        Wed, 23 Mar 2022 08:39:52 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id s10-20020a6b740a000000b006413d13477dsm124365iog.33.2022.03.23.08.39.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 08:39:52 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     constantine.gavrilov@gmail.com, Jens Axboe <axboe@kernel.dk>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] io_uring: ensure recv and recvmsg handle MSG_WAITALL correctly
Date:   Wed, 23 Mar 2022 09:39:46 -0600
Message-Id: <20220323153947.142692-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220323153947.142692-1-axboe@kernel.dk>
References: <20220323153947.142692-1-axboe@kernel.dk>
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

We currently don't attempt to get the full asked for length even if
MSG_WAITALL is set, if we get a partial receive. If we do see a partial
receive, then just note how many bytes we did and return -EAGAIN to
get it retried.

The iov is advanced appropriately for the vector based case, and we
manually bump the buffer and remainder for the non-vector case.

Cc: stable@vger.kernel.org
Reported-by: Constantine Gavrilov <constantine.gavrilov@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f41d91ce1fd0..2cd67b4ff924 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -612,6 +612,7 @@ struct io_sr_msg {
 	int				msg_flags;
 	int				bgid;
 	size_t				len;
+	size_t				done_io;
 };
 
 struct io_open {
@@ -5417,12 +5418,14 @@ static int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (req->ctx->compat)
 		sr->msg_flags |= MSG_CMSG_COMPAT;
 #endif
+	sr->done_io = 0;
 	return 0;
 }
 
 static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_async_msghdr iomsg, *kmsg;
+	struct io_sr_msg *sr = &req->sr_msg;
 	struct socket *sock;
 	struct io_buffer *kbuf;
 	unsigned flags;
@@ -5465,6 +5468,10 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 			return io_setup_async_msg(req, kmsg);
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
+		if (ret > 0 && flags & MSG_WAITALL) {
+			sr->done_io += ret;
+			return io_setup_async_msg(req, kmsg);
+		}
 		req_set_fail(req);
 	} else if ((flags & MSG_WAITALL) && (kmsg->msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))) {
 		req_set_fail(req);
@@ -5474,6 +5481,10 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	if (kmsg->free_iov)
 		kfree(kmsg->free_iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
+	if (ret >= 0)
+		ret += sr->done_io;
+	else if (sr->done_io)
+		ret = sr->done_io;
 	__io_req_complete(req, issue_flags, ret, io_put_kbuf(req, issue_flags));
 	return 0;
 }
@@ -5524,12 +5535,22 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 			return -EAGAIN;
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
+		if (ret > 0 && flags & MSG_WAITALL) {
+			sr->len -= ret;
+			sr->buf += ret;
+			sr->done_io += ret;
+			return -EAGAIN;
+		}
 		req_set_fail(req);
 	} else if ((flags & MSG_WAITALL) && (msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))) {
 out_free:
 		req_set_fail(req);
 	}
 
+	if (ret >= 0)
+		ret += sr->done_io;
+	else if (sr->done_io)
+		ret = sr->done_io;
 	__io_req_complete(req, issue_flags, ret, io_put_kbuf(req, issue_flags));
 	return 0;
 }
-- 
2.35.1

