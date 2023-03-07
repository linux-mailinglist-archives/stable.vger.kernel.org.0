Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC4486AED7D
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232256AbjCGSEr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:04:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232172AbjCGSEW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:04:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F7FEA4033
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:57:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98657614DF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:57:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D28C4339B;
        Tue,  7 Mar 2023 17:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211829;
        bh=iPY2yEvBy9n87Ad1iR/5S8bNFr5//hIJ+0QCsAztGaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QDvAqJrLQ78f2PoDC4bwSSmYv9NDR01VGkNJyBKTfIrmNaZ+ok1oUk0nHkkReK+9M
         uQ26HMLIWC0kyhVxN0O2NWQqqAmhKTx3FWg8jEWx1b5cCFtynslwDicRCIAWbBAbQf
         /3WzvoT6klf9n34DM4OnQyqM95TsaZzaoJonm5tw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Sukumar Ghorai <sukumar.ghorai@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 6.2 0989/1001] iommu/vt-d: Fix PASID directory pointer coherency
Date:   Tue,  7 Mar 2023 18:02:41 +0100
Message-Id: <20230307170105.176375650@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Jacob Pan <jacob.jun.pan@linux.intel.com>

commit 194b3348bdbb7db65375c72f3f774aee4cc6614e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/pasid.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -128,6 +128,9 @@ int intel_pasid_alloc_table(struct devic
 	pasid_table->max_pasid = 1 << (order + PAGE_SHIFT + 3);
 	info->pasid_table = pasid_table;
 
+	if (!ecap_coherent(info->iommu->ecap))
+		clflush_cache_range(pasid_table->table, size);
+
 	return 0;
 }
 
@@ -215,6 +218,10 @@ retry:
 			free_pgtable_page(entries);
 			goto retry;
 		}
+		if (!ecap_coherent(info->iommu->ecap)) {
+			clflush_cache_range(entries, VTD_PAGE_SIZE);
+			clflush_cache_range(&dir[dir_index].val, sizeof(*dir));
+		}
 	}
 
 	return &entries[index];


