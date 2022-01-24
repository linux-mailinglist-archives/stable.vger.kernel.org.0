Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66EE0498E85
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349921AbiAXTmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:42:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344690AbiAXTkg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:40:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB1B8C07A966;
        Mon, 24 Jan 2022 11:19:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 707BDB81232;
        Mon, 24 Jan 2022 19:19:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99063C340E5;
        Mon, 24 Jan 2022 19:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051961;
        bh=vvYjAPxxL+ZjqcEidLvpz0cKF/e03ciPhpXnnDJYgtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cmh+Ceo3l2mFIYF7+bvm5LNHjLPGXXOZb1Ad06pYUB66RVO39VZH5xN5WWlqZo8Au
         BcBh3Wy/h82vcxdYkpu9pgj19eIBIUShmghVYC7Z79/CRvpZtaa99kwdiFKAuSWzne
         Olx8HkTlZwAdnr4jnFhU6NJsRSGu3U78e1dsQ5gw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avihai Horon <avihaih@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 110/239] RDMA/core: Let ib_find_gid() continue search even after empty entry
Date:   Mon, 24 Jan 2022 19:42:28 +0100
Message-Id: <20220124183946.600613206@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
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
index 6a585c3e21923..ffd0f43e2129f 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -1039,7 +1039,8 @@ int ib_find_gid(struct ib_device *device, union ib_gid *gid,
 		for (i = 0; i < device->port_immutable[port].gid_tbl_len; ++i) {
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



