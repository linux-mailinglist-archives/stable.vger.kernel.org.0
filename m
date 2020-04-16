Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60ADE1ABDB9
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 12:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441518AbgDPKQR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 06:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2441482AbgDPKPo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Apr 2020 06:15:44 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD73C061A0C;
        Thu, 16 Apr 2020 03:15:43 -0700 (PDT)
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1jP1Ya-00046E-CQ; Thu, 16 Apr 2020 12:15:40 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id A873C1C001F;
        Thu, 16 Apr 2020 12:15:39 +0200 (CEST)
Date:   Thu, 16 Apr 2020 10:15:39 -0000
From:   "tip-bot2 for Andrei Vagin" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: timers/urgent] proc, time/namespace: Show clock symbolic names
 in /proc/pid/timens_offsets
Cc:     Michael Kerrisk <mtk.manpages@gmail.com>,
        Andrei Vagin <avagin@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200411154031.642557-1-avagin@gmail.com>
References: <20200411154031.642557-1-avagin@gmail.com>
MIME-Version: 1.0
Message-ID: <158703213918.28353.5534603422697683760.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the timers/urgent branch of tip:

Commit-ID:     94d440d618467806009c8edc70b094d64e12ee5a
Gitweb:        https://git.kernel.org/tip/94d440d618467806009c8edc70b094d64e12ee5a
Author:        Andrei Vagin <avagin@gmail.com>
AuthorDate:    Sat, 11 Apr 2020 08:40:31 -07:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Thu, 16 Apr 2020 12:10:54 +02:00

proc, time/namespace: Show clock symbolic names in /proc/pid/timens_offsets

Michael Kerrisk suggested to replace numeric clock IDs with symbolic names.

Now the content of these files looks like this:
$ cat /proc/774/timens_offsets
monotonic      864000         0
boottime      1728000         0

For setting offsets, both representations of clocks (numeric and symbolic)
can be used.

As for compatibility, it is acceptable to change things as long as
userspace doesn't care. The format of timens_offsets files is very new and
there are no userspace tools yet which rely on this format.

But three projects crun, util-linux and criu rely on the interface of
setting time offsets and this is why it's required to continue supporting
the numeric clock IDs on write.

Fixes: 04a8682a71be ("fs/proc: Introduce /proc/pid/timens_offsets")
Suggested-by: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrei Vagin <avagin@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Michael Kerrisk <mtk.manpages@gmail.com>
Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20200411154031.642557-1-avagin@gmail.com
---
 fs/proc/base.c          | 14 +++++++++++++-
 kernel/time/namespace.c | 15 ++++++++++++++-
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 6042b64..572898d 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1573,6 +1573,7 @@ static ssize_t timens_offsets_write(struct file *file, const char __user *buf,
 	noffsets = 0;
 	for (pos = kbuf; pos; pos = next_line) {
 		struct proc_timens_offset *off = &offsets[noffsets];
+		char clock[10];
 		int err;
 
 		/* Find the end of line and ensure we don't look past it */
@@ -1584,10 +1585,21 @@ static ssize_t timens_offsets_write(struct file *file, const char __user *buf,
 				next_line = NULL;
 		}
 
-		err = sscanf(pos, "%u %lld %lu", &off->clockid,
+		err = sscanf(pos, "%9s %lld %lu", clock,
 				&off->val.tv_sec, &off->val.tv_nsec);
 		if (err != 3 || off->val.tv_nsec >= NSEC_PER_SEC)
 			goto out;
+
+		clock[sizeof(clock) - 1] = 0;
+		if (strcmp(clock, "monotonic") == 0 ||
+		    strcmp(clock, __stringify(CLOCK_MONOTONIC)) == 0)
+			off->clockid = CLOCK_MONOTONIC;
+		else if (strcmp(clock, "boottime") == 0 ||
+			 strcmp(clock, __stringify(CLOCK_BOOTTIME)) == 0)
+			off->clockid = CLOCK_BOOTTIME;
+		else
+			goto out;
+
 		noffsets++;
 		if (noffsets == ARRAY_SIZE(offsets)) {
 			if (next_line)
diff --git a/kernel/time/namespace.c b/kernel/time/namespace.c
index 3b30288..53bce34 100644
--- a/kernel/time/namespace.c
+++ b/kernel/time/namespace.c
@@ -338,7 +338,20 @@ static struct user_namespace *timens_owner(struct ns_common *ns)
 
 static void show_offset(struct seq_file *m, int clockid, struct timespec64 *ts)
 {
-	seq_printf(m, "%d %lld %ld\n", clockid, ts->tv_sec, ts->tv_nsec);
+	char *clock;
+
+	switch (clockid) {
+	case CLOCK_BOOTTIME:
+		clock = "boottime";
+		break;
+	case CLOCK_MONOTONIC:
+		clock = "monotonic";
+		break;
+	default:
+		clock = "unknown";
+		break;
+	}
+	seq_printf(m, "%-10s %10lld %9ld\n", clock, ts->tv_sec, ts->tv_nsec);
 }
 
 void proc_timens_show_offsets(struct task_struct *p, struct seq_file *m)
