Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFB895B7173
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234002AbiIMOgh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234185AbiIMOfU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:35:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B743865553;
        Tue, 13 Sep 2022 07:20:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 200F3B80FBC;
        Tue, 13 Sep 2022 14:18:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7552FC433D7;
        Tue, 13 Sep 2022 14:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078725;
        bh=LnZs86i6HTPON0onMhvYrIUeQVmi1/QNN1eseRf0W5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tFjQ4tznF6+l0qKfz5hC1Key2WHlz+8IZBLEmk8kJEOSNc5aQhiylJGnHkwsprB8t
         hjLNG8vPEXEykyZHdRO+/rFIAKcvkc6YkTvc/+pBx08oFRBBkefiPUDLF40JgmzVyJ
         V/EM1joFbZE4vw4VRCfVmy9iKKnLZHB8mf2wqtjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chengchang Tang <tangchengchang@huawei.com>,
        Wenpeng Liang <liangwenpeng@huawei.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 058/121] RDMA/hns: Fix supported page size
Date:   Tue, 13 Sep 2022 16:04:09 +0200
Message-Id: <20220913140359.847226445@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
References: <20220913140357.323297659@linuxfoundation.org>
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

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit 55af9d498556f0860eb89ffa7677e8d73f6f643f ]

The supported page size for hns is (4K, 128M), not (4K, 2G).

Fixes: cfc85f3e4b7f ("RDMA/hns: Add profile support for hip08 driver")
Link: https://lore.kernel.org/r/20220829105021.1427804-2-liangwenpeng@huawei.com
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index df4501e77fd17..d3d5b5f57052c 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -98,7 +98,7 @@
 
 #define HNS_ROCE_V2_QPC_TIMER_ENTRY_SZ		PAGE_SIZE
 #define HNS_ROCE_V2_CQC_TIMER_ENTRY_SZ		PAGE_SIZE
-#define HNS_ROCE_V2_PAGE_SIZE_SUPPORTED		0xFFFFF000
+#define HNS_ROCE_V2_PAGE_SIZE_SUPPORTED		0xFFFF000
 #define HNS_ROCE_V2_MAX_INNER_MTPT_NUM		2
 #define HNS_ROCE_INVALID_LKEY			0x0
 #define HNS_ROCE_INVALID_SGE_LENGTH		0x80000000
-- 
2.35.1



