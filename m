Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4A3F6E62EA
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbjDRMgg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231723AbjDRMgf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:36:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AC3912C81
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:36:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC02363298
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:36:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E31A7C4339B;
        Tue, 18 Apr 2023 12:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821393;
        bh=r0IEHCvOYJxVpanua8ayvCsQ+JLlHt4Qa5L2B+2OM88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KrRjEQtTUgitzWighE22tHA+xkZ79Pa2fOhZMQwPjme6AMcektHHZFZecb5X9y5fR
         +vrreYulUENENd5/7nBZT8jhsiYGEjbBbjk0gkxZEh29Cyd/ILIHyWt3rilEzKYfq5
         qTh21Rn+VYdSsnYI7CO4j0rZeKkisb+7xfwPvYy8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Matija Glavinic Pecotic <matija.glavinic-pecotic.ext@nokia.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 109/124] x86/rtc: Remove __init for runtime functions
Date:   Tue, 18 Apr 2023 14:22:08 +0200
Message-Id: <20230418120313.758889686@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>
References: <20230418120309.539243408@linuxfoundation.org>
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

From: Matija Glavinic Pecotic <matija.glavinic-pecotic.ext@nokia.com>

[ Upstream commit 775d3c514c5b2763a50ab7839026d7561795924d ]

set_rtc_noop(), get_rtc_noop() are after booting, therefore their __init
annotation is wrong.

A crash was observed on an x86 platform where CMOS RTC is unused and
disabled via device tree. set_rtc_noop() was invoked from ntp:
sync_hw_clock(), although CONFIG_RTC_SYSTOHC=n, however sync_cmos_clock()
doesn't honour that.

  Workqueue: events_power_efficient sync_hw_clock
  RIP: 0010:set_rtc_noop
  Call Trace:
   update_persistent_clock64
   sync_hw_clock

Fix this by dropping the __init annotation from set/get_rtc_noop().

Fixes: c311ed6183f4 ("x86/init: Allow DT configured systems to disable RTC at boot time")
Signed-off-by: Matija Glavinic Pecotic <matija.glavinic-pecotic.ext@nokia.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/59f7ceb1-446b-1d3d-0bc8-1f0ee94b1e18@nokia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/x86_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index a3038d8deb6a4..b758eeea6090b 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -32,8 +32,8 @@ static int __init iommu_init_noop(void) { return 0; }
 static void iommu_shutdown_noop(void) { }
 bool __init bool_x86_init_noop(void) { return false; }
 void x86_op_int_noop(int cpu) { }
-static __init int set_rtc_noop(const struct timespec64 *now) { return -EINVAL; }
-static __init void get_rtc_noop(struct timespec64 *now) { }
+static int set_rtc_noop(const struct timespec64 *now) { return -EINVAL; }
+static void get_rtc_noop(struct timespec64 *now) { }
 
 static __initconst const struct of_device_id of_cmos_match[] = {
 	{ .compatible = "motorola,mc146818" },
-- 
2.39.2



