Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47BC52E3C4B
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436563AbgL1OAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:00:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:34400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436562AbgL1OAl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:00:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5280720799;
        Mon, 28 Dec 2020 14:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164000;
        bh=/Ny9ygLv5EuFA6BGo52r5pyv6x5LktthaUAQl61JnT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GBEpRabQpfsuATb1Dr3DpNi7ex3ftp8HagZW10T2Fzzuv5KWIwvaTmQdlGvGWjJQ0
         zdrAgtiVhDz5nn6VUJl6J4J8R7n8rkhRtJUojMm795EOfdhwT8ueowwGG4koHRH8k6
         WlpBgkRMZ5n3wtSMwZaUB0RC5bV1TRc/cPGzilcw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Danil Kipnis <danil.kipnis@cloud.ionos.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 026/717] RDMA/rtrs-clt: Remove destroy_con_cq_qp in case route resolving failed
Date:   Mon, 28 Dec 2020 13:40:24 +0100
Message-Id: <20201228125022.238954282@linuxfoundation.org>
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

From: Danil Kipnis <danil.kipnis@cloud.ionos.com>

[ Upstream commit 2b3062e4d997f201c1ad2bbde88b7271dd9ef35f ]

We call destroy_con_cq_qp(con) in rtrs_rdma_addr_resolved() in case route
couldn't be resolved and then again in create_cm() because nothing
happens.

Don't call destroy_con_cq_qp from rtrs_rdma_addr_resolved, create_cm()
does the clean up already.

Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
Link: https://lore.kernel.org/r/20201023074353.21946-2-jinpu.wang@cloud.ionos.com
Signed-off-by: Danil Kipnis <danil.kipnis@cloud.ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index f298adc02acba..3cc957fea93ee 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -1640,10 +1640,8 @@ static int rtrs_rdma_addr_resolved(struct rtrs_clt_con *con)
 		return err;
 	}
 	err = rdma_resolve_route(con->c.cm_id, RTRS_CONNECT_TIMEOUT_MS);
-	if (err) {
+	if (err)
 		rtrs_err(s, "Resolving route failed, err: %d\n", err);
-		destroy_con_cq_qp(con);
-	}
 
 	return err;
 }
-- 
2.27.0



