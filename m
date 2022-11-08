Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF3F621466
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234842AbiKHOAw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:00:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234909AbiKHOAv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:00:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D4C53ECE
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:00:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D77F5615AD
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:00:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD484C433C1;
        Tue,  8 Nov 2022 14:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916049;
        bh=z5kW/whl77rCgDHBEZYSLtQz0HC6kS8UQ4/+c2CQANA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mze/UuhGjkczTsHdepscO5Z9HxV0BTWprPSc9SnAo0ZKt4hpq3MdPmBhsnRRIl12k
         hp7t8akgkoyvpRDf3nyjtwpz6qMGmQAAOTqXlYwOb7k+YhohppslMKlgHcia4y/bcU
         SaJJDbyrvyuVSnDANVLJUTbSvKWeXWbRyeh841pE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yangyang Li <liyangyang20@huawei.com>,
        Wenpeng Liang <liangwenpeng@huawei.com>,
        Haoyue Xu <xuhaoyue1@hisilicon.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 017/144] RDMA/hns: Disable local invalidate operation
Date:   Tue,  8 Nov 2022 14:38:14 +0100
Message-Id: <20221108133346.050725798@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
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

From: Yangyang Li <liyangyang20@huawei.com>

[ Upstream commit 9e272ed69ad6f6952fafd0599d6993575512408e ]

When function reset and local invalidate are mixed, HNS RoCEE may hang.
Before introducing the cause of the problem, two hardware internal
concepts need to be introduced:

    1. Execution queue: The queue of hardware execution instructions,
    function reset and local invalidate are queued for execution in this
    queue.

    2.Local queue: A queue that stores local operation instructions. The
    instructions in the local queue will be sent to the execution queue
    for execution. The instructions in the local queue will not be removed
    until the execution is completed.

The reason for the problem is as follows:

    1. There is a function reset instruction in the execution queue, which
    is currently being executed. A necessary condition for the successful
    execution of function reset is: the hardware pipeline needs to empty
    the instructions that were not completed before;

    2. A local invalidate instruction at the head of the local queue is
    sent to the execution queue. Now there are two instructions in the
    execution queue, the first is the function reset instruction, and the
    second is the local invalidate instruction, which will be executed in
    se quence;

    3. The user has issued many local invalidate operations, causing the
    local queue to be filled up.

    4. The user still has a new local operation command and is queuing to
    enter the local queue. But the local queue is full and cannot receive
    new instructions, this instruction is temporarily stored at the
    hardware pipeline.

    5. The function reset has been waiting for the instruction before the
    hardware pipeline stage is drained. The hardware pipeline stage also
    caches a local invalidate instruction, so the function reset cannot be
    completed, and the instructions after it cannot be executed.

These factors together cause the execution logic deadlock of the hardware,
and the consequence is that RoCEE will not have any response.  Considering
that the local operation command may potentially cause RoCEE to hang, this
feature is no longer supported.

