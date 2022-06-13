Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7DC548BDD
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346128AbiFMKj4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347001AbiFMKiY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:38:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5334713E8E;
        Mon, 13 Jun 2022 03:23:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1D3EB80E94;
        Mon, 13 Jun 2022 10:23:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC12C3411F;
        Mon, 13 Jun 2022 10:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655115781;
        bh=OQghg15WTTKbgLw8BNWy3ibXEyUcYovgtnMJ4FXHuMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AxrePapDjA34uqOUTAIBFboj01aFfzojnDxPot5MIhy3TSIgBVBsV1GT8qsGylp7C
         Ix3NJJnbrWr0sRCp4WSze1XLtWrNPQ7idOTBGSC0fdR+ViYTZYKq1UJKpGGBwB7lVi
         1/THyI6AukLvgPVb8AKCWcywTyl/VBYVqSO7N5iE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>, Jonas Bonn <jonas@southpole.se>,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
        Stafford Horne <shorne@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 028/218] openrisc: start CPU timer early in boot
Date:   Mon, 13 Jun 2022 12:08:06 +0200
Message-Id: <20220613094914.913605022@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094908.257446132@linuxfoundation.org>
References: <20220613094908.257446132@linuxfoundation.org>
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

From: Jason A. Donenfeld <Jason@zx2c4.com>

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
index 9935cad1b9b9..34d015bf0462 100644
--- a/arch/openrisc/include/asm/timex.h
+++ b/arch/openrisc/include/asm/timex.h
@@ -27,6 +27,7 @@ static inline cycles_t get_cycles(void)
 {
 	return mfspr(SPR_TTCR);
 }
+#define get_cycles get_cycles
 
 /* This isn't really used any more */
 #define CLOCK_TICK_RATE 1000
diff --git a/arch/openrisc/kernel/head.S b/arch/openrisc/kernel/head.S
index 4d878d13b860..3f1e9d168710 100644
--- a/arch/openrisc/kernel/head.S
+++ b/arch/openrisc/kernel/head.S
@@ -459,6 +459,15 @@ _start:
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



