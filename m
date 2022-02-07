Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E07A04ABAD8
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384102AbiBGLYo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:24:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356786AbiBGLNs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:13:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F68C043181;
        Mon,  7 Feb 2022 03:13:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A293CB80EC3;
        Mon,  7 Feb 2022 11:13:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB078C004E1;
        Mon,  7 Feb 2022 11:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232425;
        bh=8RcvJ0iNpGXd9hhP8foxR5IlHZdwD/RWOBg4L/G1cj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=unSfOZvWdfI7vcrAE+xWFPxD/RGcRJjHDRjNezuQ0js+ERbRI7rtkJFhdmOp9ZsC+
         m6iUoJjyLhN7RgtdDnIK2zBc5CbnZEWZ2+JsV4p+NTX7rLgZGvCuRiUX/FH3Tb99Ty
         1GGwSTSVycUXtFr1OqWrOQv2cGR0a/Gk81rLz3hg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 4.14 53/69] iommu/vt-d: Fix potential memory leak in intel_setup_irq_remapping()
Date:   Mon,  7 Feb 2022 12:06:15 +0100
Message-Id: <20220207103757.363053239@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103755.604121441@linuxfoundation.org>
References: <20220207103755.604121441@linuxfoundation.org>
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

From: Guoqing Jiang <guoqing.jiang@linux.dev>

commit 99e675d473eb8cf2deac1376a0f840222fc1adcf upstream.

After commit e3beca48a45b ("irqdomain/treewide: Keep firmware node
unconditionally allocated"). For tear down scenario, fn is only freed
after fail to allocate ir_domain, though it also should be freed in case
dmar_enable_qi returns error.

Besides free fn, irq_domain and ir_msi_domain need to be removed as well
if intel_setup_irq_remapping fails to enable queued invalidation.

Improve the rewinding path by add out_free_ir_domain and out_free_fwnode
lables per Baolu's suggestion.

Fixes: e3beca48a45b ("irqdomain/treewide: Keep firmware node unconditionally allocated")
Suggested-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
Link: https://lore.kernel.org/r/20220119063640.16864-1-guoqing.jiang@linux.dev
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20220128031002.2219155-3-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel_irq_remapping.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -543,9 +543,8 @@ static int intel_setup_irq_remapping(str
 					    fn, &intel_ir_domain_ops,
 					    iommu);
 	if (!iommu->ir_domain) {
-		irq_domain_free_fwnode(fn);
 		pr_err("IR%d: failed to allocate irqdomain\n", iommu->seq_id);
-		goto out_free_bitmap;
+		goto out_free_fwnode;
 	}
 	iommu->ir_msi_domain =
 		arch_create_remap_msi_irq_domain(iommu->ir_domain,
@@ -569,7 +568,7 @@ static int intel_setup_irq_remapping(str
 
 		if (dmar_enable_qi(iommu)) {
 			pr_err("Failed to enable queued invalidation\n");
-			goto out_free_bitmap;
+			goto out_free_ir_domain;
 		}
 	}
 
@@ -593,6 +592,14 @@ static int intel_setup_irq_remapping(str
 
 	return 0;
 
+out_free_ir_domain:
+	if (iommu->ir_msi_domain)
+		irq_domain_remove(iommu->ir_msi_domain);
+	iommu->ir_msi_domain = NULL;
+	irq_domain_remove(iommu->ir_domain);
+	iommu->ir_domain = NULL;
+out_free_fwnode:
+	irq_domain_free_fwnode(fn);
 out_free_bitmap:
 	kfree(bitmap);
 out_free_pages:


