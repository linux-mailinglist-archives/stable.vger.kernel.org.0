Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92A235316CE
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240983AbiEWRci (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240608AbiEWR3L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:29:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27EAC36681;
        Mon, 23 May 2022 10:26:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C6CB61148;
        Mon, 23 May 2022 17:24:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3464AC385A9;
        Mon, 23 May 2022 17:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326692;
        bh=xkOMtRcSAF4tvoeHESppoblqzKn/AtmYDZuKUi5GB7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iRXv1moWv1oi9qkbq4CPea59edi5xUXj6ngli05MzjMLEhc1dDWtfnOwZ7a/Xzmcf
         +86tdtSKfUWwUCn8HarsRs02KvnV4epqrC7Hf+B3GCG9WbAspjBR4ekiPBEQ8r58I+
         JubCPfPlCP6qCkYm5vah0TSlKO3Pj4iliJZa1AnQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Jean Delvare <jdelvare@suse.de>, Wolfram Sang <wsa@kernel.org>,
        Mario Limonciello <Mario.Limonciello@amd.com>
Subject: [PATCH 5.17 010/158] i2c: piix4: Add EFCH MMIO support for SMBus port select
Date:   Mon, 23 May 2022 19:02:47 +0200
Message-Id: <20220523165832.274162265@linuxfoundation.org>
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

commit 381a3083c6747ae5cdbef9b176d57d1b966db49f upstream.

AMD processors include registers capable of selecting between 2 SMBus
ports. Port selection is made during each user access by writing to
FCH::PM::DECODEEN[smbus0sel]. Change the driver to use MMIO during
SMBus port selection because cd6h/cd7h port I/O is not available on
later AMD processors.

Signed-off-by: Terry Bowman <terry.bowman@amd.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Cc: Mario Limonciello <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-piix4.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/i2c/busses/i2c-piix4.c
+++ b/drivers/i2c/busses/i2c-piix4.c
@@ -753,10 +753,19 @@ static void piix4_imc_wakeup(void)
 	release_region(KERNCZ_IMC_IDX, 2);
 }
 
-static int piix4_sb800_port_sel(u8 port)
+static int piix4_sb800_port_sel(u8 port, struct sb800_mmio_cfg *mmio_cfg)
 {
 	u8 smba_en_lo, val;
 
+	if (mmio_cfg->use_mmio) {
+		smba_en_lo = ioread8(mmio_cfg->addr + piix4_port_sel_sb800);
+		val = (smba_en_lo & ~piix4_port_mask_sb800) | port;
+		if (smba_en_lo != val)
+			iowrite8(val, mmio_cfg->addr + piix4_port_sel_sb800);
+
+		return (smba_en_lo & piix4_port_mask_sb800);
+	}
+
 	outb_p(piix4_port_sel_sb800, SB800_PIIX4_SMB_IDX);
 	smba_en_lo = inb_p(SB800_PIIX4_SMB_IDX + 1);
 
@@ -843,12 +852,12 @@ static s32 piix4_access_sb800(struct i2c
 		}
 	}
 
-	prev_port = piix4_sb800_port_sel(adapdata->port);
+	prev_port = piix4_sb800_port_sel(adapdata->port, &adapdata->mmio_cfg);
 
 	retval = piix4_access(adap, addr, flags, read_write,
 			      command, size, data);
 
-	piix4_sb800_port_sel(prev_port);
+	piix4_sb800_port_sel(prev_port, &adapdata->mmio_cfg);
 
 	/* Release the semaphore */
 	outb_p(smbslvcnt | 0x20, SMBSLVCNT);


