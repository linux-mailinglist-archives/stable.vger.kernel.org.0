Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7D85319BB
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240869AbiEWRa3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242669AbiEWR14 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:27:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECC7C8B08C;
        Mon, 23 May 2022 10:24:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 930A760C1D;
        Mon, 23 May 2022 17:24:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 950D9C385A9;
        Mon, 23 May 2022 17:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326641;
        bh=cLb5gKpb3Emt5UyYxqpjSOJ5CM5YoWj2BbF49iH0I7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MVRBtGcZda+/yDXSU3KzbDQmJtq/xPMG1o7Pa64PmDYbOgN3JBiP8HMSdyMk9G4/2
         kV0DEwf/BKZJjr9dSV6SjoszvdZIrb+ZkvNpLfJVBNEu/jLkd8l4z0TPIrdIyGxMZ7
         xPaA15ETtRviDiy6NkwdDHx6joFKx4DlM5xaVwfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Jean Delvare <jdelvare@suse.de>, Wolfram Sang <wsa@kernel.org>,
        Mario Limonciello <Mario.Limonciello@amd.com>
Subject: [PATCH 5.17 006/158] i2c: piix4: Move SMBus controller base address detect into function
Date:   Mon, 23 May 2022 19:02:43 +0200
Message-Id: <20220523165831.605365798@linuxfoundation.org>
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

commit 0a59a24e14e9b21dcbb6b8ea41422e2fdfa437fd upstream.

Move SMBus controller base address detection into function. Refactor
is in preparation for following MMIO changes.

Signed-off-by: Terry Bowman <terry.bowman@amd.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Cc: Mario Limonciello <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-piix4.c |   69 ++++++++++++++++++++++++++---------------
 1 file changed, 44 insertions(+), 25 deletions(-)

--- a/drivers/i2c/busses/i2c-piix4.c
+++ b/drivers/i2c/busses/i2c-piix4.c
@@ -282,11 +282,51 @@ static int piix4_setup(struct pci_dev *P
 	return piix4_smba;
 }
 
+static int piix4_setup_sb800_smba(struct pci_dev *PIIX4_dev,
+				  u8 smb_en,
+				  u8 aux,
+				  u8 *smb_en_status,
+				  unsigned short *piix4_smba)
+{
+	u8 smba_en_lo;
+	u8 smba_en_hi;
+	int retval;
+
+	retval = piix4_sb800_region_request(&PIIX4_dev->dev);
+	if (retval)
+		return retval;
+
+	outb_p(smb_en, SB800_PIIX4_SMB_IDX);
+	smba_en_lo = inb_p(SB800_PIIX4_SMB_IDX + 1);
+	outb_p(smb_en + 1, SB800_PIIX4_SMB_IDX);
+	smba_en_hi = inb_p(SB800_PIIX4_SMB_IDX + 1);
+
+	piix4_sb800_region_release(&PIIX4_dev->dev);
+
+	if (!smb_en) {
+		*smb_en_status = smba_en_lo & 0x10;
+		*piix4_smba = smba_en_hi << 8;
+		if (aux)
+			*piix4_smba |= 0x20;
+	} else {
+		*smb_en_status = smba_en_lo & 0x01;
+		*piix4_smba = ((smba_en_hi << 8) | smba_en_lo) & 0xffe0;
+	}
+
+	if (!*smb_en_status) {
+		dev_err(&PIIX4_dev->dev,
+			"SMBus Host Controller not enabled!\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
 static int piix4_setup_sb800(struct pci_dev *PIIX4_dev,
 			     const struct pci_device_id *id, u8 aux)
 {
 	unsigned short piix4_smba;
-	u8 smba_en_lo, smba_en_hi, smb_en, smb_en_status, port_sel;
+	u8 smb_en, smb_en_status, port_sel;
 	u8 i2ccfg, i2ccfg_offset = 0x10;
 	int retval;
 
@@ -310,33 +350,12 @@ static int piix4_setup_sb800(struct pci_
 	else
 		smb_en = (aux) ? 0x28 : 0x2c;
 
-	retval = piix4_sb800_region_request(&PIIX4_dev->dev);
+	retval = piix4_setup_sb800_smba(PIIX4_dev, smb_en, aux, &smb_en_status,
+					&piix4_smba);
+
 	if (retval)
 		return retval;
 
-	outb_p(smb_en, SB800_PIIX4_SMB_IDX);
-	smba_en_lo = inb_p(SB800_PIIX4_SMB_IDX + 1);
-	outb_p(smb_en + 1, SB800_PIIX4_SMB_IDX);
-	smba_en_hi = inb_p(SB800_PIIX4_SMB_IDX + 1);
-
-	piix4_sb800_region_release(&PIIX4_dev->dev);
-
-	if (!smb_en) {
-		smb_en_status = smba_en_lo & 0x10;
-		piix4_smba = smba_en_hi << 8;
-		if (aux)
-			piix4_smba |= 0x20;
-	} else {
-		smb_en_status = smba_en_lo & 0x01;
-		piix4_smba = ((smba_en_hi << 8) | smba_en_lo) & 0xffe0;
-	}
-
-	if (!smb_en_status) {
-		dev_err(&PIIX4_dev->dev,
-			"SMBus Host Controller not enabled!\n");
-		return -ENODEV;
-	}
-
 	if (acpi_check_region(piix4_smba, SMBIOSIZE, piix4_driver.name))
 		return -ENODEV;
 


