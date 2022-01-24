Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D884F499BA0
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1575230AbiAXVvK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:51:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1458085AbiAXVmp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:42:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C4E8C0612A7;
        Mon, 24 Jan 2022 12:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DBA961383;
        Mon, 24 Jan 2022 20:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B527C340E5;
        Mon, 24 Jan 2022 20:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056218;
        bh=j49P1pfFwa61OjVWYr6s+9X6+gQ7W8cXfksL6286Il4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZEVnN47OOKZhrQgkHeqHgg11dVSmCENrPs2YYlsN2mg8GU/G/2zgnPZZd2HmK1S2E
         xJ84w5XaHcpezgn/gvqQmEIVSvhOdtlF6vcMOtbwZAmX/D9iZIpYgiFTzdB04fAEvy
         9n+RoEcqAPGtPFcZQbLmncc5O+M3O1cBlgy20lSY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avihai Horon <avihaih@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 411/846] RDMA/cma: Let cma_resolve_ib_dev() continue search even after empty entry
Date:   Mon, 24 Jan 2022 19:38:48 +0100
Message-Id: <20220124184115.154536797@linuxfoundation.org>
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

[ Upstream commit 20679094a0161c94faf77e373fa3f7428a8e14bd ]

Currently, when cma_resolve_ib_dev() searches for a matching GID it will
stop searching after encountering the first empty GID table entry. This
behavior is wrong since neither IB nor RoCE spec enforce tightly packed
GID tables.

For example, when the matching valid GID entry exists at index N, and if a
GID entry is empty at index N-1, cma_resolve_ib_dev() will fail to find
the matching valid entry.

Fix it by making cma_resolve_ib_dev() continue searching even after
encountering missing entries.

Fixes: f17df3b0dede ("RDMA/cma: Add support for AF_IB to rdma_resolve_addr()")
Link: https://lore.kernel.org/r/b7346307e3bb396c43d67d924348c6c496493991.1639055490.git.leonro@nvidia.com
Signed-off-by: Avihai Horon <avihaih@nvidia.com>
Reviewed-by: Mark Zhang <markzhang@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cma.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 704ce595542c5..88093bbe3da69 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -766,6 +766,7 @@ static int cma_resolve_ib_dev(struct rdma_id_private *id_priv)
 	unsigned int p;
 	u16 pkey, index;
 	enum ib_port_state port_state;
+	int ret;
 	int i;
 
 	cma_dev = NULL;
@@ -784,9 +785,14 @@ static int cma_resolve_ib_dev(struct rdma_id_private *id_priv)
 
 			if (ib_get_cached_port_state(cur_dev->device, p, &port_state))
 				continue;
-			for (i = 0; !rdma_query_gid(cur_dev->device,
-						    p, i, &gid);
-			     i++) {
+
+			for (i = 0; i < cur_dev->device->port_data[p].immutable.gid_tbl_len;
+			     ++i) {
+				ret = rdma_query_gid(cur_dev->device, p, i,
+						     &gid);
+				if (ret)
+					continue;
+
 				if (!memcmp(&gid, dgid, sizeof(gid))) {
 					cma_dev = cur_dev;
 					sgid = gid;
-- 
2.34.1



