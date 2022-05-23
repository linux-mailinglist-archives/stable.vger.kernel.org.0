Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 095DB531809
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240564AbiEWR23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242725AbiEWR16 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:27:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A4F8B0B3;
        Mon, 23 May 2022 10:24:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16CE560919;
        Mon, 23 May 2022 17:24:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C6ABC385AA;
        Mon, 23 May 2022 17:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326647;
        bh=LIXj9FZokEunEf4C4T6sv1gdibFULl/cAgkv3fPPJPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zzRx/rwBPdWkAGQ1adPkEIuVL4KIlpRpZuPJNrWhhmOWB2hI+uikZBuApVEBtVDQ/
         rxzL2Z1Fn177K5PmZTwm85luI/1eKvBPQ8F0DuL5FZHiR0xLOWeIiFkJEhnKkROMAl
         +huw6KeSFTIgJxDxEO9zbmFm0RvLOhNwUeCp0zGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Jean Delvare <jdelvare@suse.de>, Wolfram Sang <wsa@kernel.org>,
        Mario Limonciello <Mario.Limonciello@amd.com>
Subject: [PATCH 5.17 008/158] i2c: piix4: Add EFCH MMIO support to region request and release
Date:   Mon, 23 May 2022 19:02:45 +0200
Message-Id: <20220523165831.943998905@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
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

commit 7c148722d074c29fb998578eea5de3c14b9608c9 upstream.

EFCH cd6h/cd7h port I/O may no longer be available on later AMD
processors and it is recommended to use MMIO instead. Update the
request and release functions to support MMIO.

MMIO request/release and mmapping require details during cleanup.
Add a MMIO configuration structure containing resource and vaddress
details for mapping the region, accessing the region, and releasing
the region.

Signed-off-by: Terry Bowman <terry.bowman@amd.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
[wsa: rebased after fixup in previous patch]
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Cc: Mario Limonciello <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-piix4.c |   66 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 58 insertions(+), 8 deletions(-)

--- a/drivers/i2c/busses/i2c-piix4.c
+++ b/drivers/i2c/busses/i2c-piix4.c
@@ -98,6 +98,9 @@
 #define SB800_PIIX4_PORT_IDX_MASK_KERNCZ	0x18
 #define SB800_PIIX4_PORT_IDX_SHIFT_KERNCZ	3
 
+#define SB800_PIIX4_FCH_PM_ADDR			0xFED80300
+#define SB800_PIIX4_FCH_PM_SIZE			8
+
 /* insmod parameters */
 
 /* If force is set to anything different from 0, we forcibly enable the
@@ -156,6 +159,12 @@ static const char *piix4_main_port_names
 };
 static const char *piix4_aux_port_name_sb800 = " port 1";
 
+struct sb800_mmio_cfg {
+	void __iomem *addr;
+	struct resource *res;
+	bool use_mmio;
+};
+
 struct i2c_piix4_adapdata {
 	unsigned short smba;
 
@@ -163,10 +172,40 @@ struct i2c_piix4_adapdata {
 	bool sb800_main;
 	bool notify_imc;
 	u8 port;		/* Port number, shifted */
+	struct sb800_mmio_cfg mmio_cfg;
 };
 
