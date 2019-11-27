Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E111710BCDB
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727197AbfK0VCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:02:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:55864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731959AbfK0VCw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:02:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54AF4215F1;
        Wed, 27 Nov 2019 21:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888571;
        bh=iPFtIhlFnF1IDIP9CFvA7qpSv6U66EhbaLGNIWWMfT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ade925yB9HuhNluVKLjwEVTMtaCc/NurzJFAr/8s/y9pBRuZx0wrW5uF4/30TKPv6
         PwT8YEjfGwCsucm9SC9SQLFc8xFUvAyLdsFejvblF7J3AMapFrzdjCkfgDhjfo0sCw
         lMwLn0K6gWgUT4PrX0luNKvOlsTCuYe2ocVvC0YI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacob Keller <jacob.e.keller@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 184/306] fm10k: ensure completer aborts are marked as non-fatal after a resume
Date:   Wed, 27 Nov 2019 21:30:34 +0100
Message-Id: <20191127203128.734577348@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit e330af788998b0de4da4f5bd7ddd087507999800 ]

VF drivers can trigger PCIe completer aborts any time they read a queue
that they don't own. Even in nominal circumstances, it is not possible
to prevent the VF driver from reading queues it doesn't own. VF drivers
may attempt to read queues it previously owned, but which it no longer
does due to a PF reset.

Normally these completer aborts aren't an issue. However, on some
platforms these trigger machine check errors. This is true even if we
lower their severity from fatal to non-fatal. Indeed, we already have
code for lowering the severity.

We could attempt to mask these errors conditionally around resets, which
is the most common time they would occur. However this would essentially
be a race between the PF and VF drivers, and we may still occasionally
see machine check exceptions on these strictly configured platforms.

Instead, mask the errors entirely any time we resume VFs. By doing so,
we prevent the completer aborts from being sent to the parent PCIe
device, and thus these strict platforms will not upgrade them into
machine check errors.

Additionally, we don't lose any information by masking these errors,
because we'll still report VFs which attempt to access queues via the
FUM_BAD_VF_QACCESS errors.

Without this change, on platforms where completer aborts cause machine
check exceptions, the VF reading queues it doesn't own could crash the
host system. Masking the completer abort prevents this, so we should
mask it for good, and not just around a PCIe reset. Otherwise malicious
or misconfigured VFs could cause the host system to crash.

Because we are masking the error entirely, there is little reason to
also keep setting the severity bit, so that code is also removed.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/fm10k/fm10k_iov.c | 48 ++++++++++++--------
 1 file changed, 28 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_iov.c b/drivers/net/ethernet/intel/fm10k/fm10k_iov.c
index e707d717012fa..618032612f52d 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_iov.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_iov.c
@@ -302,6 +302,28 @@ void fm10k_iov_suspend(struct pci_dev *pdev)
 	}
 }
 
+static void fm10k_mask_aer_comp_abort(struct pci_dev *pdev)
+{
+	u32 err_mask;
+	int pos;
+
+	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_ERR);
+	if (!pos)
+		return;
+
+	/* Mask the completion abort bit in the ERR_UNCOR_MASK register,
+	 * preventing the device from reporting these errors to the upstream
+	 * PCIe root device. This avoids bringing down platforms which upgrade
+	 * non-fatal completer aborts into machine check exceptions. Completer
+	 * aborts can occur whenever a VF reads a queue it doesn't own.
+	 */
+	pci_read_config_dword(pdev, pos + PCI_ERR_UNCOR_MASK, &err_mask);
+	err_mask |= PCI_ERR_UNC_COMP_ABORT;
+	pci_write_config_dword(pdev, pos + PCI_ERR_UNCOR_MASK, err_mask);
+
+	mmiowb();
+}
+
 int fm10k_iov_resume(struct pci_dev *pdev)
 {
 	struct fm10k_intfc *interface = pci_get_drvdata(pdev);
@@ -317,6 +339,12 @@ int fm10k_iov_resume(struct pci_dev *pdev)
 	if (!iov_data)
 		return -ENOMEM;
 
+	/* Lower severity of completer abort error reporting as
+	 * the VFs can trigger this any time they read a queue
+	 * that they don't own.
+	 */
+	fm10k_mask_aer_comp_abort(pdev);
+
 	/* allocate hardware resources for the VFs */
 	hw->iov.ops.assign_resources(hw, num_vfs, num_vfs);
 
@@ -460,20 +488,6 @@ void fm10k_iov_disable(struct pci_dev *pdev)
 	fm10k_iov_free_data(pdev);
 }
 
-static void fm10k_disable_aer_comp_abort(struct pci_dev *pdev)
-{
-	u32 err_sev;
-	int pos;
-
-	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_ERR);
-	if (!pos)
-		return;
-
-	pci_read_config_dword(pdev, pos + PCI_ERR_UNCOR_SEVER, &err_sev);
-	err_sev &= ~PCI_ERR_UNC_COMP_ABORT;
-	pci_write_config_dword(pdev, pos + PCI_ERR_UNCOR_SEVER, err_sev);
-}
-
 int fm10k_iov_configure(struct pci_dev *pdev, int num_vfs)
 {
 	int current_vfs = pci_num_vf(pdev);
@@ -495,12 +509,6 @@ int fm10k_iov_configure(struct pci_dev *pdev, int num_vfs)
 
 	/* allocate VFs if not already allocated */
 	if (num_vfs && num_vfs != current_vfs) {
-		/* Disable completer abort error reporting as
-		 * the VFs can trigger this any time they read a queue
-		 * that they don't own.
-		 */
-		fm10k_disable_aer_comp_abort(pdev);
-
 		err = pci_enable_sriov(pdev, num_vfs);
 		if (err) {
 			dev_err(&pdev->dev,
-- 
2.20.1



