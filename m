Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7B3D6582D0
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233345AbiL1QmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:42:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233305AbiL1Ql3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:41:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 623821274D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:35:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE371B8188A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:35:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6828BC433F0;
        Wed, 28 Dec 2022 16:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245350;
        bh=pYOCBZEZxuLMlyvo7qdVW2dCoVvGZHkYFlHDwKkmoZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ENU5FMa5npJdfenXJHtcsj5hoqKPTH15eB5tljlEbP0Bh0NN7YU1Qauy6fOsjJsWv
         D1Hpnh2vTRrw78UppVWGf4GgDVz/PhPebmt6dN/qBktNEaygaNgOZopeDGS87PvKAn
         o8o14+vjw6vRDZnCbH7F2rWvhEjhxK5z6suoefbo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0844/1146] iommu/fsl_pamu: Fix resource leak in fsl_pamu_probe()
Date:   Wed, 28 Dec 2022 15:39:43 +0100
Message-Id: <20221228144353.079979638@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit 73f5fc5f884ad0c5f7d57f66303af64f9f002526 ]

The fsl_pamu_probe() returns directly when create_csd() failed, leaving
irq and memories unreleased.
Fix by jumping to error if create_csd() returns error.

Fixes: 695093e38c3e ("iommu/fsl: Freescale PAMU driver and iommu implementation.")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Link: https://lore.kernel.org/r/20221121082022.19091-1-yuancan@huawei.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/fsl_pamu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/fsl_pamu.c b/drivers/iommu/fsl_pamu.c
index 0d03f837a5d4..7a1a413f75ab 100644
--- a/drivers/iommu/fsl_pamu.c
+++ b/drivers/iommu/fsl_pamu.c
@@ -868,7 +868,7 @@ static int fsl_pamu_probe(struct platform_device *pdev)
 		ret = create_csd(ppaact_phys, mem_size, csd_port_id);
 		if (ret) {
 			dev_err(dev, "could not create coherence subdomain\n");
-			return ret;
+			goto error;
 		}
 	}
 
-- 
2.35.1



