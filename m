Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9474E635402
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236879AbiKWJBS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:01:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236888AbiKWJBP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:01:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E7BFFABC
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:01:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21098B81EEF
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:01:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81778C433D6;
        Wed, 23 Nov 2022 09:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194071;
        bh=jC5ctidMD+rvvvSf0jBUaX3iTZ9SEWA5HHJqBvOC/V0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EO1KmgoKqy8OdNpVJ4rJjeY324hQ9IAgPzlWjoMhzLZCxSsLvCkXZuAaLyxC8Rgef
         xn6jaKk5tTv2sY3rI9AulyZqRyWOfG3gfq52xRXmK48+27We5jzKAVlCZ/3ABBT+W1
         n4gAT+/u3tv8U3SZleJyUx/Y5gpaBt2RgjA4cupU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable <stable@kernel.org>,
        Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH 4.14 64/88] usb: chipidea: fix deadlock in ci_otg_del_timer
Date:   Wed, 23 Nov 2022 09:51:01 +0100
Message-Id: <20221123084550.820537126@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084548.535439312@linuxfoundation.org>
References: <20221123084548.535439312@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duoming Zhou <duoming@zju.edu.cn>

commit 7a58b8d6021426b796eebfae80983374d9a80a75 upstream.

There is a deadlock in ci_otg_del_timer(), the process is
shown below:

    (thread 1)                  |        (thread 2)
ci_otg_del_timer()              | ci_otg_hrtimer_func()
  ...                           |
  spin_lock_irqsave() //(1)     |  ...
  ...                           |
  hrtimer_cancel()              |  spin_lock_irqsave() //(2)
  (block forever)

We hold ci->lock in position (1) and use hrtimer_cancel() to
wait ci_otg_hrtimer_func() to stop, but ci_otg_hrtimer_func()
also need ci->lock in position (2). As a result, the
hrtimer_cancel() in ci_otg_del_timer() will be blocked forever.

This patch extracts hrtimer_cancel() from the protection of
spin_lock_irqsave() in order that the ci_otg_hrtimer_func()
could obtain the ci->lock.

What`s more, there will be no race happen. Because the
"next_timer" is always under the protection of
spin_lock_irqsave() and we only check whether "next_timer"
equals to NUM_OTG_FSM_TIMERS in the following code.

Fixes: 3a316ec4c91c ("usb: chipidea: use hrtimer for otg fsm timers")
Cc: stable <stable@kernel.org>
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Link: https://lore.kernel.org/r/20220918033312.94348-1-duoming@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/chipidea/otg_fsm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/chipidea/otg_fsm.c
+++ b/drivers/usb/chipidea/otg_fsm.c
@@ -260,8 +260,10 @@ static void ci_otg_del_timer(struct ci_h
 	ci->enabled_otg_timer_bits &= ~(1 << t);
 	if (ci->next_otg_timer == t) {
 		if (ci->enabled_otg_timer_bits == 0) {
+			spin_unlock_irqrestore(&ci->lock, flags);
 			/* No enabled timers after delete it */
 			hrtimer_cancel(&ci->otg_fsm_hrtimer);
+			spin_lock_irqsave(&ci->lock, flags);
 			ci->next_otg_timer = NUM_OTG_FSM_TIMERS;
 		} else {
 			/* Find the next timer */


