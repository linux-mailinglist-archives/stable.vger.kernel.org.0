Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5622839E8
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727622AbgJEP30 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:29:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727611AbgJEP3Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:29:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BC01207BC;
        Mon,  5 Oct 2020 15:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911763;
        bh=Ztzrl0avbblWlwhorgBTnlg2D2PPMnM5Y/dAUXeG29I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xZ7/+6Qi5LwG8ihbomCG4tBf7cc0ZF3d1TIoBBNzaF/b0CUl2QuyWip274rlea4Zy
         iL47UJVP3IzKGyTayu5PliTA+9xw6W97kvVTEAijNVqbGuqeUWh5QiN6Iwd0fM8zd5
         vWNob2vxr5L8xRxoVdEMdhtxOw1z5CKMFCgcQi3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 29/57] tools/io_uring: fix compile breakage
Date:   Mon,  5 Oct 2020 17:26:41 +0200
Message-Id: <20201005142111.204971375@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142109.796046410@linuxfoundation.org>
References: <20201005142109.796046410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Gilbert <dgilbert@interlog.com>

[ Upstream commit 72f04da48a9828ba3ae8ac77bea648bda8b7d0ff ]

It would seem none of the kernel continuous integration does this:
    $ cd tools/io_uring
    $ make

Otherwise it may have noticed:
   cc -Wall -Wextra -g -D_GNU_SOURCE   -c -o io_uring-bench.o
	 io_uring-bench.c
io_uring-bench.c:133:12: error: static declaration of ‘gettid’
	 follows non-static declaration
  133 | static int gettid(void)
      |            ^~~~~~
In file included from /usr/include/unistd.h:1170,
                 from io_uring-bench.c:27:
/usr/include/x86_64-linux-gnu/bits/unistd_ext.h:34:16: note:
	 previous declaration of ‘gettid’ was here
   34 | extern __pid_t gettid (void) __THROW;
      |                ^~~~~~
make: *** [<builtin>: io_uring-bench.o] Error 1

The problem on Ubuntu 20.04 (with lk 5.9.0-rc5) is that unistd.h
already defines gettid(). So prefix the local definition with
"lk_".

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/io_uring/io_uring-bench.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/io_uring/io_uring-bench.c b/tools/io_uring/io_uring-bench.c
index 0f257139b003e..7703f01183854 100644
--- a/tools/io_uring/io_uring-bench.c
+++ b/tools/io_uring/io_uring-bench.c
@@ -130,7 +130,7 @@ static int io_uring_register_files(struct submitter *s)
 					s->nr_files);
 }
 
-static int gettid(void)
+static int lk_gettid(void)
 {
 	return syscall(__NR_gettid);
 }
@@ -281,7 +281,7 @@ static void *submitter_fn(void *data)
 	struct io_sq_ring *ring = &s->sq_ring;
 	int ret, prepped;
 
-	printf("submitter=%d\n", gettid());
+	printf("submitter=%d\n", lk_gettid());
 
 	srand48_r(pthread_self(), &s->rand);
 
-- 
2.25.1



