Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9BC348F38
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbhCYL0f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:26:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:34178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230339AbhCYLZs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:25:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1A2461A33;
        Thu, 25 Mar 2021 11:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671547;
        bh=fJoOsw8FvwVVWSa0zIzBMXdbs9kITXlM5MqUwZ1EYlU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HeJ6hQDCMt4W9cwOLnEvdsPUD/tQDT6ZC+vt8iYq0KQg/NVI462+twg5sUHY0I2Kp
         5ptdn4ixELGbBKX1h3dDl9vusRVDT73USFcjW0MLqRh0vWUtAgFuJs8jqH/aJfTkWT
         XEyBW4zCVq6t/BtKBtwCjHZ1pEsm9+K9tPVNxkGhBUNwHCfqb+9cOToDyl/3Fd6XQ3
         LOc1HEH/sbYA3ZHnt/3DrVRyuzwcnuNpSSvRhMutyqAnELog0aTYK/baTW9Hc00y69
         g8PzgNpHwzT0c4fzhFzHo9q92a3wajBskoL4jWu5lzPeRoZfMHRd7p+qbt0AWKdvya
         ybngZxL3wYEoQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 37/44] io_uring: imply MSG_NOSIGNAL for send[msg]()/recv[msg]() calls
Date:   Thu, 25 Mar 2021 07:24:52 -0400
Message-Id: <20210325112459.1926846-37-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112459.1926846-1-sashal@kernel.org>
References: <20210325112459.1926846-1-sashal@kernel.org>
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
index 8e45331d1fed..4ac24e75ae63 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4645,7 +4645,7 @@ static int io_sendmsg(struct io_kiocb *req, bool force_nonblock,
 		kmsg = &iomsg;
 	}
 
-	flags = req->sr_msg.msg_flags;
+	flags = req->sr_msg.msg_flags | MSG_NOSIGNAL;
 	if (flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
 	else if (force_nonblock)
@@ -4689,7 +4689,7 @@ static int io_send(struct io_kiocb *req, bool force_nonblock,
 	msg.msg_controllen = 0;
 	msg.msg_namelen = 0;
 
-	flags = req->sr_msg.msg_flags;
+	flags = req->sr_msg.msg_flags | MSG_NOSIGNAL;
 	if (flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
 	else if (force_nonblock)
@@ -4883,7 +4883,7 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
 				1, req->sr_msg.len);
 	}
 
-	flags = req->sr_msg.msg_flags;
+	flags = req->sr_msg.msg_flags | MSG_NOSIGNAL;
 	if (flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
 	else if (force_nonblock)
@@ -4941,7 +4941,7 @@ static int io_recv(struct io_kiocb *req, bool force_nonblock,
 	msg.msg_iocb = NULL;
 	msg.msg_flags = 0;
 
-	flags = req->sr_msg.msg_flags;
+	flags = req->sr_msg.msg_flags | MSG_NOSIGNAL;
 	if (flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
 	else if (force_nonblock)
-- 
2.30.1

