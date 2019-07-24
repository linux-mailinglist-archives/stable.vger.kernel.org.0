Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADC0C7396E
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389967AbfGXTkI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:40:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:41212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389737AbfGXTkC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:40:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA5CE229F3;
        Wed, 24 Jul 2019 19:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997201;
        bh=eVvG9VZLB22zQCc4vbFJLQoEix3cpxYMAt2ee8z/IeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=txqCb9mJMHS3HZBLRi95QWgwSW9/fmeFGQbkrN7FpVQaHOEBoaVRKU0WZ58ZnJ6da
         hiv2V7dRpxHJNjFZsv5a/4oMciIHo8mXm0wCjlW4wRSG7lcEhjKv88yUXO4EKteFKB
         xf5ZNUXoIuiiJqrXlqsbpmt8IUth6x/Axu5nCmb8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eiichi Tsukata <devel@etsukata.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.2 357/413] x86/stacktrace: Prevent infinite loop in arch_stack_walk_user()
Date:   Wed, 24 Jul 2019 21:20:48 +0200
Message-Id: <20190724191801.208485964@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eiichi Tsukata <devel@etsukata.com>

commit cbf5b73d162b22e044fe0b7d51dcaa33be065253 upstream.

arch_stack_walk_user() checks `if (fp == frame.next_fp)` to prevent a
infinite loop by self reference but it's not enogh for circular reference.

Once a lack of return address is found, there is no point to continue the
loop, so break out.

Fixes: 02b67518e2b1 ("tracing: add support for userspace stacktraces in tracing/iter_ctrl")
Signed-off-by: Eiichi Tsukata <devel@etsukata.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lkml.kernel.org/r/20190711023501.963-1-devel@etsukata.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/stacktrace.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -129,11 +129,9 @@ void arch_stack_walk_user(stack_trace_co
 			break;
 		if ((unsigned long)fp < regs->sp)
 			break;
-		if (frame.ret_addr) {
-			if (!consume_entry(cookie, frame.ret_addr, false))
-				return;
-		}
-		if (fp == frame.next_fp)
+		if (!frame.ret_addr)
+			break;
+		if (!consume_entry(cookie, frame.ret_addr, false))
 			break;
 		fp = frame.next_fp;
 	}


