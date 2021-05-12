Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E36E537CDEB
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343744AbhELQ7T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:59:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:35814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243838AbhELQmJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE00E61C3A;
        Wed, 12 May 2021 16:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835652;
        bh=vac/PmXNIgxrJ7QjcWo+e62LDA7/kj5GZFUMfEqwEK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OhxMSIkXaE2o/yJX66sirayXOzTmFt7kl/6H4fdYrWTMGPFmNgVk9DQzHe/0SbdvV
         KSWBCz8CT3lzWzFdmMzq6m6oKd/ry+/fpJpzfsbW6BjmDdRdQ733JF+85O+ZbIjAn7
         ECkJB07CniN4rVsxZTEwKV8axNGr5N678lJMp32A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 430/677] io_uring: fix overflows checks in provide buffers
Date:   Wed, 12 May 2021 16:47:56 +0200
Message-Id: <20210512144851.626748341@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 38134ada0ceea3e848fe993263c0ff6207fd46e7 ]

Colin reported before possible overflow and sign extension problems in
io_provide_buffers_prep(). As Linus pointed out previous attempt did nothing
useful, see d81269fecb8ce ("io_uring: fix provide_buffers sign extension").

Do that with help of check_<op>_overflow helpers. And fix struct
io_provide_buf::len type, as it doesn't make much sense to keep it
signed.

Reported-by: Colin Ian King <colin.king@canonical.com>
Fixes: efe68c1ca8f49 ("io_uring: validate the full range of provided buffers for access")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/46538827e70fce5f6cdb50897cff4cacc490f380.1618488258.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2bdd7eab6c66..144056b0cac9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -614,7 +614,7 @@ struct io_splice {
 struct io_provide_buf {
 	struct file			*file;
 	__u64				addr;
-	__s32				len;
+	__u32				len;
 	__u32				bgid;
 	__u16				nbufs;
 	__u16				bid;
@@ -3979,7 +3979,7 @@ static int io_remove_buffers(struct io_kiocb *req, unsigned int issue_flags)
 static int io_provide_buffers_prep(struct io_kiocb *req,
 				   const struct io_uring_sqe *sqe)
 {
-	unsigned long size;
+	unsigned long size, tmp_check;
 	struct io_provide_buf *p = &req->pbuf;
 	u64 tmp;
 
@@ -3993,6 +3993,12 @@ static int io_provide_buffers_prep(struct io_kiocb *req,
 	p->addr = READ_ONCE(sqe->addr);
 	p->len = READ_ONCE(sqe->len);
 
+	if (check_mul_overflow((unsigned long)p->len, (unsigned long)p->nbufs,
+				&size))
+		return -EOVERFLOW;
+	if (check_add_overflow((unsigned long)p->addr, size, &tmp_check))
+		return -EOVERFLOW;
+
 	size = (unsigned long)p->len * p->nbufs;
 	if (!access_ok(u64_to_user_ptr(p->addr), size))
 		return -EFAULT;
-- 
2.30.2



