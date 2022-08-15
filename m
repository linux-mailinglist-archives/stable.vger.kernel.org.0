Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64B725936E0
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344161AbiHOTTw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343790AbiHOTSR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:18:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD7A5723A;
        Mon, 15 Aug 2022 11:39:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8335061149;
        Mon, 15 Aug 2022 18:39:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B30C433D6;
        Mon, 15 Aug 2022 18:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588781;
        bh=29g+cXVqocYC8eq91Vv4APTPdgmTmZ6/Ot/tHBP7O9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uNQ7Pgj+w1CqchMNpsYLXQVe+0Z94D2USih8mZJfwB5E++eqHfFP16S30jWDJMjld
         KmPlTozRUbhDtK90n6i1JFW2ShFqektq6SmobhFXqM0j0/MPlzFBaqgAce2PKROtE4
         9KLJFMDx/qwBFByiJzd3pqz72iNmoSgpQWOOBwGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haoyue Xu <xuhaoyue1@hisilicon.com>,
        Wenpeng Liang <liangwenpeng@huawei.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 512/779] RDMA/hns: Fix incorrect clearing of interrupt status register
Date:   Mon, 15 Aug 2022 20:02:36 +0200
Message-Id: <20220815180359.130831478@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
index bf01210c56c2..1dbad159f379 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -5854,8 +5854,8 @@ static irqreturn_t hns_roce_v2_msix_interrupt_abn(int irq, void *dev_id)
 
 		dev_err(dev, "AEQ overflow!\n");
 
-		int_st |= 1 << HNS_ROCE_V2_VF_INT_ST_AEQ_OVERFLOW_S;
-		roce_write(hr_dev, ROCEE_VF_ABN_INT_ST_REG, int_st);
+		roce_write(hr_dev, ROCEE_VF_ABN_INT_ST_REG,
+			   1 << HNS_ROCE_V2_VF_INT_ST_AEQ_OVERFLOW_S);
 
 		/* Set reset level for reset_event() */
 		if (ops->set_default_reset_request)
-- 
2.35.1



