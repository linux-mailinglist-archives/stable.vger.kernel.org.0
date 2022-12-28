Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE8F06580C5
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234681AbiL1QU0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:20:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234707AbiL1QUA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:20:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4BAB69
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:18:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88BA3614CF
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:18:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96940C433D2;
        Wed, 28 Dec 2022 16:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244280;
        bh=eqq7HL7SE8JPGA/vKzT+Q+FqcFzY+185eK5NQroWzJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lVTJqQV2vx4jVAASHPsNtLUuB40PUzGYWO/lZwgko7foBYc8vPWCEBA7wGUI2HNET
         PiHoXAiggfQZGsYHmJxaRSIj3R/lEJqLIRBp/Vh+J2qfI3vs1XH9rR4B+2LUgpXP1O
         XrQulMSN/Z0ZycpVj+6fCTm1T37lxnG5eCeCE5mQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Chengchang Tang <tangchengchang@huawei.com>,
        Haoyue Xu <xuhaoyue1@hisilicon.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0649/1073] RDMA/hns: Fix PBL page MTR find
Date:   Wed, 28 Dec 2022 15:37:17 +0100
Message-Id: <20221228144345.673206319@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit 9fb39ef2ff3e18f1740625ba04093dfbef086d2b ]

Now, The address of the first two pages in the MR will be searched, which
use to speed up the lookup of the pbl table for hardware.  An exception
will occur when there is only one page in this MR.  This patch fix the
number of page to search.

Fixes: 9b2cf76c9f05 ("RDMA/hns: Optimize PBL buffer allocation process")
Link: https://lore.kernel.org/r/20221126102911.2921820-4-xuhaoyue1@hisilicon.com
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Haoyue Xu <xuhaoyue1@hisilicon.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index ba60496c8f01..5bd21e589565 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -3277,7 +3277,8 @@ static int set_mtpt_pbl(struct hns_roce_dev *hr_dev,
 	int i, count;
 
 	count = hns_roce_mtr_find(hr_dev, &mr->pbl_mtr, 0, pages,
-				  ARRAY_SIZE(pages), &pbl_ba);
+				  min_t(int, ARRAY_SIZE(pages), mr->npages),
+				  &pbl_ba);
 	if (count < 1) {
 		ibdev_err(ibdev, "failed to find PBL mtr, count = %d.\n",
 			  count);
-- 
2.35.1



