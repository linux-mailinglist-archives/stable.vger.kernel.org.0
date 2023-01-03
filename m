Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59BC965BBC9
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 09:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236990AbjACIPy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 03:15:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbjACIPf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 03:15:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E68D2F6;
        Tue,  3 Jan 2023 00:15:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D669B80E49;
        Tue,  3 Jan 2023 08:15:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E73AC433EF;
        Tue,  3 Jan 2023 08:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672733729;
        bh=J5e7O0O8iPEmHTzAk8tMEyAl6ywNl1X69dM6nO2IGHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fq3HU+lYmJklsIUNFgck/YL4t7LDH9H2spcUJwu1aNANn/+w6xWJQsRr7srJumgbP
         YQOAuC9hTjDwS4lGSCeDTFlaUjBAlWrNINKvzkwtWncAltO/cZ5RvOE57UD+9k6j1r
         NPtObH6O9hz0hZwZJ504GRJarQAky81IlIRS0xXo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-mips@vger.kernel.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 24/63] mips: add support for TIF_NOTIFY_SIGNAL
Date:   Tue,  3 Jan 2023 09:13:54 +0100
Message-Id: <20230103081310.018548519@linuxfoundation.org>
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

[ Upstream commit f45c184bce15f4a314c0210519bc3b4aab408838 ]

Wire up TIF_NOTIFY_SIGNAL handling for mips.

Cc: linux-mips@vger.kernel.org
Acked-By: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/include/asm/thread_info.h |    4 +++-
 arch/mips/kernel/signal.c           |    2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/arch/mips/include/asm/thread_info.h
+++ b/arch/mips/include/asm/thread_info.h
@@ -115,6 +115,7 @@ static inline struct thread_info *curren
 #define TIF_SECCOMP		4	/* secure computing */
 #define TIF_NOTIFY_RESUME	5	/* callback before returning to user */
 #define TIF_UPROBE		6	/* breakpointed or singlestepping */
+#define TIF_NOTIFY_SIGNAL	7	/* signal notifications exist */
 #define TIF_RESTORE_SIGMASK	9	/* restore signal mask in do_signal() */
 #define TIF_USEDFPU		16	/* FPU was used by this task this quantum (SMP) */
 #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
@@ -139,6 +140,7 @@ static inline struct thread_info *curren
 #define _TIF_SECCOMP		(1<<TIF_SECCOMP)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
 #define _TIF_UPROBE		(1<<TIF_UPROBE)
+#define _TIF_NOTIFY_SIGNAL	(1<<TIF_NOTIFY_SIGNAL)
 #define _TIF_USEDFPU		(1<<TIF_USEDFPU)
 #define _TIF_NOHZ		(1<<TIF_NOHZ)
 #define _TIF_FIXADE		(1<<TIF_FIXADE)
@@ -164,7 +166,7 @@ static inline struct thread_info *curren
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK		\
 	(_TIF_SIGPENDING | _TIF_NEED_RESCHED | _TIF_NOTIFY_RESUME |	\
-	 _TIF_UPROBE)
+	 _TIF_UPROBE | _TIF_NOTIFY_SIGNAL)
 /* work to do on any return to u-space */
 #define _TIF_ALLWORK_MASK	(_TIF_NOHZ | _TIF_WORK_MASK |		\
 				 _TIF_WORK_SYSCALL_EXIT |		\
--- a/arch/mips/kernel/signal.c
+++ b/arch/mips/kernel/signal.c
@@ -903,7 +903,7 @@ asmlinkage void do_notify_resume(struct
 		uprobe_notify_resume(regs);
 
 	/* deal with pending signal delivery */
-	if (thread_info_flags & _TIF_SIGPENDING)
+	if (thread_info_flags & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL))
 		do_signal(regs);
 
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {


