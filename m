Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 664EB53A6A9
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 15:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353658AbiFANzO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 09:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353666AbiFANzG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 09:55:06 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 371FD87A26;
        Wed,  1 Jun 2022 06:54:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id ACF52CE1A24;
        Wed,  1 Jun 2022 13:54:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E806C385A5;
        Wed,  1 Jun 2022 13:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091647;
        bh=Gd+81C6t792u/OyBDJ9pfgOthfvlR8CL7NYdML5/hfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KdrigF8R6iiQ5/KDc54k/2cIuHLT32Q6SYMPKrYWurt3bUmeI86DGNspQ87mhFI5Y
         ajQw9dUkRYXUD5/kQBT/P/OziKKhmeqvhtMEcsymiJBgJstrGRhzqMShSjZ/hvlMPG
         pbStRYYNaiEPxGS/m3jj0KOTdqObWQcdJ79GulIij07DqdiEUytf7vASNPg4a3x4U1
         v9ucWwiJIZRIe9/4xz5A0SiHejAb2Het0sbnmtJIPcZIfRDF5JGlvOkInjTVZTN1XN
         nY9fi+hh2ivKxhfmz+o/T/3QAA6wIWOfCdsPWwucY00dPjYSEzJ8HSmJ40GqQHttyD
         /JBR+cb39UDQA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Finn Thain <fthain@linux-m68k.org>,
        kernel test robot <lkp@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, benh@kernel.crashing.org,
        arnd@arndb.de, masahiroy@kernel.org, rafael.j.wysocki@intel.com,
        yebin10@huawei.com, adobriyan@gmail.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.18 42/49] macintosh/via-pmu: Fix build failure when CONFIG_INPUT is disabled
Date:   Wed,  1 Jun 2022 09:52:06 -0400
Message-Id: <20220601135214.2002647-42-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135214.2002647-1-sashal@kernel.org>
References: <20220601135214.2002647-1-sashal@kernel.org>
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

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit 86ce436e30d86327c9f5260f718104ae7b21f506 ]

drivers/macintosh/via-pmu-event.o: In function `via_pmu_event':
via-pmu-event.c:(.text+0x44): undefined reference to `input_event'
via-pmu-event.c:(.text+0x68): undefined reference to `input_event'
via-pmu-event.c:(.text+0x94): undefined reference to `input_event'
via-pmu-event.c:(.text+0xb8): undefined reference to `input_event'
drivers/macintosh/via-pmu-event.o: In function `via_pmu_event_init':
via-pmu-event.c:(.init.text+0x20): undefined reference to `input_allocate_device'
via-pmu-event.c:(.init.text+0xc4): undefined reference to `input_register_device'
via-pmu-event.c:(.init.text+0xd4): undefined reference to `input_free_device'
make[1]: *** [Makefile:1155: vmlinux] Error 1
make: *** [Makefile:350: __build_one_by_one] Error 2

Don't call into the input subsystem unless CONFIG_INPUT is built-in.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/5edbe76ce68227f71e09af4614cc4c1bd61c7ec8.1649326292.git.fthain@linux-m68k.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/macintosh/Kconfig   | 4 ++++
 drivers/macintosh/Makefile  | 3 ++-
 drivers/macintosh/via-pmu.c | 2 +-
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/macintosh/Kconfig b/drivers/macintosh/Kconfig
index 5cdc361da37c..3942db15a2b8 100644
--- a/drivers/macintosh/Kconfig
+++ b/drivers/macintosh/Kconfig
@@ -67,6 +67,10 @@ config ADB_PMU
 	  this device; you should do so if your machine is one of those
 	  mentioned above.
 
+config ADB_PMU_EVENT
+	def_bool y
+	depends on ADB_PMU && INPUT=y
+
 config ADB_PMU_LED
 	bool "Support for the Power/iBook front LED"
 	depends on PPC_PMAC && ADB_PMU
diff --git a/drivers/macintosh/Makefile b/drivers/macintosh/Makefile
index 49819b1b6f20..712edcb3e0b0 100644
--- a/drivers/macintosh/Makefile
+++ b/drivers/macintosh/Makefile
@@ -12,7 +12,8 @@ obj-$(CONFIG_MAC_EMUMOUSEBTN)	+= mac_hid.o
 obj-$(CONFIG_INPUT_ADBHID)	+= adbhid.o
 obj-$(CONFIG_ANSLCD)		+= ans-lcd.o
 
-obj-$(CONFIG_ADB_PMU)		+= via-pmu.o via-pmu-event.o
+obj-$(CONFIG_ADB_PMU)		+= via-pmu.o
+obj-$(CONFIG_ADB_PMU_EVENT)	+= via-pmu-event.o
 obj-$(CONFIG_ADB_PMU_LED)	+= via-pmu-led.o
 obj-$(CONFIG_PMAC_BACKLIGHT)	+= via-pmu-backlight.o
 obj-$(CONFIG_ADB_CUDA)		+= via-cuda.o
diff --git a/drivers/macintosh/via-pmu.c b/drivers/macintosh/via-pmu.c
index 4b98bc26a94b..2109129ea1bb 100644
--- a/drivers/macintosh/via-pmu.c
+++ b/drivers/macintosh/via-pmu.c
@@ -1459,7 +1459,7 @@ pmu_handle_data(unsigned char *data, int len)
 		pmu_pass_intr(data, len);
 		/* len == 6 is probably a bad check. But how do I
 		 * know what PMU versions send what events here? */
-		if (len == 6) {
+		if (IS_ENABLED(CONFIG_ADB_PMU_EVENT) && len == 6) {
 			via_pmu_event(PMU_EVT_POWER, !!(data[1]&8));
 			via_pmu_event(PMU_EVT_LID, data[1]&1);
 		}
-- 
2.35.1

