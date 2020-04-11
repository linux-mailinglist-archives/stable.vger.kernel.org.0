Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80C7C1A5723
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730107AbgDKXUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:20:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:54888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730482AbgDKXNf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:13:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 618D6215A4;
        Sat, 11 Apr 2020 23:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646816;
        bh=54YuTguERE8XqKZlDR8a+iHZyI0tVqGcz9Ayam5Va54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N8GQ+P6/EznjHeChKB8KvXHggvzaNa9gAnT5uvhpK+TVljV3pl6mnT52pTz7At2hb
         zYlsdNG4rJ7rMwFxfx5do7Pq+mDGqXvh5OKuVeEQADgkXvBaW826T1vd4izMeeUauY
         KH0vmUZyrL49f+sCkU+Af9OCZvVjAELgsd5Ka7MY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 07/37] RDMA/cm: Add missing locking around id.state in cm_dup_req_handler
Date:   Sat, 11 Apr 2020 19:12:56 -0400
Message-Id: <20200411231327.26550-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411231327.26550-1-sashal@kernel.org>
References: <20200411231327.26550-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

[ Upstream commit d1de9a88074b66482443f0cd91618d7b51a7c9b6 ]

All accesses to id.state must be done under the spinlock.

Fixes: a977049dacde ("[PATCH] IB: Add the kernel CM implementation")
Link: https://lore.kernel.org/r/20200310092545.251365-10-leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 80a8eb7e5d6ec..d27e01e4916ae 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1687,8 +1687,12 @@ static void cm_dup_req_handler(struct cm_work *work,
 			counter[CM_REQ_COUNTER]);
 
 	/* Quick state check to discard duplicate REQs. */
-	if (cm_id_priv->id.state == IB_CM_REQ_RCVD)
+	spin_lock_irq(&cm_id_priv->lock);
+	if (cm_id_priv->id.state == IB_CM_REQ_RCVD) {
+		spin_unlock_irq(&cm_id_priv->lock);
 		return;
+	}
+	spin_unlock_irq(&cm_id_priv->lock);
 
 	ret = cm_alloc_response_msg(work->port, work->mad_recv_wc, &msg);
 	if (ret)
-- 
2.20.1

