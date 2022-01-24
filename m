Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21FA049A95C
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1322510AbiAYDV4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:21:56 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35530 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356240AbiAXU3N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:29:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33606B81257;
        Mon, 24 Jan 2022 20:29:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 677C2C340E5;
        Mon, 24 Jan 2022 20:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056150;
        bh=QcleD3Xl2DWJeZNgOOnzuLP8XHdGsxum61Y2eVgQT0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=npKK6PbX2NbsTAQH3L6aXsUBb1QjD4i7Mqx9YoK1K0P5hw+gpwm4wbIjHNbSNSwGz
         VSbAYHIaflidNSnmobq13Z/lIS6om2pZtwmcO994MNU2T29W88qVmVXbcnQseV/OYd
         pajJaiw8u1OMv3P+xsBUSAx1QnNB1R9UyKuVejZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@ionos.com>,
        Guoqing Jiang <Guoqing.Jiang@linux.dev>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 387/846] RDMA/rtrs-clt: Fix the initial value of min_latency
Date:   Mon, 24 Jan 2022 19:38:24 +0100
Message-Id: <20220124184114.287284065@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Wang <jinpu.wang@ionos.com>

[ Upstream commit 925cac6358677d3d64f9b25f205eeb3d31c9f7f8 ]

The type of min_latency is ktime_t, so use KTIME_MAX to initialize the
initial value.

Fixes: dc3b66a0ce70 ("RDMA/rtrs-clt: Add a minimum latency multipath policy")
Link: https://lore.kernel.org/r/20211124081040.19533-1-jinpu.wang@ionos.com
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Reviewed-by: Guoqing Jiang <Guoqing.Jiang@linux.dev>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index bc8824b4ee0d4..55ebe01ec9951 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -867,7 +867,7 @@ static struct rtrs_clt_sess *get_next_path_min_latency(struct path_it *it)
 	struct rtrs_clt_sess *min_path = NULL;
 	struct rtrs_clt *clt = it->clt;
 	struct rtrs_clt_sess *sess;
-	ktime_t min_latency = INT_MAX;
+	ktime_t min_latency = KTIME_MAX;
 	ktime_t latency;
 
 	list_for_each_entry_rcu(sess, &clt->paths_list, s.entry) {
-- 
2.34.1



