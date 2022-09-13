Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3D9C5B7219
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234245AbiIMOuX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234647AbiIMOtV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:49:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4FB37171F;
        Tue, 13 Sep 2022 07:25:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDCF1B80F03;
        Tue, 13 Sep 2022 14:11:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E31C433D7;
        Tue, 13 Sep 2022 14:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078318;
        bh=x4HinmjdF9alckJW2lAnscTOasT9TBJsF2wnAY7Ru5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uU4YCIdqHROBlbU6+9xt2L28DRpneZ7+o/K/vTPy9CeH/1x6GjX2yBz/O6zg67rYj
         +OI6BK5BDpBhCXTmwnys76rzRf5O0wZt3xutQaNflYVrSYRbMBtw9Coe8y7YK/2T2q
         vVgfCEJf8Vh76AV8L5R2yterUUhK9VpkgPly9IqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenpeng Liang <liangwenpeng@huawei.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 093/192] RDMA/hns: Fix wrong fixed value of qp->rq.wqe_shift
Date:   Tue, 13 Sep 2022 16:03:19 +0200
Message-Id: <20220913140414.598757371@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
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

From: Wenpeng Liang <liangwenpeng@huawei.com>

[ Upstream commit 0c8b5d6268d92d141bfd64d21c870d295a84dee1 ]

The value of qp->rq.wqe_shift of HIP08 is always determined by the number
of sge. So delete the wrong branch.

Fixes: cfc85f3e4b7f ("RDMA/hns: Add profile support for hip08 driver")
Fixes: 926a01dc000d ("RDMA/hns: Add QP operations support for hip08 SoC")
Link: https://lore.kernel.org/r/20220829105021.1427804-3-liangwenpeng@huawei.com
Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_qp.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index 48d3616a6d71d..7bee7f6c5e702 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -462,11 +462,8 @@ static int set_rq_size(struct hns_roce_dev *hr_dev, struct ib_qp_cap *cap,
 	hr_qp->rq.max_gs = roundup_pow_of_two(max(1U, cap->max_recv_sge) +
 					      hr_qp->rq.rsv_sge);
 
-	if (hr_dev->caps.max_rq_sg <= HNS_ROCE_SGE_IN_WQE)
-		hr_qp->rq.wqe_shift = ilog2(hr_dev->caps.max_rq_desc_sz);
-	else
-		hr_qp->rq.wqe_shift = ilog2(hr_dev->caps.max_rq_desc_sz *
-					    hr_qp->rq.max_gs);
+	hr_qp->rq.wqe_shift = ilog2(hr_dev->caps.max_rq_desc_sz *
+				    hr_qp->rq.max_gs);
 
 	hr_qp->rq.wqe_cnt = cnt;
 	if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_RQ_INLINE &&
-- 
2.35.1



