Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FFE527BA21
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 03:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgI2Bf4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 21:35:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727444AbgI2Baz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Sep 2020 21:30:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D03C2184D;
        Tue, 29 Sep 2020 01:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601343054;
        bh=Ztzrl0avbblWlwhorgBTnlg2D2PPMnM5Y/dAUXeG29I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=txWQCi7yybnk1E3gahoRjpoexzbzIzorn9WK4SdAm9SlrIdUXWcVbrldpiBOK6hdc
         ZMcAFo6cQLBhqLgfm86t7FEXZH+AS34Vb66voRbWMerki93VGdtFPc6DyiUP0BE7PF
         DlOerzn51eL1DBCPBgzRzSnwrpmsbedjaQ3LxypA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Douglas Gilbert <dgilbert@interlog.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.8 21/29] tools/io_uring: fix compile breakage
Date:   Mon, 28 Sep 2020 21:30:18 -0400
Message-Id: <20200929013027.2406344-21-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929013027.2406344-1-sashal@kernel.org>
References: <20200929013027.2406344-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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

