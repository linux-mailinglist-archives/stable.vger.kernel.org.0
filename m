Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 068D12EB1D
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbfE3DKJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:10:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:46444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727962AbfE3DKJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:10:09 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BC3324493;
        Thu, 30 May 2019 03:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185808;
        bh=9atv310OkXsWdprCZqXax8/d0I7Oj078BCmX34krt88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H1MoRLV/AG9To5ELxV4e7QfsGIDBgTDehHhrWTGnMxEzpYdhaBze9mccka2Q+QcQn
         nFvv0qXRwaNmxaqqtTW7kzSgGxmdU0RIsW1wRB6TIohWNtz2ahosViqmdl5JjL7VXf
         aILpXxwkI0KKyqNtJz9NkjaAf1RtSO/A/kfWEuNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
        Shenghui Wang <shhuiw@foxmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 050/405] io_uring: use cpu_online() to check p->sq_thread_cpu instead of cpu_possible()
Date:   Wed, 29 May 2019 20:00:48 -0700
Message-Id: <20190530030543.372257442@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



