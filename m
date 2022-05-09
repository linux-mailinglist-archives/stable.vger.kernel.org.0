Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6B3651F710
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 10:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237649AbiEIIqr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 04:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236049AbiEIIPl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 04:15:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7746C195BD6
        for <stable@vger.kernel.org>; Mon,  9 May 2022 01:11:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7FA4CB80FCD
        for <stable@vger.kernel.org>; Mon,  9 May 2022 08:09:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FBA9C385AB;
        Mon,  9 May 2022 08:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652083775;
        bh=IJabkilTmNvrg86KNswSB45N1QI/QNS68IkQBvXusYo=;
        h=Subject:To:Cc:From:Date:From;
        b=NDXOTLOV7jQjzQbp/PlsuQwgyJgaIhks/OyTirP/z0dHQL8M7c7vYeEh0OLlPL60A
         ZBW7ZGQDgPIqWJOx+kkytnQVN4MIYy3XeB+N9+s5nnMdFoUSwccnTHufND6cqupmGA
         bPcTpK2qILLKpT4PqcgWYxgpJFk6/sdmdGAVfIow=
Subject: FAILED: patch "[PATCH] Revert "parisc: Mark sched_clock unstable only if clocks are" failed to apply to 5.15-stable tree
To:     deller@gmx.de, dave.anglin@bell.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 May 2022 10:09:31 +0200
Message-ID: <16520837712276@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7962c0896429af2a0e00ec6bc15d992536453b2d Mon Sep 17 00:00:00 2001
From: Helge Deller <deller@gmx.de>
Date: Sat, 7 May 2022 15:32:38 +0200
Subject: [PATCH] Revert "parisc: Mark sched_clock unstable only if clocks are
 not syncronized"

This reverts commit d97180ad68bdb7ee10f327205a649bc2f558741d.

It triggers RCU stalls at boot with a 32-bit kernel.

Signed-off-by: Helge Deller <deller@gmx.de>
Noticed-by: John David Anglin <dave.anglin@bell.net>
Cc: stable@vger.kernel.org # v5.15+

diff --git a/arch/parisc/kernel/setup.c b/arch/parisc/kernel/setup.c
index b91cb45ffd4e..f005ddedb50e 100644
--- a/arch/parisc/kernel/setup.c
+++ b/arch/parisc/kernel/setup.c
@@ -161,6 +161,8 @@ void __init setup_arch(char **cmdline_p)
 #ifdef CONFIG_PA11
 	dma_ops_init();
 #endif
+
+	clear_sched_clock_stable();
 }
 
 /*
diff --git a/arch/parisc/kernel/time.c b/arch/parisc/kernel/time.c
index 95ee9e1a364b..19c31a72fe76 100644
--- a/arch/parisc/kernel/time.c
+++ b/arch/parisc/kernel/time.c
@@ -267,9 +267,6 @@ static int __init init_cr16_clocksource(void)
 			    (cpu0_loc == per_cpu(cpu_data, cpu).cpu_loc))
 				continue;
 
-			/* mark sched_clock unstable */
-			clear_sched_clock_stable();
-
 			clocksource_cr16.name = "cr16_unstable";
 			clocksource_cr16.flags = CLOCK_SOURCE_UNSTABLE;
 			clocksource_cr16.rating = 0;
@@ -277,6 +274,10 @@ static int __init init_cr16_clocksource(void)
 		}
 	}
 
+	/* XXX: We may want to mark sched_clock stable here if cr16 clocks are
+	 *	in sync:
+	 *	(clocksource_cr16.flags == CLOCK_SOURCE_IS_CONTINUOUS) */
+
 	/* register at clocksource framework */
 	clocksource_register_hz(&clocksource_cr16,
 		100 * PAGE0->mem_10msec);

