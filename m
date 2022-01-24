Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B4849A2FE
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2366051AbiAXXwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:52:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1843807AbiAXXGY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:06:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C4BCC06E038;
        Mon, 24 Jan 2022 13:17:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C07DA614F5;
        Mon, 24 Jan 2022 21:17:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9BC7C340E4;
        Mon, 24 Jan 2022 21:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059036;
        bh=GSpa0T2zR5nR7t2XEWNXHM0JnhWayGNeHrauchlvb2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0fY1sI4UlPS5//AukobzXcdfyx3DdCbsi4m6B3yIZ6gQaU30UC/luJVJPnlbIiiEt
         4V4mBner5AZbfTudAhRuLKD5Ud6pKATC3C4WccpWGka34nD5dTTnhrFmdITgO+HvCK
         NawdW0D2zvZLajQIGqn24uHYNUpIVHDUlYMhb888=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avihai Horon <avihaih@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0484/1039] RDMA/core: Let ib_find_gid() continue search even after empty entry
Date:   Mon, 24 Jan 2022 19:37:53 +0100
Message-Id: <20220124184141.543595123@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
index 22a4adda7981d..a311df07b1bdb 100644
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



