Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08FD63F941A
	for <lists+stable@lfdr.de>; Fri, 27 Aug 2021 07:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244291AbhH0Fez (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 01:34:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21277 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244290AbhH0Fey (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Aug 2021 01:34:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630042445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CeKNFgANGvuwyssNLPKOzZ48qdLKYeXvXqDZ9XvNvns=;
        b=Nv79zeFRUflff/884VzSfsi5DbNmvKMvJAcxp4DufM08echkJ+tN3b9EPo+vV2elJyPKuk
        O1vXgMQcHMib7gLmw8/MYr/zlvygkVUeWitxt+F9K8A1u04+rpobLGNCZ2wT2RUfwq9aHQ
        oby8DOk6drTsp1WvEJt9zgczep2mGxs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-120-qjYUr4JTOBCbm3o23PosZw-1; Fri, 27 Aug 2021 01:34:04 -0400
X-MC-Unique: qjYUr4JTOBCbm3o23PosZw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 433891008062;
        Fri, 27 Aug 2021 05:34:03 +0000 (UTC)
Received: from fedora-t480.redhat.com (unknown [10.39.192.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2912960C04;
        Fri, 27 Aug 2021 05:33:57 +0000 (UTC)
From:   Kate Hsuan <hpa@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, Hans de Goede <hdegoede@redhat.com>,
        Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Kate Hsuan <hpa@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2 1/1] libata: libata: add ATA_HORKAGE_NO_NCQ_TRIM for Samsung 860 and 870 SSDs
Date:   Fri, 27 Aug 2021 01:33:44 -0400
Message-Id: <20210827053344.15087-2-hpa@redhat.com>
In-Reply-To: <20210827053344.15087-1-hpa@redhat.com>
References: <20210827053344.15087-1-hpa@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A flag ATA_HORKAGE_NONCQ_ON_ASMEDIA_AMD_MARVELL is added to disable NCQ
on AMD/MAREL/ASMEDIA chipsets.

Samsung 860/870 SSD are disabled to use NCQ trim functions but it will
lead to performace drop. From the bugzilla, we could realize the issues
only appears on those chipset mentioned above. So this flag could be
used to only disable NCQ on specific chipsets.

Fixes: ca6bfcb2f6d9 ("libata: Enable queued TRIM for Samsung SSD 860")
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=203475
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Kate Hsuan <hpa@redhat.com>
---
 drivers/ata/libata-core.c | 37 ++++++++++++++++++++++++++++++++-----
 include/linux/libata.h    |  3 +++
 2 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index cc459ce90018..50f635669dd4 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2119,6 +2119,8 @@ static inline u8 ata_dev_knobble(struct ata_device *dev)
 static void ata_dev_config_ncq_send_recv(struct ata_device *dev)
 {
 	struct ata_port *ap = dev->link->ap;
+	struct device *parent = NULL;
+	struct pci_dev *pcidev = NULL;
 	unsigned int err_mask;
 
 	if (!ata_log_supported(dev, ATA_LOG_NCQ_SEND_RECV)) {
@@ -2138,9 +2140,32 @@ static void ata_dev_config_ncq_send_recv(struct ata_device *dev)
 		memcpy(cmds, ap->sector_buf, ATA_LOG_NCQ_SEND_RECV_SIZE);
 
 		if (dev->horkage & ATA_HORKAGE_NO_NCQ_TRIM) {
-			ata_dev_dbg(dev, "disabling queued TRIM support\n");
-			cmds[ATA_LOG_NCQ_SEND_RECV_DSM_OFFSET] &=
-				~ATA_LOG_NCQ_SEND_RECV_DSM_TRIM;
+			if (dev->horkage & ATA_HORKAGE_NONCQ_ON_ASMEDIA_AMD_MARVELL)
+			{
+				// get parent device for the controller vendor ID
+				for(parent = dev->tdev.parent; parent != NULL; parent = parent->parent)
+				{
+					if(dev_is_pci(parent))
+					{
+						pcidev = to_pci_dev(parent);
+						if (pcidev->vendor == PCI_VENDOR_ID_MARVELL ||
+							pcidev->vendor == PCI_VENDOR_ID_AMD 	||
+							pcidev->vendor == PCI_VENDOR_ID_ASMEDIA )
+						{
+							ata_dev_dbg(dev, "Disable NCQ -> vendor ID %x product ID %x\n", 
+												pcidev->vendor, pcidev->device);
+							cmds[ATA_LOG_NCQ_SEND_RECV_DSM_OFFSET] &=
+								~ATA_LOG_NCQ_SEND_RECV_DSM_TRIM;
+						}
+						break;
+					}
+				}
+			}else
+			{
+				ata_dev_dbg(dev, "disabling queued TRIM support\n");
+				cmds[ATA_LOG_NCQ_SEND_RECV_DSM_OFFSET] &=
+					~ATA_LOG_NCQ_SEND_RECV_DSM_TRIM;
+			}
 		}
 	}
 }
@@ -3951,9 +3976,11 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "Samsung SSD 850*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
 						ATA_HORKAGE_ZERO_AFTER_TRIM, },
 	{ "Samsung SSD 860*",           NULL,   ATA_HORKAGE_NO_NCQ_TRIM |
-						ATA_HORKAGE_ZERO_AFTER_TRIM, },
+						ATA_HORKAGE_ZERO_AFTER_TRIM |
+						ATA_HORKAGE_NONCQ_ON_ASMEDIA_AMD_MARVELL, },
 	{ "Samsung SSD 870*",           NULL,   ATA_HORKAGE_NO_NCQ_TRIM |
-						ATA_HORKAGE_ZERO_AFTER_TRIM, },
+						ATA_HORKAGE_ZERO_AFTER_TRIM |
+						ATA_HORKAGE_NONCQ_ON_ASMEDIA_AMD_MARVELL, },
 	{ "FCCT*M500*",			NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
 						ATA_HORKAGE_ZERO_AFTER_TRIM, },
 
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 3fcd24236793..ec17f1f3fbf6 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -422,6 +422,9 @@ enum {
 	ATA_HORKAGE_NOTRIM	= (1 << 24),	/* don't use TRIM */
 	ATA_HORKAGE_MAX_SEC_1024 = (1 << 25),	/* Limit max sects to 1024 */
 	ATA_HORKAGE_MAX_TRIM_128M = (1 << 26),	/* Limit max trim size to 128M */
+	ATA_HORKAGE_NONCQ_ON_ASMEDIA_AMD_MARVELL = (1 << 27), /*Disable NCQ only on 
+							ASMeida, AMD, and Marvell 
+							Chipset*/
 
 	 /* DMA mask for user DMA control: User visible values; DO NOT
 	    renumber */
-- 
2.31.1

