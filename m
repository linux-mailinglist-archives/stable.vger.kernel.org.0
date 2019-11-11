Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74DFFF7D1B
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727859AbfKKSxM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:53:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:47884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727256AbfKKSxL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:53:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67C4420818;
        Mon, 11 Nov 2019 18:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498391;
        bh=i5gkfhBnIMrzvhHOoZ2F2H3K1hIYR9G5ZodLMKdollY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jZxZV1cezY/j5IR/khYpTAnmyuc2WwPddArZNXzEuNDeERY0VkwPkgEyH7Z5PfUPb
         Jr3nXX5n8fEVkY1nOGR3o9WtI4f6EXEAeSwpWFK9HyTaSzIHAlFt4V3TApuiCVdor3
         +at2245wi+Yf9vUTnGu/94YI9W4KbMCu3oiIZiWU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH 5.3 069/193] x86/dumpstack/64: Dont evaluate exception stacks before setup
Date:   Mon, 11 Nov 2019 19:27:31 +0100
Message-Id: <20191111181506.198102010@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit e361362b08cab1098b64b0e5fd8c879f086b3f46 upstream.

Cyrill reported the following crash:

  BUG: unable to handle page fault for address: 0000000000001ff0
  #PF: supervisor read access in kernel mode
  RIP: 0010:get_stack_info+0xb3/0x148

It turns out that if the stack tracer is invoked before the exception stack
mappings are initialized in_exception_stack() can erroneously classify an
invalid address as an address inside of an exception stack:

    begin = this_cpu_read(cea_exception_stacks);  <- 0
    end = begin + sizeof(exception stacks);

i.e. any address between 0 and end will be considered as exception stack
address and the subsequent code will then try to derefence the resulting
stack frame at a non mapped address.

 end = begin + (unsigned long)ep->size;
     ==> end = 0x2000

 regs = (struct pt_regs *)end - 1;
     ==> regs = 0x2000 - sizeof(struct pt_regs *) = 0x1ff0

 info->next_sp   = (unsigned long *)regs->sp;
     ==> Crashes due to accessing 0x1ff0

Prevent this by checking the validity of the cea_exception_stack base
address and bailing out if it is zero.

Fixes: afcd21dad88b ("x86/dumpstack/64: Use cpu_entry_area instead of orig_ist")
Reported-by: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Cyrill Gorcunov <gorcunov@gmail.com>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/alpine.DEB.2.21.1910231950590.1852@nanos.tec.linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/dumpstack_64.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -94,6 +94,13 @@ static bool in_exception_stack(unsigned
 	BUILD_BUG_ON(N_EXCEPTION_STACKS != 6);
 
 	begin = (unsigned long)__this_cpu_read(cea_exception_stacks);
+	/*
+	 * Handle the case where stack trace is collected _before_
+	 * cea_exception_stacks had been initialized.
+	 */
+	if (!begin)
+		return false;
+
 	end = begin + sizeof(struct cea_exception_stacks);
 	/* Bail if @stack is outside the exception stack area. */
 	if (stk < begin || stk >= end)


