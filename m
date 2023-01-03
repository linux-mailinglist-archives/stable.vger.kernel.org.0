Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DABE65BBE5
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 09:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237039AbjACIRK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 03:17:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237036AbjACIQv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 03:16:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36200CE;
        Tue,  3 Jan 2023 00:16:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C04D9611DD;
        Tue,  3 Jan 2023 08:16:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE8ADC433EF;
        Tue,  3 Jan 2023 08:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672733809;
        bh=EpLhCWcqwMe4gW6gv72vpfBmFvGXGY9dktuYNMABuRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YiDasIj3KCQau6n2sIxSYglxpvyxi3BZz32QnyQeGBKOFxxKVnZUJOM0HaVlWtcxV
         Gx6c5Ajmj0fvZSnTjSZkKmPMbptrTuwU2hR+pQoz9rVOFLxGwLyY6hteW+OIcJEN08
         uj0jv8GybQ6TiulotAMWlBMBdMZpxa1Qk5cKuSMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Stefan Metzmacher <metze@samba.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andy Lutomirski <luto@kernel.org>,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.10 51/63] x86/process: setup io_threads more like normal user space threads
Date:   Tue,  3 Jan 2023 09:14:21 +0100
Message-Id: <20230103081311.654083836@linuxfoundation.org>
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

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit 50b7b6f29de3e18e9d6c09641256a0296361cfee ]

As io_threads are fully set up USER threads it's clearer to separate the
code path from the KTHREAD logic.

The only remaining difference to user space threads is that io_threads
never return to user space again. Instead they loop within the given
worker function.

The fact that they never return to user space means they don't have an
user space thread stack. In order to indicate that to tools like gdb we
reset the stack and instruction pointers to 0.

This allows gdb attach to user space processes using io-uring, which like
means that they have io_threads, without printing worrying message like
this:

  warning: Selected architecture i386:x86-64 is not compatible with reported target architecture i386

  warning: Architecture rejected target-supplied description

The output will be something like this:

  (gdb) info threads
    Id   Target Id                  Frame
  * 1    LWP 4863 "io_uring-cp-for" syscall () at ../sysdeps/unix/sysv/linux/x86_64/syscall.S:38
    2    LWP 4864 "iou-mgr-4863"    0x0000000000000000 in ?? ()
    3    LWP 4865 "iou-wrk-4863"    0x0000000000000000 in ?? ()
  (gdb) thread 3
  [Switching to thread 3 (LWP 4865)]
  #0  0x0000000000000000 in ?? ()
  (gdb) bt
  #0  0x0000000000000000 in ?? ()
  Backtrace stopped: Cannot access memory at address 0x0

Fixes: 4727dc20e042 ("arch: setup PF_IO_WORKER threads like PF_KTHREAD")
Link: https://lore.kernel.org/io-uring/044d0bad-6888-a211-e1d3-159a4aeed52d@polymtl.ca/T/#m1bbf5727e3d4e839603f6ec7ed79c7eebfba6267
Signed-off-by: Stefan Metzmacher <metze@samba.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>
cc: Jens Axboe <axboe@kernel.dk>
cc: Andy Lutomirski <luto@kernel.org>
cc: linux-kernel@vger.kernel.org
cc: io-uring@vger.kernel.org
cc: x86@kernel.org
Link: https://lore.kernel.org/r/20210505110310.237537-1-metze@samba.org
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/process.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -162,7 +162,7 @@ int copy_thread(unsigned long clone_flag
 #endif
 
 	/* Kernel thread ? */
-	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
+	if (unlikely(p->flags & PF_KTHREAD)) {
 		memset(childregs, 0, sizeof(struct pt_regs));
 		kthread_frame_init(frame, sp, arg);
 		return 0;
@@ -178,6 +178,23 @@ int copy_thread(unsigned long clone_flag
 	task_user_gs(p) = get_user_gs(current_pt_regs());
 #endif
 
+	if (unlikely(p->flags & PF_IO_WORKER)) {
+		/*
+		 * An IO thread is a user space thread, but it doesn't
+		 * return to ret_after_fork().
+		 *
+		 * In order to indicate that to tools like gdb,
+		 * we reset the stack and instruction pointers.
+		 *
+		 * It does the same kernel frame setup to return to a kernel
+		 * function that a kernel thread does.
+		 */
+		childregs->sp = 0;
+		childregs->ip = 0;
+		kthread_frame_init(frame, sp, arg);
+		return 0;
+	}
+
 	/* Set a new TLS for the child thread? */
 	if (clone_flags & CLONE_SETTLS)
 		ret = set_new_tls(p, tls);


