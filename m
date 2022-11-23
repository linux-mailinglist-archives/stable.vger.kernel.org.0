Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17D7A63548F
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237039AbiKWJIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:08:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237153AbiKWJH7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:07:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 580081147C
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:07:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E426B61B4D
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:07:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F046EC433D7;
        Wed, 23 Nov 2022 09:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194473;
        bh=8HKXCGGVFpmxdo+NKF8LQteVHYmNXwRyQa8UNM5udUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OudIGJ2wre7qhbMTiIGEL12H6ASvPyFRet1lGQoGrnJoAP4haXu2hwgbIhueG09ND
         MM7TRHLDkSLRNtgU71sVmGlFiUfuXkJjsMUXalzT8zts67yqTKzzfu45tsOPQ3vxd+
         9P9OCv2RYu21f3UOittSFx8UfruvKhYeWmsxPTb8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable <stable@kernel.org>,
        Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH 4.19 088/114] usb: chipidea: fix deadlock in ci_otg_del_timer
Date:   Wed, 23 Nov 2022 09:51:15 +0100
Message-Id: <20221123084555.350930798@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084551.864610302@linuxfoundation.org>
References: <20221123084551.864610302@linuxfoundation.org>
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
@@ -256,8 +256,10 @@ static void ci_otg_del_timer(struct ci_h
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


