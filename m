Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA063EED0E
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388313AbfKDWC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:02:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:33130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389416AbfKDWCy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:02:54 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2ACCC205C9;
        Mon,  4 Nov 2019 22:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904973;
        bh=WUYtsEowu6tUKxR++J7FijFndFCjk6G0o2q2sXvWxvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qp2yz9aMcYn2IoImbPC1u8pEwqNLCwi9Tscdo/7O/CyKxSr22uy/U9RELyu9lHR7I
         VLUvqO8Kvzek6c1iy1ASQ66GEsJPb6UIPpkFm4nUyFoGKwIUBnvC+07OIqsZ+QwSj1
         0z5CS3d5WWgMlg7/S/f/KmLB5ZD5VDDzioDM8kew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 4.19 128/149] s390/idle: fix cpu idle time calculation
Date:   Mon,  4 Nov 2019 22:45:21 +0100
Message-Id: <20191104212145.431494357@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 3d7efa4edd07be5c5c3ffa95ba63e97e070e1f3f upstream.

The idle time reported in /proc/stat sometimes incorrectly contains
huge values on s390. This is caused by a bug in arch_cpu_idle_time().

The kernel tries to figure out when a different cpu entered idle by
accessing its per-cpu data structure. There is an ordering problem: if
the remote cpu has an idle_enter value which is not zero, and an
idle_exit value which is zero, it is assumed it is idle since
"now". The "now" timestamp however is taken before the idle_enter
value is read.

Which in turn means that "now" can be smaller than idle_enter of the
remote cpu. Unconditionally subtracting idle_enter from "now" can thus
lead to a negative value (aka large unsigned value).

Fix this by moving the get_tod_clock() invocation out of the
loop. While at it also make the code a bit more readable.

A similar bug also exists for show_idle_time(). Fix this is as well.

Cc: <stable@vger.kernel.org>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kernel/idle.c |   29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

--- a/arch/s390/kernel/idle.c
+++ b/arch/s390/kernel/idle.c
@@ -69,18 +69,26 @@ DEVICE_ATTR(idle_count, 0444, show_idle_
 static ssize_t show_idle_time(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
+	unsigned long long now, idle_time, idle_enter, idle_exit, in_idle;
 	struct s390_idle_data *idle = &per_cpu(s390_idle, dev->id);
-	unsigned long long now, idle_time, idle_enter, idle_exit;
 	unsigned int seq;
 
 	do {
-		now = get_tod_clock();
 		seq = read_seqcount_begin(&idle->seqcount);
 		idle_time = READ_ONCE(idle->idle_time);
 		idle_enter = READ_ONCE(idle->clock_idle_enter);
 		idle_exit = READ_ONCE(idle->clock_idle_exit);
 	} while (read_seqcount_retry(&idle->seqcount, seq));
-	idle_time += idle_enter ? ((idle_exit ? : now) - idle_enter) : 0;
+	in_idle = 0;
+	now = get_tod_clock();
+	if (idle_enter) {
+		if (idle_exit) {
+			in_idle = idle_exit - idle_enter;
+		} else if (now > idle_enter) {
+			in_idle = now - idle_enter;
+		}
+	}
+	idle_time += in_idle;
 	return sprintf(buf, "%llu\n", idle_time >> 12);
 }
 DEVICE_ATTR(idle_time_us, 0444, show_idle_time, NULL);
@@ -88,17 +96,24 @@ DEVICE_ATTR(idle_time_us, 0444, show_idl
 u64 arch_cpu_idle_time(int cpu)
 {
 	struct s390_idle_data *idle = &per_cpu(s390_idle, cpu);
-	unsigned long long now, idle_enter, idle_exit;
+	unsigned long long now, idle_enter, idle_exit, in_idle;
 	unsigned int seq;
 
 	do {
-		now = get_tod_clock();
 		seq = read_seqcount_begin(&idle->seqcount);
 		idle_enter = READ_ONCE(idle->clock_idle_enter);
 		idle_exit = READ_ONCE(idle->clock_idle_exit);
 	} while (read_seqcount_retry(&idle->seqcount, seq));
-
-	return cputime_to_nsecs(idle_enter ? ((idle_exit ?: now) - idle_enter) : 0);
+	in_idle = 0;
+	now = get_tod_clock();
+	if (idle_enter) {
+		if (idle_exit) {
+			in_idle = idle_exit - idle_enter;
+		} else if (now > idle_enter) {
+			in_idle = now - idle_enter;
+		}
+	}
+	return cputime_to_nsecs(in_idle);
 }
 
 void arch_cpu_idle_enter(void)


