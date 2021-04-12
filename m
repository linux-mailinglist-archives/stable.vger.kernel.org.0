Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09E3A35BD99
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237949AbhDLIw3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:52:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:38180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238697AbhDLIu0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:50:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99E3060241;
        Mon, 12 Apr 2021 08:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217409;
        bh=vtmMATUhTRbQ5ANUCsfBOEYyu18D0Az7WZPu+cNvztI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UF8IFXsuafm/cSqDEbYEtQM44GOWMrtCss11DLQTVxvXVeZ8xTAZzExEP2G/kXGb9
         OKQpNKOzLVFoMgZDTfKW7avUQAji3Tse0UW78Gi8kouwlBGHz+WsmAhYG1UG6XVNVJ
         BU2WrM2eSBQd6ZRaWodH5zAVFb9gg9zHfkbZRkzk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 093/111] RDMA/addr: Be strict with gid size
Date:   Mon, 12 Apr 2021 10:41:11 +0200
Message-Id: <20210412084007.345524174@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084004.200986670@linuxfoundation.org>
References: <20210412084004.200986670@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit d1c803a9ccd7bd3aff5e989ccfb39ed3b799b975 ]

The nla_len() is less than or equal to 16.  If it's less than 16 then end
of the "gid" buffer is uninitialized.

Fixes: ae43f8286730 ("IB/core: Add IP to GID netlink offload")
Link: https://lore.kernel.org/r/20210405074434.264221-1-leon@kernel.org
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/addr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index 8beed4197e73..c9e63c692b6e 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -76,7 +76,9 @@ static struct workqueue_struct *addr_wq;
 
 static const struct nla_policy ib_nl_addr_policy[LS_NLA_TYPE_MAX] = {
 	[LS_NLA_TYPE_DGID] = {.type = NLA_BINARY,
-		.len = sizeof(struct rdma_nla_ls_gid)},
+		.len = sizeof(struct rdma_nla_ls_gid),
+		.validation_type = NLA_VALIDATE_MIN,
+		.min = sizeof(struct rdma_nla_ls_gid)},
 };
 
 static inline bool ib_nl_is_good_ip_resp(const struct nlmsghdr *nlh)
-- 
2.30.2



