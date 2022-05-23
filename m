Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB2875318C0
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237053AbiEWRXP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241351AbiEWRWR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:22:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C8678913;
        Mon, 23 May 2022 10:18:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD66460BFA;
        Mon, 23 May 2022 17:17:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B21C385A9;
        Mon, 23 May 2022 17:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326224;
        bh=HYJvCzrRL8mx/moWrVn+AmAVKdhS3rpIkm0q464BD6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hRgl2EwmsIz+3RF3e5rVek9bKHnd1tggcbVJt/cxAH/mCGrMVNMq21Z+dYU24ZM04
         rGBC069wWBezHsO3LQHKSYkG9MDYJFqSN2sCwOAWtmFdaZTkyDvduEjbKDYzFPMkcZ
         LLOKKWDjuqpsXogLU/TEc+uXVXKB30LCw9ALS5kM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Richter <rrichter@amd.com>,
        Terry Bowman <terry.bowman@amd.com>,
        Jean Delvare <jdelvare@suse.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Mario Limonciello <Mario.Limonciello@amd.com>
Subject: [PATCH 5.15 015/132] Watchdog: sp5100_tco: Add initialization using EFCH MMIO
Date:   Mon, 23 May 2022 19:03:44 +0200
Message-Id: <20220523165826.141439925@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
References: <20220523165823.492309987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Terry Bowman <terry.bowman@amd.com>

commit 0578fff4aae5bce3f09875f58e68e9ffbab8daf5 upstream.

cd6h/cd7h port I/O can be disabled on recent AMD hardware. Read
accesses to disabled cd6h/cd7h port I/O will return F's and written
data is dropped. It is recommended to replace the cd6h/cd7h
port I/O with MMIO.

Co-developed-by: Robert Richter <rrichter@amd.com>
Signed-off-by: Robert Richter <rrichter@amd.com>
Signed-off-by: Terry Bowman <terry.bowman@amd.com>
Tested-by: Jean Delvare <jdelvare@suse.de>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20220202153525.1693378-4-terry.bowman@amd.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Cc: Mario Limonciello <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/watchdog/sp5100_tco.c |  100 +++++++++++++++++++++++++++++++++++++++++-
 drivers/watchdog/sp5100_tco.h |    5 ++
 2 files changed, 104 insertions(+), 1 deletion(-)

--- a/drivers/watchdog/sp5100_tco.c
+++ b/drivers/watchdog/sp5100_tco.c
@@ -48,7 +48,7 @@
 /* internal variables */
 
 enum tco_reg_layout {
-	sp5100, sb800, efch
+	sp5100, sb800, efch, efch_mmio
 };
 
 struct sp5100_tco {
@@ -201,6 +201,8 @@ static void tco_timer_enable(struct sp51
 					  ~EFCH_PM_WATCHDOG_DISABLE,
 					  EFCH_PM_DECODEEN_SECOND_RES);
 		break;
+	default:
+		break;
 	}
 }
 
@@ -299,6 +301,99 @@ static int sp5100_tco_timer_init(struct
 	return 0;
 }
 
