Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6201863E012
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbiK3SxW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:53:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231549AbiK3SxI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:53:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B8EC1F614
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:53:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC26461D89
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:53:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE9F9C433C1;
        Wed, 30 Nov 2022 18:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834386;
        bh=DVsudJYSfD+iO/RcDDvNNWuARIoeYEMC5wmf+b26liY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LSbXXkcFh0WvfYE8RVWYYqlqmSCiYvW2kt9j9OX5MK8T6fl+eRiTzW9+Boy48jNfK
         N1kR6viIjIwYGRYsi+VFhE9E6Bi/J8NVRiEjyAwqZd0fB//34SGY6/tyPxPQ+VZHph
         FYgANAxrt8YluuZqPDn2g931xsasL+Y61bf2qsHE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.0 197/289] io_uring: clear TIF_NOTIFY_SIGNAL if set and task_work not available
Date:   Wed, 30 Nov 2022 19:23:02 +0100
Message-Id: <20221130180548.587691737@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 7cfe7a09489c1cefee7181e07b5f2bcbaebd9f41 upstream.

With how task_work is added and signaled, we can have TIF_NOTIFY_SIGNAL
set and no task_work pending as it got run in a previous loop. Treat
TIF_NOTIFY_SIGNAL like get_signal(), always clear it if set regardless
of whether or not task_work is pending to run.

Cc: stable@vger.kernel.org
Fixes: 46a525e199e4 ("io_uring: don't gate task_work run on TIF_NOTIFY_SIGNAL")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.h |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -229,9 +229,14 @@ static inline unsigned int io_sqring_ent
 
 static inline bool io_run_task_work(void)
 {
+	/*
+	 * Always check-and-clear the task_work notification signal. With how
+	 * signaling works for task_work, we can find it set with nothing to
+	 * run. We need to clear it for that case, like get_signal() does.
+	 */
+	if (test_thread_flag(TIF_NOTIFY_SIGNAL))
+		clear_notify_signal();
 	if (task_work_pending(current)) {
-		if (test_thread_flag(TIF_NOTIFY_SIGNAL))
-			clear_notify_signal();
 		__set_current_state(TASK_RUNNING);
 		task_work_run();
 		return 1;


