Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 049B147AEE0
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbhLTPFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:05:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239251AbhLTPD7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:03:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D39C08E84A;
        Mon, 20 Dec 2021 06:52:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 803DC611B9;
        Mon, 20 Dec 2021 14:52:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 687A0C36AE9;
        Mon, 20 Dec 2021 14:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011944;
        bh=tjf3jWyhXK0F3lgb0w/NbcxSgn/y/h2Bj74LPNc8MPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NzJNsKVwd8DBLRl9UhtDMSQiMogtuTPdYQMRWxMHUpfozzsOnvTHDxphJwX3V0jS+
         KgPVgLLsnXiwlGdSLurd7FZEONmt85tAs5LrH+jcLzD7KXZIESpnvfHnopfeEMqQmP
         uqlv0ia466MwJaSsQ74aSu7V1rZvBcK5wNPb93Ps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.15 024/177] s390/entry: fix duplicate tracking of irq nesting level
Date:   Mon, 20 Dec 2021 15:32:54 +0100
Message-Id: <20211220143040.896251354@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@linux.ibm.com>

commit c9b12b59e2ea4c3c7cedec7efb071b649652f3a9 upstream.

In the current code, when exiting from idle, rcu_irq_enter() is
called twice during irq entry:

irq_entry_enter()-> rcu_irq_enter()
irq_enter() -> rcu_irq_enter()

This may lead to wrong results from rcu_is_cpu_rrupt_from_idle()
because of a wrong dynticks nmi nesting count. Fix this by only
calling irq_enter_rcu().

Cc: <stable@vger.kernel.org> # 5.12+
Reported-by: Mark Rutland <mark.rutland@arm.com>
Fixes: 56e62a737028 ("s390: convert to generic entry")
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/irq.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/arch/s390/kernel/irq.c
+++ b/arch/s390/kernel/irq.c
@@ -138,7 +138,7 @@ void noinstr do_io_irq(struct pt_regs *r
 	struct pt_regs *old_regs = set_irq_regs(regs);
 	int from_idle;
 
-	irq_enter();
+	irq_enter_rcu();
 
 	if (user_mode(regs))
 		update_timer_sys();
@@ -155,7 +155,8 @@ void noinstr do_io_irq(struct pt_regs *r
 			do_irq_async(regs, IO_INTERRUPT);
 	} while (MACHINE_IS_LPAR && irq_pending(regs));
 
-	irq_exit();
+	irq_exit_rcu();
+
 	set_irq_regs(old_regs);
 	irqentry_exit(regs, state);
 
@@ -169,7 +170,7 @@ void noinstr do_ext_irq(struct pt_regs *
 	struct pt_regs *old_regs = set_irq_regs(regs);
 	int from_idle;
 
-	irq_enter();
+	irq_enter_rcu();
 
 	if (user_mode(regs))
 		update_timer_sys();
@@ -184,7 +185,7 @@ void noinstr do_ext_irq(struct pt_regs *
 
 	do_irq_async(regs, EXT_INTERRUPT);
 
-	irq_exit();
+	irq_exit_rcu();
 	set_irq_regs(old_regs);
 	irqentry_exit(regs, state);
 


