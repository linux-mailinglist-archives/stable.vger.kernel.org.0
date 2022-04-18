Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD175053A1
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240663AbiDRNAo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242473AbiDRM77 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:59:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01E2431227;
        Mon, 18 Apr 2022 05:41:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83D4161239;
        Mon, 18 Apr 2022 12:41:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F19C385A7;
        Mon, 18 Apr 2022 12:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285681;
        bh=9Mi13LQ3ueDfouVHxT/drIOtDkIQ87aRTzNV+mSmQwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vm6Xr/Cmet6I1pNX8GRoKIZXTDHsXDdbNyzqkLmHx/5c9BDmi2WDxdjVbOv6mGoYR
         pqqKVpG54NsIo2RvmgmEpyAo/v8RBpWp7Uog90wJSxieNLwj1RJxdfodLkEW4ke75P
         e2t9F1RZ7BVqhOpEnlmvcbqwihPWwIHPcijezvns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.10 089/105] tick/nohz: Use WARN_ON_ONCE() to prevent console saturation
Date:   Mon, 18 Apr 2022 14:13:31 +0200
Message-Id: <20220418121149.161626115@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121145.140991388@linuxfoundation.org>
References: <20220418121145.140991388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Paul Gortmaker <paul.gortmaker@windriver.com>

commit 40e97e42961f8c6cc7bd5fe67cc18417e02d78f1 upstream.

While running some testing on code that happened to allow the variable
tick_nohz_full_running to get set but with no "possible" NOHZ cores to
back up that setting, this warning triggered:

        if (unlikely(tick_do_timer_cpu == TICK_DO_TIMER_NONE))
                WARN_ON(tick_nohz_full_running);

The console was overwhemled with an endless stream of one WARN per tick
per core and there was no way to even see what was going on w/o using a
serial console to capture it and then trace it back to this.

Change it to WARN_ON_ONCE().

Fixes: 08ae95f4fd3b ("nohz_full: Allow the boot CPU to be nohz_full")
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20211206145950.10927-3-paul.gortmaker@windriver.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/tick-sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -136,7 +136,7 @@ static void tick_sched_do_timer(struct t
 	 */
 	if (unlikely(tick_do_timer_cpu == TICK_DO_TIMER_NONE)) {
 #ifdef CONFIG_NO_HZ_FULL
-		WARN_ON(tick_nohz_full_running);
+		WARN_ON_ONCE(tick_nohz_full_running);
 #endif
 		tick_do_timer_cpu = cpu;
 	}


