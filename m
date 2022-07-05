Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C812566B1A
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233568AbiGEMEW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233322AbiGEMCb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:02:31 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ABD7186CD;
        Tue,  5 Jul 2022 05:02:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BAF3CCE1B87;
        Tue,  5 Jul 2022 12:02:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF66C36AE5;
        Tue,  5 Jul 2022 12:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022535;
        bh=7IZW/plT//M+qNPKohn68SEQjce+pTBJGYC4fgLZmNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wCZbub9GRJc8fwnhBEhl3/SD8vwJZajrP+55GbQu6jq9G8R7LeQeVnFfd3cdkb8AG
         bI82mOx+WJKBL54kCxqwSXsi3idn2iocGGAl0rB0r18jfPj6MghmN2eSrphhO+/87/
         CWD/zFgI6J0UuGjFFgFI51T3tWjXx5yUk4RJImI8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Heib <kamalheib1@gmail.com>,
        =?UTF-8?q?Michal=20Kalderon=C2=A0?= <michal.kalderon@marvell.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH 4.19 12/33] RDMA/qedr: Fix reporting QP timeout attribute
Date:   Tue,  5 Jul 2022 13:58:04 +0200
Message-Id: <20220705115607.069496784@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115606.709817198@linuxfoundation.org>
References: <20220705115606.709817198@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Kamal Heib <kamalheib1@gmail.com>

commit 118f767413ada4eef7825fbd4af7c0866f883441 upstream.

Make sure to save the passed QP timeout attribute when the QP gets modified,
so when calling query QP the right value is reported and not the
converted value that is required by the firmware. This issue was found
while running the pyverbs tests.

Fixes: cecbcddf6461 ("qedr: Add support for QP verbs")
Link: https://lore.kernel.org/r/20220525132029.84813-1-kamalheib1@gmail.com
Signed-off-by: Kamal Heib <kamalheib1@gmail.com>
Acked-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/qedr/qedr.h  |    1 +
 drivers/infiniband/hw/qedr/verbs.c |    4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/hw/qedr/qedr.h
+++ b/drivers/infiniband/hw/qedr/qedr.h
@@ -407,6 +407,7 @@ struct qedr_qp {
 	u32 sq_psn;
 	u32 qkey;
 	u32 dest_qp_num;
+	u8 timeout;
 
 	/* Relevant to qps created from kernel space only (ULPs) */
 	u8 prev_wqe_size;
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -2376,6 +2376,8 @@ int qedr_modify_qp(struct ib_qp *ibqp, s
 					1 << max_t(int, attr->timeout - 8, 0);
 		else
 			qp_params.ack_timeout = 0;
+
+		qp->timeout = attr->timeout;
 	}
 
 	if (attr_mask & IB_QP_RETRY_CNT) {
@@ -2535,7 +2537,7 @@ int qedr_query_qp(struct ib_qp *ibqp,
 	rdma_ah_set_dgid_raw(&qp_attr->ah_attr, &params.dgid.bytes[0]);
 	rdma_ah_set_port_num(&qp_attr->ah_attr, 1);
 	rdma_ah_set_sl(&qp_attr->ah_attr, 0);
-	qp_attr->timeout = params.timeout;
+	qp_attr->timeout = qp->timeout;
 	qp_attr->rnr_retry = params.rnr_retry;
 	qp_attr->retry_cnt = params.retry_cnt;
 	qp_attr->min_rnr_timer = params.min_rnr_nak_timer;


