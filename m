Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17947531988
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240859AbiEWRa2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242682AbiEWR14 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:27:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A2C8021E;
        Mon, 23 May 2022 10:23:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FAC160B2C;
        Mon, 23 May 2022 17:23:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0862BC34115;
        Mon, 23 May 2022 17:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326634;
        bh=VdZ3qN2N3rMjOlO5jRK39pc0DwqbAhKuawjvaF1x4mk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UT465FEYVsy8CEClGKxMzhqJ6ly6h+iWAa06GJOslvKySUf55Fx6/6H4T08vz+g7+
         mF3S/IHmt93PHZMv7nPyXE4elEICBk3rGGuKoSxdTRmw0LgtoVeOc+zZY7GRs6Kowv
         LzTZ/fqp6371YpBmLosV3Fo64JiOJeCCNZVOypUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Jean Delvare <jdelvare@suse.de>, Wolfram Sang <wsa@kernel.org>,
        Mario Limonciello <Mario.Limonciello@amd.com>
Subject: [PATCH 5.17 004/158] i2c: piix4: Replace hardcoded memory map size with a #define
Date:   Mon, 23 May 2022 19:02:41 +0200
Message-Id: <20220523165831.272537615@linuxfoundation.org>
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

commit 93102cb449780f7b4eecf713451627b78373ce49 upstream.

Replace number constant with #define to improve readability and
maintainability.

Signed-off-by: Terry Bowman <terry.bowman@amd.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Cc: Mario Limonciello <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-piix4.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/i2c/busses/i2c-piix4.c
+++ b/drivers/i2c/busses/i2c-piix4.c
@@ -77,6 +77,7 @@
 
 /* SB800 constants */
 #define SB800_PIIX4_SMB_IDX		0xcd6
+#define SB800_PIIX4_SMB_MAP_SIZE	2
 
 #define KERNCZ_IMC_IDX			0x3e
 #define KERNCZ_IMC_DATA			0x3f
@@ -290,7 +291,8 @@ static int piix4_setup_sb800(struct pci_
 	else
 		smb_en = (aux) ? 0x28 : 0x2c;
 
-	if (!request_muxed_region(SB800_PIIX4_SMB_IDX, 2, "sb800_piix4_smb")) {
+	if (!request_muxed_region(SB800_PIIX4_SMB_IDX, SB800_PIIX4_SMB_MAP_SIZE,
+				  "sb800_piix4_smb")) {
 		dev_err(&PIIX4_dev->dev,
 			"SMB base address index region 0x%x already in use.\n",
 			SB800_PIIX4_SMB_IDX);
@@ -302,7 +304,7 @@ static int piix4_setup_sb800(struct pci_
 	outb_p(smb_en + 1, SB800_PIIX4_SMB_IDX);
 	smba_en_hi = inb_p(SB800_PIIX4_SMB_IDX + 1);
 
-	release_region(SB800_PIIX4_SMB_IDX, 2);
+	release_region(SB800_PIIX4_SMB_IDX, SB800_PIIX4_SMB_MAP_SIZE);
 
 	if (!smb_en) {
 		smb_en_status = smba_en_lo & 0x10;
@@ -371,7 +373,8 @@ static int piix4_setup_sb800(struct pci_
 			piix4_port_shift_sb800 = SB800_PIIX4_PORT_IDX_SHIFT;
 		}
 	} else {
-		if (!request_muxed_region(SB800_PIIX4_SMB_IDX, 2,
+		if (!request_muxed_region(SB800_PIIX4_SMB_IDX,
+					  SB800_PIIX4_SMB_MAP_SIZE,
 					  "sb800_piix4_smb")) {
 			release_region(piix4_smba, SMBIOSIZE);
 			return -EBUSY;
@@ -384,7 +387,7 @@ static int piix4_setup_sb800(struct pci_
 				       SB800_PIIX4_PORT_IDX;
 		piix4_port_mask_sb800 = SB800_PIIX4_PORT_IDX_MASK;
 		piix4_port_shift_sb800 = SB800_PIIX4_PORT_IDX_SHIFT;
-		release_region(SB800_PIIX4_SMB_IDX, 2);
+		release_region(SB800_PIIX4_SMB_IDX, SB800_PIIX4_SMB_MAP_SIZE);
 	}
 
 	dev_info(&PIIX4_dev->dev,
@@ -682,7 +685,8 @@ static s32 piix4_access_sb800(struct i2c
 	u8 port;
 	int retval;
 
-	if (!request_muxed_region(SB800_PIIX4_SMB_IDX, 2, "sb800_piix4_smb"))
+	if (!request_muxed_region(SB800_PIIX4_SMB_IDX, SB800_PIIX4_SMB_MAP_SIZE,
+				  "sb800_piix4_smb"))
 		return -EBUSY;
 
 	/* Request the SMBUS semaphore, avoid conflicts with the IMC */
@@ -758,7 +762,7 @@ static s32 piix4_access_sb800(struct i2c
 		piix4_imc_wakeup();
 
 release:
-	release_region(SB800_PIIX4_SMB_IDX, 2);
+	release_region(SB800_PIIX4_SMB_IDX, SB800_PIIX4_SMB_MAP_SIZE);
 	return retval;
 }
 


