Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F891548B90
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383646AbiFMO04 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383973AbiFMOYX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:24:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C97AC65D5;
        Mon, 13 Jun 2022 04:46:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66D4061342;
        Mon, 13 Jun 2022 11:46:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76520C34114;
        Mon, 13 Jun 2022 11:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120771;
        bh=EmXXkwtr+OdQj9M0ROu7qd3hWmwk2maZ/xMKVUEiJcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OHuB1uhluJDtom9LczIJc8sAgqmcxVWiXcC1Ea7X3Q4iTAvssvqaK95E1/ywtqprv
         QxEFSBcBtXL22qFD9S0ytHXbrP3D7eo1npEuMnMsM/67fegLVDCtTZq8stTk/QXTVR
         M0OaaWrAYpnNRhhfl3E6mV5Llha1pf/2woVsFPfU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Ungerer <gerg@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 152/298] m68knommu: fix undefined reference to `mach_get_rtc_pll
Date:   Mon, 13 Jun 2022 12:10:46 +0200
Message-Id: <20220613094929.547493133@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
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

From: Greg Ungerer <gerg@linux-m68k.org>

[ Upstream commit 1300eec9e51f23c34c4487d2b06f58ca22e1ad3d ]

Configuring for a nommu classic m68k target and enabling the generic rtc
driver (CONFIG_RTC_DRV_GENERIC) will result in the following compile
error:

   m68k-linux-ld: arch/m68k/kernel/time.o: in function `rtc_ioctl':
   time.c:(.text+0x82): undefined reference to `mach_get_rtc_pll'
   m68k-linux-ld: time.c:(.text+0xbc): undefined reference to `mach_set_rtc_pll'
   m68k-linux-ld: time.c:(.text+0xf4): undefined reference to `mach_set_rtc_pll'

There are no definitions of "mach_set_rtc_pll" and "mach_get_rtc_pll" in the
nommu code paths. Move these definitions and the associated "mach_hwclk",
so that they are around their use case in time.c. This means they will
always be defined on the builds that require them, and not on those that
cannot use them - such as ColdFire (both with and without MMU enabled).

Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Ungerer <gerg@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/kernel/setup_mm.c | 7 -------
 arch/m68k/kernel/setup_no.c | 1 -
 arch/m68k/kernel/time.c     | 9 +++++++++
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/m68k/kernel/setup_mm.c b/arch/m68k/kernel/setup_mm.c
index 49e573b94326..811c7b85db87 100644
--- a/arch/m68k/kernel/setup_mm.c
+++ b/arch/m68k/kernel/setup_mm.c
@@ -87,15 +87,8 @@ void (*mach_sched_init) (void) __initdata = NULL;
 void (*mach_init_IRQ) (void) __initdata = NULL;
 void (*mach_get_model) (char *model);
 void (*mach_get_hardware_list) (struct seq_file *m);
-/* machine dependent timer functions */
-int (*mach_hwclk) (int, struct rtc_time*);
-EXPORT_SYMBOL(mach_hwclk);
 unsigned int (*mach_get_ss)(void);
-int (*mach_get_rtc_pll)(struct rtc_pll_info *);
-int (*mach_set_rtc_pll)(struct rtc_pll_info *);
 EXPORT_SYMBOL(mach_get_ss);
-EXPORT_SYMBOL(mach_get_rtc_pll);
-EXPORT_SYMBOL(mach_set_rtc_pll);
 void (*mach_reset)( void );
 void (*mach_halt)( void );
 void (*mach_power_off)( void );
diff --git a/arch/m68k/kernel/setup_no.c b/arch/m68k/kernel/setup_no.c
index 5e4104f07a44..19eea73d3c17 100644
--- a/arch/m68k/kernel/setup_no.c
+++ b/arch/m68k/kernel/setup_no.c
@@ -50,7 +50,6 @@ char __initdata command_line[COMMAND_LINE_SIZE];
 
 /* machine dependent timer functions */
 void (*mach_sched_init)(void) __initdata = NULL;
-int (*mach_hwclk) (int, struct rtc_time*);
 
 /* machine dependent reboot functions */
 void (*mach_reset)(void);
diff --git a/arch/m68k/kernel/time.c b/arch/m68k/kernel/time.c
index 340ffeea0a9d..a97600b2af50 100644
--- a/arch/m68k/kernel/time.c
+++ b/arch/m68k/kernel/time.c
@@ -63,6 +63,15 @@ void timer_heartbeat(void)
 #endif /* CONFIG_HEARTBEAT */
 
 #ifdef CONFIG_M68KCLASSIC
+/* machine dependent timer functions */
+int (*mach_hwclk) (int, struct rtc_time*);
+EXPORT_SYMBOL(mach_hwclk);
+
+int (*mach_get_rtc_pll)(struct rtc_pll_info *);
+int (*mach_set_rtc_pll)(struct rtc_pll_info *);
+EXPORT_SYMBOL(mach_get_rtc_pll);
+EXPORT_SYMBOL(mach_set_rtc_pll);
+
 #if !IS_BUILTIN(CONFIG_RTC_DRV_GENERIC)
 void read_persistent_clock64(struct timespec64 *ts)
 {
-- 
2.35.1



