Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8106469F2D
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391483AbhLFPps (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:45:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390608AbhLFPmf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:42:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01505C0698DF;
        Mon,  6 Dec 2021 07:29:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3218B81129;
        Mon,  6 Dec 2021 15:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097C5C34901;
        Mon,  6 Dec 2021 15:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804548;
        bh=TUIZe1yzd7NvaTmTZH5Px/JuVGPfPK5s0zQJwnkQMFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AWQyONiHOw1FQZVhh8N0/oUoiWeGPLdPE2TKcecWUqJ8B4ODq2cKmNVnVl9QRS/My
         GGo/4+XHaWKQCJTZemliI+gzjkCEZBfa25E/eLrjcf0mKBs/4M9wvn9xXNnjnOS3KZ
         ywxTPlOBrfQyVO2pj9jf9Rca1NUsY89muymPADZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 187/207] parisc: Mark cr16 CPU clocksource unstable on all SMP machines
Date:   Mon,  6 Dec 2021 15:57:21 +0100
Message-Id: <20211206145616.751337683@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit afdb4a5b1d340e4afffc65daa21cc71890d7d589 upstream.

In commit c8c3735997a3 ("parisc: Enhance detection of synchronous cr16
clocksources") I assumed that CPUs on the same physical core are syncronous.
While booting up the kernel on two different C8000 machines, one with a
dual-core PA8800 and one with a dual-core PA8900 CPU, this turned out to be
wrong. The symptom was that I saw a jump in the internal clocks printed to the
syslog and strange overall behaviour.  On machines which have 4 cores (2
dual-cores) the problem isn't visible, because the current logic already marked
the cr16 clocksource unstable in this case.

This patch now marks the cr16 interval timers unstable if we have more than one
CPU in the system, and it fixes this issue.

Fixes: c8c3735997a3 ("parisc: Enhance detection of synchronous cr16 clocksources")
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org> # v5.15+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/time.c |   28 +++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

--- a/arch/parisc/kernel/time.c
+++ b/arch/parisc/kernel/time.c
@@ -249,30 +249,16 @@ void __init time_init(void)
 static int __init init_cr16_clocksource(void)
 {
 	/*
-	 * The cr16 interval timers are not syncronized across CPUs on
-	 * different sockets, so mark them unstable and lower rating on
-	 * multi-socket SMP systems.
+	 * The cr16 interval timers are not syncronized across CPUs, even if
+	 * they share the same socket.
 	 */
 	if (num_online_cpus() > 1 && !running_on_qemu) {
-		int cpu;
-		unsigned long cpu0_loc;
-		cpu0_loc = per_cpu(cpu_data, 0).cpu_loc;
+		/* mark sched_clock unstable */
+		clear_sched_clock_stable();
 
-		for_each_online_cpu(cpu) {
-			if (cpu == 0)
-				continue;
-			if ((cpu0_loc != 0) &&
-			    (cpu0_loc == per_cpu(cpu_data, cpu).cpu_loc))
-				continue;
-
-			/* mark sched_clock unstable */
-			clear_sched_clock_stable();
-
-			clocksource_cr16.name = "cr16_unstable";
-			clocksource_cr16.flags = CLOCK_SOURCE_UNSTABLE;
-			clocksource_cr16.rating = 0;
-			break;
-		}
+		clocksource_cr16.name = "cr16_unstable";
+		clocksource_cr16.flags = CLOCK_SOURCE_UNSTABLE;
+		clocksource_cr16.rating = 0;
 	}
 
 	/* register at clocksource framework */


