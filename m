Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39BB54AFD73
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 20:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbiBIT2x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 14:28:53 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:46724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235095AbiBIT1Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 14:27:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149E8C1DC5EB;
        Wed,  9 Feb 2022 11:19:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EB9D6193E;
        Wed,  9 Feb 2022 19:15:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B54C340E7;
        Wed,  9 Feb 2022 19:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644434152;
        bh=QeCxUFHPZAtlfe87gmSrJSiGPfQECvhSaF7Kp7KD990=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0xcBux5VdCY2jXKbJZS73gpMPfAwHbT7qFTP8mnACGBgrovWLFvqSmzTOWrtbBkPa
         D/FRzL5y95Qslq2+jjLUr/8ETryEqjuGvKB8N8fNWo8mEzrlO9QKOSLtEQilQp6LE/
         f7VH5OHonKOfsCugFMh/vdYLEmkRJ+mmKINeZTSY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Abderraouf Adjal <adjal.arf@gmail.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH 5.16 1/5] ata: libata-core: Fix ata_dev_config_cpr()
Date:   Wed,  9 Feb 2022 20:14:33 +0100
Message-Id: <20220209191249.945825874@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220209191249.887150036@linuxfoundation.org>
References: <20220209191249.887150036@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

commit fda17afc6166e975bec1197bd94cd2a3317bce3f upstream.

The concurrent positioning ranges log page 47h is a general purpose log
page and not a subpage of the indentify device log. Using
ata_identify_page_supported() to test for concurrent positioning ranges
support is thus wrong. ata_log_supported() must be used.

Furthermore, unlike other advanced ATA features (e.g. NCQ priority),
accesses to the concurrent positioning ranges log page are not gated by
a feature bit from the device IDENTIFY data. Since many older drives
react badly to the READ LOG EXT and/or READ LOG DMA EXT commands isued
to read device log pages, avoid problems with older drives by limiting
the concurrent positioning ranges support detection to drives
implementing at least the ACS-4 ATA standard (major version 11). This
additional condition effectively turns ata_dev_config_cpr() into a nop
for older drives, avoiding problems in the field.

Fixes: fe22e1c2f705 ("libata: support concurrent positioning ranges log")
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=215519
Cc: stable@vger.kernel.org
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Abderraouf Adjal <adjal.arf@gmail.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-core.c |   14 ++++++--------
 include/linux/ata.h       |    2 +-
 2 files changed, 7 insertions(+), 9 deletions(-)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2486,23 +2486,21 @@ static void ata_dev_config_cpr(struct at
 	struct ata_cpr_log *cpr_log = NULL;
 	u8 *desc, *buf = NULL;
 
-	if (!ata_identify_page_supported(dev,
-				 ATA_LOG_CONCURRENT_POSITIONING_RANGES))
+	if (ata_id_major_version(dev->id) < 11 ||
+	    !ata_log_supported(dev, ATA_LOG_CONCURRENT_POSITIONING_RANGES))
 		goto out;
 
 	/*
-	 * Read IDENTIFY DEVICE data log, page 0x47
-	 * (concurrent positioning ranges). We can have at most 255 32B range
-	 * descriptors plus a 64B header.
+	 * Read the concurrent positioning ranges log (0x47). We can have at
+	 * most 255 32B range descriptors plus a 64B header.
 	 */
 	buf_len = (64 + 255 * 32 + 511) & ~511;
 	buf = kzalloc(buf_len, GFP_KERNEL);
 	if (!buf)
 		goto out;
 
-	err_mask = ata_read_log_page(dev, ATA_LOG_IDENTIFY_DEVICE,
-				     ATA_LOG_CONCURRENT_POSITIONING_RANGES,
-				     buf, buf_len >> 9);
+	err_mask = ata_read_log_page(dev, ATA_LOG_CONCURRENT_POSITIONING_RANGES,
+				     0, buf, buf_len >> 9);
 	if (err_mask)
 		goto out;
 
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -324,12 +324,12 @@ enum {
 	ATA_LOG_NCQ_NON_DATA	= 0x12,
 	ATA_LOG_NCQ_SEND_RECV	= 0x13,
 	ATA_LOG_IDENTIFY_DEVICE	= 0x30,
+	ATA_LOG_CONCURRENT_POSITIONING_RANGES = 0x47,
 
 	/* Identify device log pages: */
 	ATA_LOG_SECURITY	  = 0x06,
 	ATA_LOG_SATA_SETTINGS	  = 0x08,
 	ATA_LOG_ZONED_INFORMATION = 0x09,
-	ATA_LOG_CONCURRENT_POSITIONING_RANGES = 0x47,
 
 	/* Identify device SATA settings log:*/
 	ATA_LOG_DEVSLP_OFFSET	  = 0x30,


