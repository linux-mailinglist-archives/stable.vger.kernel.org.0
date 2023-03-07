Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0CE6AE67A
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 17:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjCGQab (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 11:30:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjCGQab (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 11:30:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C37863609A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 08:30:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8048AB81908
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 16:30:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C19D5C433D2;
        Tue,  7 Mar 2023 16:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678206627;
        bh=7itQ7ZUbBGYIlvOasS07nGY2FUrIz9OoRoKwj2+nG8o=;
        h=Subject:To:Cc:From:Date:From;
        b=pfxPwUEBODqfksq/EOneS90yA6m9diumbZRs0lJ21eLVvMKSlLdg16MlN/GVktQoX
         wLAdNcZ4LVdEZGtm/Q5YGKfi31ff5eq4gPn9tgm15pqqa213TCsyhNpnsNFkVdbZAo
         fjLOGweIT0U/CraLlX8bCmpAl4vYO+BobH3p3yas=
Subject: FAILED: patch "[PATCH] iommu/vt-d: Fix PASID directory pointer coherency" failed to apply to 5.15-stable tree
To:     jacob.jun.pan@linux.intel.com, ashok.raj@intel.com,
        baolu.lu@linux.intel.com, jroedel@suse.de, kevin.tian@intel.com,
        stable@vger.kernel.org, sukumar.ghorai@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Mar 2023 17:30:23 +0100
Message-ID: <167820662222233@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x 194b3348bdbb7db65375c72f3f774aee4cc6614e
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167820662222233@kroah.com' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

194b3348bdbb ("iommu/vt-d: Fix PASID directory pointer coherency")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 194b3348bdbb7db65375c72f3f774aee4cc6614e Mon Sep 17 00:00:00 2001
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
Date: Thu, 16 Feb 2023 21:08:15 +0800
Subject: [PATCH] iommu/vt-d: Fix PASID directory pointer coherency

On platforms that do not support IOMMU Extended capability bit 0
Page-walk Coherency, CPU caches are not snooped when IOMMU is accessing
any translation structures. IOMMU access goes only directly to
memory. Intel IOMMU code was missing a flush for the PASID table
directory that resulted in the unrecoverable fault as shown below.

This patch adds clflush calls whenever allocating and updating
a PASID table directory to ensure cache coherency.

On the reverse direction, there's no need to clflush the PASID directory
pointer when we deactivate a context entry in that IOMMU hardware will
not see the old PASID directory pointer after we clear the context entry.
PASID directory entries are also never freed once allocated.

 DMAR: DRHD: handling fault status reg 3
 DMAR: [DMA Read NO_PASID] Request device [00:0d.2] fault addr 0x1026a4000
       [fault reason 0x51] SM: Present bit in Directory Entry is clear
 DMAR: Dump dmar1 table entries for IOVA 0x1026a4000
 DMAR: scalable mode root entry: hi 0x0000000102448001, low 0x0000000101b3e001
 DMAR: context entry: hi 0x0000000000000000, low 0x0000000101b4d401
 DMAR: pasid dir entry: 0x0000000101b4e001
 DMAR: pasid table entry[0]: 0x0000000000000109
 DMAR: pasid table entry[1]: 0x0000000000000001
 DMAR: pasid table entry[2]: 0x0000000000000000
 DMAR: pasid table entry[3]: 0x0000000000000000
 DMAR: pasid table entry[4]: 0x0000000000000000
 DMAR: pasid table entry[5]: 0x0000000000000000
 DMAR: pasid table entry[6]: 0x0000000000000000
 DMAR: pasid table entry[7]: 0x0000000000000000
 DMAR: PTE not present at level 4

Cc: <stable@vger.kernel.org>
Fixes: 0bbeb01a4faf ("iommu/vt-d: Manage scalalble mode PASID tables")
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reported-by: Sukumar Ghorai <sukumar.ghorai@intel.com>
Signed-off-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Link: https://lore.kernel.org/r/20230209212843.1788125-1-jacob.jun.pan@linux.intel.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>

diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index ec964ac7d797..9d2f05cf6164 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -128,6 +128,9 @@ int intel_pasid_alloc_table(struct device *dev)
 	pasid_table->max_pasid = 1 << (order + PAGE_SHIFT + 3);
 	info->pasid_table = pasid_table;
 
+	if (!ecap_coherent(info->iommu->ecap))
+		clflush_cache_range(pasid_table->table, size);
+
 	return 0;
 }
 
@@ -215,6 +218,10 @@ static struct pasid_entry *intel_pasid_get_entry(struct device *dev, u32 pasid)
 			free_pgtable_page(entries);
 			goto retry;
 		}
+		if (!ecap_coherent(info->iommu->ecap)) {
+			clflush_cache_range(entries, VTD_PAGE_SIZE);
+			clflush_cache_range(&dir[dir_index].val, sizeof(*dir));
+		}
 	}
 
 	return &entries[index];

