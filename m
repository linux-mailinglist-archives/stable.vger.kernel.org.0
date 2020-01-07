Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D69C133169
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbgAGVAa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:00:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:35428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727719AbgAGVAa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:00:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D006124656;
        Tue,  7 Jan 2020 21:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430829;
        bh=L8LUNO8Rt6HHwTg4ZRRXBIGs/4zDe6CvPv46PyE6Fag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jyuDapPOnmwUjBbryi0BMjK9r7FT6ETsrOfMfxqpoNlDXggPMnTI8ODqj6oubLdZD
         l5jPNLNYiwYpjekbbk4OX7FZhqqfmki1+SaJONrnfseRdgpzMlQLp+ASZGF2pbMt4V
         ZThiw/0o3H7oZ5ExCYMMoEr0ZFTk+W3O4RsCNsxM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zong Li <zong.li@sifive.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Paul Walmsley <paul.walmsley@sifive.com>
Subject: [PATCH 5.4 112/191] clocksource: riscv: add notrace to riscv_sched_clock
Date:   Tue,  7 Jan 2020 21:53:52 +0100
Message-Id: <20200107205338.978465084@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zong Li <zong.li@sifive.com>

commit 9d05c18e8d7de566ff68f221fcae65e78708dd1d upstream.

When enabling ftrace graph tracer, it gets the tracing clock in
ftrace_push_return_trace().  Eventually, it invokes riscv_sched_clock()
to get the clock value.  If riscv_sched_clock() isn't marked with
'notrace', it will call ftrace_push_return_trace() and cause infinite
loop.

The result of failure as follow:

command: echo function_graph >current_tracer
[   46.176787] Unable to handle kernel paging request at virtual address ffffffe04fb38c48
[   46.177309] Oops [#1]
[   46.177478] Modules linked in:
[   46.177770] CPU: 0 PID: 256 Comm: $d Not tainted 5.5.0-rc1 #47
[   46.177981] epc: ffffffe00035e59a ra : ffffffe00035e57e sp : ffffffe03a7569b0
[   46.178216]  gp : ffffffe000d29b90 tp : ffffffe03a756180 t0 : ffffffe03a756968
[   46.178430]  t1 : ffffffe00087f408 t2 : ffffffe03a7569a0 s0 : ffffffe03a7569f0
[   46.178643]  s1 : ffffffe00087f408 a0 : 0000000ac054cda4 a1 : 000000000087f411
[   46.178856]  a2 : 0000000ac054cda4 a3 : 0000000000373ca0 a4 : ffffffe04fb38c48
[   46.179099]  a5 : 00000000153e22a8 a6 : 00000000005522ff a7 : 0000000000000005
[   46.179338]  s2 : ffffffe03a756a90 s3 : ffffffe00032811c s4 : ffffffe03a756a58
[   46.179570]  s5 : ffffffe000d29fe0 s6 : 0000000000000001 s7 : 0000000000000003
[   46.179809]  s8 : 0000000000000003 s9 : 0000000000000002 s10: 0000000000000004
[   46.180053]  s11: 0000000000000000 t3 : 0000003fc815749c t4 : 00000000000efc90
[   46.180293]  t5 : ffffffe000d29658 t6 : 0000000000040000
[   46.180482] status: 0000000000000100 badaddr: ffffffe04fb38c48 cause: 000000000000000f

Signed-off-by: Zong Li <zong.li@sifive.com>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
[paul.walmsley@sifive.com: cleaned up patch description]
Fixes: 92e0d143fdef ("clocksource/drivers/riscv_timer: Provide the sched_clock")
Cc: stable@vger.kernel.org
Signed-off-by: Paul Walmsley <paul.walmsley@sifive.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clocksource/timer-riscv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clocksource/timer-riscv.c
+++ b/drivers/clocksource/timer-riscv.c
@@ -41,7 +41,7 @@ static unsigned long long riscv_clocksou
 	return get_cycles64();
 }
 
-static u64 riscv_sched_clock(void)
+static u64 notrace riscv_sched_clock(void)
 {
 	return get_cycles64();
 }


