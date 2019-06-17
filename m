Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61BFD492A1
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729496AbfFQVWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:22:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:46760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729495AbfFQVWL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:22:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68456208E4;
        Mon, 17 Jun 2019 21:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806530;
        bh=0asejfpYRWwdPg2ym2PXWFlNFC9l1OikWejCVTTR3ms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GUtimlQ1GRGGw7Pbceu4MRv9CDiak8ONkVNTH7tZlfuiBcz7U7eQpeekUyAUWPOtk
         0hdPREbQ+RcxSDTVSUalE9i+d5piICseI1qIjZKcjZ+woEnbRW7sPk4pBOdxhtKuNC
         uTTDUhaLRc4iVPuPQrnoOOSN2QlMHBErv2pR3RlY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 082/115] tools/io_uring: fix Makefile for pthread library link
Date:   Mon, 17 Jun 2019 23:09:42 +0200
Message-Id: <20190617210804.208810744@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210759.929316339@linuxfoundation.org>
References: <20190617210759.929316339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 486f069253c3c738dec62daeb16f7232b2cca065 ]

Currently fails with:

io_uring-bench.o: In function `main':
/home/axboe/git/linux-block/tools/io_uring/io_uring-bench.c:560: undefined reference to `pthread_create'
/home/axboe/git/linux-block/tools/io_uring/io_uring-bench.c:588: undefined reference to `pthread_join'
collect2: error: ld returned 1 exit status
Makefile:11: recipe for target 'io_uring-bench' failed
make: *** [io_uring-bench] Error 1

Move -lpthread to the end.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/io_uring/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/io_uring/Makefile b/tools/io_uring/Makefile
index f79522fc37b5..00f146c54c53 100644
--- a/tools/io_uring/Makefile
+++ b/tools/io_uring/Makefile
@@ -8,7 +8,7 @@ all: io_uring-cp io_uring-bench
 	$(CC) $(CFLAGS) -o $@ $^
 
 io_uring-bench: syscall.o io_uring-bench.o
-	$(CC) $(CFLAGS) $(LDLIBS) -o $@ $^
+	$(CC) $(CFLAGS) -o $@ $^ $(LDLIBS)
 
 io_uring-cp: setup.o syscall.o queue.o
 
-- 
2.20.1



