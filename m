Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E190319C1
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 07:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbfFAFay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 01:30:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:46206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725899AbfFAFay (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 01:30:54 -0400
Received: from localhost.localdomain (c-73-223-200-170.hsd1.ca.comcast.net [73.223.200.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D6D527137;
        Sat,  1 Jun 2019 05:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559367053;
        bh=76kYUWZhqyEefAxrOOgh8eQRlXLEO6Mvwg1D+u3WwSc=;
        h=Date:From:To:Subject:From;
        b=VfGzxyws+SPAKAeRz3Gfov3CoqVabuII/xT0+7bxDZAHM5XdaxQzOKuzXeClfivWb
         CxMWPIRhA9jS5JQKIk9zFklVayQrUdQ1OkGuqloq4s70nbpCt1A4xWBbJgDYQlLywN
         tpxwNdo8iMqMTjpZfzcbh7Tu+nupE2jq0KpO4dyU=
Date:   Fri, 31 May 2019 22:30:52 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, arnd@arndb.de, christian@brauner.io,
        colona@arista.com, deepa.kernel@gmail.com, ebiederm@xmission.com,
        gregkh@linuxfoundation.org, mm-commits@vger.kernel.org,
        oleg@redhat.com, stable@vger.kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, weizhenliang@huawei.com
Subject:  [patch 18/21] kernel/signal.c: trace_signal_deliver when
 signal_group_exit
Message-ID: <20190601053052.Qd2CzaUGy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
