Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC19531C97
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240839AbiEWRaZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242945AbiEWR2P (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:28:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC13F8BD20;
        Mon, 23 May 2022 10:24:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DCDA60B2C;
        Mon, 23 May 2022 17:24:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C1CC385A9;
        Mon, 23 May 2022 17:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326695;
        bh=l+dweFhCBdHCnU3oBcjOgofbeTDxRhLUVlx7Mb2HFa0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oO6fZ+c0rF6LLPNNd2eBRPKDFyVX7MTIIbGKPW0wWe/upvn5qZ8+q2fPOSWuY73+5
         vAphUa3kPdtsJxpUIu5X0Lzr93Ubnh6JMVFSXK6PHuw+K9azOa/ZLGty0ldYyRaETS
         X+glKDriqnh76Fpfoa1UH2/FE5mISdYYV/arotAA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Jean Delvare <jdelvare@suse.de>, Wolfram Sang <wsa@kernel.org>,
        Mario Limonciello <Mario.Limonciello@amd.com>
Subject: [PATCH 5.17 011/158] i2c: piix4: Enable EFCH MMIO for Family 17h+
Date:   Mon, 23 May 2022 19:02:48 +0200
Message-Id: <20220523165832.457360822@linuxfoundation.org>
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


