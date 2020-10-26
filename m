Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E10BD29A0CA
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408966AbgJZXuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 19:50:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408786AbgJZXtm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:49:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 606C921741;
        Mon, 26 Oct 2020 23:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756182;
        bh=6DudW/JqqtwV4WRtfvdDoaRR7NIbaoqPJeFKlaMc93I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y/gfptYP3XSBhaRyTH+N6Z5jNDtuE4YPNxTjwOP7Cyy6cmSQZ6Td3GrnjYnSeCkTm
         hze5VwN425aCc/F7w/UwquL0j3tGiJDA+zKS81sdbig1B+JHpceJGCwDS42IQ83YJy
         NIq//HYBLXfpcRK0XwlyOAu859Nz0O9MWkvft2xI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 029/147] io_uring: don't set COMP_LOCKED if won't put
Date:   Mon, 26 Oct 2020 19:47:07 -0400
Message-Id: <20201026234905.1022767-29-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026234905.1022767-1-sashal@kernel.org>
References: <20201026234905.1022767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index aae0ef2ec34d2..2145cf76a0d6a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1614,6 +1614,7 @@ static bool io_link_cancel_timeout(struct io_kiocb *req)
 
 	ret = hrtimer_try_to_cancel(&req->io->timeout.timer);
 	if (ret != -1) {
+		req->flags |= REQ_F_COMP_LOCKED;
 		io_cqring_fill_event(req, -ECANCELED);
 		io_commit_cqring(ctx);
 		req->flags &= ~REQ_F_LINK_HEAD;
@@ -1636,7 +1637,6 @@ static bool __io_kill_linked_timeout(struct io_kiocb *req)
 		return false;
 
 	list_del_init(&link->link_list);
-	link->flags |= REQ_F_COMP_LOCKED;
 	wake_ev = io_link_cancel_timeout(link);
 	req->flags &= ~REQ_F_LINK_TIMEOUT;
 	return wake_ev;
-- 
2.25.1

