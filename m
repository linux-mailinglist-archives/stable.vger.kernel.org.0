Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6AF611083
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 14:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbiJ1MGT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 08:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbiJ1MGS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 08:06:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C6F9AFC0
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 05:06:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74B1A627FF
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 12:06:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86590C433D7;
        Fri, 28 Oct 2022 12:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666958775;
        bh=edFdyQqZVy/8YOpcXkSLM6l8JbXbOOJOwDkLwXjEiag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JUp7goOXIABIpllR6AL/E9ETWDy27G43wAuH119B4UY0pJTMg5FwxJJEDW6yHCwsy
         gnNwzS/pckWxqtjkZ0z2oEBd/ItsvIRZMm7c+kS5w8ef/DVdgysV+AG0JpnlQtHbZs
         UyddtB8YLoyB2LpjGS1AFvxtJAQV9tqoR4QS+5/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 48/73] iommu/vt-d: Clean up si_domain in the init_dmars() error path
Date:   Fri, 28 Oct 2022 14:03:45 +0200
Message-Id: <20221028120234.462098748@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221028120232.344548477@linuxfoundation.org>
References: <20221028120232.344548477@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerry Snitselaar <jsnitsel@redhat.com>

[ Upstream commit 620bf9f981365c18cc2766c53d92bf8131c63f32 ]

A splat from kmem_cache_destroy() was seen with a kernel prior to
commit ee2653bbe89d ("iommu/vt-d: Remove domain and devinfo mempool")
when there was a failure in init_dmars(), because the iommu_domain
cache still had objects. While the mempool code is now gone, there
still is a leak of the si_domain memory if init_dmars() fails. So
clean up si_domain in the init_dmars() error path.

Cc: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Will Deacon <will@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Fixes: 86080ccc223a ("iommu/vt-d: Allocate si_domain in init_dmars()")
Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
Link: https://lore.kernel.org/r/20221010144842.308890-1-jsnitsel@redhat.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index c48cf737b521..f23329b7f97c 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -2846,6 +2846,7 @@ static int __init si_domain_init(int hw)
 
 	if (md_domain_init(si_domain, DEFAULT_DOMAIN_ADDRESS_WIDTH)) {
 		domain_exit(si_domain);
+		si_domain = NULL;
 		return -EFAULT;
 	}
 
@@ -3505,6 +3506,10 @@ static int __init init_dmars(void)
 		disable_dmar_iommu(iommu);
 		free_dmar_iommu(iommu);
 	}
+	if (si_domain) {
+		domain_exit(si_domain);
+		si_domain = NULL;
+	}
 
 	kfree(g_iommus);
 
-- 
2.35.1



