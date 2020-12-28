Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C07282E3C40
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407937AbgL1OAV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:00:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:33656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407933AbgL1OAT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:00:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31CEA20715;
        Mon, 28 Dec 2020 14:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164003;
        bh=7vI0Q7x/w8du7L5B9lNnZXh9mvBXTj8LZPNDxI5uM50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=safueGgGy1J9UkHsm90QiNCFm1bH1HP1YUICyXCHRyfS+y/fXDOOUpgUwRcMCJn1q
         ENbjYvxZRROh/ay0q2nNdbZijmnh5tDnxW8vc41Anl4vNvAl3Gm7vpIwnXQmJzxSnx
         ll0EgZPHt1LPfOu09/Nap6ZF3FuCm95lKwG/nG40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gioh Kim <gi-oh.kim@cloud.ionos.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 027/717] RDMA/rtrs-clt: Missing error from rtrs_rdma_conn_established
Date:   Mon, 28 Dec 2020 13:40:25 +0100
Message-Id: <20201228125022.287534526@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gioh Kim <gi-oh.kim@cloud.ionos.com>

[ Upstream commit f553e7601df9566ba7644541fc09152a3a81f793 ]

When rtrs_rdma_conn_established returns error (non-zero value), the error
value is stored in con->cm_err and it cannot trigger
rtrs_rdma_error_recovery. Finally the error of rtrs_rdma_con_established
will be forgot.

Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
Link: https://lore.kernel.org/r/20201023074353.21946-5-jinpu.wang@cloud.ionos.com
Signed-off-by: Gioh Kim <gi-oh.kim@cloud.ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 3cc957fea93ee..d54a77ebe1184 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -1835,8 +1835,8 @@ static int rtrs_clt_rdma_cm_handler(struct rdma_cm_id *cm_id,
 		cm_err = rtrs_rdma_route_resolved(con);
 		break;
 	case RDMA_CM_EVENT_ESTABLISHED:
-		con->cm_err = rtrs_rdma_conn_established(con, ev);
-		if (likely(!con->cm_err)) {
+		cm_err = rtrs_rdma_conn_established(con, ev);
+		if (likely(!cm_err)) {
 			/*
 			 * Report success and wake up. Here we abuse state_wq,
 			 * i.e. wake up without state change, but we set cm_err.
-- 
2.27.0



