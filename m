Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62BC314C9A8
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 12:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgA2LdG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 06:33:06 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:51053 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgA2LdF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jan 2020 06:33:05 -0500
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1iwlaa-0007kN-Mo; Wed, 29 Jan 2020 12:32:56 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 578D01C1C19;
        Wed, 29 Jan 2020 12:32:56 +0100 (CET)
Date:   Wed, 29 Jan 2020 11:32:56 -0000
From:   "tip-bot2 for Song Liu" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/urgent] perf/core: Fix mlock accounting in perf_mmap()
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Song Liu <songliubraving@fb.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, <stable@vger.kernel.org>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200123181146.2238074-1-songliubraving@fb.com>
References: <20200123181146.2238074-1-songliubraving@fb.com>
MIME-Version: 1.0
Message-ID: <158029757616.396.9494045381575919767.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: 1.5
X-Linutronix-Spam-Level: +
X-Linutronix-Spam-Status: No , 1.5 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_DBL_ABUSE_MALW=2.5
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/urgent branch of tip:

Commit-ID:     003461559ef7a9bd0239bae35a22ad8924d6e9ad
Gitweb:        https://git.kernel.org/tip/003461559ef7a9bd0239bae35a22ad8924d6e9ad
Author:        Song Liu <songliubraving@fb.com>
AuthorDate:    Thu, 23 Jan 2020 10:11:46 -08:00
Committer:     Ingo Molnar <mingo@kernel.org>
CommitterDate: Tue, 28 Jan 2020 21:20:18 +01:00

perf/core: Fix mlock accounting in perf_mmap()

Decreasing sysctl_perf_event_mlock between two consecutive perf_mmap()s of
a perf ring buffer may lead to an integer underflow in locked memory
accounting. This may lead to the undesired behaviors, such as failures in
BPF map creation.

Address this by adjusting the accounting logic to take into account the
possibility that the amount of already locked memory may exceed the
current limit.

Fixes: c4b75479741c ("perf/core: Make the mlock accounting simple again")
Suggested-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: <stable@vger.kernel.org>
Acked-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Link: https://lkml.kernel.org/r/20200123181146.2238074-1-songliubraving@fb.com
---
 kernel/events/core.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 2173c23..2d9aeba 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5916,7 +5916,15 @@ accounting:
 	 */
 	user_lock_limit *= num_online_cpus();
 
-	user_locked = atomic_long_read(&user->locked_vm) + user_extra;
+	user_locked = atomic_long_read(&user->locked_vm);
+
+	/*
+	 * sysctl_perf_event_mlock may have changed, so that
+	 *     user->locked_vm > user_lock_limit
+	 */
+	if (user_locked > user_lock_limit)
+		user_locked = user_lock_limit;
+	user_locked += user_extra;
 
 	if (user_locked > user_lock_limit) {
 		/*
