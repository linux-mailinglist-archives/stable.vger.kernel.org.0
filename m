Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81EFC6580C7
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234627AbiL1QUi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:20:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234656AbiL1QUR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:20:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A418AFCF4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:18:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CECD6156E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:18:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C74C433EF;
        Wed, 28 Dec 2022 16:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244285;
        bh=Jgg7TCoqsarInQDAUHkSEWzVo7lha8VB+5fIZuTHviY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qpurM9wUd1Yw00C9DYK4G+oCsg73EVHNmozsP/3ljIfSExOOzKf7aKGuZ2s4bS+n1
         MRc72tvF1DvcVLvEWNkMkbULVNS5aerWxi1yGDTZHacWk9P1XWEIgtCVfGhgoCF6v4
         cZ0VWPt+O8ayO6Vrt1QZbr2qmOMfipaS8aB6vrqA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Chengchang Tang <tangchengchang@huawei.com>,
        Haoyue Xu <xuhaoyue1@hisilicon.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0650/1073] RDMA/hns: Fix page size cap from firmware
Date:   Wed, 28 Dec 2022 15:37:18 +0100
Message-Id: <20221228144345.699956476@linuxfoundation.org>
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

[ Upstream commit 99dc5a0712883d5d13b620d25b3759d429577bc8 ]

Add verification to make sure the roce page size cap is supported by the
system page size.

Fixes: ba6bb7e97421 ("RDMA/hns: Add interfaces to get pf capabilities from firmware")
Link: https://lore.kernel.org/r/20221126102911.2921820-5-xuhaoyue1@hisilicon.com
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Haoyue Xu <xuhaoyue1@hisilicon.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 5bd21e589565..49c33baed69c 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -2344,6 +2344,9 @@ static int hns_roce_query_pf_caps(struct hns_roce_dev *hr_dev)
 	caps->wqe_sge_hop_num = hr_reg_read(resp_d, PF_CAPS_D_EX_SGE_HOP_NUM);
 	caps->wqe_rq_hop_num = hr_reg_read(resp_d, PF_CAPS_D_RQWQE_HOP_NUM);
 
+	if (!(caps->page_size_cap & PAGE_SIZE))
+		caps->page_size_cap = HNS_ROCE_V2_PAGE_SIZE_SUPPORTED;
+
 	return 0;
 }
 
-- 
2.35.1



