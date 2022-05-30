Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 461005381BE
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241101AbiE3OU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241400AbiE3ORe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:17:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D2690CDB;
        Mon, 30 May 2022 06:46:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41C7360EC3;
        Mon, 30 May 2022 13:46:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B9C3C385B8;
        Mon, 30 May 2022 13:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918378;
        bh=LgBYfNEutcs56hBZA16toOrWrUGiF2HDPIjqczeJ3m8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=axZdemZ0kHJ4p/NBZ1DCCMLEza/qZ0QLoHzHLA0fUq0Zw7Arvqf1uoAC4YVFRZ8zg
         JjC0GevHhru/yPeb4xi0AWBHtQ1Tkff3NmdpYnzCsPtXTYHUt7BYm5wv36iw7NFr3R
         /gdZDv35AhIFwo3H3iMlD6PP8KcC7nICeYSID41r4yGVDgUrObGrMWvevGVxKPMhHm
         Mor4cZbzYq+8SOHNlK3QyTvhxId47eWu9YlaBfkD5uLHmPtxT5hAhm67v3tKB+gN3k
         3rdzbzqM6G3CnDWCaN8EE3VmVSACCcK2VnkDjht/9dSyoVv1xoqWKqSIPrXPfiFIBD
         eeIL266f8jjTA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>, Jonas Bonn <jonas@southpole.se>,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
        Stafford Horne <shorne@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, linux@dominikbrodowski.net,
        rdunlap@infradead.org, openrisc@lists.librecores.org
Subject: [PATCH AUTOSEL 5.10 59/76] openrisc: start CPU timer early in boot
Date:   Mon, 30 May 2022 09:43:49 -0400
Message-Id: <20220530134406.1934928-59-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530134406.1934928-1-sashal@kernel.org>
References: <20220530134406.1934928-1-sashal@kernel.org>
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
index af355e3f4619..459b0a1e4eb2 100644
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

