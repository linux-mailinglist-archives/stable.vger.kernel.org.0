Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45E1665BBE2
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 09:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237072AbjACIQi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 03:16:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237046AbjACIQX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 03:16:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF4CDF59
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 00:16:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE98B611F0
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 08:16:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C394DC433D2;
        Tue,  3 Jan 2023 08:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672733782;
        bh=39BQoTJnxJQxgSTgyciiwrfcOzq7T/IxXK98SKqCj2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tFKFHiom/V17pPVjwwX75a9b3PIKfa9U02qfu70yFvJWckOTgtIOAbAWWa6ogLa9c
         2rmwVeGkrvEWqAQe2Z2abpJZRnmji1HuVyjrPvEM48EA3urtjsUe5y95L44X1B04cd
         nIhAGLOrD6uGNxT68cNJ3p2ey5EkgMw2GtIdjw+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-m68k@lists.linux-m68k.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 20/63] m68k: add support for TIF_NOTIFY_SIGNAL
Date:   Tue,  3 Jan 2023 09:13:50 +0100
Message-Id: <20230103081309.775973572@linuxfoundation.org>
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

[ Upstream commit e660653cd9f2df470d156c249631f68b9dee51ee ]

Wire up TIF_NOTIFY_SIGNAL handling for m68k.

Cc: linux-m68k@lists.linux-m68k.org
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/m68k/include/asm/thread_info.h |    1 +
 arch/m68k/kernel/signal.c           |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/arch/m68k/include/asm/thread_info.h
+++ b/arch/m68k/include/asm/thread_info.h
@@ -60,6 +60,7 @@ static inline struct thread_info *curren
  * bits 0-7 are tested at every exception exit
  * bits 8-15 are also tested at syscall exit
  */
+#define TIF_NOTIFY_SIGNAL	4
 #define TIF_NOTIFY_RESUME	5	/* callback before returning to user */
 #define TIF_SIGPENDING		6	/* signal pending */
 #define TIF_NEED_RESCHED	7	/* rescheduling necessary */
--- a/arch/m68k/kernel/signal.c
+++ b/arch/m68k/kernel/signal.c
@@ -1129,7 +1129,8 @@ static void do_signal(struct pt_regs *re
 
 void do_notify_resume(struct pt_regs *regs)
 {
-	if (test_thread_flag(TIF_SIGPENDING))
+	if (test_thread_flag(TIF_NOTIFY_SIGNAL) ||
+	    test_thread_flag(TIF_SIGPENDING))
 		do_signal(regs);
 
 	if (test_thread_flag(TIF_NOTIFY_RESUME))


