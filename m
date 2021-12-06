Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 991B8469EBA
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232136AbhLFPnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:43:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357960AbhLFPiA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:38:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA5BC08EAEB;
        Mon,  6 Dec 2021 07:23:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86477B8111C;
        Mon,  6 Dec 2021 15:23:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFB7EC341C6;
        Mon,  6 Dec 2021 15:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804231;
        bh=DqbYj/mvzfOb/qAm0GYxjFamM5U2VUdc0EP9JoYjnNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rLnimRDDIxemzEPusdE8IXiPMlWzj7ENqGwBXAub9UjSreV22IOlu19DHqaBf32rc
         ztsFAiwXu8580L58C7QT5npg2zgNlLrxL2aKqWSysQ0HI+rFIfn9xRdpk+f8nSyIHZ
         S9ImdsNOTPxsEZEM4kLN0K/tBMTx1vD9n+Bv12wg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 066/207] scsi: ufs: ufs-pci: Add support for Intel ADL
Date:   Mon,  6 Dec 2021 15:55:20 +0100
Message-Id: <20211206145612.523023691@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit 7dc9fb47bc9a95f1cc6c5655341860c5e50f91d4 upstream.

Add PCI ID and callbacks to support Intel Alder Lake.

Link: https://lore.kernel.org/r/20211124204218.1784559-1-adrian.hunter@intel.com
Cc: stable@vger.kernel.org # v5.15+
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/ufs/ufshcd-pci.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -421,6 +421,13 @@ static int ufs_intel_lkf_init(struct ufs
 	return err;
 }
 
+static int ufs_intel_adl_init(struct ufs_hba *hba)
+{
+	hba->nop_out_timeout = 200;
+	hba->quirks |= UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8;
+	return ufs_intel_common_init(hba);
+}
+
 static struct ufs_hba_variant_ops ufs_intel_cnl_hba_vops = {
 	.name                   = "intel-pci",
 	.init			= ufs_intel_common_init,
@@ -449,6 +456,15 @@ static struct ufs_hba_variant_ops ufs_in
 	.device_reset		= ufs_intel_device_reset,
 };
 
+static struct ufs_hba_variant_ops ufs_intel_adl_hba_vops = {
+	.name			= "intel-pci",
+	.init			= ufs_intel_adl_init,
+	.exit			= ufs_intel_common_exit,
+	.link_startup_notify	= ufs_intel_link_startup_notify,
+	.resume			= ufs_intel_resume,
+	.device_reset		= ufs_intel_device_reset,
+};
+
 #ifdef CONFIG_PM_SLEEP
 static int ufshcd_pci_restore(struct device *dev)
 {
@@ -563,6 +579,8 @@ static const struct pci_device_id ufshcd
 	{ PCI_VDEVICE(INTEL, 0x4B41), (kernel_ulong_t)&ufs_intel_ehl_hba_vops },
 	{ PCI_VDEVICE(INTEL, 0x4B43), (kernel_ulong_t)&ufs_intel_ehl_hba_vops },
 	{ PCI_VDEVICE(INTEL, 0x98FA), (kernel_ulong_t)&ufs_intel_lkf_hba_vops },
+	{ PCI_VDEVICE(INTEL, 0x51FF), (kernel_ulong_t)&ufs_intel_adl_hba_vops },
+	{ PCI_VDEVICE(INTEL, 0x54FF), (kernel_ulong_t)&ufs_intel_adl_hba_vops },
 	{ }	/* terminate list */
 };
 


