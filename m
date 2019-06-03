Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6401033946
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 21:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbfFCTuK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 15:50:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:56694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726033AbfFCTuK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 15:50:10 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4D18268AE;
        Mon,  3 Jun 2019 19:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559591410;
        bh=7fuc0z+9VgPldy/PovZcYLSde13GkHbwK+Fcx5rwtIo=;
        h=Date:From:To:Subject:From;
        b=o++zYuDqVgmdxYkIfstoiida5QoK7kVfzVlnpozjz4iKvKVvMRdjX0xccghaAVKch
         BL6VXC8j4R0TzuSa4PUJsQkl2CYlkysfl5EiFd7eg6EuTR/tyAUHRU6Sm4Ewgj2EuO
         L5xKmHGDmP9Bq74JZXtCeyB7jL2CoRxxQjB3+p7k=
Date:   Mon, 03 Jun 2019 12:50:09 -0700
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, christian@brauner.io, colona@arista.com,
        deepa.kernel@gmail.com, ebiederm@xmission.com,
        gregkh@linuxfoundation.org, mm-commits@vger.kernel.org,
        oleg@redhat.com, stable@vger.kernel.org, tglx@linutronix.de,
        weizhenliang@huawei.com
Subject:  [merged]
 signal-trace_signal_deliver-when-signal_group_exit.patch removed from -mm
 tree
Message-ID: <20190603195009.OMPzmpH6Q%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: kernel/signal.c: trace_signal_deliver when signal_group_exit
has been removed from the -mm tree.  Its filename was
     signal-trace_signal_deliver-when-signal_group_exit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


