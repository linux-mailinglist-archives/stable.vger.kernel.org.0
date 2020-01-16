Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50B4813E373
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729263AbgAPRCJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:02:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:54482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388276AbgAPRCJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:02:09 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B15E21D56;
        Thu, 16 Jan 2020 17:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194128;
        bh=+2g8YbRkKj4/ek6gIMPpD8fSakK9WKulrjtOujpsfPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KkPLUsO51UWJ4wdD1bJU6qkmUXqER31E1miB0OYTybhJ9Amkm+3ZpJjhIEjwW2Sjk
         Fv6kVJ9DKltMHEcaOIJKuuEFNdl052ZqbUoFx9lMuhqxgDj9dWJmDb/vF/xle8lO4u
         NXqbDecvwr/brunVztAjFFomVhrmdDqiJnYrR8Xk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Gary R Hook <gary.hook@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 4.19 219/671] iommu: Fix IOMMU debugfs fallout
Date:   Thu, 16 Jan 2020 11:52:08 -0500
Message-Id: <20200116165940.10720-102-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 18b3af4492a0aa6046b86d712f6ba4cbb66100fb ]

A change made in the final version of IOMMU debugfs support replaced the
public function iommu_debugfs_new_driver_dir() by the public dentry
iommu_debugfs_dir in <linux/iommu.h>, but forgot to update both the
implementation in iommu-debugfs.c, and the patch description.

Fix this by exporting iommu_debugfs_dir, and removing the reference to
and implementation of iommu_debugfs_new_driver_dir().

Fixes: bad614b24293ae46 ("iommu: Enable debugfs exposure of IOMMU driver internals")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Gary R Hook <gary.hook@amd.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommu-debugfs.c | 23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/drivers/iommu/iommu-debugfs.c b/drivers/iommu/iommu-debugfs.c
index 3b1bf88fd1b0..f03548942096 100644
--- a/drivers/iommu/iommu-debugfs.c
+++ b/drivers/iommu/iommu-debugfs.c
@@ -12,6 +12,7 @@
 #include <linux/debugfs.h>
 
 struct dentry *iommu_debugfs_dir;
+EXPORT_SYMBOL_GPL(iommu_debugfs_dir);
 
 /**
  * iommu_debugfs_setup - create the top-level iommu directory in debugfs
@@ -23,9 +24,9 @@ struct dentry *iommu_debugfs_dir;
  * Emit a strong warning at boot time to indicate that this feature is
  * enabled.
  *
- * This function is called from iommu_init; drivers may then call
- * iommu_debugfs_new_driver_dir() to instantiate a vendor-specific
- * directory to be used to expose internal data.
+ * This function is called from iommu_init; drivers may then use
+ * iommu_debugfs_dir to instantiate a vendor-specific directory to be used
+ * to expose internal data.
  */
 void iommu_debugfs_setup(void)
 {
@@ -48,19 +49,3 @@ void iommu_debugfs_setup(void)
 		pr_warn("*************************************************************\n");
 	}
 }
-
-/**
- * iommu_debugfs_new_driver_dir - create a vendor directory under debugfs/iommu
- * @vendor: name of the vendor-specific subdirectory to create
- *
- * This function is called by an IOMMU driver to create the top-level debugfs
- * directory for that driver.
- *
- * Return: upon success, a pointer to the dentry for the new directory.
- *         NULL in case of failure.
- */
-struct dentry *iommu_debugfs_new_driver_dir(const char *vendor)
-{
-	return debugfs_create_dir(vendor, iommu_debugfs_dir);
-}
-EXPORT_SYMBOL_GPL(iommu_debugfs_new_driver_dir);
-- 
2.20.1

