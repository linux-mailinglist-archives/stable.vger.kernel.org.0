Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98B48548709
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349063AbiFMK4s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350665AbiFMKzD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:55:03 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB4C24BCE;
        Mon, 13 Jun 2022 03:31:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4D642CE110D;
        Mon, 13 Jun 2022 10:31:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E2D3C34114;
        Mon, 13 Jun 2022 10:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116306;
        bh=3auhrHrzlTGiTtumf+6fB985sdZVoAfk/Jd9psB6YF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z3k+Ds0Av1/7ii7Q7SYCMNmZF9/GVDDz7KYpqwK8NpPqzfI/hdfINLk8waeGakURT
         Tl9Phan5pUAi26bNjoa4J0ZB6HOdDehcd7Zy5kai1fpwZX8tC4VvCc0vXbcunMEX9w
         5Kt19bDiT4EbvfgeVRNoamJfUNL6ise6JJ04i1no=
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
Subject: [PATCH 5.4 052/411] openrisc: start CPU timer early in boot
Date:   Mon, 13 Jun 2022 12:05:25 +0200
Message-Id: <20220613094930.071174717@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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
index b0dc974f9a74..ffbbf639b7f9 100644
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



