Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 900774993AC
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386108AbiAXUfK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:35:10 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53096 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384621AbiAXUaP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:30:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 813A961512;
        Mon, 24 Jan 2022 20:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F046C340E5;
        Mon, 24 Jan 2022 20:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056214;
        bh=eXD3O4QmX5J7aE4pQ1f46f7WdUCuth2V6BwFwk8xKBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Huxj35rT2hgAn0hzZDRNXXZ1n0E5Zw9Hcx+DTjQNRycbmB3aVaUT7DZ3huxC2cECN
         kDOJfRcERZmuCNs0XTCEtrT3A3QLCq3qpe4pqtpy4vlZYKvrA5o7ppfQ5aRvTnELlR
         SrRjspmGXbF44V0BEXUEouqqI/6RJIy3cot3iVfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avihai Horon <avihaih@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 410/846] RDMA/core: Let ib_find_gid() continue search even after empty entry
Date:   Mon, 24 Jan 2022 19:38:47 +0100
Message-Id: <20220124184115.121049627@linuxfoundation.org>
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

From: Avihai Horon <avihaih@nvidia.com>

[ Upstream commit 483d805191a23191f8294bbf9b4e94836f5d92e4 ]

Currently, ib_find_gid() will stop searching after encountering the first
empty GID table entry. This behavior is wrong since neither IB nor RoCE
spec enforce tightly packed GID tables.

For example, when a valid GID entry exists at index N, and if a GID entry
is empty at index N-1, ib_find_gid() will fail to find the valid entry.

Fix it by making ib_find_gid() continue searching even after encountering
missing entries.

Fixes: 5eb620c81ce3 ("IB/core: Add helpers for uncached GID and P_Key searches")
Link: https://lore.kernel.org/r/e55d331b96cecfc2cf19803d16e7109ea966882d.1639055490.git.leonro@nvidia.com
Signed-off-by: Avihai Horon <avihaih@nvidia.com>
Reviewed-by: Mark Zhang <markzhang@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/device.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index f4814bb7f082f..6ab46648af909 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -2461,7 +2461,8 @@ int ib_find_gid(struct ib_device *device, union ib_gid *gid,
 		     ++i) {
 			ret = rdma_query_gid(device, port, i, &tmp_gid);
 			if (ret)
-				return ret;
+				continue;
+
 			if (!memcmp(&tmp_gid, gid, sizeof *gid)) {
 				*port_num = port;
 				if (index)
-- 
2.34.1



