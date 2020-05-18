Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 145C21D825C
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730501AbgERRzo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:55:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:33110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731550AbgERRzn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:55:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64E9520674;
        Mon, 18 May 2020 17:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824542;
        bh=qm2ebLQpPuB5UzhypP58ZpTegmhnDmthwg66hFvVqtM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ZrylI9rmm0LfuLOAoT6Vt7yL5vnti1hlsBdIv8rTVIixUUdiQjarKTUiYobA/2xD
         cA7Gt++zDzMKMYiNqL0Y9DiTxaGLl24amhpV9Bf7rJYBuZan5ILYRIYqMsXQgsAFje
         g67WV4TrT5Lx1a4vNYGTdh9cPqj/W+7FTypRuKck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 054/147] IB/hfi1: Fix another case where pq is left on waitlist
Date:   Mon, 18 May 2020 19:36:17 +0200
Message-Id: <20200518173520.713628898@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

[ Upstream commit fa8dac3968635dec8518a13ac78d662f2aa88e4d ]

The commit noted below fixed a case where a pq is left on the sdma wait
list.

It however missed another case.

user_sdma_send_pkts() has two calls from hfi1_user_sdma_process_request().

If the first one fails as indicated by -EBUSY, the pq will be placed on
the waitlist as by design.

If the second call then succeeds, the pq is still on the waitlist setting
up a race with the interrupt handler if a subsequent request uses a
different SDMA engine

Fix by deleting the first call.

The use of pcount and the intent to send a short burst of packets followed
by the larger balance of packets was never correctly implemented, because
the two calls always send pcount packets no matter what.  A subsequent
patch will correct that issue.

Fixes: 9a293d1e21a6 ("IB/hfi1: Ensure pq is not left on waitlist")
Link: https://lore.kernel.org/r/20200504130917.175613.43231.stgit@awfm-01.aw.intel.com
Cc: <stable@vger.kernel.org>
Reviewed-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/user_sdma.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index 13e4203497b33..a92346e88628b 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -589,10 +589,6 @@ int hfi1_user_sdma_process_request(struct hfi1_filedata *fd,
 
 	set_comp_state(pq, cq, info.comp_idx, QUEUED, 0);
 	pq->state = SDMA_PKT_Q_ACTIVE;
-	/* Send the first N packets in the request to buy us some time */
-	ret = user_sdma_send_pkts(req, pcount);
-	if (unlikely(ret < 0 && ret != -EBUSY))
-		goto free_req;
 
 	/*
 	 * This is a somewhat blocking send implementation.
-- 
2.20.1



