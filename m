Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 765DB5219F3
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241611AbiEJNwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244227AbiEJNtm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:49:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409D073562;
        Tue, 10 May 2022 06:37:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53991618A6;
        Tue, 10 May 2022 13:37:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7CDC385C2;
        Tue, 10 May 2022 13:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189833;
        bh=qeRM6FQzBbEvCNb4O/cYvgcYLA+zC9ijzGkyG9hloSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WM6l59SqV6Aess7Y/5XN8UiokLKWCAEE9QHxrlEpf7KdBcLR9WNfj2aZbVmaiTDoT
         alI7gl+dhXcNR9YYSLt9zb+ZoIYH4FRbURMl9GjpmnKdqfbTIYs6IfEBMnOrvW78lG
         DV2bvFmsy5xUikE1S59x/yyHgvsxNrsRNI9Uu42M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>,
        John David Anglin <dave.anglin@bell.net>
Subject: [PATCH 5.17 006/140] Revert "parisc: Mark sched_clock unstable only if clocks are not syncronized"
Date:   Tue, 10 May 2022 15:06:36 +0200
Message-Id: <20220510130741.788784661@linuxfoundation.org>
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

commit 7962c0896429af2a0e00ec6bc15d992536453b2d upstream.

This reverts commit d97180ad68bdb7ee10f327205a649bc2f558741d.

It triggers RCU stalls at boot with a 32-bit kernel.

Signed-off-by: Helge Deller <deller@gmx.de>
Noticed-by: John David Anglin <dave.anglin@bell.net>
Cc: stable@vger.kernel.org # v5.15+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/setup.c |    2 ++
 arch/parisc/kernel/time.c  |    7 ++++---
 2 files changed, 6 insertions(+), 3 deletions(-)

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
--- a/arch/parisc/kernel/time.c
+++ b/arch/parisc/kernel/time.c
@@ -265,9 +265,6 @@ static int __init init_cr16_clocksource(
 			    (cpu0_loc == per_cpu(cpu_data, cpu).cpu_loc))
 				continue;
 
-			/* mark sched_clock unstable */
-			clear_sched_clock_stable();
-
 			clocksource_cr16.name = "cr16_unstable";
 			clocksource_cr16.flags = CLOCK_SOURCE_UNSTABLE;
 			clocksource_cr16.rating = 0;
@@ -275,6 +272,10 @@ static int __init init_cr16_clocksource(
 		}
 	}
 
+	/* XXX: We may want to mark sched_clock stable here if cr16 clocks are
+	 *	in sync:
+	 *	(clocksource_cr16.flags == CLOCK_SOURCE_IS_CONTINUOUS) */
+
 	/* register at clocksource framework */
 	clocksource_register_hz(&clocksource_cr16,
 		100 * PAGE0->mem_10msec);


