Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 117161FE67F
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387718AbgFRCeB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:34:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:44274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728278AbgFRBOf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:14:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B230221D7E;
        Thu, 18 Jun 2020 01:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442874;
        bh=IgxoX0dS7tQSm492V5SCVu1eGtYviV5OFE6vUo6NCXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LszBUIfvimymPLQXwwylFVUcDTKosxudXH54mAbhkfHvPzTgyc69iinRO/gIYhsQO
         FGE7U6m5HfhFxUD4b8tBuacK+UBcmM3JRHlTpPKmoVlxJLWpEzh/KzIgxFF8n4ReyU
         p2ccx/D6lG3SV6IqMvdL4mZYSKnnnEuIe+IE2bL8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 300/388] ARM: davinci: fix build failure without I2C
Date:   Wed, 17 Jun 2020 21:06:37 -0400
Message-Id: <20200618010805.600873-300-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 147922f91965e734664374a3f226adfeaa586d72 ]

The two supplies are referenced outside of #ifdef CONFIG_I2C but
defined inside, which breaks the build if that is not built-in:

mach-davinci/board-dm644x-evm.c:861:21: error: use of undeclared identifier 'fixed_supplies_1_8v'
                                     ARRAY_SIZE(fixed_supplies_1_8v), 1800000);
                                                ^
mach-davinci/board-dm644x-evm.c:861:21: error: use of undeclared identifier 'fixed_supplies_1_8v'
mach-davinci/board-dm644x-evm.c:861:21: error: use of undeclared identifier 'fixed_supplies_1_8v'
mach-davinci/board-dm644x-evm.c:860:49: error: use of undeclared identifier 'fixed_supplies_1_8v'
        regulator_register_always_on(0, "fixed-dummy", fixed_supplies_1_8v,

I don't know if the regulators are used anywhere without I2C, but
always registering them seems to be the safe choice here.

On a related note, it might be best to also deal with CONFIG_I2C=m
across the file, unless this is going to be moved to DT and removed
really soon anyway.

Link: https://lore.kernel.org/r/20200527133746.643895-1-arnd@arndb.de
Fixes: 5e06d19694a4 ("ARM: davinci: dm644x-evm: Add Fixed regulators needed for tlv320aic33")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-davinci/board-dm644x-evm.c | 26 ++++++++++++------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davinci/board-dm644x-evm.c
index 3461d12bbfc0..a5d3708fedf6 100644
--- a/arch/arm/mach-davinci/board-dm644x-evm.c
+++ b/arch/arm/mach-davinci/board-dm644x-evm.c
@@ -655,19 +655,6 @@ static struct i2c_board_info __initdata i2c_info[] =  {
 	},
 };
 
-/* Fixed regulator support */
-static struct regulator_consumer_supply fixed_supplies_3_3v[] = {
-	/* Baseboard 3.3V: 5V -> TPS54310PWP -> 3.3V */
-	REGULATOR_SUPPLY("AVDD", "1-001b"),
-	REGULATOR_SUPPLY("DRVDD", "1-001b"),
-};
-
-static struct regulator_consumer_supply fixed_supplies_1_8v[] = {
-	/* Baseboard 1.8V: 5V -> TPS54310PWP -> 1.8V */
-	REGULATOR_SUPPLY("IOVDD", "1-001b"),
-	REGULATOR_SUPPLY("DVDD", "1-001b"),
-};
-
 #define DM644X_I2C_SDA_PIN	GPIO_TO_PIN(2, 12)
 #define DM644X_I2C_SCL_PIN	GPIO_TO_PIN(2, 11)
 
@@ -700,6 +687,19 @@ static void __init evm_init_i2c(void)
 }
 #endif
 
+/* Fixed regulator support */
+static struct regulator_consumer_supply fixed_supplies_3_3v[] = {
+	/* Baseboard 3.3V: 5V -> TPS54310PWP -> 3.3V */
+	REGULATOR_SUPPLY("AVDD", "1-001b"),
+	REGULATOR_SUPPLY("DRVDD", "1-001b"),
+};
+
+static struct regulator_consumer_supply fixed_supplies_1_8v[] = {
+	/* Baseboard 1.8V: 5V -> TPS54310PWP -> 1.8V */
+	REGULATOR_SUPPLY("IOVDD", "1-001b"),
+	REGULATOR_SUPPLY("DVDD", "1-001b"),
+};
+
 #define VENC_STD_ALL	(V4L2_STD_NTSC | V4L2_STD_PAL)
 
 /* venc standard timings */
-- 
2.25.1

