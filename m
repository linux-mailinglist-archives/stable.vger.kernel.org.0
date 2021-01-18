Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 537A32FA41F
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 16:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405552AbhARPHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 10:07:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:34192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390787AbhARLmp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:42:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC2CE22D6F;
        Mon, 18 Jan 2021 11:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970139;
        bh=bpaQKIZvd4zoW/KfB27aVIPVlOHiIh2TQhLtNqawqwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2u4z+izqq2asg2Rywtszeuk+Anb7ryE9JvjgbDadIuV9HIIflVsFMU8Iw0qIA3tZx
         1nRvi8FnXTF90vKp2BXGFkCoFrqXgh9HBICHOIIDN7QEdTg+gnJZbkNoyjGdV3i3a/
         0LUm6tSHRkT0Jl1jx5w9PwPf7OAcqWh3xMCKC5P4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 053/152] io_uring: dont take files/mm for a dead task
Date:   Mon, 18 Jan 2021 12:33:48 +0100
Message-Id: <20210118113355.336971937@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 621fadc22365f3cf307bcd9048e3372e9ee9cdcc ]

In rare cases a task may be exiting while io_ring_exit_work() trying to
cancel/wait its requests. It's ok for __io_sq_thread_acquire_mm()
because of SQPOLL check, but is not for __io_sq_thread_acquire_files().
Play safe and fail for both of them.

Cc: stable@vger.kernel.org # 5.5+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4833b68f1a1cc..6c356b9e87b39 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1009,6 +1009,8 @@ static int __io_sq_thread_acquire_mm(struct io_ring_ctx *ctx)
 {
 	struct mm_struct *mm;
 
+	if (current->flags & PF_EXITING)
+		return -EFAULT;
 	if (current->mm)
 		return 0;
 
-- 
2.27.0



