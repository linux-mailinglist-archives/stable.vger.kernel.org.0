Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 866774269A0
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242159AbhJHLjj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:39:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:39734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242880AbhJHLiO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:38:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32B1461504;
        Fri,  8 Oct 2021 11:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692788;
        bh=kfx+XLaDIgra7kg/8qrhIsESd+Jy2cgR7BnU2EEpG+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c9EDa+FPcLPK553v+DCtS6fosrAhgcrzbXBgE2O2uijv4v/Z2BVcXcTcrke5hC16k
         tpM4ic9kfZB+NS3R67U3se4HsTpFDzt6wmSUsMMS57YBAE/7gnVXKPG+pWbXW4b0DU
         Ghj1X5BgkvnXU4B8gxpYD5eVe7G+nmrBiJSpeVzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kate Hsuan <hpa@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        =?UTF-8?q?Krzysztof=20Ol=C4=99dzki?= <ole@ans.pl>
Subject: [PATCH 5.14 46/48] libata: Add ATA_HORKAGE_NO_NCQ_ON_ATI for Samsung 860 and 870 SSD.
Date:   Fri,  8 Oct 2021 13:28:22 +0200
Message-Id: <20211008112721.595855283@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112720.008415452@linuxfoundation.org>
References: <20211008112720.008415452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kate Hsuan <hpa@redhat.com>

commit 7a8526a5cd51cf5f070310c6c37dd7293334ac49 upstream.

Many users are reporting that the Samsung 860 and 870 SSD are having
various issues when combined with AMD/ATI (vendor ID 0x1002)  SATA
controllers and only completely disabling NCQ helps to avoid these
issues.

Always disabling NCQ for Samsung 860/870 SSDs regardless of the host
SATA adapter vendor will cause I/O performance degradation with well
behaved adapters. To limit the performance impact to ATI adapters,
introduce the ATA_HORKAGE_NO_NCQ_ON_ATI flag to force disable NCQ
only for these adapters.

Also, two libata.force parameters (noncqati and ncqati) are introduced
to disable and enable the NCQ for the system which equipped with ATI
SATA adapter and Samsung 860 and 870 SSDs. The user can determine NCQ
function to be enabled or disabled according to the demand.

After verifying the chipset from the user reports, the issue appears
on AMD/ATI SB7x0/SB8x0/SB9x0 SATA Controllers and does not appear on
recent AMD SATA adapters. The vendor ID of ATI should be 0x1002.
Therefore, ATA_HORKAGE_NO_NCQ_ON_AMD was modified to
ATA_HORKAGE_NO_NCQ_ON_ATI.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=201693
Signed-off-by: Kate Hsuan <hpa@redhat.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210903094411.58749-1-hpa@redhat.com
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: Krzysztof Olędzki <ole@ans.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-core.c |   34 ++++++++++++++++++++++++++++++++--
 include/linux/libata.h    |    1 +
 2 files changed, 33 insertions(+), 2 deletions(-)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2199,6 +2199,25 @@ static void ata_dev_config_ncq_prio(stru
 
 }
 
+static bool ata_dev_check_adapter(struct ata_device *dev,
+				  unsigned short vendor_id)
+{
+	struct pci_dev *pcidev = NULL;
+	struct device *parent_dev = NULL;
+
+	for (parent_dev = dev->tdev.parent; parent_dev != NULL;
+	     parent_dev = parent_dev->parent) {
+		if (dev_is_pci(parent_dev)) {
+			pcidev = to_pci_dev(parent_dev);
+			if (pcidev->vendor == vendor_id)
+				return true;
+			break;
+		}
+	}
+
+	return false;
+}
+
 static int ata_dev_config_ncq(struct ata_device *dev,
 			       char *desc, size_t desc_sz)
 {
@@ -2217,6 +2236,13 @@ static int ata_dev_config_ncq(struct ata
 		snprintf(desc, desc_sz, "NCQ (not used)");
 		return 0;
 	}
+
+	if (dev->horkage & ATA_HORKAGE_NO_NCQ_ON_ATI &&
+	    ata_dev_check_adapter(dev, PCI_VENDOR_ID_ATI)) {
+		snprintf(desc, desc_sz, "NCQ (not used)");
+		return 0;
+	}
+
 	if (ap->flags & ATA_FLAG_NCQ) {
 		hdepth = min(ap->scsi_host->can_queue, ATA_MAX_QUEUE);
 		dev->flags |= ATA_DFLAG_NCQ;
@@ -3951,9 +3977,11 @@ static const struct ata_blacklist_entry
 	{ "Samsung SSD 850*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
 						ATA_HORKAGE_ZERO_AFTER_TRIM, },
 	{ "Samsung SSD 860*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
-						ATA_HORKAGE_ZERO_AFTER_TRIM, },
+						ATA_HORKAGE_ZERO_AFTER_TRIM |
+						ATA_HORKAGE_NO_NCQ_ON_ATI, },
 	{ "Samsung SSD 870*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
-						ATA_HORKAGE_ZERO_AFTER_TRIM, },
+						ATA_HORKAGE_ZERO_AFTER_TRIM |
+						ATA_HORKAGE_NO_NCQ_ON_ATI, },
 	{ "FCCT*M500*",			NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
 						ATA_HORKAGE_ZERO_AFTER_TRIM, },
 
@@ -6108,6 +6136,8 @@ static int __init ata_parse_force_one(ch
 		{ "ncq",	.horkage_off	= ATA_HORKAGE_NONCQ },
 		{ "noncqtrim",	.horkage_on	= ATA_HORKAGE_NO_NCQ_TRIM },
 		{ "ncqtrim",	.horkage_off	= ATA_HORKAGE_NO_NCQ_TRIM },
+		{ "noncqati",	.horkage_on	= ATA_HORKAGE_NO_NCQ_ON_ATI },
+		{ "ncqati",	.horkage_off	= ATA_HORKAGE_NO_NCQ_ON_ATI },
 		{ "dump_id",	.horkage_on	= ATA_HORKAGE_DUMP_ID },
 		{ "pio0",	.xfer_mask	= 1 << (ATA_SHIFT_PIO + 0) },
 		{ "pio1",	.xfer_mask	= 1 << (ATA_SHIFT_PIO + 1) },
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -422,6 +422,7 @@ enum {
 	ATA_HORKAGE_NOTRIM	= (1 << 24),	/* don't use TRIM */
 	ATA_HORKAGE_MAX_SEC_1024 = (1 << 25),	/* Limit max sects to 1024 */
 	ATA_HORKAGE_MAX_TRIM_128M = (1 << 26),	/* Limit max trim size to 128M */
+	ATA_HORKAGE_NO_NCQ_ON_ATI = (1 << 27),	/* Disable NCQ on ATI chipset */
 
 	 /* DMA mask for user DMA control: User visible values; DO NOT
 	    renumber */


