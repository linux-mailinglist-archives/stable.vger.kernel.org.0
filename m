Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8892E5CC6
	for <lists+stable@lfdr.de>; Sat, 26 Oct 2019 15:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbfJZNSN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Oct 2019 09:18:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:39824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727689AbfJZNSL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Oct 2019 09:18:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 232A7222C1;
        Sat, 26 Oct 2019 13:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095891;
        bh=dLdwn7YwP9Q8YuRYcjz7At87CX/uoTurZZGIHkt97z0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AVgI1AFw2Zp7brB4Sd7T3yp58jZ2vndhxjwvD47T5mGbWKMi7xSCul28Y61PPRyJU
         9RFYXCXkpSW4hW1aY7fv0u+6OlMD57RbesPALnGOQkF2qPFj+eZsagAkN4UWq7Ecb3
         VbtbRK0v9He9buZOTHdnQm4MtNxhPd2v4rmm6zo8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        Gary R Hook <gary.hook@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.3 73/99] iommu/amd: Fix incorrect PASID decoding from event log
Date:   Sat, 26 Oct 2019 09:15:34 -0400
Message-Id: <20191026131600.2507-73-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131600.2507-1-sashal@kernel.org>
References: <20191026131600.2507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>

[ Upstream commit ec21f17a9437e11bb29e5fa375aa31b472793c15 ]

IOMMU Event Log encodes 20-bit PASID for events:
    ILLEGAL_DEV_TABLE_ENTRY
    IO_PAGE_FAULT
    PAGE_TAB_HARDWARE_ERROR
    INVALID_DEVICE_REQUEST
as:
    PASID[15:0]  = bit 47:32
    PASID[19:16] = bit 19:16

Note that INVALID_PPR_REQUEST event has different encoding
from the rest of the events as the following:
    PASID[15:0]  = bit 31:16
    PASID[19:16] = bit 45:42

So, fixes the decoding logic.

Fixes: d64c0486ed50 ("iommu/amd: Update the PASID information printed to the system log")
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Gary R Hook <gary.hook@amd.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd_iommu.c       | 5 +++--
 drivers/iommu/amd_iommu_types.h | 4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 3b1d7ae6f75e0..79b113a2b779e 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -560,7 +560,8 @@ static void iommu_print_event(struct amd_iommu *iommu, void *__evt)
 retry:
 	type    = (event[1] >> EVENT_TYPE_SHIFT)  & EVENT_TYPE_MASK;
 	devid   = (event[0] >> EVENT_DEVID_SHIFT) & EVENT_DEVID_MASK;
-	pasid   = PPR_PASID(*(u64 *)&event[0]);
+	pasid   = (event[0] & EVENT_DOMID_MASK_HI) |
+		  (event[1] & EVENT_DOMID_MASK_LO);
 	flags   = (event[1] >> EVENT_FLAGS_SHIFT) & EVENT_FLAGS_MASK;
 	address = (u64)(((u64)event[3]) << 32) | event[2];
 
@@ -593,7 +594,7 @@ static void iommu_print_event(struct amd_iommu *iommu, void *__evt)
 			address, flags);
 		break;
 	case EVENT_TYPE_PAGE_TAB_ERR:
-		dev_err(dev, "Event logged [PAGE_TAB_HARDWARE_ERROR device=%02x:%02x.%x domain=0x%04x address=0x%llx flags=0x%04x]\n",
+		dev_err(dev, "Event logged [PAGE_TAB_HARDWARE_ERROR device=%02x:%02x.%x pasid=0x%04x address=0x%llx flags=0x%04x]\n",
 			PCI_BUS_NUM(devid), PCI_SLOT(devid), PCI_FUNC(devid),
 			pasid, address, flags);
 		break;
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index 64edd5a9694cc..5a698ad23d50f 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -130,8 +130,8 @@
 #define EVENT_TYPE_INV_PPR_REQ	0x9
 #define EVENT_DEVID_MASK	0xffff
 #define EVENT_DEVID_SHIFT	0
-#define EVENT_DOMID_MASK	0xffff
-#define EVENT_DOMID_SHIFT	0
+#define EVENT_DOMID_MASK_LO	0xffff
+#define EVENT_DOMID_MASK_HI	0xf0000
 #define EVENT_FLAGS_MASK	0xfff
 #define EVENT_FLAGS_SHIFT	0x10
 
-- 
2.20.1

