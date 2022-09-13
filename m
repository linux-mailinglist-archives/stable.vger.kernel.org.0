Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB21A5B702A
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233247AbiIMOUe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233617AbiIMOT2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:19:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED7BA22296;
        Tue, 13 Sep 2022 07:14:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A017AB80F3B;
        Tue, 13 Sep 2022 14:12:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0425CC433D6;
        Tue, 13 Sep 2022 14:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078321;
        bh=qX0q1/pi9rDuU2etg1JGzkgGhFIgIbO1c+x7casxCaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R13r9n2t7r7zBp6i9TX8rJgPc4k6rK7ivQyStUYiZnmZCzK9Qu58x8X4wFJLRWz/1
         915IjB3kLnkquFkqxxdVrPJ2iYAv7DiPcHfPG7FjWSrk4sUJhStpICakU4MqfolLTm
         PXtS9o1PiogVO41o5hamBxtH3G+oPCzZUX+Leo1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yixing Liu <liuyixing1@huawei.com>,
        Wenpeng Liang <liangwenpeng@huawei.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 094/192] RDMA/hns: Remove the num_qpc_timer variable
Date:   Tue, 13 Sep 2022 16:03:20 +0200
Message-Id: <20220913140414.648397708@linuxfoundation.org>
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

From: Yixing Liu <liuyixing1@huawei.com>

[ Upstream commit 45baad7dd98f4d83f67c86c28769d3184390e324 ]

The bt number of qpc_timer of HIP09 increases compared with that of HIP08.
Therefore, qpc_timer_bt_num and num_qpc_timer do not match. As a result,
the driver may fail to allocate qpc_timer. So the driver needs to uniquely
uses qpc_timer_bt_num to represent the bt number of qpc_timer.

Fixes: 0e40dc2f70cd ("RDMA/hns: Add timer allocation support for hip08")
Link: https://lore.kernel.org/r/20220829105021.1427804-4-liangwenpeng@huawei.com
Signed-off-by: Yixing Liu <liuyixing1@huawei.com>
Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_device.h | 1 -
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 3 +--
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  | 2 +-
 drivers/infiniband/hw/hns/hns_roce_main.c   | 2 +-
 4 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 2855e9ad4b328..1df076e70e293 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -730,7 +730,6 @@ struct hns_roce_caps {
 	u32		num_qps;
 	u32		num_pi_qps;
 	u32		reserved_qps;
-	int		num_qpc_timer;
 	u32		num_srqs;
 	u32		max_wqes;
 	u32		max_srq_wrs;
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index b354caeaa9b29..49edff989f1f1 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -1941,7 +1941,7 @@ static void set_default_caps(struct hns_roce_dev *hr_dev)
 
 	caps->num_mtpts		= HNS_ROCE_V2_MAX_MTPT_NUM;
 	caps->num_pds		= HNS_ROCE_V2_MAX_PD_NUM;
-	caps->num_qpc_timer	= HNS_ROCE_V2_MAX_QPC_TIMER_NUM;
+	caps->qpc_timer_bt_num	= HNS_ROCE_V2_MAX_QPC_TIMER_BT_NUM;
 	caps->cqc_timer_bt_num	= HNS_ROCE_V2_MAX_CQC_TIMER_BT_NUM;
 
 	caps->max_qp_init_rdma	= HNS_ROCE_V2_MAX_QP_INIT_RDMA;
@@ -2237,7 +2237,6 @@ static int hns_roce_query_pf_caps(struct hns_roce_dev *hr_dev)
 	caps->max_rq_sg		     = le16_to_cpu(resp_a->max_rq_sg);
 	caps->max_rq_sg = roundup_pow_of_two(caps->max_rq_sg);
 	caps->max_extend_sg	     = le32_to_cpu(resp_a->max_extend_sg);
-	caps->num_qpc_timer	     = le16_to_cpu(resp_a->num_qpc_timer);
 	caps->max_srq_sges	     = le16_to_cpu(resp_a->max_srq_sges);
 	caps->max_srq_sges = roundup_pow_of_two(caps->max_srq_sges);
 	caps->num_aeq_vectors	     = resp_a->num_aeq_vectors;
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index 2d7e91004e3c7..e4b640caee1b7 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -36,11 +36,11 @@
 #include <linux/bitops.h>
 
 #define HNS_ROCE_V2_MAX_QP_NUM			0x1000
-#define HNS_ROCE_V2_MAX_QPC_TIMER_NUM		0x200
 #define HNS_ROCE_V2_MAX_WQE_NUM			0x8000
 #define HNS_ROCE_V2_MAX_SRQ_WR			0x8000
 #define HNS_ROCE_V2_MAX_SRQ_SGE			64
 #define HNS_ROCE_V2_MAX_CQ_NUM			0x100000
+#define HNS_ROCE_V2_MAX_QPC_TIMER_BT_NUM	0x100
 #define HNS_ROCE_V2_MAX_CQC_TIMER_BT_NUM	0x100
 #define HNS_ROCE_V2_MAX_SRQ_NUM			0x100000
 #define HNS_ROCE_V2_MAX_CQE_NUM			0x400000
diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index c8af4ebd7cbd3..4ccb217b2841d 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -725,7 +725,7 @@ static int hns_roce_init_hem(struct hns_roce_dev *hr_dev)
 		ret = hns_roce_init_hem_table(hr_dev, &hr_dev->qpc_timer_table,
 					      HEM_TYPE_QPC_TIMER,
 					      hr_dev->caps.qpc_timer_entry_sz,
-					      hr_dev->caps.num_qpc_timer, 1);
+					      hr_dev->caps.qpc_timer_bt_num, 1);
 		if (ret) {
 			dev_err(dev,
 				"Failed to init QPC timer memory, aborting.\n");
-- 
2.35.1



