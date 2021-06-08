Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCF63A036E
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235674AbhFHTQs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:16:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:36962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238343AbhFHTOq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:14:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECEEF61434;
        Tue,  8 Jun 2021 18:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178223;
        bh=Q3LK4c37Lcc4PeoLN/dLINCVDg5mSVxY0TkKAzM5HDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PBPM0B3ZBX0+RyeQJjlSe8eCtoH87FPmnkDU0kTW9SW3jtltQ7tHZlZKzsKd1omvb
         2MpVNbpNrfScbwoPM1paYxuNXjL3T3BL3/nnU8xNZBVCF0u6NUJoyRKeJ6uF30HnZG
         rb+KOWE4IIg4Uq/jqTIdxESLKXM2XMAHqAIBgDU0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        syzbot+5a864149dd970b546223@syzkaller.appspotmail.com
Subject: [PATCH 5.12 088/161] io_uring: fix ltout double free on completion race
Date:   Tue,  8 Jun 2021 20:26:58 +0200
Message-Id: <20210608175948.412603388@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 447c19f3b5074409c794b350b10306e1da1ef4ba ]

Always remove linked timeout on io_link_timeout_fn() from the master
request link list, otherwise we may get use-after-free when first
io_link_timeout_fn() puts linked timeout in the fail path, and then
will be found and put on master's free.

Cc: stable@vger.kernel.org # 5.10+
Fixes: 90cd7e424969d ("io_uring: track link timeout's master explicitly")
Reported-and-tested-by: syzbot+5a864149dd970b546223@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/69c46bf6ce37fec4fdcd98f0882e18eb07ce693a.1620990121.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index dd8b3fac877c..359d1abb089c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6289,10 +6289,11 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 	 * We don't expect the list to be empty, that will only happen if we
 	 * race with the completion of the linked work.
 	 */
-	if (prev && req_ref_inc_not_zero(prev))
+	if (prev) {
 		io_remove_next_linked(prev);
-	else
-		prev = NULL;
+		if (!req_ref_inc_not_zero(prev))
+			prev = NULL;
+	}
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
 	if (prev) {
-- 
2.30.2



