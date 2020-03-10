Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DECD17F89C
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727865AbgCJMtb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:49:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:53906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728132AbgCJMtb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:49:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 621EB2468D;
        Tue, 10 Mar 2020 12:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844570;
        bh=h8EAJl19Wp0HALYjFidwI9cUFJDeGchtkcXLkJUuArs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2kWF3TqrNNCYdcOzRzpoq64p+e84vhdu1U+5lHLev2v/Fk83H2B7Y4Kq7ReRG4kRJ
         EeL5RJ0c/an17Y4Uqg9szo6AWtiUrsejqlxHZYgnmIy6/el+8G8OdISrcDbG/dlrcM
         yXlI7JyY4gZhAQFqctUEK5GjCUrga8JIsPYPuv60=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 041/168] iommu/amd: Disable IOMMU on Stoney Ridge systems
Date:   Tue, 10 Mar 2020 13:38:07 +0100
Message-Id: <20200310123639.555161702@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit 3dfee47b215e49788cfc80e474820ea2e948c031 ]

Serious screen flickering when Stoney Ridge outputs to a 4K monitor.

Use identity-mapping and PCI ATS doesn't help this issue.

According to Alex Deucher, IOMMU isn't enabled on Windows, so let's do
the same here to avoid screen flickering on 4K monitor.

Cc: Alex Deucher <alexander.deucher@amd.com>
Bug: https://gitlab.freedesktop.org/drm/amd/issues/961
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd_iommu_init.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index d7cbca8bf2cd4..b5ae9f7c0510b 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -2533,6 +2533,7 @@ static int __init early_amd_iommu_init(void)
 	struct acpi_table_header *ivrs_base;
 	acpi_status status;
 	int i, remap_cache_sz, ret = 0;
+	u32 pci_id;
 
 	if (!amd_iommu_detected)
 		return -ENODEV;
@@ -2620,6 +2621,16 @@ static int __init early_amd_iommu_init(void)
 	if (ret)
 		goto out;
 
+	/* Disable IOMMU if there's Stoney Ridge graphics */
+	for (i = 0; i < 32; i++) {
+		pci_id = read_pci_config(0, i, 0, 0);
+		if ((pci_id & 0xffff) == 0x1002 && (pci_id >> 16) == 0x98e4) {
+			pr_info("Disable IOMMU on Stoney Ridge\n");
+			amd_iommu_disabled = true;
+			break;
+		}
+	}
+
 	/* Disable any previously enabled IOMMUs */
 	if (!is_kdump_kernel() || amd_iommu_disabled)
 		disable_iommus();
@@ -2728,7 +2739,7 @@ static int __init state_next(void)
 		ret = early_amd_iommu_init();
 		init_state = ret ? IOMMU_INIT_ERROR : IOMMU_ACPI_FINISHED;
 		if (init_state == IOMMU_ACPI_FINISHED && amd_iommu_disabled) {
-			pr_info("AMD IOMMU disabled on kernel command-line\n");
+			pr_info("AMD IOMMU disabled\n");
 			init_state = IOMMU_CMDLINE_DISABLED;
 			ret = -EINVAL;
 		}
-- 
2.20.1



