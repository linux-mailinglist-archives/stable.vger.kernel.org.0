Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB701A5B68
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbgDKXEP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:04:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:37492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727048AbgDKXEN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:04:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 682AF2173E;
        Sat, 11 Apr 2020 23:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646254;
        bh=xiyflRifsOXsJLL/7BvIprL3s/32ge0KuHtMipDMcBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BkswcVO+b8bdQ//LhbWfue42Oy1wGaSO9jof4eognFA9WHp2tnYlmsCR92dJKGWRU
         Utrx2mOdvdugl0aqEBXCmv8TgHTo6ZTUkfu7A8ZXuSiXpIWvY0bdtP71jsGooXCAH5
         hADqNIktLEMPY5OXdtpEajPEk/Y6Zx+Fsn8xYLww=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 021/149] RDMA/cm: Add missing locking around id.state in cm_dup_req_handler
Date:   Sat, 11 Apr 2020 19:01:38 -0400
Message-Id: <20200411230347.22371-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
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
index 3b2b9a3546a13..f3a845c100384 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1833,8 +1833,12 @@ static void cm_dup_req_handler(struct cm_work *work,
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

