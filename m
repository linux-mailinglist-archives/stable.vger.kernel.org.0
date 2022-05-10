Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BEED521ADC
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 16:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242823AbiEJOEl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 10:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244927AbiEJOD3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 10:03:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A452E07E4;
        Tue, 10 May 2022 06:40:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6FA961937;
        Tue, 10 May 2022 13:40:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9778BC385C2;
        Tue, 10 May 2022 13:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652190028;
        bh=oDuFlmJCIctp+Ayd40Ehucb9lIVEg0UZrSC3qoPaDp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rw66WgzMPx+WZW0nv7RFrJvbAbV9HwZlqvCapcf9UzSoIOy3zCaEaFisVg1Foxmlt
         W5JfpHYMcuWdauf6BsUCh30OVW2GPqyYepkaWzWek/nNYVSjrjV5Stk3i03XjMFLK2
         k4G/RRLFZlcc4GPKVNQzsPUeWwhHaeZCS41iIEPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 5.17 105/140] parisc: Mark cr16 clock unstable on all SMP machines
Date:   Tue, 10 May 2022 15:08:15 +0200
Message-Id: <20220510130744.607483464@linuxfoundation.org>
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

commit 340233dcc0160aafcce46ca893d1679f16acf409 upstream.

The cr16 interval timers are not synchronized across CPUs, even with just
one dual-core CPU. This becomes visible if the machines have a longer
uptime.

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/time.c |   27 ++++-----------------------
 1 file changed, 4 insertions(+), 23 deletions(-)

--- a/arch/parisc/kernel/time.c
+++ b/arch/parisc/kernel/time.c
@@ -249,33 +249,14 @@ void __init time_init(void)
 static int __init init_cr16_clocksource(void)
 {
 	/*
-	 * The cr16 interval timers are not syncronized across CPUs on
-	 * different sockets, so mark them unstable and lower rating on
-	 * multi-socket SMP systems.
+	 * The cr16 interval timers are not synchronized across CPUs.
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
 
-	/* XXX: We may want to mark sched_clock stable here if cr16 clocks are
-	 *	in sync:
-	 *	(clocksource_cr16.flags == CLOCK_SOURCE_IS_CONTINUOUS) */
-
 	/* register at clocksource framework */
 	clocksource_register_hz(&clocksource_cr16,
 		100 * PAGE0->mem_10msec);


