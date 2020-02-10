Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8408515775E
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729275AbgBJM7t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:59:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:42486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729563AbgBJMlE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:04 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EB342467C;
        Mon, 10 Feb 2020 12:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338464;
        bh=1mBv9FsT65fiq4XZwUJQkTx18vF+a9/p+GVNey9Umcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C6y7gla/l62X0XQ1lD8QmQa2iSM1DDpp/SfhVfaXufwiaH1LU7gXUAXTZJIE8sOCb
         E/kXk0CzQ81+LfSnPSLgOt2f9fYFX4fO5xH867wPQXFYSlkHE14/9hQhrP9rnkGiwk
         jllEXNQ0ExRIr4PUVI+4rtNimuR9irpEon32OVIM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Melnic <dmm@fb.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.5 223/367] io_uring: dont map read/write iovec potentially twice
Date:   Mon, 10 Feb 2020 04:32:16 -0800
Message-Id: <20200210122444.634072021@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 5d204bcfa09330972ad3428a8f81c23f371d3e6d upstream.

If we have a read/write that is deferred, we already setup the async IO
context for that request, and mapped it. When we later try and execute
the request and we get -EAGAIN, we don't want to attempt to re-map it.
If we do, we end up with garbage in the iovec, which typically leads
to an -EFAULT or -EINVAL completion.

Cc: stable@vger.kernel.org # 5.5
Reported-by: Dan Melnic <dmm@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1789,10 +1789,12 @@ static int io_setup_async_rw(struct io_k
 	if (req->opcode == IORING_OP_READ_FIXED ||
 	    req->opcode == IORING_OP_WRITE_FIXED)
 		return 0;
-	if (!req->io && io_alloc_async_ctx(req))
-		return -ENOMEM;
+	if (!req->io) {
+		if (io_alloc_async_ctx(req))
+			return -ENOMEM;
 
-	io_req_map_rw(req, io_size, iovec, fast_iov, iter);
+		io_req_map_rw(req, io_size, iovec, fast_iov, iter);
+	}
 	req->work.func = io_rw_async;
 	return 0;
 }


