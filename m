Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D416DD4BC
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406273AbfJRW0y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:26:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727821AbfJRWEK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:04:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1872222C5;
        Fri, 18 Oct 2019 22:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436249;
        bh=NjxgLiEaplHS39J1mvZTecb/FKS7xh3ECqXe5Meeb1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T7tdWfg4UlopICbWd2CYzSZlmga3l/r8e1AfGqqu+PNuQ9fQNi0rQ1AlaYDbhzxds
         mHeYluE886vIeb6gBrgHM8QTWWo0SEFDqhM96WWhTiMh1k/glUUOGDSKE37swfzVns
         K3vbeq+M6q5FVU9neyRM7ynhe8vmELxkM980g11E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 33/89] RDMA/core: Fix an error handling path in 'res_get_common_doit()'
Date:   Fri, 18 Oct 2019 18:02:28 -0400
Message-Id: <20191018220324.8165-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220324.8165-1-sashal@kernel.org>
References: <20191018220324.8165-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit ab59ca3eb4e7059727df85eee68bda169d26c8f8 ]

According to surrounding error paths, it is likely that 'goto err_get;' is
expected here. Otherwise, a call to 'rdma_restrack_put(res);' would be
missing.

Fixes: c5dfe0ea6ffa ("RDMA/nldev: Add resource tracker doit callback")
Link: https://lore.kernel.org/r/20190818091044.8845-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/nldev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 020c269765584..91e2cc9ddb9f8 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -1230,7 +1230,7 @@ static int res_get_common_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg) {
 		ret = -ENOMEM;
-		goto err;
+		goto err_get;
 	}
 
 	nlh = nlmsg_put(msg, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
-- 
2.20.1

