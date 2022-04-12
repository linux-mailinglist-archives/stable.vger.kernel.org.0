Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B012E4FD4A0
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343874AbiDLHcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353684AbiDLHZv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:25:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 814EB275E7;
        Tue, 12 Apr 2022 00:03:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40AAAB81B4F;
        Tue, 12 Apr 2022 07:03:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE6AC385A6;
        Tue, 12 Apr 2022 07:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747016;
        bh=XAj7FCfm0M/jy4rFK9gDsnIs+X5IJ8/MZGnWY/bFg0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bzWojVxqGa33efcml94VqSxxkRoWjwJD2lANT9nrDPNIKgYALWy/HVnO9Id0dhOdl
         6InCBt1WzwJlajctcyk2NuG1U4IzoqIzis8bvYk/f6EAbMK4Eo3sMwej+mCUgyqfVv
         lBOACpSIX8OaBQFcnZc27czJf659cLNBoD0dip9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.16 214/285] scsi: ufs: ufs-pci: Add support for Intel MTL
Date:   Tue, 12 Apr 2022 08:31:11 +0200
Message-Id: <20220412062949.834426664@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit 4049f7acef3eb37c1ea0df45f3ffc29404f4e708 upstream.

Add PCI ID and callbacks to support Intel Meteor Lake (MTL).

Link: https://lore.kernel.org/r/20220404055038.2208051-1-adrian.hunter@intel.com
Cc: stable@vger.kernel.org # v5.15+
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/ufs/ufshcd-pci.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -428,6 +428,12 @@ static int ufs_intel_adl_init(struct ufs
 	return ufs_intel_common_init(hba);
 }
 
+static int ufs_intel_mtl_init(struct ufs_hba *hba)
+{
+	hba->caps |= UFSHCD_CAP_CRYPTO | UFSHCD_CAP_WB_EN;
+	return ufs_intel_common_init(hba);
+}
+
 static struct ufs_hba_variant_ops ufs_intel_cnl_hba_vops = {
 	.name                   = "intel-pci",
 	.init			= ufs_intel_common_init,
@@ -465,6 +471,16 @@ static struct ufs_hba_variant_ops ufs_in
 	.device_reset		= ufs_intel_device_reset,
 };
 
+static struct ufs_hba_variant_ops ufs_intel_mtl_hba_vops = {
+	.name                   = "intel-pci",
+	.init			= ufs_intel_mtl_init,
+	.exit			= ufs_intel_common_exit,
+	.hce_enable_notify	= ufs_intel_hce_enable_notify,
+	.link_startup_notify	= ufs_intel_link_startup_notify,
+	.resume			= ufs_intel_resume,
+	.device_reset		= ufs_intel_device_reset,
+};
+
 #ifdef CONFIG_PM_SLEEP
 static int ufshcd_pci_restore(struct device *dev)
 {
@@ -579,6 +595,7 @@ static const struct pci_device_id ufshcd
 	{ PCI_VDEVICE(INTEL, 0x98FA), (kernel_ulong_t)&ufs_intel_lkf_hba_vops },
 	{ PCI_VDEVICE(INTEL, 0x51FF), (kernel_ulong_t)&ufs_intel_adl_hba_vops },
 	{ PCI_VDEVICE(INTEL, 0x54FF), (kernel_ulong_t)&ufs_intel_adl_hba_vops },
+	{ PCI_VDEVICE(INTEL, 0x7E47), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
 	{ }	/* terminate list */
 };
 


