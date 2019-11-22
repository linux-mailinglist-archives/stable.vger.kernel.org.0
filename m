Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A29A91061C1
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 06:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727665AbfKVF6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:58:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:36624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729592AbfKVF6A (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:58:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D75B207FA;
        Fri, 22 Nov 2019 05:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402280;
        bh=lHb8nb/xLhqlCfKyPOxFc1Drdc9QqB8nk+WE0IyxIF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R5JZpB8J4ZwZ5HyiLGC4OV7avZDTB+WhhToWJElUF4bEVji4FOmep4dGTsasFR/n2
         3Q8yB8+0mo1YJv1u3puP248qOqvb3WwwcAWUbzEBIJpT2Gy3qwBEOlhycigFiV5rXK
         00f8mbKFHDzdfUSmIiwyfC0q5P5y6tIKkVTftra4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aaron Ma <aaron.ma@canonical.com>, Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 4.14 119/127] iommu/amd: Fix NULL dereference bug in match_hid_uid
Date:   Fri, 22 Nov 2019 00:55:36 -0500
Message-Id: <20191122055544.3299-117-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122055544.3299-1-sashal@kernel.org>
References: <20191122055544.3299-1-sashal@kernel.org>
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
index 07b6cf58fd99b..d09c24825734e 100644
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

