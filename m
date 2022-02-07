Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D79D4ABD9C
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 13:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388816AbiBGLpc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:45:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385568AbiBGLb7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:31:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83552C03E969;
        Mon,  7 Feb 2022 03:30:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DA3CB80EBD;
        Mon,  7 Feb 2022 11:30:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 879BBC004E1;
        Mon,  7 Feb 2022 11:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233452;
        bh=ommyWLdHB1X5ao2pxgZFgQltSg+lALGtV7sFv7djEpk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i6vbk9/b8rxq0BGIoBa7l3rrlS9RSFVdIVtnEYvAKfI5INttm5FwmXK1ZcDxSVX6O
         P4aVJcrUHWOfzInlDvYwGX7Qnn2mqrow2N7PBE4O5LZ/QT6uC12s1kYRWTlhRUCI6e
         PJ0TJx+f3UoG4xDRmdNsDqvehV9WpdzR/aHupF2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anton Lundin <glance@acc.umu.se>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH 5.16 017/126] ata: libata-core: Introduce ATA_HORKAGE_NO_LOG_DIR horkage
Date:   Mon,  7 Feb 2022 12:05:48 +0100
Message-Id: <20220207103804.653311531@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103804.053675072@linuxfoundation.org>
References: <20220207103804.053675072@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Anton Lundin <glance@acc.umu.se>

commit ac9f0c810684a1b161c18eb4b91ce84cbc13c91d upstream.

06f6c4c6c3e8 ("ata: libata: add missing ata_identify_page_supported() calls")
introduced additional calls to ata_identify_page_supported(), thus also
adding indirectly accesses to the device log directory log page through
ata_log_supported(). Reading this log page causes SATADOM-ML 3ME devices
to lock up.

Introduce the horkage flag ATA_HORKAGE_NO_LOG_DIR to prevent accesses to
the log directory in ata_log_supported() and add a blacklist entry
with this flag for "SATADOM-ML 3ME" devices.

Fixes: 636f6e2af4fb ("libata: add horkage for missing Identify Device log")
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Anton Lundin <glance@acc.umu.se>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-core.c |   10 ++++++++++
 include/linux/libata.h    |    1 +
 2 files changed, 11 insertions(+)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2043,6 +2043,9 @@ static bool ata_log_supported(struct ata
 {
 	struct ata_port *ap = dev->link->ap;
 
+	if (dev->horkage & ATA_HORKAGE_NO_LOG_DIR)
+		return false;
+
 	if (ata_read_log_page(dev, ATA_LOG_DIRECTORY, 0, ap->sector_buf, 1))
 		return false;
 	return get_unaligned_le16(&ap->sector_buf[log * 2]) ? true : false;
@@ -4123,6 +4126,13 @@ static const struct ata_blacklist_entry
 	{ "WDC WD3000JD-*",		NULL,	ATA_HORKAGE_WD_BROKEN_LPM },
 	{ "WDC WD3200JD-*",		NULL,	ATA_HORKAGE_WD_BROKEN_LPM },
 
+	/*
+	 * This sata dom device goes on a walkabout when the ATA_LOG_DIRECTORY
+	 * log page is accessed. Ensure we never ask for this log page with
+	 * these devices.
+	 */
+	{ "SATADOM-ML 3ME",		NULL,	ATA_HORKAGE_NO_LOG_DIR },
+
 	/* End Marker */
 	{ }
 };
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -428,6 +428,7 @@ enum {
 	ATA_HORKAGE_MAX_TRIM_128M = (1 << 26),	/* Limit max trim size to 128M */
 	ATA_HORKAGE_NO_NCQ_ON_ATI = (1 << 27),	/* Disable NCQ on ATI chipset */
 	ATA_HORKAGE_NO_ID_DEV_LOG = (1 << 28),	/* Identify device log missing */
+	ATA_HORKAGE_NO_LOG_DIR	= (1 << 29),	/* Do not read log directory */
 
 	 /* DMA mask for user DMA control: User visible values; DO NOT
 	    renumber */


