Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE0F41060EC
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 06:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728786AbfKVFxH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:53:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:59086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728779AbfKVFxG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:53:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0597E2084B;
        Fri, 22 Nov 2019 05:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401985;
        bh=vTnqRBhSJThxK31D6vHxdhMGVr8Vgn7F/eGcARVmDAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wfcE+SYGXsak2mRNeEa1tKTBcTXEh37aioE2GYcxIqy6HcQZ2D9LrdH65vUx/xNFl
         MPob3ERQiwb9UfAEpVcRMNnLSOsmaHxqH5noFQPsxeff18tT2o2JYGr+LlYCXuG8sM
         iGsTkqAMIjt9vgdvk4uwM9uryT66N+vMo/Ji2WZE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aaron Ma <aaron.ma@canonical.com>, Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 4.19 204/219] iommu/amd: Fix NULL dereference bug in match_hid_uid
Date:   Fri, 22 Nov 2019 00:48:55 -0500
Message-Id: <20191122054911.1750-196-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaron Ma <aaron.ma@canonical.com>

[ Upstream commit bb6bccba390c7d743c1e4427de4ef284c8cc6869 ]

Add a non-NULL check to fix potential NULL pointer dereference
Cleanup code to call function once.

Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
Fixes: 2bf9a0a12749b ('iommu/amd: Add iommu support for ACPI HID devices')
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd_iommu.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 1f2ed44de2438..fe18804a50083 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -139,10 +139,14 @@ static struct lock_class_key reserved_rbtree_key;
 static inline int match_hid_uid(struct device *dev,
 				struct acpihid_map_entry *entry)
 {
+	struct acpi_device *adev = ACPI_COMPANION(dev);
 	const char *hid, *uid;
 
-	hid = acpi_device_hid(ACPI_COMPANION(dev));
-	uid = acpi_device_uid(ACPI_COMPANION(dev));
+	if (!adev)
+		return -ENODEV;
+
+	hid = acpi_device_hid(adev);
+	uid = acpi_device_uid(adev);
 
 	if (!hid || !(*hid))
 		return -ENODEV;
-- 
2.20.1

