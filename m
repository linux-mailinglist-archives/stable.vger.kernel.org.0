Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCB532E8CF
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbhCEM3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:29:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:37526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231937AbhCEM2e (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:28:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0872B6502C;
        Fri,  5 Mar 2021 12:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947314;
        bh=nAMy39NkZ2ClvWI4RhXZXpAd0ZD3tiTUAxGjjWRA8HY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rKEcnwHgpfAofIii0DhYSJFkVx5wO2gU5IlPmjHVUIlBkoQDq5WioB1QxW5ifXyKC
         6R2ak9AEANf7A7FA24BsDuyoYNppGbVw+OAsxnPSO2/mIQYDr1ArztJsB8mWfA7BiH
         V9KlawXIQOZ3jIOiEs8vaRtigHOracdlB9brg7Nk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@cloud.ionos.com>,
        Gioh Kim <gi-oh.kim@cloud.ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.10 022/102] RDMA/rtrs-srv: Do not signal REG_MR
Date:   Fri,  5 Mar 2021 13:20:41 +0100
Message-Id: <20210305120904.373956110@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.276489876@linuxfoundation.org>
References: <20210305120903.276489876@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Wang <jinpu.wang@cloud.ionos.com>

commit e8ae7ddb48a1b81fd1e67da34a0cb59daf0445d6 upstream.

We do not need to wait for REG_MR completion, so remove the
SIGNAL flag.

Fixes: 9cb837480424 ("RDMA/rtrs: server: main functionality")
Link: https://lore.kernel.org/r/20201217141915.56989-18-jinpu.wang@cloud.ionos.com
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Gioh Kim <gi-oh.kim@cloud.ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-srv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -836,7 +836,7 @@ static int process_info_req(struct rtrs_
 		rwr[mri].wr.opcode = IB_WR_REG_MR;
 		rwr[mri].wr.wr_cqe = &local_reg_cqe;
 		rwr[mri].wr.num_sge = 0;
-		rwr[mri].wr.send_flags = mri ? 0 : IB_SEND_SIGNALED;
+		rwr[mri].wr.send_flags = 0;
 		rwr[mri].mr = mr;
 		rwr[mri].key = mr->rkey;
 		rwr[mri].access = (IB_ACCESS_LOCAL_WRITE |


