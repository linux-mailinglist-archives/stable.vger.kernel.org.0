Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D586E5486CF
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355915AbiFMLtt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356164AbiFMLsZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:48:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485794BBB9;
        Mon, 13 Jun 2022 03:53:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F536B80D3A;
        Mon, 13 Jun 2022 10:52:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A44FC34114;
        Mon, 13 Jun 2022 10:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117577;
        bh=7ZJdOB8NWztNFmJga+HULPqObVqV573O24/WNfw5IOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EcdjCwRQQm7yHPUpOsdHnQ0tah7oFB9cmULcnaNVs2WrsjbpNw5QL75iNwHktVks6
         mUpuNYOdNomt8jt6P7io9oItPAtoQTNfDJhNaKP+JsLb+SwcZRc4PXR5RTjxxN9SOV
         gI+EMonlyNkxs60oGEtb4GNRQlej9eLMs3ECa8bc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH 5.4 402/411] ata: libata-transport: fix {dma|pio|xfer}_mode sysfs files
Date:   Mon, 13 Jun 2022 12:11:15 +0200
Message-Id: <20220613094940.879082162@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Shtylyov <s.shtylyov@omp.ru>

commit 72aad489f992871e908ff6d9055b26c6366fb864 upstream.

The {dma|pio}_mode sysfs files are incorrectly documented as having a
list of the supported DMA/PIO transfer modes, while the corresponding
fields of the *struct* ata_device hold the transfer mode IDs, not masks.

To match these docs, the {dma|pio}_mode (and even xfer_mode!) sysfs
files are handled by the ata_bitfield_name_match() macro which leads to
reading such kind of nonsense from them:

$ cat /sys/class/ata_device/dev3.0/pio_mode
XFER_UDMA_7, XFER_UDMA_6, XFER_UDMA_5, XFER_UDMA_4, XFER_MW_DMA_4,
XFER_PIO_6, XFER_PIO_5, XFER_PIO_4, XFER_PIO_3, XFER_PIO_2, XFER_PIO_1,
XFER_PIO_0

Using the correct ata_bitfield_name_search() macro fixes that:

$ cat /sys/class/ata_device/dev3.0/pio_mode
XFER_PIO_4

While fixing the file documentation, somewhat reword the {dma|pio}_mode
file doc and add a note about being mostly useful for PATA devices to
the xfer_mode file doc...

Fixes: d9027470b886 ("[libata] Add ATA transport class")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/ABI/testing/sysfs-ata |   11 ++++++-----
 drivers/ata/libata-transport.c      |    2 +-
 2 files changed, 7 insertions(+), 6 deletions(-)

--- a/Documentation/ABI/testing/sysfs-ata
+++ b/Documentation/ABI/testing/sysfs-ata
@@ -107,13 +107,14 @@ Description:
 				described in ATA8 7.16 and 7.17. Only valid if
 				the device is not a PM.
 
-		pio_mode:	(RO) Transfer modes supported by the device when
-				in PIO mode. Mostly used by PATA device.
+		pio_mode:	(RO) PIO transfer mode used by the device.
+				Mostly used by PATA devices.
 
-		xfer_mode:	(RO) Current transfer mode
+		xfer_mode:	(RO) Current transfer mode. Mostly used by
+				PATA devices.
 
-		dma_mode:	(RO) Transfer modes supported by the device when
-				in DMA mode. Mostly used by PATA device.
+		dma_mode:	(RO) DMA transfer mode used by the device.
+				Mostly used by PATA devices.
 
 		class:		(RO) Device class. Can be "ata" for disk,
 				"atapi" for packet device, "pmp" for PM, or
--- a/drivers/ata/libata-transport.c
+++ b/drivers/ata/libata-transport.c
@@ -196,7 +196,7 @@ static struct {
 	{ XFER_PIO_0,			"XFER_PIO_0" },
 	{ XFER_PIO_SLOW,		"XFER_PIO_SLOW" }
 };
-ata_bitfield_name_match(xfer,ata_xfer_names)
+ata_bitfield_name_search(xfer, ata_xfer_names)
 
 /*
  * ATA Port attributes


