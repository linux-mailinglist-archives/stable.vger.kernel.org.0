Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC4336AEC32
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:53:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbjCGRxL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:53:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbjCGRwt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:52:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D5CEA6BC1
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:47:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EEBE61501
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:47:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 753CEC433D2;
        Tue,  7 Mar 2023 17:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211234;
        bh=gb6m6q7eJ7vrIpStGuM1hl7wRfb5hqwy+aLdckHBeXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kAMAjWW/cL2F1hd6ddVpkv3HfP2WMduCYPNtgPo+SzRQMfrq0lzcbwawYCeHpZXXx
         8x4zK/ivMwt76iC+5qS2ZL/b0CWsanBGDhc7bhagsfSX7v0A6z5v20plS7Frz9RxaZ
         0Y0E/DU6HrUT3UebO1IsJb+hdE7Pd1BirrnhAjhw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.2 0756/1001] io_uring: handle TIF_NOTIFY_RESUME when checking for task_work
Date:   Tue,  7 Mar 2023 17:58:48 +0100
Message-Id: <20230307170054.526787657@linuxfoundation.org>
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

commit b5d3ae202fbfe055aa2a8ae8524531ee1dcab717 upstream.

If TIF_NOTIFY_RESUME is set, then we need to call resume_user_mode_work()
for PF_IO_WORKER threads. They never return to usermode, hence never get
a chance to process any items that are marked by this flag. Most notably
this includes the final put of files, but also any throttling markers set
by block cgroups.

Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.h |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -3,6 +3,7 @@
 
 #include <linux/errno.h>
 #include <linux/lockdep.h>
+#include <linux/resume_user_mode.h>
 #include <linux/io_uring_types.h>
 #include <uapi/linux/eventpoll.h>
 #include "io-wq.h"
@@ -270,6 +271,13 @@ static inline int io_run_task_work(void)
 	 */
 	if (test_thread_flag(TIF_NOTIFY_SIGNAL))
 		clear_notify_signal();
+	/*
+	 * PF_IO_WORKER never returns to userspace, so check here if we have
+	 * notify work that needs processing.
+	 */
+	if (current->flags & PF_IO_WORKER &&
+	    test_thread_flag(TIF_NOTIFY_RESUME))
+		resume_user_mode_work(NULL);
 	if (task_work_pending(current)) {
 		__set_current_state(TASK_RUNNING);
 		task_work_run();


