Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C46E63FDC14
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245738AbhIAMqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:46:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345623AbhIAMow (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:44:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6065A60F56;
        Wed,  1 Sep 2021 12:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499924;
        bh=TvDWqhPF04TvKZBzOXNRsyIb4UiNdXanc/bHZnCrsUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vUUTNQCraC+R1UzVpQTNxNfJMFiUsHiwYOpaI3jnaTl9Y+fKoATM89Io7vGmeDhQP
         H1Y9FKcYU2dcbVu3ux0FdrSe3ko0zCWcQvseRf/DHc2pR48aTQvLOZGNlDbBpMio5E
         6358KQod8u9mMUdhqoTbQ1NqzabiAV+HiEECcWUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 037/113] RDMA/bnxt_re: Add missing spin lock initialization
Date:   Wed,  1 Sep 2021 14:27:52 +0200
Message-Id: <20210901122303.227686968@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>

[ Upstream commit 17f2569dce1848080825b8336e6b7c6900193b44 ]

Add the missing initialization of srq lock.

Fixes: 37cb11acf1f7 ("RDMA/bnxt_re: Add SRQ support for Broadcom adapters")
Link: https://lore.kernel.org/r/1629343553-5843-3-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 2efaa80bfbd2..9d79005befd6 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1691,6 +1691,7 @@ int bnxt_re_create_srq(struct ib_srq *ib_srq,
 	if (nq)
 		nq->budget++;
 	atomic_inc(&rdev->srq_count);
+	spin_lock_init(&srq->lock);
 
 	return 0;
 
-- 
2.30.2



