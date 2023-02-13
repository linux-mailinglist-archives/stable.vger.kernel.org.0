Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91FBA694971
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbjBMO7G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:59:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbjBMO6r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:58:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12C341DBA9
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:58:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00A76B8125E
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:58:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E2C1C4339B;
        Mon, 13 Feb 2023 14:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300284;
        bh=PGwWfxbIybMQGdRCzPgTOzJdRYvn5d/o0LGBVWj5gL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MxB/IQLhDPQRqgH60DvdNyyPm5+Wm6ukyyvdtBuy9zIX+UV5m92F8T90naiFWc1/1
         c1Jgm8JzYfQ+ZV80zKcp8J/rKk0ouSNBS2beTZiRccoy+k8L64y6oJ6CJq978A2TPp
         glmOWE63lITHWBe9G4+zEzDcEkI90itGgx198m1Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 20/67] RDMA/usnic: use iommu_map_atomic() under spin_lock()
Date:   Mon, 13 Feb 2023 15:49:01 +0100
Message-Id: <20230213144733.314004301@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
References: <20230213144732.336342050@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit b7e08a5a63a11627601915473c3b569c1f6c6c06 ]

usnic_uiom_map_sorted_intervals() is called under spin_lock(), iommu_map()
might sleep, use iommu_map_atomic() to avoid potential sleep in atomic
context.

Fixes: e3cf00d0a87f ("IB/usnic: Add Cisco VIC low-level hardware driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20230129093757.637354-1-yangyingliang@huawei.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/usnic/usnic_uiom.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infiniband/hw/usnic/usnic_uiom.c
index 760b254ba42d6..48a57568cad69 100644
--- a/drivers/infiniband/hw/usnic/usnic_uiom.c
+++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
@@ -281,8 +281,8 @@ static int usnic_uiom_map_sorted_intervals(struct list_head *intervals,
 				size = pa_end - pa_start + PAGE_SIZE;
 				usnic_dbg("va 0x%lx pa %pa size 0x%zx flags 0x%x",
 					va_start, &pa_start, size, flags);
-				err = iommu_map(pd->domain, va_start, pa_start,
-							size, flags);
+				err = iommu_map_atomic(pd->domain, va_start,
+						       pa_start, size, flags);
 				if (err) {
 					usnic_err("Failed to map va 0x%lx pa %pa size 0x%zx with err %d\n",
 						va_start, &pa_start, size, err);
@@ -298,8 +298,8 @@ static int usnic_uiom_map_sorted_intervals(struct list_head *intervals,
 				size = pa - pa_start + PAGE_SIZE;
 				usnic_dbg("va 0x%lx pa %pa size 0x%zx flags 0x%x\n",
 					va_start, &pa_start, size, flags);
-				err = iommu_map(pd->domain, va_start, pa_start,
-						size, flags);
+				err = iommu_map_atomic(pd->domain, va_start,
+						       pa_start, size, flags);
 				if (err) {
 					usnic_err("Failed to map va 0x%lx pa %pa size 0x%zx with err %d\n",
 						va_start, &pa_start, size, err);
-- 
2.39.0