+static u8 efch_read_pm_reg8(void __iomem *addr, u8 index)
+{
+	return readb(addr + index);
+}
+
+static void efch_update_pm_reg8(void __iomem *addr, u8 index, u8 reset, u8 set)
+{
+	u8 val;
+
+	val = readb(addr + index);
+	val &= reset;
+	val |= set;
+	writeb(val, addr + index);
+}
+
+static void tco_timer_enable_mmio(void __iomem *addr)
+{
+	efch_update_pm_reg8(addr, EFCH_PM_DECODEEN3,
+			    ~EFCH_PM_WATCHDOG_DISABLE,
+			    EFCH_PM_DECODEEN_SECOND_RES);
+}
+
+static int sp5100_tco_setupdevice_mmio(struct device *dev,
+				       struct watchdog_device *wdd)
+{
+	struct sp5100_tco *tco = watchdog_get_drvdata(wdd);
+	const char *dev_name = SB800_DEVNAME;
+	u32 mmio_addr = 0, alt_mmio_addr = 0;
+	struct resource *res;
+	void __iomem *addr;
+	int ret;
+	u32 val;
+
+	res = request_mem_region_muxed(EFCH_PM_ACPI_MMIO_PM_ADDR,
+				       EFCH_PM_ACPI_MMIO_PM_SIZE,
+				       "sp5100_tco");
+
+	if (!res) {
+		dev_err(dev,
+			"Memory region 0x%08x already in use\n",
+			EFCH_PM_ACPI_MMIO_PM_ADDR);
+		return -EBUSY;
+	}
+
+	addr = ioremap(EFCH_PM_ACPI_MMIO_PM_ADDR, EFCH_PM_ACPI_MMIO_PM_SIZE);
+	if (!addr) {
+		dev_err(dev, "Address mapping failed\n");
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/*
+	 * EFCH_PM_DECODEEN_WDT_TMREN is dual purpose. This bitfield
+	 * enables sp5100_tco register MMIO space decoding. The bitfield
+	 * also starts the timer operation. Enable if not already enabled.
+	 */
+	val = efch_read_pm_reg8(addr, EFCH_PM_DECODEEN);
+	if (!(val & EFCH_PM_DECODEEN_WDT_TMREN)) {
+		efch_update_pm_reg8(addr, EFCH_PM_DECODEEN, 0xff,
+				    EFCH_PM_DECODEEN_WDT_TMREN);
+	}
+
+	/* Error if the timer could not be enabled */
+	val = efch_read_pm_reg8(addr, EFCH_PM_DECODEEN);
+	if (!(val & EFCH_PM_DECODEEN_WDT_TMREN)) {
+		dev_err(dev, "Failed to enable the timer\n");
+		ret = -EFAULT;
+		goto out;
+	}
+
+	mmio_addr = EFCH_PM_WDT_ADDR;
+
+	/* Determine alternate MMIO base address */
+	val = efch_read_pm_reg8(addr, EFCH_PM_ISACONTROL);
+	if (val & EFCH_PM_ISACONTROL_MMIOEN)
+		alt_mmio_addr = EFCH_PM_ACPI_MMIO_ADDR +
+			EFCH_PM_ACPI_MMIO_WDT_OFFSET;
+
+	ret = sp5100_tco_prepare_base(tco, mmio_addr, alt_mmio_addr, dev_name);
+	if (!ret) {
+		tco_timer_enable_mmio(addr);
+		ret = sp5100_tco_timer_init(tco);
+	}
+
+out:
+	if (addr)
+		iounmap(addr);
+
+	release_resource(res);
+
+	return ret;
+}
+
 static int sp5100_tco_setupdevice(struct device *dev,
 				  struct watchdog_device *wdd)
 {
@@ -308,6 +403,9 @@ static int sp5100_tco_setupdevice(struct
 	u32 alt_mmio_addr = 0;
 	int ret;
 
+	if (tco->tco_reg_layout == efch_mmio)
+		return sp5100_tco_setupdevice_mmio(dev, wdd);
+
 	/* Request the IO ports used by this driver */
 	if (!request_muxed_region(SP5100_IO_PM_INDEX_REG,
 				  SP5100_PM_IOPORTS_SIZE, "sp5100_tco")) {
--- a/drivers/watchdog/sp5100_tco.h
+++ b/drivers/watchdog/sp5100_tco.h
@@ -83,4 +83,9 @@
 #define EFCH_PM_ISACONTROL_MMIOEN	BIT(1)
 
 #define EFCH_PM_ACPI_MMIO_ADDR		0xfed80000
+#define EFCH_PM_ACPI_MMIO_PM_OFFSET	0x00000300
 #define EFCH_PM_ACPI_MMIO_WDT_OFFSET	0x00000b00
+
+#define EFCH_PM_ACPI_MMIO_PM_ADDR	(EFCH_PM_ACPI_MMIO_ADDR +	\
+					 EFCH_PM_ACPI_MMIO_PM_OFFSET)
+#define EFCH_PM_ACPI_MMIO_PM_SIZE	8


