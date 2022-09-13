Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D79A05B71F0
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbiIMOop (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234495AbiIMOnl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:43:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08CC36EF29;
        Tue, 13 Sep 2022 07:23:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70956B80F97;
        Tue, 13 Sep 2022 14:23:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF551C433D6;
        Tue, 13 Sep 2022 14:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078995;
        bh=j90Uc8ZsfXepqIyM6WV/PLdAbU0hv1dUaJEvYkRqv3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fi8cKhOIUemtJr0py/VlsBHftQnKxNad83bGELj9nkr/WydT+6LgXbVrkCidGG+RH
         LxXSPyjUlgF9EWI+yLtL8h91sKVcm/rFbdl58AhtQu14tX9AP+j4YUMT91LpG2gqa0
         1EuVEbp69x12Yy16IiCxigs7zWK2RrXeWtcdhd6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chengchang Tang <tangchengchang@huawei.com>,
        Wenpeng Liang <liangwenpeng@huawei.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 42/79] RDMA/hns: Fix supported page size
Date:   Tue, 13 Sep 2022 16:04:47 +0200
Message-Id: <20220913140352.328257156@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140350.291927556@linuxfoundation.org>
References: <20220913140350.291927556@linuxfoundation.org>
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
index be7f2fe1e8839..8a92faeb3d237 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -92,7 +92,7 @@
 
 #define HNS_ROCE_V2_QPC_TIMER_ENTRY_SZ		PAGE_SIZE
 #define HNS_ROCE_V2_CQC_TIMER_ENTRY_SZ		PAGE_SIZE
-#define HNS_ROCE_V2_PAGE_SIZE_SUPPORTED		0xFFFFF000
+#define HNS_ROCE_V2_PAGE_SIZE_SUPPORTED		0xFFFF000
 #define HNS_ROCE_V2_MAX_INNER_MTPT_NUM		2
 #define HNS_ROCE_INVALID_LKEY			0x100
 #define HNS_ROCE_CMQ_TX_TIMEOUT			30000
-- 
2.35.1



