Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79B3D28F59
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 05:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387560AbfEXDBA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 23:01:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387408AbfEXDBA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 23:01:00 -0400
Received: from localhost.localdomain (c-73-223-200-170.hsd1.ca.comcast.net [73.223.200.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D204E2177E;
        Fri, 24 May 2019 03:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558666859;
        bh=CfmXMmkfaezAvwsN9zlEs/DSNdAtIguy5Elf/Wz2cIk=;
        h=Date:From:To:Subject:From;
        b=sE18acCm0uWyOrfS4M13p+bBGhSoylB5t2YQWD7spZILdmaTIK+lpJuY7xcx6UQL3
         bgCQamoHtYur2NgmXtfjxRAFM+kV9Q/GntbLYz+41k8tCuW0gTgmIe/7qmww8qEjGV
         FxC1flhyMI63ajcYCaPTbFsu+F/f7H7MDhJ32oUY=
Date:   Thu, 23 May 2019 20:00:58 -0700
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, christian@brauner.io, colona@arista.com,
        deepa.kernel@gmail.com, ebiederm@xmission.com,
        gregkh@linuxfoundation.org, mm-commits@vger.kernel.org,
        oleg@redhat.com, stable@vger.kernel.org, tglx@linutronix.de,
        weizhenliang@huawei.com
Subject:  +
 signal-trace_signal_deliver-when-signal_group_exit.patch added to -mm tree
Message-ID: <20190524030058.hmdBvXpsG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: kernel/signal.c: trace_signal_deliver when signal_group_exit
has been added to the -mm tree.  Its filename is
     signal-trace_signal_deliver-when-signal_group_exit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/signal-trace_signal_deliver-when-signal_group_exit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/signal-trace_signal_deliver-when-signal_group_exit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhenliang Wei <weizhenliang@huawei.com>
Subject: kernel/signal.c: trace_signal_deliver when signal_group_exit

In the fixes commit, removing SIGKILL from each thread signal mask and
executing "goto fatal" directly will skip the call to
"trace_signal_deliver".  At this point, the delivery tracking of the
SIGKILL signal will be inaccurate.

Therefore, we need to add trace_signal_deliver before "goto fatal" after
executing sigdelset.

Note: SEND_SIG_NOINFO matches the fact that SIGKILL doesn't have any info.

Link: http://lkml.kernel.org/r/20190425025812.91424-1-weizhenliang@huawei.com
Fixes: cf43a757fd4944 ("signal: Restore the stop PTRACE_EVENT_EXIT")
Signed-off-by: Zhenliang Wei <weizhenliang@huawei.com>
Reviewed-by: Christian Brauner <christian@brauner.io>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Ivan Delalande <colona@arista.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/signal.c~signal-trace_signal_deliver-when-signal_group_exit
+++ a/kernel/signal.c
@@ -2485,6 +2485,8 @@ relock:
 	if (signal_group_exit(signal)) {
 		ksig->info.si_signo = signr = SIGKILL;
 		sigdelset(&current->pending.signal, SIGKILL);
+		trace_signal_deliver(SIGKILL, SEND_SIG_NOINFO,
+				&sighand->action[SIGKILL - 1]);
 		recalc_sigpending();
 		goto fatal;
 	}
_

Patches currently in -mm which might be from weizhenliang@huawei.com are

signal-trace_signal_deliver-when-signal_group_exit.patch