Fixes: e93df0108579 ("RDMA/hns: Support local invalidate for hip08 in kernel space")
Signed-off-by: Yangyang Li <liyangyang20@huawei.com>
Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Haoyue Xu <xuhaoyue1@hisilicon.com>
Link: https://lore.kernel.org/r/20221024083814.1089722-2-xuhaoyue1@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 11 -----------
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h |  2 --
 2 files changed, 13 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 3b26c74efee0..1421896abaf0 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -82,7 +82,6 @@ static const u32 hns_roce_op_code[] = {
 	HR_OPC_MAP(ATOMIC_CMP_AND_SWP,		ATOM_CMP_AND_SWAP),
 	HR_OPC_MAP(ATOMIC_FETCH_AND_ADD,	ATOM_FETCH_AND_ADD),
 	HR_OPC_MAP(SEND_WITH_INV,		SEND_WITH_INV),
-	HR_OPC_MAP(LOCAL_INV,			LOCAL_INV),
 	HR_OPC_MAP(MASKED_ATOMIC_CMP_AND_SWP,	ATOM_MSK_CMP_AND_SWAP),
 	HR_OPC_MAP(MASKED_ATOMIC_FETCH_AND_ADD,	ATOM_MSK_FETCH_AND_ADD),
 	HR_OPC_MAP(REG_MR,			FAST_REG_PMR),
@@ -524,9 +523,6 @@ static int set_rc_opcode(struct hns_roce_dev *hr_dev,
 		else
 			ret = -EOPNOTSUPP;
 		break;
-	case IB_WR_LOCAL_INV:
-		hr_reg_enable(rc_sq_wqe, RC_SEND_WQE_SO);
-		fallthrough;
 	case IB_WR_SEND_WITH_INV:
 		rc_sq_wqe->inv_key = cpu_to_le32(wr->ex.invalidate_rkey);
 		break;
@@ -3058,7 +3054,6 @@ static int hns_roce_v2_write_mtpt(struct hns_roce_dev *hr_dev,
 
 	hr_reg_write(mpt_entry, MPT_ST, V2_MPT_ST_VALID);
 	hr_reg_write(mpt_entry, MPT_PD, mr->pd);
-	hr_reg_enable(mpt_entry, MPT_L_INV_EN);
 
 	hr_reg_write_bool(mpt_entry, MPT_BIND_EN,
 			  mr->access & IB_ACCESS_MW_BIND);
@@ -3151,7 +3146,6 @@ static int hns_roce_v2_frmr_write_mtpt(struct hns_roce_dev *hr_dev,
 
 	hr_reg_enable(mpt_entry, MPT_RA_EN);
 	hr_reg_enable(mpt_entry, MPT_R_INV_EN);
-	hr_reg_enable(mpt_entry, MPT_L_INV_EN);
 
 	hr_reg_enable(mpt_entry, MPT_FRE);
 	hr_reg_clear(mpt_entry, MPT_MR_MW);
@@ -3183,7 +3177,6 @@ static int hns_roce_v2_mw_write_mtpt(void *mb_buf, struct hns_roce_mw *mw)
 	hr_reg_write(mpt_entry, MPT_PD, mw->pdn);
 
 	hr_reg_enable(mpt_entry, MPT_R_INV_EN);
-	hr_reg_enable(mpt_entry, MPT_L_INV_EN);
 	hr_reg_enable(mpt_entry, MPT_LW_EN);
 
 	hr_reg_enable(mpt_entry, MPT_MR_MW);
@@ -3540,7 +3533,6 @@ static const u32 wc_send_op_map[] = {
 	HR_WC_OP_MAP(RDMA_READ,			RDMA_READ),
 	HR_WC_OP_MAP(RDMA_WRITE,		RDMA_WRITE),
 	HR_WC_OP_MAP(RDMA_WRITE_WITH_IMM,	RDMA_WRITE),
-	HR_WC_OP_MAP(LOCAL_INV,			LOCAL_INV),
 	HR_WC_OP_MAP(ATOM_CMP_AND_SWAP,		COMP_SWAP),
 	HR_WC_OP_MAP(ATOM_FETCH_AND_ADD,	FETCH_ADD),
 	HR_WC_OP_MAP(ATOM_MSK_CMP_AND_SWAP,	MASKED_COMP_SWAP),
@@ -3590,9 +3582,6 @@ static void fill_send_wc(struct ib_wc *wc, struct hns_roce_v2_cqe *cqe)
 	case HNS_ROCE_V2_WQE_OP_RDMA_WRITE_WITH_IMM:
 		wc->wc_flags |= IB_WC_WITH_IMM;
 		break;
-	case HNS_ROCE_V2_WQE_OP_LOCAL_INV:
-		wc->wc_flags |= IB_WC_WITH_INVALIDATE;
-		break;
 	case HNS_ROCE_V2_WQE_OP_ATOM_CMP_AND_SWAP:
 	case HNS_ROCE_V2_WQE_OP_ATOM_FETCH_AND_ADD:
 	case HNS_ROCE_V2_WQE_OP_ATOM_MSK_CMP_AND_SWAP:
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index ddb99a7ff135..2f4a0019a716 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -184,7 +184,6 @@ enum {
 	HNS_ROCE_V2_WQE_OP_ATOM_MSK_CMP_AND_SWAP	= 0x8,
 	HNS_ROCE_V2_WQE_OP_ATOM_MSK_FETCH_AND_ADD	= 0x9,
 	HNS_ROCE_V2_WQE_OP_FAST_REG_PMR			= 0xa,
-	HNS_ROCE_V2_WQE_OP_LOCAL_INV			= 0xb,
 	HNS_ROCE_V2_WQE_OP_BIND_MW			= 0xc,
 	HNS_ROCE_V2_WQE_OP_MASK				= 0x1f,
 };
@@ -944,7 +943,6 @@ struct hns_roce_v2_rc_send_wqe {
 #define RC_SEND_WQE_OWNER RC_SEND_WQE_FIELD_LOC(7, 7)
 #define RC_SEND_WQE_CQE RC_SEND_WQE_FIELD_LOC(8, 8)
 #define RC_SEND_WQE_FENCE RC_SEND_WQE_FIELD_LOC(9, 9)
-#define RC_SEND_WQE_SO RC_SEND_WQE_FIELD_LOC(10, 10)
 #define RC_SEND_WQE_SE RC_SEND_WQE_FIELD_LOC(11, 11)
 #define RC_SEND_WQE_INLINE RC_SEND_WQE_FIELD_LOC(12, 12)
 #define RC_SEND_WQE_WQE_INDEX RC_SEND_WQE_FIELD_LOC(30, 15)
-- 
2.35.1



