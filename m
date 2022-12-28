Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6649A657BA9
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233343AbiL1PYL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:24:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233713AbiL1PYG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:24:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 250BE1402A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:24:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5EFB61567
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:24:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C139BC433EF;
        Wed, 28 Dec 2022 15:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241045;
        bh=QcAXhnMJf0HaZcf+CL/5/q5zJxDCYkltjS2Y+Pa3fFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vlRK81hEFLsMungo0yjCnIwsqGKB4xktHiUK5NfYvTBDAZSrJy0oECX+JMLz/uud1
         Cnj6CwpUXJuRPbiyFAUg/A33Wgkt8o5bTKamVRrp4rEAG3Bkwb032ONuWDh8FxGNyK
         lxz+OuOXpAfwFds/liYcVs6V2lP4uD7Fq7U+6TB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Chengchang Tang <tangchengchang@huawei.com>,
        Haoyue Xu <xuhaoyue1@hisilicon.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 431/731] RDMA/hns: Fix page size cap from firmware
Date:   Wed, 28 Dec 2022 15:38:58 +0100
Message-Id: <20221228144309.057282846@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index b9557be812b7..16f39321b319 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -2371,6 +2371,9 @@ static int hns_roce_query_pf_caps(struct hns_roce_dev *hr_dev)
 					  V2_QUERY_PF_CAPS_D_RQWQE_HOP_NUM_M,
 					  V2_QUERY_PF_CAPS_D_RQWQE_HOP_NUM_S);
 
+	if (!(caps->page_size_cap & PAGE_SIZE))
+		caps->page_size_cap = HNS_ROCE_V2_PAGE_SIZE_SUPPORTED;
+
 	return 0;
 }
 
-- 
2.35.1



