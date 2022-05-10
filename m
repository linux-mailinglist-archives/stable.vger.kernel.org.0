Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7F455219E8
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237374AbiEJNw3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344022AbiEJNss (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:48:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 693986FD2A;
        Tue, 10 May 2022 06:37:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A70A618B4;
        Tue, 10 May 2022 13:37:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB09C385A6;
        Tue, 10 May 2022 13:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189830;
        bh=SXyEZMAQcqYISW4MVCLhRpD3aV940h5MdKUH9HHsXWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=loteEV+xKbTA1wwmtna2Cb/Sk9isJi97sZTl143tzLDVFJpPH+pGoGPmJdIZq/ndh
         HN+afcPOGOFFRJ2LsF9JAHu/DwxO61WxjarHVbN3jhM7lAXvC3bJKT0drKxUXp9qPu
         yMzDLzQwC3MgWOSBQ1VgavPTBfFG3WEdX9dz/MXw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>,
        John David Anglin <dave.anglin@bell.net>
Subject: [PATCH 5.17 005/140] Revert "parisc: Mark cr16 CPU clocksource unstable on all SMP machines"
Date:   Tue, 10 May 2022 15:06:35 +0200
Message-Id: <20220510130741.760254485@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit 9dc4241bb14afecd16518a0760bceb3d7359b12a upstream.

This reverts commit afdb4a5b1d340e4afffc65daa21cc71890d7d589.

It triggers RCU stalls at boot with a 32-bit kernel.

Signed-off-by: Helge Deller <deller@gmx.de>
Noticed-by: John David Anglin <dave.anglin@bell.net>
Cc: stable@vger.kernel.org # v5.16+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/time.c |   28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

--- a/arch/parisc/kernel/time.c
+++ b/arch/parisc/kernel/time.c
@@ -249,16 +249,30 @@ void __init time_init(void)
 static int __init init_cr16_clocksource(void)
 {
 	/*
-	 * The cr16 interval timers are not syncronized across CPUs, even if
-	 * they share the same socket.
+	 * The cr16 interval timers are not syncronized across CPUs on
+	 * different sockets, so mark them unstable and lower rating on
+	 * multi-socket SMP systems.
 	 */
 	if (num_online_cpus() > 1 && !running_on_qemu) {
-		/* mark sched_clock unstable */
-		clear_sched_clock_stable();
+		int cpu;
+		unsigned long cpu0_loc;
+		cpu0_loc = per_cpu(cpu_data, 0).cpu_loc;
 
-		clocksource_cr16.name = "cr16_unstable";
-		clocksource_cr16.flags = CLOCK_SOURCE_UNSTABLE;
-		clocksource_cr16.rating = 0;
+		for_each_online_cpu(cpu) {
+			if (cpu == 0)
+				continue;
+			if ((cpu0_loc != 0) &&
+			    (cpu0_loc == per_cpu(cpu_data, cpu).cpu_loc))
+				continue;
+
+			/* mark sched_clock unstable */
+			clear_sched_clock_stable();
+
+			clocksource_cr16.name = "cr16_unstable";
+			clocksource_cr16.flags = CLOCK_SOURCE_UNSTABLE;
+			clocksource_cr16.rating = 0;
+			break;
+		}
 	}
 
 	/* register at clocksource framework */


