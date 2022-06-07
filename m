Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2951A540B05
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351876AbiFGSZG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351439AbiFGSQV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:16:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256ED15FE26;
        Tue,  7 Jun 2022 10:49:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E57EC616B6;
        Tue,  7 Jun 2022 17:49:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050A5C3411C;
        Tue,  7 Jun 2022 17:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624170;
        bh=uKzbAHhniBxqNfOLHN7fXBq8UX3CxpbNw564zyvnrWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tpdXCPlm4CQPBSAG/m8P3OL94qDAh2Gt4tECyLBP886+CHT0dJLAIeNRa7PH9STHL
         5cnFMyx0MDPMsK9dd0Ly55b5MWEhZSiAmdwQY1kWtijFE6eiCR+rpbE7eevFCqb8g0
         BC9jKsKHHiJsHn82nOksQJdtt+gAcrVtZzsJDI+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Ogness <john.ogness@linutronix.de>,
        Petr Mladek <pmladek@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 231/667] printk: use atomic updates for klogd work
Date:   Tue,  7 Jun 2022 18:58:16 +0200
Message-Id: <20220607164941.716619893@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Ogness <john.ogness@linutronix.de>

[ Upstream commit 2ba3673d70178bf07fb75ff25c54bc478add4021 ]

The per-cpu @printk_pending variable can be updated from
sleepable contexts, such as:

  get_random_bytes()
    warn_unseeded_randomness()
      printk_deferred()
        defer_console_output()

and can be updated from interrupt contexts, such as:

  handle_irq_event_percpu()
    __irq_wake_thread()
      wake_up_process()
        try_to_wake_up()
          select_task_rq()
            select_fallback_rq()
              printk_deferred()
                defer_console_output()

and can be updated from NMI contexts, such as:

  vprintk()
    if (in_nmi()) defer_console_output()

Therefore the atomic variant of the updating functions must be used.

Replace __this_cpu_xchg() with this_cpu_xchg().
Replace __this_cpu_or() with this_cpu_or().

Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: John Ogness <john.ogness@linutronix.de>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/87iltld4ue.fsf@jogness.linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/printk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 7aeb13542ce7..e6a815a1cd76 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -3215,7 +3215,7 @@ static DEFINE_PER_CPU(int, printk_pending);
 
 static void wake_up_klogd_work_func(struct irq_work *irq_work)
 {
-	int pending = __this_cpu_xchg(printk_pending, 0);
+	int pending = this_cpu_xchg(printk_pending, 0);
 
 	if (pending & PRINTK_PENDING_OUTPUT) {
 		/* If trylock fails, someone else is doing the printing */
@@ -3249,7 +3249,7 @@ void defer_console_output(void)
 		return;
 
 	preempt_disable();
-	__this_cpu_or(printk_pending, PRINTK_PENDING_OUTPUT);
+	this_cpu_or(printk_pending, PRINTK_PENDING_OUTPUT);
 	irq_work_queue(this_cpu_ptr(&wake_up_klogd_work));
 	preempt_enable();
 }
-- 
2.35.1



