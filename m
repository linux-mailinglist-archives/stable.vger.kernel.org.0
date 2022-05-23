Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED5D53166B
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240413AbiEWRYA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241714AbiEWRWd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:22:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B735F7B9CE;
        Mon, 23 May 2022 10:19:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E2E6B811CC;
        Mon, 23 May 2022 17:17:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C53ACC385A9;
        Mon, 23 May 2022 17:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326278;
        bh=l+dweFhCBdHCnU3oBcjOgofbeTDxRhLUVlx7Mb2HFa0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E6AJTzliV7iniNYW5DDKntKpQzkv9yTWbYWE4yc1Yh2U1UutstgGQDZaNC0XyYX+j
         ODxHxAc8G7wqwC1Ww/ykRqZ7ONFyertnAtRJZTNCAwGLSnNe7V1vOqBZ3g/1Sk22QP
         2V6FLSS0df/McDXOnmrirkeydO2O7amZyPP+o9+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Jean Delvare <jdelvare@suse.de>, Wolfram Sang <wsa@kernel.org>,
        Mario Limonciello <Mario.Limonciello@amd.com>
Subject: [PATCH 5.15 012/132] i2c: piix4: Enable EFCH MMIO for Family 17h+
Date:   Mon, 23 May 2022 19:03:41 +0200
Message-Id: <20220523165825.647117603@linuxfoundation.org>
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

commit 6cf72f41808ab5db1d7718b999b3ff0166e67e45 upstream.

Enable EFCH MMIO using check for SMBus PCI revision ID value 0x51 or
greater. This PCI revision ID check will enable family 17h and future
AMD processors with the same EFCH SMBus controller HW.

Signed-off-by: Terry Bowman <terry.bowman@amd.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Cc: Mario Limonciello <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-piix4.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/drivers/i2c/busses/i2c-piix4.c
+++ b/drivers/i2c/busses/i2c-piix4.c
@@ -229,6 +229,18 @@ static void piix4_sb800_region_release(s
 	release_region(SB800_PIIX4_SMB_IDX, SB800_PIIX4_SMB_MAP_SIZE);
 }
 
+static bool piix4_sb800_use_mmio(struct pci_dev *PIIX4_dev)
+{
+	/*
+	 * cd6h/cd7h port I/O accesses can be disabled on AMD processors
+	 * w/ SMBus PCI revision ID 0x51 or greater. MMIO is supported on
+	 * the same processors and is the recommended access method.
+	 */
+	return (PIIX4_dev->vendor == PCI_VENDOR_ID_AMD &&
+		PIIX4_dev->device == PCI_DEVICE_ID_AMD_KERNCZ_SMBUS &&
+		PIIX4_dev->revision >= 0x51);
+}
+
 static int piix4_setup(struct pci_dev *PIIX4_dev,
 		       const struct pci_device_id *id)
 {
@@ -339,7 +351,7 @@ static int piix4_setup_sb800_smba(struct
 	u8 smba_en_hi;
 	int retval;
 
-	mmio_cfg.use_mmio = 0;
+	mmio_cfg.use_mmio = piix4_sb800_use_mmio(PIIX4_dev);
 	retval = piix4_sb800_region_request(&PIIX4_dev->dev, &mmio_cfg);
 	if (retval)
 		return retval;
@@ -461,7 +473,7 @@ static int piix4_setup_sb800(struct pci_
 			piix4_port_shift_sb800 = SB800_PIIX4_PORT_IDX_SHIFT;
 		}
 	} else {
-		mmio_cfg.use_mmio = 0;
+		mmio_cfg.use_mmio = piix4_sb800_use_mmio(PIIX4_dev);
 		retval = piix4_sb800_region_request(&PIIX4_dev->dev, &mmio_cfg);
 		if (retval) {
 			release_region(piix4_smba, SMBIOSIZE);
@@ -944,6 +956,7 @@ static int piix4_add_adapter(struct pci_
 		return -ENOMEM;
 	}
 
+	adapdata->mmio_cfg.use_mmio = piix4_sb800_use_mmio(dev);
 	adapdata->smba = smba;
 	adapdata->sb800_main = sb800_main;
 	adapdata->port = port << piix4_port_shift_sb800;


