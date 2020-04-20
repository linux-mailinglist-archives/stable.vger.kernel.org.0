Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDDA51B0A21
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728672AbgDTMpL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:45:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:39422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728638AbgDTMpJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:45:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 875E120747;
        Mon, 20 Apr 2020 12:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386709;
        bh=3U4MOA2zSjanbkoh2i0PBmMVJ0JOxoR9ZqVWiBu1pGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g2y2J8XF4e9oJjMtKXGfcQqvmdY34H4aIAufKZ+48guUrCGpJNuyzelnTy72mjCuV
         +p0BYm6luH1c25+xEqlQr5BtZ1CWeENisiB86pFk/+JMCp2er5qvxOHHrSDpxlZMIv
         H70bMEjYCM4BEfU+zYYi/Kopuszo90PF6nHYIz8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>,
        Andrei Vagin <avagin@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>
Subject: [PATCH 5.6 67/71] proc, time/namespace: Show clock symbolic names in /proc/pid/timens_offsets
Date:   Mon, 20 Apr 2020 14:39:21 +0200
Message-Id: <20200420121522.296713087@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121508.491252919@linuxfoundation.org>
References: <20200420121508.491252919@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrei Vagin <avagin@gmail.com>

commit 94d440d618467806009c8edc70b094d64e12ee5a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/proc/base.c          |   14 +++++++++++++-
 kernel/time/namespace.c |   15 ++++++++++++++-
 2 files changed, 27 insertions(+), 2 deletions(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1573,6 +1573,7 @@ static ssize_t timens_offsets_write(stru
 	noffsets = 0;
 	for (pos = kbuf; pos; pos = next_line) {
 		struct proc_timens_offset *off = &offsets[noffsets];
+		char clock[10];
 		int err;
 
 		/* Find the end of line and ensure we don't look past it */
@@ -1584,10 +1585,21 @@ static ssize_t timens_offsets_write(stru
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
--- a/kernel/time/namespace.c
+++ b/kernel/time/namespace.c
@@ -337,7 +337,20 @@ static struct user_namespace *timens_own
 
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


