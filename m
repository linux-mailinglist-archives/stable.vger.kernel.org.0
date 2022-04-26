Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F23C650F7CA
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346184AbiDZJHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347348AbiDZJFa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:05:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CDFF11096A;
        Tue, 26 Apr 2022 01:44:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25EF3B81C76;
        Tue, 26 Apr 2022 08:44:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62271C385A4;
        Tue, 26 Apr 2022 08:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962665;
        bh=1OWTHQQH1jcO8sBBchXhD6ZyJQdD/B6PmUizs65gAqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h51o3B+bUFpDVWirLVqsdkGhQuLMCHK9XiG10FIxQo6lmY7dlQdAEEzS64szSc5PM
         tbFzIVPSQOOevkSE5uXXMfib3LifNTMI81bLqLNBYzUwp7oQs5TH78ruXqGH/skDRz
         mUG0j5+t/tNkVflL+P9Xs8bNtifNZX8JztgZFizY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Hao <haokexin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 047/146] net: stmmac: Use readl_poll_timeout_atomic() in atomic state
Date:   Tue, 26 Apr 2022 10:20:42 +0200
Message-Id: <20220426081751.394223497@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
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
index a7ec9f4d46ce..d68ef72dcdde 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
@@ -71,9 +71,9 @@ static int init_systime(void __iomem *ioaddr, u32 sec, u32 nsec)
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



