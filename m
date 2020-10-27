Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C28829B0C3
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:25:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1758746AbgJ0OXU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:23:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758740AbgJ0OXS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:23:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EA5920773;
        Tue, 27 Oct 2020 14:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808597;
        bh=xJxejLZCoGIvMfxUxvrVB+wqA500Juzsi2P35DDcQ+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hWxN7Zi5fDny3kqBgwH8jQ9/evzOrhBnIaDAYk5+8ScQQHSjhDLAkT0vaIkePWHbz
         bYx1vz3BCx3EAnkTsiJjePcubmt45OMn82YWsiKveSLGm9/Mw8uiWCmwS78SLVn7oN
         jOyMoP8q3RtRqM4fBrj2Oox1IaXJqQAp7ER4IKxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijun Ou <oulijun@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 153/264] RDMA/hns: Set the unsupported wr opcode
Date:   Tue, 27 Oct 2020 14:53:31 +0100
Message-Id: <20201027135437.862347953@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

[ Upstream commit 22d3e1ed2cc837af87f76c3c8a4ccf4455e225c5 ]

hip06 does not support IB_WR_LOCAL_INV, so the ps_opcode should be set to
an invalid value instead of being left uninitialized.

Fixes: 9a4435375cd1 ("IB/hns: Add driver files for hns RoCE driver")
Fixes: a2f3d4479fe9 ("RDMA/hns: Avoid unncessary initialization")
Link: https://lore.kernel.org/r/1600350615-115217-1-git-send-email-oulijun@huawei.com
Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index 081aa91fc162d..620eaca2b8314 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -274,7 +274,6 @@ static int hns_roce_v1_post_send(struct ib_qp *ibqp,
 				ps_opcode = HNS_ROCE_WQE_OPCODE_SEND;
 				break;
 			case IB_WR_LOCAL_INV:
-				break;
 			case IB_WR_ATOMIC_CMP_AND_SWP:
 			case IB_WR_ATOMIC_FETCH_AND_ADD:
 			case IB_WR_LSO:
-- 
2.25.1



