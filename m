Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6EEF4C6323
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 07:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233218AbiB1Gig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 01:38:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231978AbiB1Gif (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 01:38:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF31611C25
        for <stable@vger.kernel.org>; Sun, 27 Feb 2022 22:37:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86F5D60FEB
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 06:37:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D81C340E7;
        Mon, 28 Feb 2022 06:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646030277;
        bh=nA5bx7sZ5MA7+/H3xgguMGG/mBcg9hj5/mT+dkqIWOU=;
        h=Subject:To:Cc:From:Date:From;
        b=X4l6VRs0ff4DH/mfGuUtHBHQTCAK5cFJoHQ1UTmQ4LOzlJ0k6zJf82FJvbV0hmaxn
         lOgH/YLkjVer+zFup/RJIW1Rg4hRa9ddWTVtZ9htI2GboCjcAebBb+KA1t8GNJuOZb
         9cPemhJqW16HoQnkd8Z785sX2PWkqHVfrvnBC0qo=
Subject: FAILED: patch "[PATCH] ata: pata_hpt37x: fix PCI clock detection" failed to apply to 5.4-stable tree
To:     s.shtylyov@omp.ru, damien.lemoal@opensource.wdc.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Feb 2022 07:37:40 +0100
Message-ID: <164603026017287@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5f6b0f2d037c8864f20ff15311c695f65eb09db5 Mon Sep 17 00:00:00 2001
From: Sergey Shtylyov <s.shtylyov@omp.ru>
Date: Sat, 19 Feb 2022 23:04:29 +0300
Subject: [PATCH] ata: pata_hpt37x: fix PCI clock detection

The f_CNT register (at the PCI config. address 0x78) is 16-bit, not
8-bit! The bug was there from the very start... :-(

Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Fixes: 669a5db411d8 ("[libata] Add a bunch of PATA drivers.")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

diff --git a/drivers/ata/pata_hpt37x.c b/drivers/ata/pata_hpt37x.c
index 7abc7e04f656..1baaca7b72ed 100644
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -950,14 +950,14 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 
 	if ((freq >> 12) != 0xABCDE) {
 		int i;
-		u8 sr;
+		u16 sr;
 		u32 total = 0;
 
 		dev_warn(&dev->dev, "BIOS has not set timing clocks\n");
 
 		/* This is the process the HPT371 BIOS is reported to use */
 		for (i = 0; i < 128; i++) {
-			pci_read_config_byte(dev, 0x78, &sr);
+			pci_read_config_word(dev, 0x78, &sr);
 			total += sr & 0x1FF;
 			udelay(15);
 		}

