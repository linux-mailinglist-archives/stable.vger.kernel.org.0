Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB4C14F0D
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbfEFOgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:36:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:57292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727224AbfEFOgt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:36:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 234B9204EC;
        Mon,  6 May 2019 14:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153408;
        bh=eF1lfFAie7NE02O+U2JLXR5vKUcczpO4HqZ2NCz0ivM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yRol1mUwJLbYI48gUWoIAdfUmEnSPPsNXW7nASOwaT+FOKzK3wErvP8MpcCZhrod/
         YGbiItBuzRX9AM3W5JXMEzbHgb7+IoBdppLmf7+lqWsW98GAE1k959mZeis1hAVrLF
         SC9z+cZC4Td8zMLfNo/oc/TXBp4SWv/FZbabsJd4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roi Dayan <roid@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 047/122] net/mlx5: E-Switch, Protect from invalid memory access in offload fdb table
Date:   Mon,  6 May 2019 16:31:45 +0200
Message-Id: <20190506143059.165325989@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5c1d260ed10cf08dd7a0299c103ad0a3f9a9f7a1 ]

The esw offloads structures share a union with the legacy mode structs.
Reset the offloads struct to zero in init to protect from null
assumptions made by the legacy mode code.

Signed-off-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index d4e6fe5b9300..ce5766a26baa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1402,6 +1402,7 @@ int esw_offloads_init(struct mlx5_eswitch *esw, int nvports)
 {
 	int err;
 
+	memset(&esw->fdb_table.offloads, 0, sizeof(struct offloads_fdb));
 	mutex_init(&esw->fdb_table.offloads.fdb_prio_lock);
 
 	err = esw_create_offloads_fdb_tables(esw, nvports);
-- 
2.20.1



