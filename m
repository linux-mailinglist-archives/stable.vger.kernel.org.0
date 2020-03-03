Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB44177EA9
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730972AbgCCRpl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:45:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:51892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730969AbgCCRpl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:45:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2915221741;
        Tue,  3 Mar 2020 17:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257540;
        bh=bwqt22GXErc9LKOF1ZlvL4ihh4c3qNfF8vE522rf70Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kngaOYW4Od4ovJiVe2Y6dkv2rOJCcYULV4Evv6BRAPrqeytszhyc+Dggd+pTMkIZP
         kn26adcuepTZp5MZpJ/p5M9en5SdTi9eIfeVPXiJANBNY/rdU2lNbxf+miJpaeGhlz
         R4NENvllcPuJ4Mou1wg1HjpfV6aa/6KA67uz4HNc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 033/176] io_uring: flush overflowed CQ events in the io_uring_poll()
Date:   Tue,  3 Mar 2020 18:41:37 +0100
Message-Id: <20200303174308.340114195@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>

[ Upstream commit 63e5d81f72af1bf370bf8a6745b0a8d71a7bb37d ]

In io_uring_poll() we must flush overflowed CQ events before to
check if there are CQ events available, to avoid missing events.

We call the io_cqring_events() that checks and flushes any overflow
and returns the number of CQ events available.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 678c62782ba3b..de4bd647cd1df 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4970,7 +4970,7 @@ static __poll_t io_uring_poll(struct file *file, poll_table *wait)
 	if (READ_ONCE(ctx->rings->sq.tail) - ctx->cached_sq_head !=
 	    ctx->rings->sq_ring_entries)
 		mask |= EPOLLOUT | EPOLLWRNORM;
-	if (READ_ONCE(ctx->rings->cq.head) != ctx->cached_cq_tail)
+	if (io_cqring_events(ctx, false))
 		mask |= EPOLLIN | EPOLLRDNORM;
 
 	return mask;
-- 
2.20.1



