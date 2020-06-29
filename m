Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3639720E763
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730060AbgF2V4q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:56:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:56764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726520AbgF2Sfa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5804624692;
        Mon, 29 Jun 2020 15:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443987;
        bh=C7vN3ZMmLv4OKeTt0VDBRY3+6jrh8L5yizzK4p3NFxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B14r1JVg6iVJardyj+AmxyVwh9+7Q+ytQVgR3jrcxdPoamDMrdQ/R3Kp5cse0hhGN
         3GKf24PM3aHBKSxR5xUHnyXtK1GMLO/Cc1QI1CWCiNFXxNm9x0zdNHKCoG74+yAx5I
         Z2W/oxPmkjK4MwhkQ+DaFNvq7zEj3xaFlUmuO2bk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shay Drory <shayd@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 091/265] IB/mad: Fix use after free when destroying MAD agent
Date:   Mon, 29 Jun 2020 11:15:24 -0400
Message-Id: <20200629151818.2493727-92-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shay Drory <shayd@mellanox.com>

commit 116a1b9f1cb769b83e5adff323f977a62b1dcb2e upstream.

Currently, when RMPP MADs are processed while the MAD agent is destroyed,
it could result in use after free of rmpp_recv, as decribed below:

	cpu-0						cpu-1
	-----						-----
ib_mad_recv_done()
 ib_mad_complete_recv()
  ib_process_rmpp_recv_wc()
						unregister_mad_agent()
						 ib_cancel_rmpp_recvs()
						  cancel_delayed_work()
   process_rmpp_data()
    start_rmpp()
     queue_delayed_work(rmpp_recv->cleanup_work)
						  destroy_rmpp_recv()
						   free_rmpp_recv()
     cleanup_work()[1]
      spin_lock_irqsave(&rmpp_recv->agent->lock) <-- use after free

[1] cleanup_work() == recv_cleanup_handler

Fix it by waiting for the MAD agent reference count becoming zero before
calling to ib_cancel_rmpp_recvs().

Fixes: 9a41e38a467c ("IB/mad: Use IDR for agent IDs")
Link: https://lore.kernel.org/r/20200621104738.54850-2-leon@kernel.org
Signed-off-by: Shay Drory <shayd@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/mad.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index c54db13fa9b0a..f7626ebcf31cf 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -639,10 +639,10 @@ static void unregister_mad_agent(struct ib_mad_agent_private *mad_agent_priv)
 	xa_erase(&ib_mad_clients, mad_agent_priv->agent.hi_tid);
 
 	flush_workqueue(port_priv->wq);
-	ib_cancel_rmpp_recvs(mad_agent_priv);
 
 	deref_mad_agent(mad_agent_priv);
 	wait_for_completion(&mad_agent_priv->comp);
+	ib_cancel_rmpp_recvs(mad_agent_priv);
 
 	ib_mad_agent_security_cleanup(&mad_agent_priv->agent);
 
-- 
2.25.1

