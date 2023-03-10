Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 023EF6B496B
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234007AbjCJPMZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:12:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234010AbjCJPLx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:11:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1346910FBA8
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:03:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FD8161982
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:02:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76624C4339E;
        Fri, 10 Mar 2023 15:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460556;
        bh=IIMQdk/pq2T6PUL9kEChOSc+fiB1XAYvRjkMCWhn9lM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p7rXedpg4VQpk7n5Gr7ewUvdQNPj7JpW6Lo+JZSOK8/DXYWXyB1HkwvAWFtE000IU
         3/RY1EtjTrYkVjcqVw2QmavMiTrd7pmx3RjMs6uVKdF/skgAqI8XjX1e+c5S66D7gW
         QucdDOX1FJ9QTmZWsWrB8fUBZc/dQ3Y6fiUjQT3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 373/529] io_uring: handle TIF_NOTIFY_RESUME when checking for task_work
Date:   Fri, 10 Mar 2023 14:38:36 +0100
Message-Id: <20230310133822.278967669@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
@@ -2460,6 +2460,13 @@ static inline unsigned int io_put_rw_kbu
 
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


