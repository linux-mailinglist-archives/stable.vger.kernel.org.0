Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76F536AEC37
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:53:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbjCGRxY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:53:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231337AbjCGRw6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:52:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C69BD92F04
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:47:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56BEDB819B4
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:47:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB83EC433EF;
        Tue,  7 Mar 2023 17:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211238;
        bh=poVf9OJM0rm/t1qD/IVmJ2U4134Ns7Gc3xEKCJ1jw2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VU4yJw0kcuTuvZmqyQa8qg7uolNoF1G5h+ucic/n/QTqGKXNT0EHX2Si4dIcgDAJt
         FUMcqCKvqlMP7SKW1I1NHp0ij8HmvUHJ/QLTgZVrgC1yuRJe9J5jtKnCpBLkDjXJDB
         rO+0EYOhThsCbKfy/+nuOHCOvISpVZBVFvVJFODk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <oliver.sang@intel.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.2 0790/1001] io_uring: mark task TASK_RUNNING before handling resume/task work
Date:   Tue,  7 Mar 2023 17:59:22 +0100
Message-Id: <20230307170056.039424328@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 2f2bb1ffc9983e227424d0787289da5483b0c74f upstream.

Just like for task_work, set the task mode to TASK_RUNNING before doing
any potential resume work. We're not holding any locks at this point,
but we may have already set the task state to TASK_INTERRUPTIBLE in
preparation for going to sleep waiting for events. Ensure that we set it
back to TASK_RUNNING if we have work to process, to avoid warnings on
calling blocking operations with !TASK_RUNNING.

Fixes: b5d3ae202fbf ("io_uring: handle TIF_NOTIFY_RESUME when checking for task_work")
Reported-by: kernel test robot <oliver.sang@intel.com>
Link: https://lore.kernel.org/oe-lkp/202302062208.24d3e563-oliver.sang@intel.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -276,8 +276,10 @@ static inline int io_run_task_work(void)
 	 * notify work that needs processing.
 	 */
 	if (current->flags & PF_IO_WORKER &&
-	    test_thread_flag(TIF_NOTIFY_RESUME))
+	    test_thread_flag(TIF_NOTIFY_RESUME)) {
+		__set_current_state(TASK_RUNNING);
 		resume_user_mode_work(NULL);
+	}
 	if (task_work_pending(current)) {
 		__set_current_state(TASK_RUNNING);
 		task_work_run();


