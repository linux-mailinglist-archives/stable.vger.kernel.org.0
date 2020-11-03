Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5576C2A5160
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730199AbgKCUkX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:40:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:51638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729787AbgKCUkW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:40:22 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F17F0223AC;
        Tue,  3 Nov 2020 20:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436022;
        bh=IWxqs2X63agThMfuF3hPsQ3OgyfHQ83oTP7Q4kzW7JA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aogMO7yyvOigFeMl6w34ut0hVMj0qXyK83Bf8so8kXtcznxXOT5EVrelGDb1UeDkg
         IWjzbtVChFdHCSni1/IEzi6pjNxl9ow56+mEskpUni2AphaQzBGJAnKJicImD7RK90
         lfKRzJjDQDdNPKujoVYkt5BpEtrKmwqv/ZwBhI/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 070/391] io_uring: dont set COMP_LOCKED if wont put
Date:   Tue,  3 Nov 2020 21:32:01 +0100
Message-Id: <20201103203351.972293956@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 368c5481ae7c6a9719c40984faea35480d9f4872 ]

__io_kill_linked_timeout() sets REQ_F_COMP_LOCKED for a linked timeout
even if it can't cancel it, e.g. it's already running. It not only races
with io_link_timeout_fn() for ->flags field, but also leaves the flag
set and so io_link_timeout_fn() may find it and decide that it holds the
lock. Hopefully, the second problem is potential.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 59ab8c5c2aaaa..50a7a99dad4ca 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1650,6 +1650,7 @@ static bool io_link_cancel_timeout(struct io_kiocb *req)
 
 	ret = hrtimer_try_to_cancel(&req->io->timeout.timer);
 	if (ret != -1) {
+		req->flags |= REQ_F_COMP_LOCKED;
 		io_cqring_fill_event(req, -ECANCELED);
 		io_commit_cqring(ctx);
 		req->flags &= ~REQ_F_LINK_HEAD;
@@ -1672,7 +1673,6 @@ static bool __io_kill_linked_timeout(struct io_kiocb *req)
 		return false;
 
 	list_del_init(&link->link_list);
-	link->flags |= REQ_F_COMP_LOCKED;
 	wake_ev = io_link_cancel_timeout(link);
 	req->flags &= ~REQ_F_LINK_TIMEOUT;
 	return wake_ev;
-- 
2.27.0