-static int piix4_sb800_region_request(struct device *dev)
+static int piix4_sb800_region_request(struct device *dev,
+				      struct sb800_mmio_cfg *mmio_cfg)
 {
+	if (mmio_cfg->use_mmio) {
+		struct resource *res;
+		void __iomem *addr;
+
+		res = request_mem_region_muxed(SB800_PIIX4_FCH_PM_ADDR,
+					       SB800_PIIX4_FCH_PM_SIZE,
+					       "sb800_piix4_smb");
+		if (!res) {
+			dev_err(dev,
+				"SMBus base address memory region 0x%x already in use.\n",
+				SB800_PIIX4_FCH_PM_ADDR);
+			return -EBUSY;
+		}
+
+		addr = ioremap(SB800_PIIX4_FCH_PM_ADDR,
+			       SB800_PIIX4_FCH_PM_SIZE);
+		if (!addr) {
+			release_resource(res);
+			dev_err(dev, "SMBus base address mapping failed.\n");
+			return -ENOMEM;
+		}
+
+		mmio_cfg->res = res;
+		mmio_cfg->addr = addr;
+
+		return 0;
+	}
+
 	if (!request_muxed_region(SB800_PIIX4_SMB_IDX, SB800_PIIX4_SMB_MAP_SIZE,
 				  "sb800_piix4_smb")) {
 		dev_err(dev,
@@ -178,8 +217,15 @@ static int piix4_sb800_region_request(st
 	return 0;
 }
 
-static void piix4_sb800_region_release(struct device *dev)
+static void piix4_sb800_region_release(struct device *dev,
+				       struct sb800_mmio_cfg *mmio_cfg)
 {
+	if (mmio_cfg->use_mmio) {
+		iounmap(mmio_cfg->addr);
+		release_resource(mmio_cfg->res);
+		return;
+	}
+
 	release_region(SB800_PIIX4_SMB_IDX, SB800_PIIX4_SMB_MAP_SIZE);
 }
 
@@ -288,11 +334,13 @@ static int piix4_setup_sb800_smba(struct
 				  u8 *smb_en_status,
 				  unsigned short *piix4_smba)
 {
+	struct sb800_mmio_cfg mmio_cfg;
 	u8 smba_en_lo;
 	u8 smba_en_hi;
 	int retval;
 
-	retval = piix4_sb800_region_request(&PIIX4_dev->dev);
+	mmio_cfg.use_mmio = 0;
+	retval = piix4_sb800_region_request(&PIIX4_dev->dev, &mmio_cfg);
 	if (retval)
 		return retval;
 
@@ -301,7 +349,7 @@ static int piix4_setup_sb800_smba(struct
 	outb_p(smb_en + 1, SB800_PIIX4_SMB_IDX);
 	smba_en_hi = inb_p(SB800_PIIX4_SMB_IDX + 1);
 
-	piix4_sb800_region_release(&PIIX4_dev->dev);
+	piix4_sb800_region_release(&PIIX4_dev->dev, &mmio_cfg);
 
 	if (!smb_en) {
 		*smb_en_status = smba_en_lo & 0x10;
@@ -328,6 +376,7 @@ static int piix4_setup_sb800(struct pci_
 	unsigned short piix4_smba;
 	u8 smb_en, smb_en_status, port_sel;
 	u8 i2ccfg, i2ccfg_offset = 0x10;
+	struct sb800_mmio_cfg mmio_cfg;
 	int retval;
 
 	/* SB800 and later SMBus does not support forcing address */
@@ -407,7 +456,8 @@ static int piix4_setup_sb800(struct pci_
 			piix4_port_shift_sb800 = SB800_PIIX4_PORT_IDX_SHIFT;
 		}
 	} else {
-		retval = piix4_sb800_region_request(&PIIX4_dev->dev);
+		mmio_cfg.use_mmio = 0;
+		retval = piix4_sb800_region_request(&PIIX4_dev->dev, &mmio_cfg);
 		if (retval) {
 			release_region(piix4_smba, SMBIOSIZE);
 			return retval;
@@ -420,7 +470,7 @@ static int piix4_setup_sb800(struct pci_
 				       SB800_PIIX4_PORT_IDX;
 		piix4_port_mask_sb800 = SB800_PIIX4_PORT_IDX_MASK;
 		piix4_port_shift_sb800 = SB800_PIIX4_PORT_IDX_SHIFT;
-		piix4_sb800_region_release(&PIIX4_dev->dev);
+		piix4_sb800_region_release(&PIIX4_dev->dev, &mmio_cfg);
 	}
 
 	dev_info(&PIIX4_dev->dev,
@@ -731,7 +781,7 @@ static s32 piix4_access_sb800(struct i2c
 	u8 prev_port;
 	int retval;
 
-	retval = piix4_sb800_region_request(&adap->dev);
+	retval = piix4_sb800_region_request(&adap->dev, &adapdata->mmio_cfg);
 	if (retval)
 		return retval;
 
@@ -802,7 +852,7 @@ static s32 piix4_access_sb800(struct i2c
 		piix4_imc_wakeup();
 
 release:
-	piix4_sb800_region_release(&adap->dev);
+	piix4_sb800_region_release(&adap->dev, &adapdata->mmio_cfg);
 	return retval;
 }
 


