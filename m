Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53A675410C1
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355136AbiFGT3U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355887AbiFGT0G (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:26:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DB0119F05B;
        Tue,  7 Jun 2022 11:09:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB61DB81F38;
        Tue,  7 Jun 2022 18:09:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DDD7C385A2;
        Tue,  7 Jun 2022 18:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625369;
        bh=0zqDnn8AWgneW2psyZRXzX0YIsFeJ0J6TgZN6NpYX3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aoIe+Es3/3mcgvxn7L7dY7Qk0Zvuy0N9ooxjiStmg2KlGapAbOkjMr16dr4GejD1x
         37mdzngt8ZOxk9VnrS2688b4MevFdeFuopf6yAMioceUA2Ef5TQ/0qTdSoV0K3wT3r
         WWrbZgGal6cKoC+sZ4KyBW9HiQeXOdulMNBMjZfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yixing Liu <liuyixing1@huawei.com>,
        Wenpeng Liang <liangwenpeng@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.15 655/667] RDMA/hns: Remove the num_cqc_timer variable
Date:   Tue,  7 Jun 2022 19:05:20 +0200
Message-Id: <20220607164954.292745089@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yixing Liu <liuyixing1@huawei.com>

commit db5dfbf5b201df65c1f5332c4d9d5e7c2f42396b upstream.

The bt number of cqc_timer of HIP09 increases compared with that of HIP08.
Therefore, cqc_timer_bt_num and num_cqc_timer do not match. As a result,
the driver may fail to allocate cqc_timer. So the driver needs to uniquely
uses cqc_timer_bt_num to represent the bt number of cqc_timer.

Fixes: 0e40dc2f70cd ("RDMA/hns: Add timer allocation support for hip08")
Link: https://lore.kernel.org/r/20220429093545.58070-1-liangwenpeng@huawei.com
Signed-off-by: Yixing Liu <liuyixing1@huawei.com>
Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/hns/hns_roce_device.h |    1 -
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  |    3 +--
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  |    2 +-
 drivers/infiniband/hw/hns/hns_roce_main.c   |    2 +-
 4 files changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -759,7 +759,6 @@ struct hns_roce_caps {
 	u32		num_pi_qps;
 	u32		reserved_qps;
 	int		num_qpc_timer;
-	int		num_cqc_timer;
 	int		num_srqs;
 	u32		max_wqes;
 	u32		max_srq_wrs;
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -1973,7 +1973,7 @@ static void set_default_caps(struct hns_
 	caps->num_mtpts		= HNS_ROCE_V2_MAX_MTPT_NUM;
 	caps->num_pds		= HNS_ROCE_V2_MAX_PD_NUM;
 	caps->num_qpc_timer	= HNS_ROCE_V2_MAX_QPC_TIMER_NUM;
-	caps->num_cqc_timer	= HNS_ROCE_V2_MAX_CQC_TIMER_NUM;
+	caps->cqc_timer_bt_num	= HNS_ROCE_V2_MAX_CQC_TIMER_BT_NUM;
 
 	caps->max_qp_init_rdma	= HNS_ROCE_V2_MAX_QP_INIT_RDMA;
 	caps->max_qp_dest_rdma	= HNS_ROCE_V2_MAX_QP_DEST_RDMA;
@@ -2267,7 +2267,6 @@ static int hns_roce_query_pf_caps(struct
 	caps->max_rq_sg = roundup_pow_of_two(caps->max_rq_sg);
 	caps->max_extend_sg	     = le32_to_cpu(resp_a->max_extend_sg);
 	caps->num_qpc_timer	     = le16_to_cpu(resp_a->num_qpc_timer);
-	caps->num_cqc_timer	     = le16_to_cpu(resp_a->num_cqc_timer);
 	caps->max_srq_sges	     = le16_to_cpu(resp_a->max_srq_sges);
 	caps->max_srq_sges = roundup_pow_of_two(caps->max_srq_sges);
 	caps->num_aeq_vectors	     = resp_a->num_aeq_vectors;
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -51,7 +51,7 @@
 #define HNS_ROCE_V2_MAX_SRQ_WR			0x8000
 #define HNS_ROCE_V2_MAX_SRQ_SGE			64
 #define HNS_ROCE_V2_MAX_CQ_NUM			0x100000
-#define HNS_ROCE_V2_MAX_CQC_TIMER_NUM		0x100
+#define HNS_ROCE_V2_MAX_CQC_TIMER_BT_NUM	0x100
 #define HNS_ROCE_V2_MAX_SRQ_NUM			0x100000
 #define HNS_ROCE_V2_MAX_CQE_NUM			0x400000
 #define HNS_ROCE_V2_MAX_SRQWQE_NUM		0x8000
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -663,7 +663,7 @@ static int hns_roce_init_hem(struct hns_
 		ret = hns_roce_init_hem_table(hr_dev, &hr_dev->cqc_timer_table,
 					      HEM_TYPE_CQC_TIMER,
 					      hr_dev->caps.cqc_timer_entry_sz,
-					      hr_dev->caps.num_cqc_timer, 1);
+					      hr_dev->caps.cqc_timer_bt_num, 1);
 		if (ret) {
 			dev_err(dev,
 				"Failed to init CQC timer memory, aborting.\n");


