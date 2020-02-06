Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC921542E1
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 12:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727626AbgBFLRh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 06:17:37 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:59556 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727607AbgBFLRg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Feb 2020 06:17:36 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 016BHXgE012961;
        Thu, 6 Feb 2020 05:17:33 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1580987853;
        bh=+m7cJqiaPTAt35RzkCxMV+/3fy67doLnxsI8W1Jm5vU=;
        h=From:To:CC:Subject:Date;
        b=iZMhQee8mNEN3M4lopYrHxVD9NnYxE3BVnATE6xXxgdN6LSs5vAsvup0HGd6KSYHa
         SAfGz3773xd2WsY5VLV5eiQlq6gEFD2QD+hF3odi6xtqsL34Cb/nAtKuTOE6zvJUXd
         PFYbHkentN1cwhq0MGG/oMUBmgo/nfyyRSWCUyvM=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 016BHWfC005620
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 6 Feb 2020 05:17:33 -0600
Received: from DFLE102.ent.ti.com (10.64.6.23) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Thu, 6 Feb
 2020 05:17:32 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Thu, 6 Feb 2020 05:17:32 -0600
Received: from lta0400828a.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 016BHUWH011314;
        Thu, 6 Feb 2020 05:17:30 -0600
From:   Roger Quadros <rogerq@ti.com>
To:     <hdegoede@redhat.com>, <axboe@kernel.dk>
CC:     <vigneshr@ti.com>, <nsekhar@ti.com>, <linux-ide@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] ata: ahci_platform: add 32-bit quirk for dwc-ahci
Date:   Thu, 6 Feb 2020 13:17:28 +0200
Message-ID: <20200206111728.6703-1-rogerq@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On TI Platforms using LPAE, SATA breaks with 64-bit DMA.
Restrict it to 32-bit.

Cc: stable@vger.kernel.org
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/ata/ahci_platform.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index 3aab2e3d57f3..b925dc54cfa5 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -62,6 +62,9 @@ static int ahci_probe(struct platform_device *pdev)
 	if (of_device_is_compatible(dev->of_node, "hisilicon,hisi-ahci"))
 		hpriv->flags |= AHCI_HFLAG_NO_FBS | AHCI_HFLAG_NO_NCQ;
 
+	if (of_device_is_compatible(dev->of_node, "snps,dwc-ahci"))
+		hpriv->flags |= AHCI_HFLAG_32BIT_ONLY;
+
 	port = acpi_device_get_match_data(dev);
 	if (!port)
 		port = &ahci_port_info;
-- 
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki

