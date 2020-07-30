Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9CF2232E2D
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729573AbgG3IIW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:08:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:46498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729163AbgG3IIR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:08:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98E702074B;
        Thu, 30 Jul 2020 08:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096497;
        bh=NNlEVXo3UQ7qWHdlC8wROzn6n5lKu8TzbE3HTYTb5so=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rwub0oFdAv5xwfk1CNpVyYO3NQINCkE7IDNC9cFvVyetdSOPSfZ01+149XnY0EJzD
         tKhtVi+al7NgFtZtom5QMLr6m8tE0hFdaXrp4Ck06FxkuDMDl/DgSX7b5QBOO/fIYm
         q9wwn5VWoTggR4UH/dwEPJNgJ1d+KcoGeLvQTQLo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaron Merey <amerey@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: [PATCH 4.9 10/61] uprobes: Change handle_swbp() to send SIGTRAP with si_code=SI_KERNEL, to fix GDB regression
Date:   Thu, 30 Jul 2020 10:04:28 +0200
Message-Id: <20200730074421.323102663@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200730074420.811058810@linuxfoundation.org>
References: <20200730074420.811058810@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

commit fe5ed7ab99c656bd2f5b79b49df0e9ebf2cead8a upstream.

If a tracee is uprobed and it hits int3 inserted by debugger, handle_swbp()
does send_sig(SIGTRAP, current, 0) which means si_code == SI_USER. This used
to work when this code was written, but then GDB started to validate si_code
and now it simply can't use breakpoints if the tracee has an active uprobe:

	# cat test.c
	void unused_func(void)
	{
	}
	int main(void)
	{
		return 0;
	}

	# gcc -g test.c -o test
	# perf probe -x ./test -a unused_func
	# perf record -e probe_test:unused_func gdb ./test -ex run
	GNU gdb (GDB) 10.0.50.20200714-git
	...
	Program received signal SIGTRAP, Trace/breakpoint trap.
	0x00007ffff7ddf909 in dl_main () from /lib64/ld-linux-x86-64.so.2
	(gdb)

The tracee hits the internal breakpoint inserted by GDB to monitor shared
library events but GDB misinterprets this SIGTRAP and reports a signal.

Change handle_swbp() to use force_sig(SIGTRAP), this matches do_int3_user()
and fixes the problem.

This is the minimal fix for -stable, arch/x86/kernel/uprobes.c is equally
wrong; it should use send_sigtrap(TRAP_TRACE) instead of send_sig(SIGTRAP),
but this doesn't confuse GDB and needs another x86-specific patch.

Reported-by: Aaron Merey <amerey@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200723154420.GA32043@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/events/uprobes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1885,7 +1885,7 @@ static void handle_swbp(struct pt_regs *
 	if (!uprobe) {
 		if (is_swbp > 0) {
 			/* No matching uprobe; signal SIGTRAP. */
-			send_sig(SIGTRAP, current, 0);
+			force_sig(SIGTRAP, current);
 		} else {
 			/*
 			 * Either we raced with uprobe_unregister() or we can't


