Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 660D418A5FE
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 22:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbgCRUzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 16:55:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:55014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727259AbgCRUzA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 16:55:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63A8F2173E;
        Wed, 18 Mar 2020 20:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564900;
        bh=r7+VUzxjLQB4PABrIOlLBl4f8gaO2eLJmpqEIWbWdWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oga0jxxlqqSiGLSx1rFZGG/WmV4fwgFhf8+JlgkGodTwi3dqevJKc6UskhESU852z
         lTFXZPk3z1jCL1kR1I9FgMcbesbqAtR3dMyCp4mu6MNCcU6OkED798NXdlYUvaQso4
         1Wc+8dR/F8Pf63sHO6alVr9ICddq1yCq7dA5BJi0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.4 67/73] iommu/vt-d: quirk_ioat_snb_local_iommu: replace WARN_TAINT with pr_warn + add_taint
Date:   Wed, 18 Mar 2020 16:53:31 -0400
Message-Id: <20200318205337.16279-67-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205337.16279-1-sashal@kernel.org>
References: <20200318205337.16279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 81ee85d0462410de8eeeec1b9761941fd6ed8c7b ]

Quoting from the comment describing the WARN functions in
include/asm-generic/bug.h:

 * WARN(), WARN_ON(), WARN_ON_ONCE, and so on can be used to report
 * significant kernel issues that need prompt attention if they should ever
 * appear at runtime.
 *
 * Do not use these macros when checking for invalid external inputs

The (buggy) firmware tables which the dmar code was calling WARN_TAINT
for really are invalid external inputs. They are not under the kernel's
control and the issues in them cannot be fixed by a kernel update.
So logging a backtrace, which invites bug reports to be filed about this,
is not helpful.

Fixes: 556ab45f9a77 ("ioat2: catch and recover from broken vtd configurations v6")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20200309182510.373875-1-hdegoede@redhat.com
BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=701847
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel-iommu.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 9b3d169c6ff53..be39363244389 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -4129,10 +4129,11 @@ static void quirk_ioat_snb_local_iommu(struct pci_dev *pdev)
 
 	/* we know that the this iommu should be at offset 0xa000 from vtbar */
 	drhd = dmar_find_matched_drhd_unit(pdev);
-	if (WARN_TAINT_ONCE(!drhd || drhd->reg_base_addr - vtbar != 0xa000,
-			    TAINT_FIRMWARE_WORKAROUND,
-			    "BIOS assigned incorrect VT-d unit for Intel(R) QuickData Technology device\n"))
+	if (!drhd || drhd->reg_base_addr - vtbar != 0xa000) {
+		pr_warn_once(FW_BUG "BIOS assigned incorrect VT-d unit for Intel(R) QuickData Technology device\n");
+		add_taint(TAINT_FIRMWARE_WORKAROUND, LOCKDEP_STILL_OK);
 		pdev->dev.archdata.iommu = DUMMY_DEVICE_DOMAIN_INFO;
+	}
 }
 DECLARE_PCI_FIXUP_ENABLE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_SNB, quirk_ioat_snb_local_iommu);
 
-- 
2.20.1

