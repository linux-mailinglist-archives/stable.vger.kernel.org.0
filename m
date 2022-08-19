Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD6DB59A1F0
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352093AbiHSQXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351613AbiHSQVJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:21:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC1574B8D;
        Fri, 19 Aug 2022 09:02:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02167B8280D;
        Fri, 19 Aug 2022 16:02:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF83C433D6;
        Fri, 19 Aug 2022 16:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924959;
        bh=P1VYVGNOavNF8RQzM/uLlQlUG2FfNU83k2ALbbh9MVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j0i1ZVHNGbamI27FINjTSFQmFu99BJDc2Isq0tyAv55h54gyPBWyyEt6Jb94emoQr
         6bLsCxtvw5srlI8p2URrdGWWADz8hnSbIan29r0PMzS+u4KOutK+fq6gKvQcYmaadJ
         L2PSptf5RqN1cmjHHXmAzrfsUXLY1VBYs9z0Qtj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haoyue Xu <xuhaoyue1@hisilicon.com>,
        Wenpeng Liang <liangwenpeng@huawei.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 337/545] RDMA/hns: Fix incorrect clearing of interrupt status register
Date:   Fri, 19 Aug 2022 17:41:47 +0200
Message-Id: <20220819153844.471428927@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Haoyue Xu <xuhaoyue1@hisilicon.com>

[ Upstream commit ecb4db5c3590aa956b4b2c352081a5b632d1f9f9 ]

The driver will clear all the interrupts in the same area
when the driver handles the interrupt of type AEQ overflow.
It should only set the interrupt status bit of type AEQ overflow.

Fixes: a5073d6054f7 ("RDMA/hns: Add eq support of hip08")
Link: https://lore.kernel.org/r/20220714134353.16700-4-liangwenpeng@huawei.com
Signed-off-by: Haoyue Xu <xuhaoyue1@hisilicon.com>
Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index abe882ec1bae..6dab03b7aca8 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -5642,8 +5642,8 @@ static irqreturn_t hns_roce_v2_msix_interrupt_abn(int irq, void *dev_id)
 
 		dev_err(dev, "AEQ overflow!\n");
 
-		int_st |= 1 << HNS_ROCE_V2_VF_INT_ST_AEQ_OVERFLOW_S;
-		roce_write(hr_dev, ROCEE_VF_ABN_INT_ST_REG, int_st);
+		roce_write(hr_dev, ROCEE_VF_ABN_INT_ST_REG,
+			   1 << HNS_ROCE_V2_VF_INT_ST_AEQ_OVERFLOW_S);
 
 		/* Set reset level for reset_event() */
 		if (ops->set_default_reset_request)
-- 
2.35.1



