Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B36765BBFB
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 09:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237089AbjACISH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 03:18:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237136AbjACIRm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 03:17:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56E8BBA
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 00:17:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E9DDB80E4B
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 08:17:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4A73C433D2;
        Tue,  3 Jan 2023 08:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672733833;
        bh=MpwhqiXhOk4c5z7KQwtyBu+QDEjT5mowJjvKFfLHYHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SWTaQefA2gH/3gsQ9a8CzkYa7m7dMWA/9INiAvpwIov71FKn86jye649LEu+jQV0g
         IMEdSHlA2qhVMivmoC318PpvlAGg+GVa/i0vqDvT8tshxV/GmFcOmFbvtPAZ1LlmQk
         zo5QnkT8kkQQjzr0QaYZH0nT47V0TKnUuGujTbLA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Song Liu <songliubraving@fb.com>,
        John Stultz <john.stultz@linaro.org>,
        Douglas Anderson <dianders@chromium.org>,
        Jens Axboe <axboe@kernel.dk>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH 5.10 57/63] task_work: unconditionally run task_work from get_signal()
Date:   Tue,  3 Jan 2023 09:14:27 +0100
Message-Id: <20230103081312.034796892@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230103081308.548338576@linuxfoundation.org>
References: <20230103081308.548338576@linuxfoundation.org>
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

[ Upstream commit 35d0b389f3b23439ad15b610d6e43fc72fc75779 ]

Song reported a boot regression in a kvm image with 5.11-rc, and bisected
it down to the below patch. Debugging this issue, turns out that the boot
stalled when a task is waiting on a pipe being released. As we no longer
run task_work from get_signal() unless it's queued with TWA_SIGNAL, the
task goes idle without running the task_work. This prevents ->release()
from being called on the pipe, which another boot task is waiting on.

For now, re-instate the unconditional task_work run from get_signal().
For 5.12, we'll collapse TWA_RESUME and TWA_SIGNAL, as it no longer
makes sense to have a distinction between the two. This will turn
task_work notification into a simple boolean, whether to notify or not.

Fixes: 98b89b649fce ("signal: kill JOBCTL_TASK_WORK")
Reported-by: Song Liu <songliubraving@fb.com>
Tested-by: John Stultz <john.stultz@linaro.org>
Tested-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com> # LLVM/Clang version 11.0.1
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/signal.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2520,6 +2520,9 @@ bool get_signal(struct ksignal *ksig)
 	struct signal_struct *signal = current->signal;
 	int signr;
 
+	if (unlikely(current->task_works))
+		task_work_run();
+
 	/*
 	 * For non-generic architectures, check for TIF_NOTIFY_SIGNAL so
 	 * that the arch handlers don't all have to do it. If we get here


