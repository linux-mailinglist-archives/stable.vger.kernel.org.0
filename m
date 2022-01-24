Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95F249A304
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2364793AbiAXXtF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:49:05 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52320 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1454274AbiAXVcI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:32:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22BAD614E1;
        Mon, 24 Jan 2022 21:32:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FE14C340E4;
        Mon, 24 Jan 2022 21:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059926;
        bh=Qo14H2WFM8vzQOp8leB6E2PM+33J6T1IeUDHX0WOzv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VrClL7tev6a3jX4b64q/McsUpZGnPC1Aei3ZLC/RMTnSmkJ5o6S0rQyYhyPqXiSah
         6pJU3DHwtd0QljLLrNe5VlSNffASFCw0d9n8OhbHjN5QL9Y8NulFEhNQkbIgR7InQN
         IyjJlWOz38GpYg9HZEi1TuksnYZ+ChiVDo4VaDkc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0781/1039] signal: In get_signal test for signal_group_exit every time through the loop
Date:   Mon, 24 Jan 2022 19:42:50 +0100
Message-Id: <20220124184151.539020855@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

[ Upstream commit e7f7c99ba911f56bc338845c1cd72954ba591707 ]

Recently while investigating a problem with rr and signals I noticed
that siglock is dropped in ptrace_signal and get_signal does not jump
to relock.

Looking farther to see if the problem is anywhere else I see that
do_signal_stop also returns if signal_group_exit is true.  I believe
that test can now never be true, but it is a bit hard to trace
through and be certain.

Testing signal_group_exit is not expensive, so move the test for
signal_group_exit into the for loop inside of get_signal to ensure
the test is never skipped improperly.

This has been a potential problem since I added the test for
signal_group_exit was added.

Fixes: 35634ffa1751 ("signal: Always notice exiting tasks")
Reviewed-by: Kees Cook <keescook@chromium.org>
Link: https://lkml.kernel.org/r/875yssekcd.fsf_-_@email.froward.int.ebiederm.org
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/signal.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index dfcee3888b00e..cf97b9c4d665a 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2684,19 +2684,19 @@ relock:
 		goto relock;
 	}
 
-	/* Has this task already been marked for death? */
-	if (signal_group_exit(signal)) {
-		ksig->info.si_signo = signr = SIGKILL;
-		sigdelset(&current->pending.signal, SIGKILL);
-		trace_signal_deliver(SIGKILL, SEND_SIG_NOINFO,
-				&sighand->action[SIGKILL - 1]);
-		recalc_sigpending();
-		goto fatal;
-	}
-
 	for (;;) {
 		struct k_sigaction *ka;
 
+		/* Has this task already been marked for death? */
+		if (signal_group_exit(signal)) {
+			ksig->info.si_signo = signr = SIGKILL;
+			sigdelset(&current->pending.signal, SIGKILL);
+			trace_signal_deliver(SIGKILL, SEND_SIG_NOINFO,
+				&sighand->action[SIGKILL - 1]);
+			recalc_sigpending();
+			goto fatal;
+		}
+
 		if (unlikely(current->jobctl & JOBCTL_STOP_PENDING) &&
 		    do_signal_stop(0))
 			goto relock;
-- 
2.34.1



