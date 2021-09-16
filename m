Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61C4840E680
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346918AbhIPRV7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:21:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351944AbhIPRUA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:20:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA7AB61A2A;
        Thu, 16 Sep 2021 16:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810510;
        bh=Va8bcP5CQ4q/oK4EpZUyhifW4YVhyPh0tA5iq7z/eMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CMwgTVpMbnXr71qLwJrMM7hgXmbYeonvGgT/B0z3wlWbg0BhQZwVO1YcuXRiRtRS1
         a35SprlLycPczYuP8ludwF5ik4sOF/8XazgYr5d8X4fAygj420JCd26ACnZ82lsRFB
         oRgcBOXh2RkedGZM+D6kti3cF4oEl36MQCsByGU4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yixing Liu <liuyixing1@huawei.com>,
        Wenpeng Liang <liangwenpeng@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 135/432] RDMA/hns: Fix incorrect lsn field
Date:   Thu, 16 Sep 2021 17:58:04 +0200
Message-Id: <20210916155815.331821768@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yixing Liu <liuyixing1@huawei.com>

[ Upstream commit 9bed8a70716ba65d300b9cc30eb7e0276353f7bf ]

In RNR NAK screnario, according to the specification, when no credit is
available, only the first fragment of the send request can be sent. The
LSN(Limit Sequence Number) field should be 0 or the entire packet will be
resent.

Fixes: 926a01dc000d ("RDMA/hns: Add QP operations support for hip08 SoC")
Link: https://lore.kernel.org/r/1629883169-2306-1-git-send-email-liangwenpeng@huawei.com
Signed-off-by: Yixing Liu <liuyixing1@huawei.com>
Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 0e0be5664137..f4cea6dcec2f 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4489,9 +4489,6 @@ static int modify_qp_rtr_to_rts(struct ib_qp *ibqp,
 
 	hr_reg_clear(qpc_mask, QPC_CHECK_FLG);
 
-	hr_reg_write(context, QPC_LSN, 0x100);
-	hr_reg_clear(qpc_mask, QPC_LSN);
-
 	hr_reg_clear(qpc_mask, QPC_V2_IRRL_HEAD);
 
 	return 0;
-- 
2.30.2



