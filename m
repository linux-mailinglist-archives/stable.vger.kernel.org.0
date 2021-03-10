Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66254333DC5
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233058AbhCJNYu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:24:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:45660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232830AbhCJNYa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:24:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C6BF64FE8;
        Wed, 10 Mar 2021 13:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382670;
        bh=1M1m0uH2q7uBqF/WhqQItDLmoETowGVwj1uW41Switk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lPgymjPpNUvbd47jx3rm+6abqPEzyea0nboXnkM2QCTSuV2dFFyl+KKVzyecJU8gN
         QfOY+Vla24BvMrUexUgYPAerBO1OpYFBH2GFnR9UdfzFXHjNr+p6hy7SwxaHWchSMv
         0pMjy0TSvIose9jr4ilem97YMeq/HUxlyGZDy16g=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 13/49] bus: ti-sysc: Implement GPMC debug quirk to drop platform data
Date:   Wed, 10 Mar 2021 14:23:24 +0100
Message-Id: <20210310132322.383450855@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132321.948258062@linuxfoundation.org>
References: <20210310132321.948258062@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit cfeeea60af2f01c13b94d57a9bb1291e7bc181da ]

We need to enable no-reset-on-init quirk for GPMC if the config
option for CONFIG_OMAP_GPMC_DEBUG is set. Otherwise the GPMC
driver code is unable to show the bootloader configured timings.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c                 | 10 ++++++++++
 include/linux/platform_data/ti-sysc.h |  1 +
 2 files changed, 11 insertions(+)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index 92ecf1a78ec7..45f5530666d3 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -1379,6 +1379,8 @@ static const struct sysc_revision_quirk sysc_revision_quirks[] = {
 		   SYSC_QUIRK_CLKDM_NOAUTO),
 	SYSC_QUIRK("dwc3", 0x488c0000, 0, 0x10, -ENODEV, 0x500a0200, 0xffffffff,
 		   SYSC_QUIRK_CLKDM_NOAUTO),
+	SYSC_QUIRK("gpmc", 0, 0, 0x10, 0x14, 0x00000060, 0xffffffff,
+		   SYSC_QUIRK_GPMC_DEBUG),
 	SYSC_QUIRK("hdmi", 0, 0, 0x10, -ENODEV, 0x50030200, 0xffffffff,
 		   SYSC_QUIRK_OPT_CLKS_NEEDED),
 	SYSC_QUIRK("hdq1w", 0, 0, 0x14, 0x18, 0x00000006, 0xffffffff,
@@ -1814,6 +1816,14 @@ static void sysc_init_module_quirks(struct sysc *ddata)
 		return;
 	}
 
+#ifdef CONFIG_OMAP_GPMC_DEBUG
+	if (ddata->cfg.quirks & SYSC_QUIRK_GPMC_DEBUG) {
+		ddata->cfg.quirks |= SYSC_QUIRK_NO_RESET_ON_INIT;
+
+		return;
+	}
+#endif
+
 	if (ddata->cfg.quirks & SYSC_MODULE_QUIRK_I2C) {
 		ddata->pre_reset_quirk = sysc_pre_reset_quirk_i2c;
 		ddata->post_reset_quirk = sysc_post_reset_quirk_i2c;
diff --git a/include/linux/platform_data/ti-sysc.h b/include/linux/platform_data/ti-sysc.h
index 240dce553a0b..fafc1beea504 100644
--- a/include/linux/platform_data/ti-sysc.h
+++ b/include/linux/platform_data/ti-sysc.h
@@ -50,6 +50,7 @@ struct sysc_regbits {
 	s8 emufree_shift;
 };
 
+#define SYSC_QUIRK_GPMC_DEBUG		BIT(26)
 #define SYSC_MODULE_QUIRK_ENA_RESETDONE	BIT(25)
 #define SYSC_MODULE_QUIRK_PRUSS		BIT(24)
 #define SYSC_MODULE_QUIRK_DSS_RESET	BIT(23)
-- 
2.30.1



