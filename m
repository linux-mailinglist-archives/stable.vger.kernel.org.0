Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1D9850F559
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345517AbiDZIl5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345538AbiDZIkr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:40:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7542155711;
        Tue, 26 Apr 2022 01:32:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 930B9617D2;
        Tue, 26 Apr 2022 08:32:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC62C385A0;
        Tue, 26 Apr 2022 08:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961969;
        bh=xE7E+TojZIIQlgWoWbhVcfx6tcCfv5XifeXacFZ7gA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SS8NzCgqwdrGJ7nmpNZOMFmUQwg7MWt6dITv6ESpqzKfHBhYAu6egoas5lu7m0MSw
         7BoyIp3HuY18MlSbIEZoTzverWIJ6oFPXWswxlK/t9aWb9j9hAmgR9V+mpkae+ruj/
         e4/o/sW2Z4tshoRMeamWFdJdlIpeRwLGAWe0uIXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Hao <haokexin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 28/86] net: stmmac: Use readl_poll_timeout_atomic() in atomic state
Date:   Tue, 26 Apr 2022 10:20:56 +0200
Message-Id: <20220426081742.020829413@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081741.202366502@linuxfoundation.org>
References: <20220426081741.202366502@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Hao <haokexin@gmail.com>

[ Upstream commit 234901de2bc6847eaa0aeb4aba62c31ffb8d3ad6 ]

The init_systime() may be invoked in atomic state. We have observed the
following call trace when running "phc_ctl /dev/ptp0 set" on a Intel
Agilex board.
  BUG: sleeping function called from invalid context at drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c:74
  in_atomic(): 1, irqs_disabled(): 128, non_block: 0, pid: 381, name: phc_ctl
  preempt_count: 1, expected: 0
  RCU nest depth: 0, expected: 0
  Preemption disabled at:
  [<ffff80000892ef78>] stmmac_set_time+0x34/0x8c
  CPU: 2 PID: 381 Comm: phc_ctl Not tainted 5.18.0-rc2-next-20220414-yocto-standard+ #567
  Hardware name: SoCFPGA Agilex SoCDK (DT)
  Call trace:
   dump_backtrace.part.0+0xc4/0xd0
   show_stack+0x24/0x40
   dump_stack_lvl+0x7c/0xa0
   dump_stack+0x18/0x34
   __might_resched+0x154/0x1c0
   __might_sleep+0x58/0x90
   init_systime+0x78/0x120
   stmmac_set_time+0x64/0x8c
   ptp_clock_settime+0x60/0x9c
   pc_clock_settime+0x6c/0xc0
   __arm64_sys_clock_settime+0x88/0xf0
   invoke_syscall+0x5c/0x130
   el0_svc_common.constprop.0+0x4c/0x100
   do_el0_svc+0x7c/0xa0
   el0_svc+0x58/0xcc
   el0t_64_sync_handler+0xa4/0x130
   el0t_64_sync+0x18c/0x190

So we should use readl_poll_timeout_atomic() here instead of
readl_poll_timeout().

Also adjust the delay time to 10us to fix a "__bad_udelay" build error
reported by "kernel test robot <lkp@intel.com>". I have tested this on
Intel Agilex and NXP S32G boards, there is no delay needed at all.
So the 10us delay should be long enough for most cases.

Fixes: ff8ed737860e ("net: stmmac: use readl_poll_timeout() function in init_systime()")
Signed-off-by: Kevin Hao <haokexin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
index 07b1b8374cd2..53efcc9c40e2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
@@ -68,9 +68,9 @@ static int init_systime(void __iomem *ioaddr, u32 sec, u32 nsec)
 	writel(value, ioaddr + PTP_TCR);
 
 	/* wait for present system time initialize to complete */
-	return readl_poll_timeout(ioaddr + PTP_TCR, value,
+	return readl_poll_timeout_atomic(ioaddr + PTP_TCR, value,
 				 !(value & PTP_TCR_TSINIT),
-				 10000, 100000);
+				 10, 100000);
 }
 
 static int config_addend(void __iomem *ioaddr, u32 addend)
-- 
2.35.1



