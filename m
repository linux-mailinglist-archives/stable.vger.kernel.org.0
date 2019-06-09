Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34F0B3A7C9
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731100AbfFIQxO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:53:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732366AbfFIQxO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:53:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77CE3206BB;
        Sun,  9 Jun 2019 16:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099194;
        bh=+SaQOnpuc3KYK1Uzlk7Tb/UZnbTi3fsoVUAx8VBchwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RcHwUWYIGHLlN4JlcNrOPsuCzJdFTCDH+/mPwdg03mKcffA5G6cKjw7ohdXbDSmbU
         WljSsqwpbKXqG3g0U87bMsUAdfwU/eG0zCDtPF91jVon7aoplncS7+WTxDo7kWAAYW
         B5hFPx0phB22C040U8bRy4BmgFRQ4b+G9NjmXN3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhenliang Wei <weizhenliang@huawei.com>,
        Christian Brauner <christian@brauner.io>,
        Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Ivan Delalande <colona@arista.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 43/83] kernel/signal.c: trace_signal_deliver when signal_group_exit
Date:   Sun,  9 Jun 2019 18:42:13 +0200
Message-Id: <20190609164131.563594039@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.843327870@linuxfoundation.org>
References: <20190609164127.843327870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhenliang Wei <weizhenliang@huawei.com>

commit 98af37d624ed8c83f1953b1b6b2f6866011fc064 upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/signal.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2244,6 +2244,8 @@ relock:
 	if (signal_group_exit(signal)) {
 		ksig->info.si_signo = signr = SIGKILL;
 		sigdelset(&current->pending.signal, SIGKILL);
+		trace_signal_deliver(SIGKILL, SEND_SIG_NOINFO,
+				&sighand->action[SIGKILL - 1]);
 		recalc_sigpending();
 		goto fatal;
 	}


