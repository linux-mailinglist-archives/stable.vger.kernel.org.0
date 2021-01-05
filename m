Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A7B2EA20A
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 02:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727927AbhAEBAD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 20:00:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:38772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727905AbhAEBAC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 20:00:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4125F22582;
        Tue,  5 Jan 2021 00:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609808361;
        bh=jCNVPeOnIUB1NtbTFC3Anj//bhI87IHO9E0tIhWQgbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tbIzuCxzOh90GmIykFypUaD3GhYA3pb71PPIE2imtXFedA1h89pveCuadqbP5o3p1
         oKL+GijahQarX32uAKIEs+Oe5ojDTAADuNJSyMxq/s4aAXXYyO8ctXBC5aN3VJK/LY
         yL04uQzSAkL+FMtchTbyNqF7ZeEJm0E09rroOPar/NLZY9n1ztFQCqHzwYmxZ3ZZal
         RZZrmQdmhA9efSEObmO6dpZJto30oaCNnn1sus/J0qiNY176WvoZrx7daXjkQUFcHu
         NzKQFI8qokIUOUqAE//GWQ4cxnUPf9fuUTv9DWSstZcvmpTzWXvJLfs15HYRxhQUD0
         whjLS9zPZR8AA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 04/17] scsi: ufs-pci: Fix restore from S4 for Intel controllers
Date:   Mon,  4 Jan 2021 19:59:02 -0500
Message-Id: <20210105005915.3954208-4-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210105005915.3954208-1-sashal@kernel.org>
References: <20210105005915.3954208-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit c763729a10e538d997744317cf4a1c4f25266066 ]

Currently, ufshcd-pci is the only UFS driver with support for
suspend-to-disk PM callbacks (i.e. freeze/thaw/restore/poweroff). These
callbacks are set by the macro SET_SYSTEM_SLEEP_PM_OPS to the same
functions as system suspend/resume. That will work with spm_lvl 5 because
spm_lvl 5 will result in a full restore for the ->restore() callback.  In
the absence of a full restore, the host controller registers will have
values set up by the restore kernel (the kernel that boots and loads the
restore image) which are not necessarily the same. However it turns out,
the only registers that sometimes need restore are the base address
registers. This has gone un-noticed because, depending on IOMMU settings,
the kernel can end up allocating the same addresses every time.

For Intel controllers, an spm_lvl other than 5 can be used, so to support
S4 (suspend-to-disk) with spm_lvl other than 5, restore the base address
registers.

Link: https://lore.kernel.org/r/20201207083120.26732-2-adrian.hunter@intel.com
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd-pci.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index df3a564c3e334..360c25f1f061a 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -163,6 +163,24 @@ static void ufs_intel_common_exit(struct ufs_hba *hba)
 	intel_ltr_hide(hba->dev);
 }
 
+static int ufs_intel_resume(struct ufs_hba *hba, enum ufs_pm_op op)
+{
+	/*
+	 * To support S4 (suspend-to-disk) with spm_lvl other than 5, the base
+	 * address registers must be restored because the restore kernel can
+	 * have used different addresses.
+	 */
+	ufshcd_writel(hba, lower_32_bits(hba->utrdl_dma_addr),
+		      REG_UTP_TRANSFER_REQ_LIST_BASE_L);
+	ufshcd_writel(hba, upper_32_bits(hba->utrdl_dma_addr),
+		      REG_UTP_TRANSFER_REQ_LIST_BASE_H);
+	ufshcd_writel(hba, lower_32_bits(hba->utmrdl_dma_addr),
+		      REG_UTP_TASK_REQ_LIST_BASE_L);
+	ufshcd_writel(hba, upper_32_bits(hba->utmrdl_dma_addr),
+		      REG_UTP_TASK_REQ_LIST_BASE_H);
+	return 0;
+}
+
 static int ufs_intel_ehl_init(struct ufs_hba *hba)
 {
 	hba->quirks |= UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8;
@@ -174,6 +192,7 @@ static struct ufs_hba_variant_ops ufs_intel_cnl_hba_vops = {
 	.init			= ufs_intel_common_init,
 	.exit			= ufs_intel_common_exit,
 	.link_startup_notify	= ufs_intel_link_startup_notify,
+	.resume			= ufs_intel_resume,
 };
 
 static struct ufs_hba_variant_ops ufs_intel_ehl_hba_vops = {
@@ -181,6 +200,7 @@ static struct ufs_hba_variant_ops ufs_intel_ehl_hba_vops = {
 	.init			= ufs_intel_ehl_init,
 	.exit			= ufs_intel_common_exit,
 	.link_startup_notify	= ufs_intel_link_startup_notify,
+	.resume			= ufs_intel_resume,
 };
 
 #ifdef CONFIG_PM_SLEEP
-- 
2.27.0

