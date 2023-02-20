Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8832269CD8F
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbjBTNua (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:50:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232415AbjBTNu2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:50:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A955D1CF47
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:50:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F48B60EA9
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:50:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FBB4C433EF;
        Mon, 20 Feb 2023 13:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901022;
        bh=oHgcWu/dOATSK/GoxVWdu8Flaf2aB6BR8awNd7JS4XY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SBlgfWuyqhM1XkUTFYki+tSxOyGkL/h1cqovbglQE2vR94xJSefmQ2yQhyvVfkiin
         oscbtllIrnNbjdK2iI6ZxBpfN20Uqsekh4p1IoBYQIPzsepzfmyCtquldAFidMCCg1
         slB+TCNn4qvXKMHOKUo8u36yAX3UhbEdQpMyQI1Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Qian Cai <cai@lca.pw>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.4 156/156] iommu/amd: Pass gfp flags to iommu_map_page() in amd_iommu_map()
Date:   Mon, 20 Feb 2023 14:36:40 +0100
Message-Id: <20230220133609.183427426@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

commit 3057fb9377eb5e73386dd0d8804bf72bdd23e391 upstream.

A recent commit added a gfp parameter to amd_iommu_map() to make it
callable from atomic context, but forgot to pass it down to
iommu_map_page() and left GFP_KERNEL there. This caused
sleep-while-atomic warnings and needs to be fixed.

Reported-by: Qian Cai <cai@lca.pw>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 781ca2de89ba ("iommu: Add gfp parameter to iommu_ops::map")
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/amd_iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -3114,7 +3114,7 @@ static int amd_iommu_map(struct iommu_do
 		prot |= IOMMU_PROT_IW;
 
 	mutex_lock(&domain->api_lock);
-	ret = iommu_map_page(domain, iova, paddr, page_size, prot, GFP_KERNEL);
+	ret = iommu_map_page(domain, iova, paddr, page_size, prot, gfp);
 	mutex_unlock(&domain->api_lock);
 
 	domain_flush_np_cache(domain, iova, page_size);


