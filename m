Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67BD44CFA65
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234604AbiCGKQZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:16:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239336AbiCGKPD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:15:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F067A9AE;
        Mon,  7 Mar 2022 01:57:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78EEB60E8F;
        Mon,  7 Mar 2022 09:56:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80236C340F3;
        Mon,  7 Mar 2022 09:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646986;
        bh=ZdNObHiYHnzSCAvNC2nWvjr0DzK6YzERh5u9K+IXs9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2BWEtnMrptFPF/m3XbbPHcA3PdTDUBp6JVZVcYcLQV3iFkfhJUjOlpyuQV+CKw8k2
         EiRralQeREDcdbKS/eAQ4q5sYL2FzIg2r3AXuVOqCp7VbECbL8bsTAMtglufZMdHhR
         7gbAdPxAzovduPaaBAuWKTtqV9DHuUvqZl4/xt/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.16 105/186] iommu/tegra-smmu: Fix missing put_device() call in tegra_smmu_find
Date:   Mon,  7 Mar 2022 10:19:03 +0100
Message-Id: <20220307091657.015501227@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

commit 9826e393e4a8c3df474e7f9eacd3087266f74005 upstream.

The reference taken by 'of_find_device_by_node()' must be released when
not needed anymore.
Add the corresponding 'put_device()' in the error handling path.

Fixes: 765a9d1d02b2 ("iommu/tegra-smmu: Fix mc errors on tegra124-nyan")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20220107080915.12686-1-linmq006@gmail.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/tegra-smmu.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -808,8 +808,10 @@ static struct tegra_smmu *tegra_smmu_fin
 		return NULL;
 
 	mc = platform_get_drvdata(pdev);
-	if (!mc)
+	if (!mc) {
+		put_device(&pdev->dev);
 		return NULL;
+	}
 
 	return mc->smmu;
 }


