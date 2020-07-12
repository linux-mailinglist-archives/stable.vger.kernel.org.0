Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFD3B21C885
	for <lists+stable@lfdr.de>; Sun, 12 Jul 2020 12:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgGLKZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Jul 2020 06:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727777AbgGLKZV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Jul 2020 06:25:21 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A3CC061794;
        Sun, 12 Jul 2020 03:25:20 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id ga4so10921655ejb.11;
        Sun, 12 Jul 2020 03:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BklUmOJzay1uK19VmlrmlVYNXA/Uomou+PJbzVp04D8=;
        b=f5hTh6O1TTBWn0QIuEFAvuYjjpaef3nla57Lrsy/tEugfWzWnFuYdc/d7QDEMlfZ7z
         6i64T/0wrKLnjx5xSLhpJlY59o+Qu+88c6vqKjol28Ru9cAtH/KpoattzY4QA3nlGogx
         js/JcmJMlC/DIKq5S8nn66ka+Wz8li24+Yd9bL3sA2gT6VQgHmli2TIFeeMvUTpaejyN
         8ix3n8xvORlc3vbrJdHTN99jvau6Sp1VZ1cpublWNkNC0a2KNSbnRPQQlDC8jk//HZ5U
         mW98rWRExNLVqBqwYWNMtBjm+iUpQTy3kSvqArwB0LbaKLk2fm+fgofJWUqJWSnHUVxm
         r0Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BklUmOJzay1uK19VmlrmlVYNXA/Uomou+PJbzVp04D8=;
        b=Em5hms1IOGUeWMB0Sb19yh93IFiZpLwSs2OlnxfrwLBEe0CXrjEK3IDPKqMfh/WshP
         dmCkXU6d0/1omLI561/IQTlA4mXC0JgFq3kfcdy3EIHP1y+88tPw+zTag4911NtGrpIx
         c+u1stMbytjJww8nUrpev9D9xG8clUE5TISJ2z8W/I7MDvFyP8jUdP5VIw5uPcSYUmoV
         YPsveNrTGwQAuMakxFizqbEUsW1KNMut9p53Uo/eSctCIWfF6myxNP6U5MfsiR0G+R/h
         wab6bf4wUuQ7MOXMCD3Wh5oDgFcYuA9/DPEMfZcHQCfnX+NFmvZ6jP0EEQkApk/a0KnK
         zTOw==
X-Gm-Message-State: AOAM533XnneVa7qW28Oi/kCu6PLHp+ktXd4J2k8C4ow2mEr1qomsaaWq
        Thp3lSg9206eDwRCIKjQ4bWfrRcy
X-Google-Smtp-Source: ABdhPJzughq2eLqR8+bAgXYlE+87yGBajL3QGoabCPd+YlAWgx5+ciwTBtyPIv+hQ/CpnucxYVPYgw==
X-Received: by 2002:a17:906:4bcf:: with SMTP id x15mr58377063ejv.188.1594549519132;
        Sun, 12 Jul 2020 03:25:19 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id q3sm8722869eds.41.2020.07.12.03.25.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2020 03:25:18 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH v2] io_uring: fix missing msg_name assignment
Date:   Sun, 12 Jul 2020 13:23:08 +0300
Message-Id: <1b98c048b3a0cad032affc44fa08ff7fd8f8f2b3.1594549283.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <fcf14a85d9478be55b72551b3046e898503950c9.1594537448.git.asml.silence@gmail.com>
References: <fcf14a85d9478be55b72551b3046e898503950c9.1594537448.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ensure to set msg.msg_name for the async portion of send/recvmsg,
as the header copy will copy to/from it.

Cc: stable@vger.kernel.org # 5.5, 5.6, 5.7
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
v2: don't miss out compat for recv

 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7f2a2cb5c056..0ecd70dbf0fd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3913,6 +3913,7 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (req->flags & REQ_F_NEED_CLEANUP)
 		return 0;
 
+	io->msg.msg.msg_name = &io->msg.addr;
 	io->msg.iov = io->msg.fast_iov;
 	ret = sendmsg_copy_msghdr(&io->msg.msg, sr->msg, sr->msg_flags,
 					&io->msg.iov);
@@ -4094,6 +4095,7 @@ static int __io_compat_recvmsg_copy_hdr(struct io_kiocb *req,
 
 static int io_recvmsg_copy_hdr(struct io_kiocb *req, struct io_async_ctx *io)
 {
+	io->msg.msg.msg_name = &io->msg.addr;
 	io->msg.iov = io->msg.fast_iov;
 
 #ifdef CONFIG_COMPAT
-- 
2.24.0

