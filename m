Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 027C349904E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359355AbiAXT7f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:59:35 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41764 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358158AbiAXTyg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:54:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA682B81229;
        Mon, 24 Jan 2022 19:54:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18552C340E7;
        Mon, 24 Jan 2022 19:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054071;
        bh=Zf2oU5zgQQMODYzgwGbMC19Oupb+AxdNmqbbKp+TCUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WD8Ki+t3wazPKsayV5p0ZbllDHSPGPEPJCe1biuDfRyfGCD9yLzWb/QwH1XogWoVR
         C1l6C6lDcWBZfkaaB3RO6Xzs6NI7NCt9lO/64gRAzMRiA82qlDPxsX2QxHz1xxajG2
         jKZc5GVDyWPOTggvy2PxrnqPXYrc90gvqwHIjPxc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avihai Horon <avihaih@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 269/563] RDMA/cma: Let cma_resolve_ib_dev() continue search even after empty entry
Date:   Mon, 24 Jan 2022 19:40:34 +0100
Message-Id: <20220124184033.749989711@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
index 8e54184566f7f..4d4ba09f6cf93 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -775,6 +775,7 @@ static int cma_resolve_ib_dev(struct rdma_id_private *id_priv)
 	unsigned int p;
 	u16 pkey, index;
 	enum ib_port_state port_state;
+	int ret;
 	int i;
 
 	cma_dev = NULL;
@@ -793,9 +794,14 @@ static int cma_resolve_ib_dev(struct rdma_id_private *id_priv)
 
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



