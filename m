Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B61B53FA0E
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 11:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239375AbiFGJnG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 05:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239836AbiFGJnC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 05:43:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83F6319009
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 02:43:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E2F461240
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 09:43:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1DBC385A5;
        Tue,  7 Jun 2022 09:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654594980;
        bh=pEsqjQ6bVMrIn8TN0FcKowoKHGRINOCiiKWSRKHLxL8=;
        h=Subject:To:Cc:From:Date:From;
        b=I9XgiAdzQXsXutMT+ZZpvlwPjGqV/L/i05dty5rPaz6FrVQGmYrbd1RDuDvq3Llup
         7q5phGb2W8QRS9Irkk4/Su0SBmy35FO1/NIz8XDsWNiOFaaSfMkt9xmtDz/y3KmgYI
         v93mfkKrYPp3Rg4w56YoyB/O6X8ISQviw/kFHUBQ=
Subject: FAILED: patch "[PATCH] RDMA/hns: Remove the num_cqc_timer variable" failed to apply to 5.4-stable tree
To:     liuyixing1@huawei.com, jgg@nvidia.com, liangwenpeng@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Jun 2022 11:42:55 +0200
Message-ID: <16545949759967@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From db5dfbf5b201df65c1f5332c4d9d5e7c2f42396b Mon Sep 17 00:00:00 2001
From: Yixing Liu <liuyixing1@huawei.com>
Date: Fri, 29 Apr 2022 17:35:45 +0800
Subject: [PATCH] RDMA/hns: Remove the num_cqc_timer variable

The bt number of cqc_timer of HIP09 increases compared with that of HIP08.
Therefore, cqc_timer_bt_num and num_cqc_timer do not match. As a result,
the driver may fail to allocate cqc_timer. So the driver needs to uniquely
uses cqc_timer_bt_num to represent the bt number of cqc_timer.

Fixes: 0e40dc2f70cd ("RDMA/hns: Add timer allocation support for hip08")
Link: https://lore.kernel.org/r/20220429093545.58070-1-liangwenpeng@huawei.com
Signed-off-by: Yixing Liu <liuyixing1@huawei.com>
Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index fc2fd4e9e8a6..eb40fb795aaf 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -721,7 +721,6 @@ struct hns_roce_caps {
 	u32		num_pi_qps;
 	u32		reserved_qps;
 	int		num_qpc_timer;
-	int		num_cqc_timer;
 	u32		num_srqs;
 	u32		max_wqes;
 	u32		max_srq_wrs;
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 329b37de1990..d233b6c2b29a 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -1975,7 +1975,7 @@ static void set_default_caps(struct hns_roce_dev *hr_dev)
 	caps->num_mtpts		= HNS_ROCE_V2_MAX_MTPT_NUM;
 	caps->num_pds		= HNS_ROCE_V2_MAX_PD_NUM;
 	caps->num_qpc_timer	= HNS_ROCE_V2_MAX_QPC_TIMER_NUM;
-	caps->num_cqc_timer	= HNS_ROCE_V2_MAX_CQC_TIMER_NUM;
+	caps->cqc_timer_bt_num	= HNS_ROCE_V2_MAX_CQC_TIMER_BT_NUM;
 
 	caps->max_qp_init_rdma	= HNS_ROCE_V2_MAX_QP_INIT_RDMA;
 	caps->max_qp_dest_rdma	= HNS_ROCE_V2_MAX_QP_DEST_RDMA;
@@ -2271,7 +2271,6 @@ static int hns_roce_query_pf_caps(struct hns_roce_dev *hr_dev)
 	caps->max_rq_sg = roundup_pow_of_two(caps->max_rq_sg);
 	caps->max_extend_sg	     = le32_to_cpu(resp_a->max_extend_sg);
 	caps->num_qpc_timer	     = le16_to_cpu(resp_a->num_qpc_timer);
-	caps->num_cqc_timer	     = le16_to_cpu(resp_a->num_cqc_timer);
 	caps->max_srq_sges	     = le16_to_cpu(resp_a->max_srq_sges);
 	caps->max_srq_sges = roundup_pow_of_two(caps->max_srq_sges);
 	caps->num_aeq_vectors	     = resp_a->num_aeq_vectors;
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index 0d87b627601e..9cbb230de03b 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -41,7 +41,7 @@
 #define HNS_ROCE_V2_MAX_SRQ_WR			0x8000
 #define HNS_ROCE_V2_MAX_SRQ_SGE			64
 #define HNS_ROCE_V2_MAX_CQ_NUM			0x100000
-#define HNS_ROCE_V2_MAX_CQC_TIMER_NUM		0x100
+#define HNS_ROCE_V2_MAX_CQC_TIMER_BT_NUM	0x100
 #define HNS_ROCE_V2_MAX_SRQ_NUM			0x100000
 #define HNS_ROCE_V2_MAX_CQE_NUM			0x400000
 #define HNS_ROCE_V2_MAX_RQ_SGE_NUM		64
diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index f73ba619f375..c8af4ebd7cbd 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -737,7 +737,7 @@ static int hns_roce_init_hem(struct hns_roce_dev *hr_dev)
 		ret = hns_roce_init_hem_table(hr_dev, &hr_dev->cqc_timer_table,
 					      HEM_TYPE_CQC_TIMER,
 					      hr_dev->caps.cqc_timer_entry_sz,
-					      hr_dev->caps.num_cqc_timer, 1);
+					      hr_dev->caps.cqc_timer_bt_num, 1);
 		if (ret) {
 			dev_err(dev,
 				"Failed to init CQC timer memory, aborting.\n");

