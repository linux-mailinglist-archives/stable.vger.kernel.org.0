Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6DC658116
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234703AbiL1QYs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:24:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234675AbiL1QYJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:24:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C59B1165BF
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:21:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78EB8B81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:21:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDDF3C433D2;
        Wed, 28 Dec 2022 16:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244465;
        bh=FgHMjHJUjyT44N2gi/ODXxTj6153Z5JtXkpro7j2C+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R0MC6Jx4uvgGlbl4EBhtlnlF/9mjYeWH0z4jcMZjXQREjD+CK96tRQAQLRGeJxvSA
         TFxrjagXEaB7FDJIddq18Mgv7+2mYbqoZufhTrnysKFTJ5/gfDEW0i6jS/VSmL7ofw
         P2EufEtXtvYowvl35Vl4AKOq4QthROYLJoBSHCyc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Chengchang Tang <tangchengchang@huawei.com>,
        Haoyue Xu <xuhaoyue1@hisilicon.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0674/1146] RDMA/hns: Fix page size cap from firmware
Date:   Wed, 28 Dec 2022 15:36:53 +0100
Message-Id: <20221228144348.454147347@linuxfoundation.org>
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
index 747ce3ac72f1..fbdaf95fd82b 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -2341,6 +2341,9 @@ static int hns_roce_query_pf_caps(struct hns_roce_dev *hr_dev)
 	caps->wqe_sge_hop_num = hr_reg_read(resp_d, PF_CAPS_D_EX_SGE_HOP_NUM);
 	caps->wqe_rq_hop_num = hr_reg_read(resp_d, PF_CAPS_D_RQWQE_HOP_NUM);
 
+	if (!(caps->page_size_cap & PAGE_SIZE))
+		caps->page_size_cap = HNS_ROCE_V2_PAGE_SIZE_SUPPORTED;
+
 	return 0;
 }
 
-- 
2.35.1



