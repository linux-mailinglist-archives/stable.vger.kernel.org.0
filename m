Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B29C1A0C25
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 12:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbgDGKmE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 06:42:04 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:47030 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgDGKmE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 06:42:04 -0400
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1jLlg8-0004LQ-Vs; Tue, 07 Apr 2020 12:42:01 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 93F871C0481;
        Tue,  7 Apr 2020 12:42:00 +0200 (CEST)
Date:   Tue, 07 Apr 2020 10:42:00 -0000
From:   "tip-bot2 for Michael Kerrisk (man-pages)" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: timers/urgent] time/namespace: Fix time_for_children symlink
Cc:     Michael Kerrisk <mtk.manpages@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dmitry Safonov <dima@arista.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Andrei Vagin <avagin@gmail.com>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <a2418c48-ed80-3afe-116e-6611cb799557@gmail.com>
References: <a2418c48-ed80-3afe-116e-6611cb799557@gmail.com>
MIME-Version: 1.0
Message-ID: <158625612023.28353.17886180270911841813.tip-bot2@tip-bot2>
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

Commit-ID:     b801f1e22c23c259d6a2c955efddd20370de19a6
Gitweb:        https://git.kernel.org/tip/b801f1e22c23c259d6a2c955efddd20370de19a6
Author:        Michael Kerrisk (man-pages) <mtk.manpages@gmail.com>
AuthorDate:    Fri, 03 Apr 2020 14:11:39 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 07 Apr 2020 12:37:21 +02:00

time/namespace: Fix time_for_children symlink

Looking at the contents of the /proc/PID/ns/time_for_children symlink shows
an anomaly:

$ ls -l /proc/self/ns/* |awk '{print $9, $10, $11}'
...
/proc/self/ns/pid -> pid:[4026531836]
/proc/self/ns/pid_for_children -> pid:[4026531836]
/proc/self/ns/time -> time:[4026531834]
/proc/self/ns/time_for_children -> time_for_children:[4026531834]
/proc/self/ns/user -> user:[4026531837]
...

The reference for 'time_for_children' should be a 'time' namespace, just as
the reference for 'pid_for_children' is a 'pid' namespace.  In other words,
the above time_for_children link should read:

/proc/self/ns/time_for_children -> time:[4026531834]

Fixes: 769071ac9f20 ("ns: Introduce Time Namespace")
Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Dmitry Safonov <dima@arista.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Acked-by: Andrei Vagin <avagin@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/a2418c48-ed80-3afe-116e-6611cb799557@gmail.com
---
 kernel/time/namespace.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/time/namespace.c b/kernel/time/namespace.c
index e6ba064..3b30288 100644
--- a/kernel/time/namespace.c
+++ b/kernel/time/namespace.c
@@ -447,6 +447,7 @@ const struct proc_ns_operations timens_operations = {
 
 const struct proc_ns_operations timens_for_children_operations = {
 	.name		= "time_for_children",
+	.real_ns_name	= "time",
 	.type		= CLONE_NEWTIME,
 	.get		= timens_for_children_get,
 	.put		= timens_put,
