Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F127348F8B
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231597AbhCYL2C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:28:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:35234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231241AbhCYL0o (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:26:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FF1361A59;
        Thu, 25 Mar 2021 11:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671603;
        bh=ldidxlO0RHixIRKOI+qPyVgc1B5zd7JU6pPTMSBeE2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kSVLgcxIFzagBgvk/OIaH+Y2QAjQtwUKZwsox3Qz4hIXs3a/dS5dz6cOMnixv1FgK
         6b4L6Vcsmk18RxBOnJJEUKZrkcSmUV22L3iz2MqZX4B0bM53s4KSsHodk71ssDrjtV
         3GE1xMd6GmS4pG7Irohb85PwYy3ZfuCpV2c7Oa+aF4uEPY1KlLx8dVexrE3nFrcMpH
         ETzWhZAQAlhpvZRkcoBAevFioMXnaCowp77iRANp8gayVJ4JzSl6pom3h1tkYpC9LW
         YDkDdOZ/HukGeARfozfS+fkmJ1q5LBH4mUkUH199KDmbpbSXf54BLWwbCdhgU+Dlwo
         4KYWiDD9bkF3w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 34/39] io_uring: imply MSG_NOSIGNAL for send[msg]()/recv[msg]() calls
Date:   Thu, 25 Mar 2021 07:25:53 -0400
Message-Id: <20210325112558.1927423-34-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112558.1927423-1-sashal@kernel.org>
References: <20210325112558.1927423-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit 76cd979f4f38a27df22efb5773a0d567181a9392 ]

We never want to generate any SIGPIPE, -EPIPE only is much better.

Signed-off-by: Stefan Metzmacher <metze@samba.org>
Link: https://lore.kernel.org/r/38961085c3ec49fd21550c7788f214d1ff02d2d4.1615908477.git.metze@samba.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8f57fd328df6..38a394c6260d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4410,7 +4410,7 @@ static int io_sendmsg(struct io_kiocb *req, bool force_nonblock,
 		kmsg = &iomsg;
 	}
 
-	flags = req->sr_msg.msg_flags;
+	flags = req->sr_msg.msg_flags | MSG_NOSIGNAL;
 	if (flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
 	else if (force_nonblock)
@@ -4454,7 +4454,7 @@ static int io_send(struct io_kiocb *req, bool force_nonblock,
 	msg.msg_controllen = 0;
 	msg.msg_namelen = 0;
 
-	flags = req->sr_msg.msg_flags;
+	flags = req->sr_msg.msg_flags | MSG_NOSIGNAL;
 	if (flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
 	else if (force_nonblock)
@@ -4648,7 +4648,7 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
 				1, req->sr_msg.len);
 	}
 
-	flags = req->sr_msg.msg_flags;
+	flags = req->sr_msg.msg_flags | MSG_NOSIGNAL;
 	if (flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
 	else if (force_nonblock)
@@ -4706,7 +4706,7 @@ static int io_recv(struct io_kiocb *req, bool force_nonblock,
 	msg.msg_iocb = NULL;
 	msg.msg_flags = 0;
 
-	flags = req->sr_msg.msg_flags;
+	flags = req->sr_msg.msg_flags | MSG_NOSIGNAL;
 	if (flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
 	else if (force_nonblock)
-- 
2.30.1

