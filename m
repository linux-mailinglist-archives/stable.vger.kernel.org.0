Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E86A815DD79
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 16:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388658AbgBNP6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:58:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:42842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388562AbgBNP6l (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:58:41 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F02F24681;
        Fri, 14 Feb 2020 15:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695920;
        bh=6zXHtMvPOWZZVz1WXnJVvUXrtnS42BuV0zOkgI24V18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QvnDNDAYwCbAmXqYxZQ2eXsky9o+7zuKJOc/9YTvBuSCTq1jKjLLD6PjVMsBj7M/w
         fSYOuMkHd2Btx96ztDzRcKMtZFN+5nsPHSI1fVgXXAGKxQsNWUgnx6Tp7ZEFrV1Qxz
         9wOEEECB0V5B6nw052FlfFvwddVBjZ745oABbX5I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Barret Rhoden <brho@google.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.5 458/542] iommu/vt-d: Mark firmware tainted if RMRR fails sanity check
Date:   Fri, 14 Feb 2020 10:47:30 -0500
Message-Id: <20200214154854.6746-458-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Barret Rhoden <brho@google.com>

[ Upstream commit f5a68bb0752e0cf77c06f53f72258e7beb41381b ]

RMRR entries describe memory regions that are DMA targets for devices
outside the kernel's control.

RMRR entries that fail the sanity check are pointing to regions of
memory that the firmware did not tell the kernel are reserved or
otherwise should not be used.

Instead of aborting DMAR processing, this commit marks the firmware
as tainted. These RMRRs will still be identity mapped, otherwise,
some devices, e.x. graphic devices, will not work during boot.

Signed-off-by: Barret Rhoden <brho@google.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Fixes: f036c7fa0ab60 ("iommu/vt-d: Check VT-d RMRR region in BIOS is reported as reserved")
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel-iommu.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 541896ab3d086..dfedbb04f647d 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -4320,12 +4320,16 @@ int __init dmar_parse_one_rmrr(struct acpi_dmar_header *header, void *arg)
 {
 	struct acpi_dmar_reserved_memory *rmrr;
 	struct dmar_rmrr_unit *rmrru;
-	int ret;
 
 	rmrr = (struct acpi_dmar_reserved_memory *)header;
-	ret = arch_rmrr_sanity_check(rmrr);
-	if (ret)
-		return ret;
+	if (arch_rmrr_sanity_check(rmrr))
+		WARN_TAINT(1, TAINT_FIRMWARE_WORKAROUND,
+			   "Your BIOS is broken; bad RMRR [%#018Lx-%#018Lx]\n"
+			   "BIOS vendor: %s; Ver: %s; Product Version: %s\n",
+			   rmrr->base_address, rmrr->end_address,
+			   dmi_get_system_info(DMI_BIOS_VENDOR),
+			   dmi_get_system_info(DMI_BIOS_VERSION),
+			   dmi_get_system_info(DMI_PRODUCT_VERSION));
 
 	rmrru = kzalloc(sizeof(*rmrru), GFP_KERNEL);
 	if (!rmrru)
-- 
2.20.1

