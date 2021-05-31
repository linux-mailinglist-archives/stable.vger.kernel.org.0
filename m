Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3390396027
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231913AbhEaOXO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:23:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:46050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233482AbhEaOTH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:19:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81308619B7;
        Mon, 31 May 2021 13:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468649;
        bh=zH5zUuwgFW9ZZZXgIpNcKq6XZaHbmZk4BtIuoV0z7ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wr0CGvjhFSaya2nZCE7L79IRFdXipemyxfHb51NA0eS4kEjuKO1LCM9M4vMU9pUSV
         ZrDeOaeaGQJ+NrsvgCfyqhEQsRhINfwEKZQnTtz56ZR9WHGy6a7qhCQWwPC1de5ThV
         bkfmxj0beacPW1x5GJEUzvCN2p82mQWxWqauIz60=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dima Chumak <dchumak@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.4 072/177] net/mlx5e: Fix multipath lag activation
Date:   Mon, 31 May 2021 15:13:49 +0200
Message-Id: <20210531130650.387543693@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dima Chumak <dchumak@nvidia.com>

commit 97817fcc684ed01497bd19d0cd4dea699665b9cf upstream.

When handling FIB_EVENT_ENTRY_REPLACE event for a new multipath route,
lag activation can be missed if a stale (struct lag_mp)->mfi pointer
exists, which was associated with an older multipath route that had been
removed.

Normally, when a route is removed, it triggers mlx5_lag_fib_event(),
which handles FIB_EVENT_ENTRY_DEL and clears mfi pointer. But, if
mlx5_lag_check_prereq() condition isn't met, for example when eswitch is
in legacy mode, the fib event is skipped and mfi pointer becomes stale.

Fix by resetting mfi pointer to NULL every time mlx5_lag_mp_init() is
called.

Fixes: 544fe7c2e654 ("net/mlx5e: Activate HW multipath and handle port affinity based on FIB events")
Signed-off-by: Dima Chumak <dchumak@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
@@ -307,6 +307,11 @@ int mlx5_lag_mp_init(struct mlx5_lag *ld
 	struct lag_mp *mp = &ldev->lag_mp;
 	int err;
 
+	/* always clear mfi, as it might become stale when a route delete event
+	 * has been missed
+	 */
+	mp->mfi = NULL;
+
 	if (mp->fib_nb.notifier_call)
 		return 0;
 
@@ -328,4 +333,5 @@ void mlx5_lag_mp_cleanup(struct mlx5_lag
 
 	unregister_fib_notifier(&mp->fib_nb);
 	mp->fib_nb.notifier_call = NULL;
+	mp->mfi = NULL;
 }


