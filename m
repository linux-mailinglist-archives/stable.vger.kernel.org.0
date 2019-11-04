Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9CD7EED51
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389841AbfKDWFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:05:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:36852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388444AbfKDWF3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:05:29 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A182E2084D;
        Mon,  4 Nov 2019 22:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905129;
        bh=NjxgLiEaplHS39J1mvZTecb/FKS7xh3ECqXe5Meeb1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FdiwL18mZDpu6kEsp5i85i1dCXuR1t4mTmy0p+0BH8B8q47pwC4kbO9cm8JoHIAPf
         5chXSz4JXu62ThtCMigsuZ0yV/GiKBOEjg0aG9em8CT7U7BB0uE2j4K7Qgso9YBitQ
         Cspbzz74MOAVbDsopL8o7542hNgjcHYam8T3bpm0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 037/163] RDMA/core: Fix an error handling path in res_get_common_doit()
Date:   Mon,  4 Nov 2019 22:43:47 +0100
Message-Id: <20191104212142.888554239@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



