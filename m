Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79E6879706
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391019AbfG2TyU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:54:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:46996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390733AbfG2TyU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:54:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8A5E21655;
        Mon, 29 Jul 2019 19:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564430060;
        bh=n6R0gcYCZXGZoQwAw6Op0fgmjeV8rEY30bF0MOUNEQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uoPegt/eW+KezImSpriYL+1Fv6R1v/T3rLO274BQJccIWtZhy0emhGxUcrWH5hAJN
         Th/LMofQ8SoADUxdAIzWhq1RJxBOAOfuQEq+asA5AD1fmaAQqSbmyz0JFd6rliT4ID
         liUAElfC8rMT81IfLAQVhtX07v0U+QeB6W0U5tqA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juri Lelli <juri.lelli@gmail.com>,
        Eiichi Tsukata <devel@etsukata.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.2 183/215] x86/stacktrace: Prevent access_ok() warnings in arch_stack_walk_user()
Date:   Mon, 29 Jul 2019 21:22:59 +0200
Message-Id: <20190729190811.906620918@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eiichi Tsukata <devel@etsukata.com>

commit 2af7c85714d8cafadf925d55441458eae312cd6b upstream.

When arch_stack_walk_user() is called from atomic contexts, access_ok() can
trigger the following warning if compiled with CONFIG_DEBUG_ATOMIC_SLEEP=y.

Reproducer:

  // CONFIG_DEBUG_ATOMIC_SLEEP=y
  # cd /sys/kernel/debug/tracing
  # echo 1 > options/userstacktrace
  # echo 1 > events/irq/irq_handler_entry/enable

  WARNING: CPU: 0 PID: 2649 at arch/x86/kernel/stacktrace.c:103 arch_stack_walk_user+0x6e/0xf6
  CPU: 0 PID: 2649 Comm: bash Not tainted 5.3.0-rc1+ #99
  RIP: 0010:arch_stack_walk_user+0x6e/0xf6
  Call Trace:
   <IRQ>
   stack_trace_save_user+0x10a/0x16d
   trace_buffer_unlock_commit_regs+0x185/0x240
   trace_event_buffer_commit+0xec/0x330
   trace_event_raw_event_irq_handler_entry+0x159/0x1e0
   __handle_irq_event_percpu+0x22d/0x440
   handle_irq_event_percpu+0x70/0x100
   handle_irq_event+0x5a/0x8b
   handle_edge_irq+0x12f/0x3f0
   handle_irq+0x34/0x40
   do_IRQ+0xa6/0x1f0
   common_interrupt+0xf/0xf
   </IRQ>

Fix it by calling __range_not_ok() directly instead of access_ok() as
copy_from_user_nmi() does. This is fine here because the actual copy is
inside a pagefault disabled region.

Reported-by: Juri Lelli <juri.lelli@gmail.com>
Signed-off-by: Eiichi Tsukata <devel@etsukata.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20190722083216.16192-2-devel@etsukata.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/stacktrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -100,7 +100,7 @@ copy_stack_frame(const void __user *fp,
 {
 	int ret;
 
-	if (!access_ok(fp, sizeof(*frame)))
+	if (__range_not_ok(fp, sizeof(*frame), TASK_SIZE))
 		return 0;
 
 	ret = 1;


