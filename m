Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58D9C6AF548
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233980AbjCGTYE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:24:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233982AbjCGTXm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:23:42 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85EC9A2C30
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:09:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AE444CE1B2F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:09:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADEBEC433D2;
        Tue,  7 Mar 2023 19:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678216147;
        bh=OJ8z5rPXMqSQeX3Fi53RbqbQ7dLeYonoQduNq8qjMJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yD1BXgvR87YnAcZeeOzDfH1/2aERcVEe6/H9/EYnZce7ft+Si7eUy8Oq3n0le58RK
         dYbE5WxrGpyRmrOsHYERjdv8zEUFjEKULYwOHCLSFh3MqyYf1/SKVx+Tms9FRC2PAE
         guAgFPwiUSvya8AVJ9IMA2IHohPuXxsEnTutz1fA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 490/567] io_uring: handle TIF_NOTIFY_RESUME when checking for task_work
Date:   Tue,  7 Mar 2023 18:03:46 +0100
Message-Id: <20230307165927.183954375@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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
 io_uring/io_uring.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2463,6 +2463,13 @@ static inline unsigned int io_put_rw_kbu
 
 static inline bool io_run_task_work(void)
 {
+	/*
+	 * PF_IO_WORKER never returns to userspace, so check here if we have
+	 * notify work that needs processing.
+	 */
+	if (current->flags & PF_IO_WORKER &&
+	    test_thread_flag(TIF_NOTIFY_RESUME))
+		tracehook_notify_resume(NULL);
 	if (test_thread_flag(TIF_NOTIFY_SIGNAL) || current->task_works) {
 		__set_current_state(TASK_RUNNING);
 		tracehook_notify_signal();


