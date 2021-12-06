Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69695469C09
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347295AbhLFPTp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:19:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346512AbhLFPRn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:17:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81472C08ED3E;
        Mon,  6 Dec 2021 07:10:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E8856132C;
        Mon,  6 Dec 2021 15:10:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E0FC341C6;
        Mon,  6 Dec 2021 15:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803454;
        bh=pC166YA6n24amnNkQtGTNNSNnR3GI8K7nn0VAxxRJGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cr1wD3xrEz2mwM3KsxsYvyIfE4xZHxLRA7hH6oRnTqzPXS+3QCtpXui9mhfD3Lecu
         Nz3ho8wBpVvMk5VV5PQG4mAajeza9kIeHar1xS24AT3WpGCmwEJ9NTUfAfACQ46XBG
         c4WoXRpQV2Q0ZmKi08g3Zd4wNTV7rydth6zRS/Ik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 4.19 47/48] parisc: Mark cr16 CPU clocksource unstable on all SMP machines
Date:   Mon,  6 Dec 2021 15:57:04 +0100
Message-Id: <20211206145550.469616314@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145548.859182340@linuxfoundation.org>
References: <20211206145548.859182340@linuxfoundation.org>
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
 arch/parisc/kernel/time.c |   24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)

--- a/arch/parisc/kernel/time.c
+++ b/arch/parisc/kernel/time.c
@@ -245,27 +245,13 @@ void __init time_init(void)
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
-
-		for_each_online_cpu(cpu) {
-			if (cpu == 0)
-				continue;
-			if ((cpu0_loc != 0) &&
-			    (cpu0_loc == per_cpu(cpu_data, cpu).cpu_loc))
-				continue;
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
 
 	/* XXX: We may want to mark sched_clock stable here if cr16 clocks are


