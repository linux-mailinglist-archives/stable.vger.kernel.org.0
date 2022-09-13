Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFD025B6FF7
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233241AbiIMOUe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233616AbiIMOT2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:19:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF276556E;
        Tue, 13 Sep 2022 07:14:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BFC78B80EF8;
        Tue, 13 Sep 2022 14:14:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34789C433D6;
        Tue, 13 Sep 2022 14:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078443;
        bh=ZEPGgOGoYFei7a8Dw68+BjH8Pus/gQZBsMUyRUPSWYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2no+xc0LYmY5Pmy+PfkExHUytYhm4bxW2nJxUMgrjYwRmQOU+Lsu6PqNPcKzDzI8V
         tz2phG/LktFn9m/sMgDCEplWWqx3nzcJyK9GhIDR1OHUhimtLtS4/jvJ2Q80zLdoKe
         T/NIF9yS+XmDiF1eF5ROeMMqHYwyyxB9ZFnXe0KI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sindhu-Devale <sindhu.devale@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 142/192] RDMA/irdma: Return correct WC error for bind operation failure
Date:   Tue, 13 Sep 2022 16:04:08 +0200
Message-Id: <20220913140417.094887013@linuxfoundation.org>
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

From: Sindhu-Devale <sindhu.devale@intel.com>

[ Upstream commit dcb23bbb1de7e009875fdfac2b8a9808a9319cc6 ]

When a QP and a MR on a local host are in different PDs, the HW generates
an asynchronous event (AE). The same AE is generated when a QP and a MW
are in different PDs during a bind operation. Return the more appropriate
IBV_WC_MW_BIND_ERR for the latter case by checking the OP type from the
CQE in error.

Fixes: 551c46edc769 ("RDMA/irdma: Add user/kernel shared libraries")
Signed-off-by: Sindhu-Devale <sindhu.devale@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Link: https://lore.kernel.org/r/20220906223244.1119-4-shiraz.saleem@intel.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/uk.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/uk.c b/drivers/infiniband/hw/irdma/uk.c
index daeab5daed5bc..d003ad864ee44 100644
--- a/drivers/infiniband/hw/irdma/uk.c
+++ b/drivers/infiniband/hw/irdma/uk.c
@@ -1005,6 +1005,7 @@ int irdma_uk_cq_poll_cmpl(struct irdma_cq_uk *cq,
 	int ret_code;
 	bool move_cq_head = true;
 	u8 polarity;
+	u8 op_type;
 	bool ext_valid;
 	__le64 *ext_cqe;
 
@@ -1187,7 +1188,6 @@ int irdma_uk_cq_poll_cmpl(struct irdma_cq_uk *cq,
 			do {
 				__le64 *sw_wqe;
 				u64 wqe_qword;
-				u8 op_type;
 				u32 tail;
 
 				tail = qp->sq_ring.tail;
@@ -1204,6 +1204,8 @@ int irdma_uk_cq_poll_cmpl(struct irdma_cq_uk *cq,
 					break;
 				}
 			} while (1);
+			if (op_type == IRDMA_OP_TYPE_BIND_MW && info->minor_err == FLUSH_PROT_ERR)
+				info->minor_err = FLUSH_MW_BIND_ERR;
 			qp->sq_flush_seen = true;
 			if (!IRDMA_RING_MORE_WORK(qp->sq_ring))
 				qp->sq_flush_complete = true;
-- 
2.35.1



