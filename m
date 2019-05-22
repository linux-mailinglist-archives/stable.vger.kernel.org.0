Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7FD27082
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 22:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729866AbfEVTVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:21:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:41792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729790AbfEVTVX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:21:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DFD821841;
        Wed, 22 May 2019 19:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558552882;
        bh=doNg1gXw6eyhwf7280nikzntpuqn8BhVuwpCh91jyuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yv5Viyw/JPFlMiGQY3QDwNVJMTJE9bwA0Jxb1HzkIdrry6rulvzV/FqGfFAqQvmqJ
         21M63oxpODoH15MttF2Zs9tSaoLpo3wqPTZ+JV5V9j4XSIYUEPqmTmNPvGEr5bgMHu
         h1IVlQNVnDFW7WMWHCIoT/CegtgwezVV4a+M8c3A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shenghui Wang <shhuiw@foxmail.com>, Jeff Moyer <jmoyer@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 006/375] io_uring: use cpu_online() to check p->sq_thread_cpu instead of cpu_possible()
Date:   Wed, 22 May 2019 15:15:06 -0400
Message-Id: <20190522192115.22666-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192115.22666-1-sashal@kernel.org>
References: <20190522192115.22666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shenghui Wang <shhuiw@foxmail.com>

[ Upstream commit 7889f44dd9cee15aff1c3f7daf81ca4dfed48fc7 ]

This issue is found by running liburing/test/io_uring_setup test.

When test run, the testcase "attempt to bind to invalid cpu" would not
pass with messages like:
   io_uring_setup(1, 0xbfc2f7c8), \
flags: IORING_SETUP_SQPOLL|IORING_SETUP_SQ_AFF, \
resv: 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000, \
sq_thread_cpu: 2
   expected -1, got 3
   FAIL

On my system, there is:
   CPU(s) possible : 0-3
   CPU(s) online   : 0-1
   CPU(s) offline  : 2-3
   CPU(s) present  : 0-1

The sq_thread_cpu 2 is offline on my system, so the bind should fail.
But cpu_possible() will pass the check. We shouldn't be able to bind
to an offline cpu. Use cpu_online() to do the check.

After the change, the testcase run as expected: EINVAL will be returned
for cpu offlined.

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Shenghui Wang <shhuiw@foxmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 84efb8956734f..30a5687a17b65 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2334,7 +2334,7 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
 							nr_cpu_ids);
 
 			ret = -EINVAL;
-			if (!cpu_possible(cpu))
+			if (!cpu_online(cpu))
 				goto err;
 
 			ctx->sqo_thread = kthread_create_on_cpu(io_sq_thread,
-- 
2.20.1

