Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9EB5053D6
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240861AbiDRNCE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242574AbiDRNAK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:00:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3891D2612A;
        Mon, 18 Apr 2022 05:41:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C811560FB6;
        Mon, 18 Apr 2022 12:41:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D458AC385A1;
        Mon, 18 Apr 2022 12:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285698;
        bh=+bJHROMegmTVcDWC4ZKfPap8cszGveXnm0W1xWIE8ko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bIs2yQXUL950qWWOD6vFsCwuWgJSS572j/OVpjHNknOS3StKy3MfjRt0Faj56HVo8
         mj0vQ6E0J+DUdDex9CLxw48ou9oGgs9KN1JCwm78JWnl/5bq1ztshNZC+n3WAosJGl
         xZWTGqW3EYxQ8iSKukisSkHwo0rjrnjo+g3HWD38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
        Anna-Maria Behnsen <anna-maria@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <frederic@kernel.org>
Subject: [PATCH 5.10 094/105] timers: Fix warning condition in __run_timers()
Date:   Mon, 18 Apr 2022 14:13:36 +0200
Message-Id: <20220418121149.304352708@linuxfoundation.org>
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

From: Anna-Maria Behnsen <anna-maria@linutronix.de>

commit c54bc0fc84214b203f7a0ebfd1bd308ce2abe920 upstream.

When the timer base is empty, base::next_expiry is set to base::clk +
NEXT_TIMER_MAX_DELTA and base::next_expiry_recalc is false. When no timer
is queued until jiffies reaches base::next_expiry value, the warning for
not finding any expired timer and base::next_expiry_recalc is false in
__run_timers() triggers.

To prevent triggering the warning in this valid scenario
base::timers_pending needs to be added to the warning condition.

Fixes: 31cd0e119d50 ("timers: Recalculate next timer interrupt only when necessary")
Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Anna-Maria Behnsen <anna-maria@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Link: https://lore.kernel.org/r/20220405191732.7438-3-anna-maria@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/timer.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -1738,11 +1738,14 @@ static inline void __run_timers(struct t
 	       time_after_eq(jiffies, base->next_expiry)) {
 		levels = collect_expired_timers(base, heads);
 		/*
-		 * The only possible reason for not finding any expired
-		 * timer at this clk is that all matching timers have been
-		 * dequeued.
+		 * The two possible reasons for not finding any expired
+		 * timer at this clk are that all matching timers have been
+		 * dequeued or no timer has been queued since
+		 * base::next_expiry was set to base::clk +
+		 * NEXT_TIMER_MAX_DELTA.
 		 */
-		WARN_ON_ONCE(!levels && !base->next_expiry_recalc);
+		WARN_ON_ONCE(!levels && !base->next_expiry_recalc
+			     && base->timers_pending);
 		base->clk++;
 		base->next_expiry = __next_timer_interrupt(base);
 


