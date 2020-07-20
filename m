Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87E592269DC
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730148AbgGTQaU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:30:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:59206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbgGTP6x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:58:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBA04206E9;
        Mon, 20 Jul 2020 15:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260732;
        bh=o1BxW2p/IDTazm0qR0b7SPI7HOaA15A88r2Ua1vEwyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q++7IgCbnPSACwEFgvA7eyBkdrybrO7s7F9BG87QEFz3v9ikUM60WP3JFUZOP4V/f
         TVhyyaUywBFlfZVGkOPOjg4RDD38q4QsGgvQy1TjBnMNMtjumI6qPirNkcdx4oNNrf
         XWvWgkXfuGEkdeivyOe7aCzZGRDZk36ntldM4dfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 076/215] bus: ti-sysc: Handle module unlock quirk needed for some RTC
Date:   Mon, 20 Jul 2020 17:35:58 +0200
Message-Id: <20200720152823.834254962@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit e8639e1c986a8a9d0f94549170f6db579376c3ae ]

The RTC modules on am3 and am4 need quirk handling to unlock and lock
them for reset so let's add the quirk handling based on what we already
have for legacy platform data. In later patches we will simply drop the
RTC related platform data and the old quirk handling.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c                 | 74 ++++++++++++++++++++++++---
 include/linux/platform_data/ti-sysc.h |  1 +
 2 files changed, 69 insertions(+), 6 deletions(-)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index 588dde5a252b6..5c78b5afb85c7 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -75,6 +75,8 @@ static const char * const clock_names[SYSC_MAX_CLOCKS] = {
  * @reset_done_quirk: module specific reset done quirk
  * @module_enable_quirk: module specific enable quirk
  * @module_disable_quirk: module specific disable quirk
+ * @module_unlock_quirk: module specific sysconfig unlock quirk
+ * @module_lock_quirk: module specific sysconfig lock quirk
  */
 struct sysc {
 	struct device *dev;
@@ -102,6 +104,8 @@ struct sysc {
 	void (*reset_done_quirk)(struct sysc *sysc);
 	void (*module_enable_quirk)(struct sysc *sysc);
 	void (*module_disable_quirk)(struct sysc *sysc);
+	void (*module_unlock_quirk)(struct sysc *sysc);
+	void (*module_lock_quirk)(struct sysc *sysc);
 };
 
 static void sysc_parse_dts_quirks(struct sysc *ddata, struct device_node *np,
@@ -863,6 +867,22 @@ static void sysc_show_registers(struct sysc *ddata)
 		buf);
 }
 
+/**
+ * sysc_write_sysconfig - handle sysconfig quirks for register write
+ * @ddata: device driver data
+ * @value: register value
+ */
+static void sysc_write_sysconfig(struct sysc *ddata, u32 value)
+{
+	if (ddata->module_unlock_quirk)
+		ddata->module_unlock_quirk(ddata);
+
+	sysc_write(ddata, ddata->offsets[SYSC_SYSCONFIG], value);
+
+	if (ddata->module_lock_quirk)
+		ddata->module_lock_quirk(ddata);
+}
+
 #define SYSC_IDLE_MASK	(SYSC_NR_IDLEMODES - 1)
 #define SYSC_CLOCACT_ICK	2
 
@@ -912,7 +932,7 @@ static int sysc_enable_module(struct device *dev)
 
 	reg &= ~(SYSC_IDLE_MASK << regbits->sidle_shift);
 	reg |= best_mode << regbits->sidle_shift;
-	sysc_write(ddata, ddata->offsets[SYSC_SYSCONFIG], reg);
+	sysc_write_sysconfig(ddata, reg);
 
 set_midle:
 	/* Set MIDLE mode */
@@ -931,14 +951,14 @@ set_midle:
 
 	reg &= ~(SYSC_IDLE_MASK << regbits->midle_shift);
 	reg |= best_mode << regbits->midle_shift;
-	sysc_write(ddata, ddata->offsets[SYSC_SYSCONFIG], reg);
+	sysc_write_sysconfig(ddata, reg);
 
 set_autoidle:
 	/* Autoidle bit must enabled separately if available */
 	if (regbits->autoidle_shift >= 0 &&
 	    ddata->cfg.sysc_val & BIT(regbits->autoidle_shift)) {
 		reg |= 1 << regbits->autoidle_shift;
-		sysc_write(ddata, ddata->offsets[SYSC_SYSCONFIG], reg);
+		sysc_write_sysconfig(ddata, reg);
 	}
 
 	/* Flush posted write */
@@ -999,7 +1019,7 @@ static int sysc_disable_module(struct device *dev)
 
 	reg &= ~(SYSC_IDLE_MASK << regbits->midle_shift);
 	reg |= best_mode << regbits->midle_shift;
-	sysc_write(ddata, ddata->offsets[SYSC_SYSCONFIG], reg);
+	sysc_write_sysconfig(ddata, reg);
 
 set_sidle:
 	/* Set SIDLE mode */
@@ -1022,7 +1042,7 @@ set_sidle:
 	if (regbits->autoidle_shift >= 0 &&
 	    ddata->cfg.sysc_val & BIT(regbits->autoidle_shift))
 		reg |= 1 << regbits->autoidle_shift;
-	sysc_write(ddata, ddata->offsets[SYSC_SYSCONFIG], reg);
+	sysc_write_sysconfig(ddata, reg);
 
 	/* Flush posted write */
 	sysc_read(ddata, ddata->offsets[SYSC_SYSCONFIG]);
@@ -1281,6 +1301,8 @@ static const struct sysc_revision_quirk sysc_revision_quirks[] = {
 	SYSC_QUIRK("gpu", 0x50000000, 0x14, -ENODEV, -ENODEV, 0x00010201, 0xffffffff, 0),
 	SYSC_QUIRK("gpu", 0x50000000, 0xfe00, 0xfe10, -ENODEV, 0x40000000 , 0xffffffff,
 		   SYSC_MODULE_QUIRK_SGX),
+	SYSC_QUIRK("rtc", 0, 0x74, 0x78, -ENODEV, 0x4eb01908, 0xffff00f0,
+		   SYSC_MODULE_QUIRK_RTC_UNLOCK),
 	SYSC_QUIRK("usb_otg_hs", 0, 0x400, 0x404, 0x408, 0x00000050,
 		   0xffffffff, SYSC_QUIRK_SWSUP_SIDLE | SYSC_QUIRK_SWSUP_MSTANDBY),
 	SYSC_QUIRK("usb_otg_hs", 0, 0, 0x10, -ENODEV, 0x4ea2080d, 0xffffffff,
@@ -1336,7 +1358,6 @@ static const struct sysc_revision_quirk sysc_revision_quirks[] = {
 	SYSC_QUIRK("slimbus", 0, 0, 0x10, -ENODEV, 0x40002903, 0xffffffff, 0),
 	SYSC_QUIRK("spinlock", 0, 0, 0x10, -ENODEV, 0x50020000, 0xffffffff, 0),
 	SYSC_QUIRK("rng", 0, 0x1fe0, 0x1fe4, -ENODEV, 0x00000020, 0xffffffff, 0),
-	SYSC_QUIRK("rtc", 0, 0x74, 0x78, -ENODEV, 0x4eb01908, 0xffff00f0, 0),
 	SYSC_QUIRK("timer32k", 0, 0, 0x4, -ENODEV, 0x00000060, 0xffffffff, 0),
 	SYSC_QUIRK("usbhstll", 0, 0, 0x10, 0x14, 0x00000004, 0xffffffff, 0),
 	SYSC_QUIRK("usbhstll", 0, 0, 0x10, 0x14, 0x00000008, 0xffffffff, 0),
@@ -1458,6 +1479,40 @@ static void sysc_post_reset_quirk_i2c(struct sysc *ddata)
 	sysc_clk_quirk_i2c(ddata, true);
 }
 
+/* RTC on am3 and 4 needs to be unlocked and locked for sysconfig */
+static void sysc_quirk_rtc(struct sysc *ddata, bool lock)
+{
+	u32 val, kick0_val = 0, kick1_val = 0;
+	unsigned long flags;
+	int error;
+
+	if (!lock) {
+		kick0_val = 0x83e70b13;
+		kick1_val = 0x95a4f1e0;
+	}
+
+	local_irq_save(flags);
+	/* RTC_STATUS BUSY bit may stay active for 1/32768 seconds (~30 usec) */
+	error = readl_poll_timeout(ddata->module_va + 0x44, val,
+				   !(val & BIT(0)), 100, 50);
+	if (error)
+		dev_warn(ddata->dev, "rtc busy timeout\n");
+	/* Now we have ~15 microseconds to read/write various registers */
+	sysc_write(ddata, 0x6c, kick0_val);
+	sysc_write(ddata, 0x70, kick1_val);
+	local_irq_restore(flags);
+}
+
+static void sysc_module_unlock_quirk_rtc(struct sysc *ddata)
+{
+	sysc_quirk_rtc(ddata, false);
+}
+
+static void sysc_module_lock_quirk_rtc(struct sysc *ddata)
+{
+	sysc_quirk_rtc(ddata, true);
+}
+
 /* 36xx SGX needs a quirk for to bypass OCP IPG interrupt logic */
 static void sysc_module_enable_quirk_sgx(struct sysc *ddata)
 {
@@ -1512,6 +1567,13 @@ static void sysc_init_module_quirks(struct sysc *ddata)
 	if (ddata->cfg.quirks & SYSC_MODULE_QUIRK_AESS)
 		ddata->module_enable_quirk = sysc_module_enable_quirk_aess;
 
+	if (ddata->cfg.quirks & SYSC_MODULE_QUIRK_RTC_UNLOCK) {
+		ddata->module_unlock_quirk = sysc_module_unlock_quirk_rtc;
+		ddata->module_lock_quirk = sysc_module_lock_quirk_rtc;
+
+		return;
+	}
+
 	if (ddata->cfg.quirks & SYSC_MODULE_QUIRK_SGX)
 		ddata->module_enable_quirk = sysc_module_enable_quirk_sgx;
 
diff --git a/include/linux/platform_data/ti-sysc.h b/include/linux/platform_data/ti-sysc.h
index 2cbde6542849d..5fcc9bc9e7517 100644
--- a/include/linux/platform_data/ti-sysc.h
+++ b/include/linux/platform_data/ti-sysc.h
@@ -49,6 +49,7 @@ struct sysc_regbits {
 	s8 emufree_shift;
 };
 
+#define SYSC_MODULE_QUIRK_RTC_UNLOCK	BIT(22)
 #define SYSC_QUIRK_CLKDM_NOAUTO		BIT(21)
 #define SYSC_QUIRK_FORCE_MSTANDBY	BIT(20)
 #define SYSC_MODULE_QUIRK_AESS		BIT(19)
-- 
2.25.1



