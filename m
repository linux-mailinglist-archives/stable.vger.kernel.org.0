Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB01531A38
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240087AbiEWRac (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242654AbiEWR1z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:27:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA7DE8214E;
        Mon, 23 May 2022 10:23:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7AA6460BD3;
        Mon, 23 May 2022 17:23:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73AC9C34115;
        Mon, 23 May 2022 17:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326637;
        bh=LaAjS8cZQOdxuggr2dDcHhn+6Koq9XyzmAvd0iYdBRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U6tOQxhFMd+XZtrndKR7MYwdMOc3jJNGQGTJt2uYrcR5xvb154WR/mlABAxnPMXZi
         AIL7gnOT5oVQIN7DymoZPhgW2vNTrrI+sRSzDG6HMbH1vldRYXEx4GzPndfLrkC4Hm
         S7T3yMWOhy59m17KW4PdExlK1ZvIwKZFbSRY5w4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Jean Delvare <jdelvare@suse.de>, Wolfram Sang <wsa@kernel.org>,
        Mario Limonciello <Mario.Limonciello@amd.com>
Subject: [PATCH 5.17 005/158] i2c: piix4: Move port I/O region request/release code into functions
Date:   Mon, 23 May 2022 19:02:42 +0200
Message-Id: <20220523165831.454338946@linuxfoundation.org>
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

commit a3325d225b00889f4b7fdb25d83033cae1048a92 upstream.

Move duplicated region request and release code into a function. Move is
in preparation for following MMIO changes.

Signed-off-by: Terry Bowman <terry.bowman@amd.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
[wsa: added missing curly brace]
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Cc: Mario Limonciello <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-piix4.c |   48 ++++++++++++++++++++++++++---------------
 1 file changed, 31 insertions(+), 17 deletions(-)

--- a/drivers/i2c/busses/i2c-piix4.c
+++ b/drivers/i2c/busses/i2c-piix4.c
@@ -165,6 +165,24 @@ struct i2c_piix4_adapdata {
 	u8 port;		/* Port number, shifted */
 };
 
+static int piix4_sb800_region_request(struct device *dev)
+{
+	if (!request_muxed_region(SB800_PIIX4_SMB_IDX, SB800_PIIX4_SMB_MAP_SIZE,
+				  "sb800_piix4_smb")) {
+		dev_err(dev,
+			"SMBus base address index region 0x%x already in use.\n",
+			SB800_PIIX4_SMB_IDX);
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
+static void piix4_sb800_region_release(struct device *dev)
+{
+	release_region(SB800_PIIX4_SMB_IDX, SB800_PIIX4_SMB_MAP_SIZE);
+}
+
 static int piix4_setup(struct pci_dev *PIIX4_dev,
 		       const struct pci_device_id *id)
 {
@@ -270,6 +288,7 @@ static int piix4_setup_sb800(struct pci_
 	unsigned short piix4_smba;
 	u8 smba_en_lo, smba_en_hi, smb_en, smb_en_status, port_sel;
 	u8 i2ccfg, i2ccfg_offset = 0x10;
+	int retval;
 
 	/* SB800 and later SMBus does not support forcing address */
 	if (force || force_addr) {
@@ -291,20 +310,16 @@ static int piix4_setup_sb800(struct pci_
 	else
 		smb_en = (aux) ? 0x28 : 0x2c;
 
-	if (!request_muxed_region(SB800_PIIX4_SMB_IDX, SB800_PIIX4_SMB_MAP_SIZE,
-				  "sb800_piix4_smb")) {
-		dev_err(&PIIX4_dev->dev,
-			"SMB base address index region 0x%x already in use.\n",
-			SB800_PIIX4_SMB_IDX);
-		return -EBUSY;
-	}
+	retval = piix4_sb800_region_request(&PIIX4_dev->dev);
+	if (retval)
+		return retval;
 
 	outb_p(smb_en, SB800_PIIX4_SMB_IDX);
 	smba_en_lo = inb_p(SB800_PIIX4_SMB_IDX + 1);
 	outb_p(smb_en + 1, SB800_PIIX4_SMB_IDX);
 	smba_en_hi = inb_p(SB800_PIIX4_SMB_IDX + 1);
 
-	release_region(SB800_PIIX4_SMB_IDX, SB800_PIIX4_SMB_MAP_SIZE);
+	piix4_sb800_region_release(&PIIX4_dev->dev);
 
 	if (!smb_en) {
 		smb_en_status = smba_en_lo & 0x10;
@@ -373,11 +388,10 @@ static int piix4_setup_sb800(struct pci_
 			piix4_port_shift_sb800 = SB800_PIIX4_PORT_IDX_SHIFT;
 		}
 	} else {
-		if (!request_muxed_region(SB800_PIIX4_SMB_IDX,
-					  SB800_PIIX4_SMB_MAP_SIZE,
-					  "sb800_piix4_smb")) {
+		retval = piix4_sb800_region_request(&PIIX4_dev->dev);
+		if (retval) {
 			release_region(piix4_smba, SMBIOSIZE);
-			return -EBUSY;
+			return retval;
 		}
 
 		outb_p(SB800_PIIX4_PORT_IDX_SEL, SB800_PIIX4_SMB_IDX);
@@ -387,7 +401,7 @@ static int piix4_setup_sb800(struct pci_
 				       SB800_PIIX4_PORT_IDX;
 		piix4_port_mask_sb800 = SB800_PIIX4_PORT_IDX_MASK;
 		piix4_port_shift_sb800 = SB800_PIIX4_PORT_IDX_SHIFT;
-		release_region(SB800_PIIX4_SMB_IDX, SB800_PIIX4_SMB_MAP_SIZE);
+		piix4_sb800_region_release(&PIIX4_dev->dev);
 	}
 
 	dev_info(&PIIX4_dev->dev,
@@ -685,9 +699,9 @@ static s32 piix4_access_sb800(struct i2c
 	u8 port;
 	int retval;
 
-	if (!request_muxed_region(SB800_PIIX4_SMB_IDX, SB800_PIIX4_SMB_MAP_SIZE,
-				  "sb800_piix4_smb"))
-		return -EBUSY;
+	retval = piix4_sb800_region_request(&adap->dev);
+	if (retval)
+		return retval;
 
 	/* Request the SMBUS semaphore, avoid conflicts with the IMC */
 	smbslvcnt  = inb_p(SMBSLVCNT);
@@ -762,7 +776,7 @@ static s32 piix4_access_sb800(struct i2c
 		piix4_imc_wakeup();
 
 release:
-	release_region(SB800_PIIX4_SMB_IDX, SB800_PIIX4_SMB_MAP_SIZE);
+	piix4_sb800_region_release(&adap->dev);
 	return retval;
 }
 


