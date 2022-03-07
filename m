Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 886EC4CF885
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238948AbiCGJ4h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:56:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238807AbiCGJyh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:54:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F8E97807A;
        Mon,  7 Mar 2022 01:45:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8556861365;
        Mon,  7 Mar 2022 09:45:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35F23C340E9;
        Mon,  7 Mar 2022 09:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646326;
        bh=6eaBAaiTx6z1KDKJ9qfmaLGoCODvGB//OB2/h1VZiFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r/u+ZJ6TwGX7Y0ON9ZQPqjP0mwWLBCamoW15Ci7MK43cb2nDynb8q4vTdoJZDxO3L
         AAho/dsz3YCaGfFVaAOhj88XAFLdjvbQh/AXQpSyGyRdpr1wxmfaIsgh8i0uYT03+2
         nZP7vmi8VNJHbeDgitX5nrUsKfAZRAUXbMoJz6N4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 206/262] iommu/amd: Fix I/O page table memory leak
Date:   Mon,  7 Mar 2022 10:19:10 +0100
Message-Id: <20220307091708.595648414@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

[ Upstream commit 6b0b2d9a6a308bcd9300c2d83000a82812c56cea ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/io_pgtable.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

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
 
-- 
2.34.1



