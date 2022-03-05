Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7F24CE6AD
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 21:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbiCEUGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 15:06:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbiCEUGo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 15:06:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763606331
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 12:05:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 116D660B65
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 20:05:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14E32C004E1;
        Sat,  5 Mar 2022 20:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646510752;
        bh=U16FyN1Y0Kjn+pmAOvbkJnsSRyCYE+/oaVet/DYaCjc=;
        h=Subject:To:Cc:From:Date:From;
        b=tnP6nWu4PSYkqmztN2ZRBJJsy/EvrY5IoyxKYi1I16VpgxX7CqyU7k6AoLFIUiZYg
         u4+FtgjvyvMNvhlbHma3Umue7DHkmnIWhlsrQTS3xaGNSJ6kXqyYqyB0jXzXjxJNB/
         x+s4MoiePxh1dyNyh4WSwXx65nYiWYiR4yJc+NK8=
Subject: FAILED: patch "[PATCH] iommu/amd: Fix I/O page table memory leak" failed to apply to 5.16-stable tree
To:     suravee.suthikulpanit@amd.com, daniel.m.jordan@oracle.com,
        joro@8bytes.org, jroedel@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 05 Mar 2022 21:05:49 +0100
Message-ID: <16465107491237@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.16-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6b0b2d9a6a308bcd9300c2d83000a82812c56cea Mon Sep 17 00:00:00 2001
From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Date: Thu, 10 Feb 2022 09:47:45 -0600
Subject: [PATCH] iommu/amd: Fix I/O page table memory leak

The current logic updates the I/O page table mode for the domain
before calling the logic to free memory used for the page table.
This results in IOMMU page table memory leak, and can be observed
when launching VM w/ pass-through devices.

Fix by freeing the memory used for page table before updating the mode.

Cc: Joerg Roedel <joro@8bytes.org>
Reported-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Tested-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Fixes: e42ba0633064 ("iommu/amd: Restructure code for freeing page table")
Link: https://lore.kernel.org/all/20220118194720.urjgi73b7c3tq2o6@oracle.com/
Link: https://lore.kernel.org/r/20220210154745.11524-1-suravee.suthikulpanit@amd.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>

diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index b1bf4125b0f7..6608d1717574 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -492,18 +492,18 @@ static void v1_free_pgtable(struct io_pgtable *iop)
 
 	dom = container_of(pgtable, struct protection_domain, iop);
 
-	/* Update data structure */
-	amd_iommu_domain_clr_pt_root(dom);
-
-	/* Make changes visible to IOMMUs */
-	amd_iommu_domain_update(dom);
-
 	/* Page-table is not visible to IOMMU anymore, so free it */
 	BUG_ON(pgtable->mode < PAGE_MODE_NONE ||
 	       pgtable->mode > PAGE_MODE_6_LEVEL);
 
 	free_sub_pt(pgtable->root, pgtable->mode, &freelist);
 
+	/* Update data structure */
+	amd_iommu_domain_clr_pt_root(dom);
+
+	/* Make changes visible to IOMMUs */
+	amd_iommu_domain_update(dom);
+
 	put_pages_list(&freelist);
 }
 

