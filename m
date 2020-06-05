Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A041EFA57
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728302AbgFEOQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:16:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:45950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728295AbgFEOQq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:16:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A5EF208A7;
        Fri,  5 Jun 2020 14:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366605;
        bh=0S8H3cUhAiZf8diHXmSrml5+cVPZLK2++DqPF6FkBPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KM+E6zI7JSL9C7NtKkJimAcNOb7zcpkJCqKe7y2huEs5FrX5KQp2QLtgW444yUtA8
         t7jVQNOQep+ht2SSahPfpTH6gIg3UQYjNMiUzxfzmglcpbiD4Ak4w8KD31G9tWqaiX
         0WZpXvXVGubMy2cgV5LbSXky5NSAdbM12Iz+xQUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 20/43] io_uring: reset -EBUSY error when io sq thread is waken up
Date:   Fri,  5 Jun 2020 16:14:50 +0200
Message-Id: <20200605140153.581180425@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200605140152.493743366@linuxfoundation.org>
References: <20200605140152.493743366@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>

[ Upstream commit d4ae271dfaae2a5f41c015f2f20d62a1deeec734 ]

In io_sq_thread(), currently if we get an -EBUSY error and go to sleep,
we will won't clear it again, which will result in io_sq_thread() will
never have a chance to submit sqes again. Below test program test.c
can reveal this bug:

int main(int argc, char *argv[])
{
        struct io_uring ring;
        int i, fd, ret;
        struct io_uring_sqe *sqe;
        struct io_uring_cqe *cqe;
        struct iovec *iovecs;
        void *buf;
        struct io_uring_params p;

        if (argc < 2) {
                printf("%s: file\n", argv[0]);
                return 1;
        }

        memset(&p, 0, sizeof(p));
        p.flags = IORING_SETUP_SQPOLL;
        ret = io_uring_queue_init_params(4, &ring, &p);
        if (ret < 0) {
                fprintf(stderr, "queue_init: %s\n", strerror(-ret));
                return 1;
        }

        fd = open(argv[1], O_RDONLY | O_DIRECT);
        if (fd < 0) {
                perror("open");
                return 1;
        }

        iovecs = calloc(10, sizeof(struct iovec));
        for (i = 0; i < 10; i++) {
                if (posix_memalign(&buf, 4096, 4096))
                        return 1;
                iovecs[i].iov_base = buf;
                iovecs[i].iov_len = 4096;
        }

        ret = io_uring_register_files(&ring, &fd, 1);
        if (ret < 0) {
                fprintf(stderr, "%s: register %d\n", __FUNCTION__, ret);
                return ret;
        }

        for (i = 0; i < 10; i++) {
                sqe = io_uring_get_sqe(&ring);
                if (!sqe)
                        break;

                io_uring_prep_readv(sqe, 0, &iovecs[i], 1, 0);
                sqe->flags |= IOSQE_FIXED_FILE;

                ret = io_uring_submit(&ring);
                sleep(1);
                printf("submit %d\n", i);
        }

        for (i = 0; i < 10; i++) {
                io_uring_wait_cqe(&ring, &cqe);
                printf("receive: %d\n", i);
                if (cqe->res != 4096) {
                        fprintf(stderr, "ret=%d, wanted 4096\n", cqe->res);
                        ret = 1;
                }
                io_uring_cqe_seen(&ring, cqe);
        }

        close(fd);
        io_uring_queue_exit(&ring);
        return 0;
}
sudo ./test testfile
above command will hang on the tenth request, to fix this bug, when io
sq_thread is waken up, we reset the variable 'ret' to be zero.

Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 504484dc33e4..c6e1f76a6ee0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5224,6 +5224,7 @@ static int io_sq_thread(void *data)
 				finish_wait(&ctx->sqo_wait, &wait);
 
 				ctx->rings->sq_flags &= ~IORING_SQ_NEED_WAKEUP;
+				ret = 0;
 				continue;
 			}
 			finish_wait(&ctx->sqo_wait, &wait);
-- 
2.25.1



