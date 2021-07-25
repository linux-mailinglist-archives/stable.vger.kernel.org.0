Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FAC23D4F77
	for <lists+stable@lfdr.de>; Sun, 25 Jul 2021 20:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbhGYRnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Jul 2021 13:43:52 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:41466 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbhGYRnw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Jul 2021 13:43:52 -0400
X-Greylist: delayed 2381 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Jul 2021 13:43:52 EDT
Received: from [173.237.58.148] (port=51036 helo=localhost)
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1m7iB5-0004MM-GM; Sun, 25 Jul 2021 13:44:39 -0400
Message-Id: <82a82077d8b02166482df754b1abb7c3fbc3c560.1627189961.git.olivier@trillion01.com>
From:   Olivier Langlois <olivier@trillion01.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, gregkh@linuxfoundation.org
Date:   Sat, 24 Jul 2021 22:07:59 -0700
Subject: [PATCH io_uring backport to 5.13.y] io_uring: Fix race condition
 when sqp thread goes to sleep
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cloud48395.mywhc.ca
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - trillion01.com
X-Get-Message-Sender-Via: cloud48395.mywhc.ca: authenticated_id: olivier@trillion01.com
X-Authenticated-Sender: cloud48395.mywhc.ca: olivier@trillion01.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 997135017716 ("io_uring: Fix race condition when sqp thread goes to sleep") ]

If an asynchronous completion happens before the task is preparing
itself to wait and set its state to TASK_INTERRUPTIBLE, the completion
will not wake up the sqp thread.

Signed-off-by: Olivier Langlois <olivier@trillion01.com>
---
 fs/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index eeea6b8c8bee..a7f1cbd7be9a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6876,7 +6876,8 @@ static int io_sq_thread(void *data)
 		}
 
 		prepare_to_wait(&sqd->wait, &wait, TASK_INTERRUPTIBLE);
-		if (!test_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state)) {
+		if (!test_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state) &&
+		    !io_run_task_work()) {
 			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
 				io_ring_set_wakeup_flag(ctx);
 
-- 
2.32.0

