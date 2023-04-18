Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 793746E621E
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbjDRMaV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbjDRMaT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:30:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B42DC5596
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:29:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94A6D631DD
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:29:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9DA2C433EF;
        Tue, 18 Apr 2023 12:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681820993;
        bh=2wA44kDtgI9IRu4YzCwgCu50ewXF20yfzD+KbsOE260=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u29W9uoCwjLiM/MJVL4lXgJGc50OJvQqO7wq8zU0u00AC6HkHBJv9Kt1XJGdswZOn
         zM1hydybe8BcJMYmTDZ7hnzgnh31WGBYuVHAfofr5UcCh61An+FSJ90gfN1DQNGQXZ
         /rNwMBMKFkS7ZfR1RxqXmgG+HkZ1Wo5xEx2egKwU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Min Li <lm0963hack@gmail.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.4 51/92] Bluetooth: Fix race condition in hidp_session_thread
Date:   Tue, 18 Apr 2023 14:21:26 +0200
Message-Id: <20230418120306.641145622@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
References: <20230418120304.658273364@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Min Li <lm0963hack@gmail.com>

commit c95930abd687fcd1aa040dc4fe90dff947916460 upstream.

There is a potential race condition in hidp_session_thread that may
lead to use-after-free. For instance, the timer is active while
hidp_del_timer is called in hidp_session_thread(). After hidp_session_put,
then 'session' will be freed, causing kernel panic when hidp_idle_timeout
is running.

The solution is to use del_timer_sync instead of del_timer.

Here is the call trace:

? hidp_session_probe+0x780/0x780
call_timer_fn+0x2d/0x1e0
__run_timers.part.0+0x569/0x940
hidp_session_probe+0x780/0x780
call_timer_fn+0x1e0/0x1e0
ktime_get+0x5c/0xf0
lapic_next_deadline+0x2c/0x40
clockevents_program_event+0x205/0x320
run_timer_softirq+0xa9/0x1b0
__do_softirq+0x1b9/0x641
__irq_exit_rcu+0xdc/0x190
irq_exit_rcu+0xe/0x20
sysvec_apic_timer_interrupt+0xa1/0xc0

Cc: stable@vger.kernel.org
Signed-off-by: Min Li <lm0963hack@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hidp/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -433,7 +433,7 @@ static void hidp_set_timer(struct hidp_s
 static void hidp_del_timer(struct hidp_session *session)
 {
 	if (session->idle_to > 0)
-		del_timer(&session->timer);
+		del_timer_sync(&session->timer);
 }
 
 static void hidp_process_report(struct hidp_session *session, int type,


