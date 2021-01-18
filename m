Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA3072FA401
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 16:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405282AbhARPDK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 10:03:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:37702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390799AbhARLmy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:42:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 135FF22D70;
        Mon, 18 Jan 2021 11:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970141;
        bh=MhgRcf7sqHECTaVMRMeimJpL+lflvD4YZfgi2ggkGZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j5pVld6lFoowFFJ/lzSPFNnd2kSjtYIa4kwx7YcSXvqZi/JqoZYyrLwawnVRGU/DD
         cBKeXDF575Hd3Qbbdq7wn2emuB1nSeklUbGJp5lHGXXuiJwIxp2ONQPOvrTAZFrf8Q
         bcHkuXAmKPaB2ffkyHsoAnCrjNNeIIL90Cv7K1OI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 054/152] io_uring: drop mm and files after task_work_run
Date:   Mon, 18 Jan 2021 12:33:49 +0100
Message-Id: <20210118113355.385620010@linuxfoundation.org>
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

[ Upstream commit d434ab6db524ab1efd0afad4ffa1ee65ca6ac097 ]

__io_req_task_submit() run by task_work can set mm and files, but
io_sq_thread() in some cases, and because __io_sq_thread_acquire_mm()
and __io_sq_thread_acquire_files() do a simple current->mm/files check
it may end up submitting IO with mm/files of another task.

We also need to drop it after in the end to drop potentially grabbed
references to them.

Cc: stable@vger.kernel.org # 5.9+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6c356b9e87b39..cab640c10bc0f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6841,6 +6841,7 @@ static int io_sq_thread(void *data)
 
 		if (ret & SQT_SPIN) {
 			io_run_task_work();
+			io_sq_thread_drop_mm();
 			cond_resched();
 		} else if (ret == SQT_IDLE) {
 			if (kthread_should_park())
@@ -6855,6 +6856,7 @@ static int io_sq_thread(void *data)
 	}
 
 	io_run_task_work();
+	io_sq_thread_drop_mm();
 
 	if (cur_css)
 		io_sq_thread_unassociate_blkcg();
-- 
2.27.0



