Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76F23537D3E
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 15:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237325AbiE3NjT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237357AbiE3Ngl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:36:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB1CA8A315;
        Mon, 30 May 2022 06:30:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50D3FB80DAD;
        Mon, 30 May 2022 13:30:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8EE4C3411C;
        Mon, 30 May 2022 13:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917408;
        bh=n+AaXBeWTOxHXF2nYHq4qOyEFHDvsdaw+ZoRXf+hNbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gaaQjzi8WoHxnzlkC8vH9y5aWEHov2Np1OF2ossQWbulKfgvwmAElrlcrsS6JWxLR
         meOzUp7+6ZQ3zph18dwgNCXoshXgwzcDKMRTSXcyQT16efXlYERji5an4CCB48dbKA
         S3gDshFTLkH6UtTy9qVuxgdGHIOhohAm2grIiOUZFL/T7hbgTwtdxCPY8BRLphyjqN
         RWbnvn6TipSHCZOzx1nOKT1dl3hjmoZTUVi5ZUg9ta/fofnXqfxZWJzf/L2YRfzhyx
         Ni7wDUMDFf2x1rAICZL2m4ZbVDvxQcXyg7A27VwkpMeki0RXdlZ432/YdEdYQj5inA
         LGFhx2l1sgIRg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>, Jonas Bonn <jonas@southpole.se>,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
        Stafford Horne <shorne@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, rdunlap@infradead.org,
        linux@dominikbrodowski.net, openrisc@lists.librecores.org
Subject: [PATCH AUTOSEL 5.18 125/159] openrisc: start CPU timer early in boot
Date:   Mon, 30 May 2022 09:23:50 -0400
Message-Id: <20220530132425.1929512-125-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

[ Upstream commit 516dd4aacd67a0f27da94f3fe63fe0f4dbab6e2b ]

In order to measure the boot process, the timer should be switched on as
early in boot as possible. As well, the commit defines the get_cycles
macro, like the previous patches in this series, so that generic code is
aware that it's implemented by the platform, as is done on other archs.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Acked-by: Stafford Horne <shorne@gmail.com>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/openrisc/include/asm/timex.h | 1 +
 arch/openrisc/kernel/head.S       | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/arch/openrisc/include/asm/timex.h b/arch/openrisc/include/asm/timex.h
index d52b4e536e3f..5487fa93dd9b 100644
--- a/arch/openrisc/include/asm/timex.h
+++ b/arch/openrisc/include/asm/timex.h
@@ -23,6 +23,7 @@ static inline cycles_t get_cycles(void)
 {
 	return mfspr(SPR_TTCR);
 }
+#define get_cycles get_cycles
 
 /* This isn't really used any more */
 #define CLOCK_TICK_RATE 1000
diff --git a/arch/openrisc/kernel/head.S b/arch/openrisc/kernel/head.S
index 15f1b38dfe03..871f4c858859 100644
--- a/arch/openrisc/kernel/head.S
+++ b/arch/openrisc/kernel/head.S
@@ -521,6 +521,15 @@ _start:
 	l.ori	r3,r0,0x1
 	l.mtspr	r0,r3,SPR_SR
 
+	/*
+	 * Start the TTCR as early as possible, so that the RNG can make use of
+	 * measurements of boot time from the earliest opportunity. Especially
+	 * important is that the TTCR does not return zero by the time we reach
+	 * rand_initialize().
+	 */
+	l.movhi r3,hi(SPR_TTMR_CR)
+	l.mtspr r0,r3,SPR_TTMR
+
 	CLEAR_GPR(r1)
 	CLEAR_GPR(r2)
 	CLEAR_GPR(r3)
-- 
2.35.1

