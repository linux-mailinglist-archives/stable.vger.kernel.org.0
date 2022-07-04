Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92643565430
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 13:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbiGDL4e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 07:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbiGDL4d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 07:56:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7606DF33
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 04:56:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 527AE60B87
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 11:56:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D6BC3411E;
        Mon,  4 Jul 2022 11:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656935791;
        bh=+nxF9RmKs9HxaIqB1ygL6inVq4JXNz0Fj880HLTpuw4=;
        h=Subject:To:Cc:From:Date:From;
        b=UCFjGmqrE+dnfXQ7/MwjDtzyDsisG25XJJ2fgTNSWIIpBQ26xFOs73o8Pkxgrluak
         LxPT8KHSYKzlxA54OviCsr0WwVnQSyjdJF529W/lXedQ0VRF9/p/lxbERkqOk04Q3w
         hqYS39qh3PNvW4QOPwabgy6sXTF8qsp8JFPrU7Mw=
Subject: FAILED: patch "[PATCH] RDMA/qedr: Fix reporting QP timeout attribute" failed to apply to 4.9-stable tree
To:     kamalheib1@gmail.com, leonro@nvidia.com,
        michal.kalderon@marvell.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Jul 2022 13:56:29 +0200
Message-ID: <165693578923618@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 118f767413ada4eef7825fbd4af7c0866f883441 Mon Sep 17 00:00:00 2001
From: Kamal Heib <kamalheib1@gmail.com>
Date: Wed, 25 May 2022 16:20:29 +0300
Subject: [PATCH] RDMA/qedr: Fix reporting QP timeout attribute
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Make sure to save the passed QP timeout attribute when the QP gets modified,
so when calling query QP the right value is reported and not the
converted value that is required by the firmware. This issue was found
while running the pyverbs tests.

Fixes: cecbcddf6461 ("qedr: Add support for QP verbs")
Link: https://lore.kernel.org/r/20220525132029.84813-1-kamalheib1@gmail.com
Signed-off-by: Kamal Heib <kamalheib1@gmail.com>
Acked-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

diff --git a/drivers/infiniband/hw/qedr/qedr.h b/drivers/infiniband/hw/qedr/qedr.h
index 8def88cfa300..db9ef3e1eb97 100644
--- a/drivers/infiniband/hw/qedr/qedr.h
+++ b/drivers/infiniband/hw/qedr/qedr.h
@@ -418,6 +418,7 @@ struct qedr_qp {
 	u32 sq_psn;
 	u32 qkey;
 	u32 dest_qp_num;
+	u8 timeout;
 
 	/* Relevant to qps created from kernel space only (ULPs) */
 	u8 prev_wqe_size;
diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index f0f43b6db89e..03ed7c0fae50 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -2613,6 +2613,8 @@ int qedr_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 					1 << max_t(int, attr->timeout - 8, 0);
 		else
 			qp_params.ack_timeout = 0;
+
+		qp->timeout = attr->timeout;
 	}
 
 	if (attr_mask & IB_QP_RETRY_CNT) {
@@ -2772,7 +2774,7 @@ int qedr_query_qp(struct ib_qp *ibqp,
 	rdma_ah_set_dgid_raw(&qp_attr->ah_attr, &params.dgid.bytes[0]);
 	rdma_ah_set_port_num(&qp_attr->ah_attr, 1);
 	rdma_ah_set_sl(&qp_attr->ah_attr, 0);
-	qp_attr->timeout = params.timeout;
+	qp_attr->timeout = qp->timeout;
 	qp_attr->rnr_retry = params.rnr_retry;
 	qp_attr->retry_cnt = params.retry_cnt;
 	qp_attr->min_rnr_timer = params.min_rnr_nak_timer;

