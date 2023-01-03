Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6E865BBF1
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 09:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237036AbjACISL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 03:18:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237111AbjACIRt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 03:17:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB8E2E082
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 00:17:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5788DB80E57
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 08:17:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8446C433F0;
        Tue,  3 Jan 2023 08:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672733839;
        bh=vfKzb+eY3wnt2ReVcnp29G/Dfuf7PoOI+KT5aeKdfW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cKnFxM5fh0WlmTj/EtyPubRu7ZQGKKaHls4pR1pA2MdKthsheApY8zsWRLCroZXGT
         cgzCNHDL/TBLl73+Wm0CfvOlQUnhO4fSP4wtzZomaLDKxRXTdtfmiKEha+hM5yog/j
         4L+3hy0jPhNSjoLw3Qhuw547hE+tX98aLi2vHUCc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-riscv@lists.infradead.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 39/63] riscv: add support for TIF_NOTIFY_SIGNAL
Date:   Tue,  3 Jan 2023 09:14:09 +0100
Message-Id: <20230103081310.924046326@linuxfoundation.org>
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

[ Upstream commit 24a31b81e38309b1604f24520110aae1f83f3cbf ]

Wire up TIF_NOTIFY_SIGNAL handling for riscv.

Cc: linux-riscv@lists.infradead.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/thread_info.h |    5 ++++-
 arch/riscv/kernel/signal.c           |    2 +-
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/arch/riscv/include/asm/thread_info.h
+++ b/arch/riscv/include/asm/thread_info.h
@@ -80,6 +80,7 @@ struct thread_info {
 #define TIF_SYSCALL_TRACEPOINT  6       /* syscall tracepoint instrumentation */
 #define TIF_SYSCALL_AUDIT	7	/* syscall auditing */
 #define TIF_SECCOMP		8	/* syscall secure computing */
+#define TIF_NOTIFY_SIGNAL	9	/* signal notifications exist */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
@@ -88,9 +89,11 @@ struct thread_info {
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
+#define _TIF_NOTIFY_SIGNAL	(1 << TIF_NOTIFY_SIGNAL)
 
 #define _TIF_WORK_MASK \
-	(_TIF_NOTIFY_RESUME | _TIF_SIGPENDING | _TIF_NEED_RESCHED)
+	(_TIF_NOTIFY_RESUME | _TIF_SIGPENDING | _TIF_NEED_RESCHED | \
+	 _TIF_NOTIFY_SIGNAL)
 
 #define _TIF_SYSCALL_WORK \
 	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_TRACEPOINT | _TIF_SYSCALL_AUDIT | \
--- a/arch/riscv/kernel/signal.c
+++ b/arch/riscv/kernel/signal.c
@@ -312,7 +312,7 @@ asmlinkage __visible void do_notify_resu
 					   unsigned long thread_info_flags)
 {
 	/* Handle pending signal delivery */
-	if (thread_info_flags & _TIF_SIGPENDING)
+	if (thread_info_flags & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL))
 		do_signal(regs);
 
 	if (thread_info_flags & _TIF_NOTIFY_RESUME)


