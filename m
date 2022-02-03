Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1600B4A819C
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 10:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244374AbiBCJlz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 04:41:55 -0500
Received: from mail.acc.umu.se ([130.239.18.156]:39089 "EHLO mail.acc.umu.se"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232632AbiBCJlz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Feb 2022 04:41:55 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by amavisd-new (Postfix) with ESMTP id DEB7A44B90;
        Thu,  3 Feb 2022 10:41:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=acc.umu.se; s=mail1;
        t=1643881313; bh=LMnweUAtZICmF6EStx9nhGZFkQWxH9aNicWi4eglCdQ=;
        h=From:To:Cc:Subject:Date:From;
        b=NT280VSwF8sMt3wv6ESqm2LzIUBvcNYKGYTFzuuVg0f+k/mkSVQr808L2W2dgeFZK
         WuAAxpyCj4U1BhULK7j/pBl8kxpP2AnA8OCctNkVmcMvDDOGH6FcIhnbk2srhzvdko
         xLhN/7x9yIZlT+jx1uXxwCHkq9DilIC/pDHWa/On3wPDC5KGY9QT0LOJid7I00pefp
         gA2ICYJbt+opxvHbMdwstPfVvkhr4krTXvv1mgfxXljLTcwhJTqNTimAcl5nMYgq1z
         IiqZmXEr5z2z0vmwwkBPnXqTtAYpGHiG4SXpb4+yyC/vEzbwfBTMPY2BNGMxlHlJY/
         3i4V15ZyigGZA==
Received: by mail.acc.umu.se (Postfix, from userid 24471)
        id 13F3D44B92; Thu,  3 Feb 2022 10:41:53 +0100 (CET)
From:   Anton Lundin <glance@acc.umu.se>
To:     linux-ide@vger.kernel.org
Cc:     Anton Lundin <glance@acc.umu.se>, stable@vger.kernel.org,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH] ata: libata-core: Introduce ATA_HORKAGE_NO_LOG_DIR horkage
Date:   Thu,  3 Feb 2022 10:41:35 +0100
Message-Id: <20220203094135.2437143-1-glance@acc.umu.se>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/ata/libata-core.c | 10 ++++++++++
 include/linux/libata.h    |  1 +
 2 files changed, 11 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 67f88027680a..e1b1dd215267 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2007,6 +2007,9 @@ static bool ata_log_supported(struct ata_device *dev, u8 log)
 {
 	struct ata_port *ap = dev->link->ap;
 
+	if (dev->horkage & ATA_HORKAGE_NO_LOG_DIR)
+		return false;
+
 	if (ata_read_log_page(dev, ATA_LOG_DIRECTORY, 0, ap->sector_buf, 1))
 		return false;
 	return get_unaligned_le16(&ap->sector_buf[log * 2]) ? true : false;
@@ -4073,6 +4076,13 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
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
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 605756f645be..7f99b4d78822 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -380,6 +380,7 @@ enum {
 	ATA_HORKAGE_MAX_TRIM_128M = (1 << 26),	/* Limit max trim size to 128M */
 	ATA_HORKAGE_NO_NCQ_ON_ATI = (1 << 27),	/* Disable NCQ on ATI chipset */
 	ATA_HORKAGE_NO_ID_DEV_LOG = (1 << 28),	/* Identify device log missing */
+	ATA_HORKAGE_NO_LOG_DIR	= (1 << 29),	/* Do not read log directory */
 
 	 /* DMA mask for user DMA control: User visible values; DO NOT
 	    renumber */
-- 
2.30.2

