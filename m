Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA234C72C0
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234523AbiB1R2f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:28:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237319AbiB1R2I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:28:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B7717E3D;
        Mon, 28 Feb 2022 09:27:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B109CB815B3;
        Mon, 28 Feb 2022 17:27:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E1DC340E7;
        Mon, 28 Feb 2022 17:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069247;
        bh=Vj7+RV1mSAdxwWoIV35hkfTUgm01kukRlhS/2oE8/tA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XEDhL+2bRrDVY5XOyaLBhcMU8I7dxtqYDVxtAnUdf/kvfcrHPym6iBfxntfZNCvJJ
         TgkUqrvbRrbWQ08JUNOC0scwhIoEusIuOsCBFzcVGouNAZx9gEtGli72FzOf6cvUXo
         g/B5dON7JzW9RA6y1aZmNHJqYf2N4VK0695e6YBI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH 4.14 17/31] ata: pata_hpt37x: disable primary channel on HPT371
Date:   Mon, 28 Feb 2022 18:24:13 +0100
Message-Id: <20220228172201.481566753@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172159.515152296@linuxfoundation.org>
References: <20220228172159.515152296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Sergey Shtylyov <s.shtylyov@omp.ru>

commit 8d093e02e898b24c58788b0289e3202317a96d2a upstream.

The HPT371 chip physically has only one channel, the secondary one,
however the primary channel registers do exist! Thus we have to
manually disable the non-existing channel if the BIOS hasn't done this
already. Similarly to the pata_hpt3x2n driver, always disable the
primary channel.

Fixes: 669a5db411d8 ("[libata] Add a bunch of PATA drivers.")
Cc: stable@vger.kernel.org
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/pata_hpt37x.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -920,6 +920,20 @@ static int hpt37x_init_one(struct pci_de
 	pci_write_config_byte(dev, 0x5a, irqmask);
 
 	/*
+	 * HPT371 chips physically have only one channel, the secondary one,
+	 * but the primary channel registers do exist!  Go figure...
+	 * So,  we manually disable the non-existing channel here
+	 * (if the BIOS hasn't done this already).
+	 */
+	if (dev->device == PCI_DEVICE_ID_TTI_HPT371) {
+		u8 mcr1;
+
+		pci_read_config_byte(dev, 0x50, &mcr1);
+		mcr1 &= ~0x04;
+		pci_write_config_byte(dev, 0x50, mcr1);
+	}
+
+	/*
 	 * default to pci clock. make sure MA15/16 are set to output
 	 * to prevent drives having problems with 40-pin cables. Needed
 	 * for some drives such as IBM-DTLA which will not enter ready


