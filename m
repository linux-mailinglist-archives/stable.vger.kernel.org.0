Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9491163219D
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 13:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiKUMJo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 07:09:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiKUMJn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 07:09:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F751FCFD
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 04:09:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90B40B80ED5
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 12:09:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3049CC433C1;
        Mon, 21 Nov 2022 12:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669032580;
        bh=amAlRXOojG5f+ZGaf4nsx5jj1pZnuzLMjahZnRKnEys=;
        h=Subject:To:Cc:From:Date:From;
        b=Hiz8xhlZtMyAoC9mc9inl58NR40qR/gHMjI1226pwmeUtJRfxWrqWWVXnPmUNW60L
         d5piIAXV3TqLg/NPvaajHL1ae/s7NbD2fUJAlzhaj9HYErmRZaN/laJKzxWeWgOt+9
         83pCa+g9EEuULvWDK7SXq9NkUOVQUhIyenQ1UGyI=
Subject: FAILED: patch "[PATCH] iommu/vt-d: Set SRE bit only when hardware has SRS cap" failed to apply to 5.4-stable tree
To:     tina.zhang@intel.com, baolu.lu@linux.intel.com, jroedel@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Nov 2022 13:09:35 +0100
Message-ID: <1669032575216142@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

7fc961cf7ffc ("iommu/vt-d: Set SRE bit only when hardware has SRS cap")
54c80d907400 ("iommu/vt-d: Use user privilege for RID2PASID translation")
672cf6df9b8a ("iommu/vt-d: Move Intel IOMMU driver into subdirectory")
3b50142d8528 ("MAINTAINERS: sort field names for all entries")
4400b7d68f6e ("MAINTAINERS: sort entries by entry name")
b032227c6293 ("Merge tag 'nios2-v5.7-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/lftan/nios2")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7fc961cf7ffcb130c4e93ee9a5628134f9de700a Mon Sep 17 00:00:00 2001
From: Tina Zhang <tina.zhang@intel.com>
Date: Wed, 16 Nov 2022 13:15:44 +0800
Subject: [PATCH] iommu/vt-d: Set SRE bit only when hardware has SRS cap

SRS cap is the hardware cap telling if the hardware IOMMU can support
requests seeking supervisor privilege or not. SRE bit in scalable-mode
PASID table entry is treated as Reserved(0) for implementation not
supporting SRS cap.

Checking SRS cap before setting SRE bit can avoid the non-recoverable
fault of "Non-zero reserved field set in PASID Table Entry" caused by
setting SRE bit while there is no SRS cap support. The fault messages
look like below:

 DMAR: DRHD: handling fault status reg 2
 DMAR: [DMA Read NO_PASID] Request device [00:0d.0] fault addr 0x1154e1000
       [fault reason 0x5a]
       SM: Non-zero reserved field set in PASID Table Entry

Fixes: 6f7db75e1c46 ("iommu/vt-d: Add second level page table interface")
Cc: stable@vger.kernel.org
Signed-off-by: Tina Zhang <tina.zhang@intel.com>
Link: https://lore.kernel.org/r/20221115070346.1112273-1-tina.zhang@intel.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20221116051544.26540-3-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>

diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index c30ddac40ee5..e13d7e5273e1 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -642,7 +642,7 @@ int intel_pasid_setup_second_level(struct intel_iommu *iommu,
 	 * Since it is a second level only translation setup, we should
 	 * set SRE bit as well (addresses are expected to be GPAs).
 	 */
-	if (pasid != PASID_RID2PASID)
+	if (pasid != PASID_RID2PASID && ecap_srs(iommu->ecap))
 		pasid_set_sre(pte);
 	pasid_set_present(pte);
 	spin_unlock(&iommu->lock);
@@ -685,7 +685,8 @@ int intel_pasid_setup_pass_through(struct intel_iommu *iommu,
 	 * We should set SRE bit as well since the addresses are expected
 	 * to be GPAs.
 	 */
-	pasid_set_sre(pte);
+	if (ecap_srs(iommu->ecap))
+		pasid_set_sre(pte);
 	pasid_set_present(pte);
 	spin_unlock(&iommu->lock);
 

