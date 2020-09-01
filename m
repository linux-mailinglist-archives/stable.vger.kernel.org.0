Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C23A425951A
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728980AbgIAPqe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:46:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:36424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731941AbgIAPqd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:46:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E13D62064B;
        Tue,  1 Sep 2020 15:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598975193;
        bh=x9I1diIdkoWPz2TxjPJNl3qjhvHFnG1wkPzdr3NEUew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a9Pzql+iHL6lap21p7/6fKyNK8Rj7GhaNKEJYW3Nvy4uartq79H1cRV1PYVZYcc26
         FNpxhzALeetJ/HJ3Y7ynL/i43+xNERX/kFP9C+qCv3fVg3EmsJZV2VzekFFtcWCy0e
         63WyaiQ1PCfa0CUOS3HQP7DhxXiwgb3JpwxNQ//A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benedikt Ames <wisp3rwind@posteo.eu>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 244/255] io_uring: dont use poll handler if file cant be nonblocking read/written
Date:   Tue,  1 Sep 2020 17:11:40 +0200
Message-Id: <20200901151012.444381510@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 9dab14b81807a40dab8e464ec87043935c562c2c ]

There's no point in using the poll handler if we can't do a nonblocking
IO attempt of the operation, since we'll need to go async anyway. In
fact this is actively harmful, as reading from eg pipes won't return 0
to indicate EOF.

Cc: stable@vger.kernel.org # v5.7+
Reported-by: Benedikt Ames <wisp3rwind@posteo.eu>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c384caad64665..2b7018456091c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4503,12 +4503,20 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 	struct async_poll *apoll;
 	struct io_poll_table ipt;
 	__poll_t mask, ret;
+	int rw;
 
 	if (!req->file || !file_can_poll(req->file))
 		return false;
 	if (req->flags & (REQ_F_MUST_PUNT | REQ_F_POLLED))
 		return false;
-	if (!def->pollin && !def->pollout)
+	if (def->pollin)
+		rw = READ;
+	else if (def->pollout)
+		rw = WRITE;
+	else
+		return false;
+	/* if we can't nonblock try, then no point in arming a poll handler */
+	if (!io_file_supports_async(req->file, rw))
 		return false;
 
 	apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
-- 
2.25.1



