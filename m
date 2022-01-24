Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBE4498DF9
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348372AbiAXTiZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:38:25 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52872 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352276AbiAXTaD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:30:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E699B8122C;
        Mon, 24 Jan 2022 19:30:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64AF8C340E5;
        Mon, 24 Jan 2022 19:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052599;
        bh=4S2dYCqoHBKcD8cOK9/6OdcbmPKRa6oX9Z0TpfEVuIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NJJm1PsyQxTpVWO9TeY+dabjxnCC6uHIGPQaTLUOWYNsYaJOHUjrkYY7u6L+qbqqh
         gNkux9HEmEq91nvpyHdvQI1MDG0odBgRLbswctZU3E9um+Cb6xENw+6DlJnJqxS86H
         sAfYHibQMAf8XBKTlzwfhqJP0KHlUSqkAKmROsPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 113/320] net/mlx5e: Dont block routes with nexthop objects in SW
Date:   Mon, 24 Jan 2022 19:41:37 +0100
Message-Id: <20220124183957.554448069@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

[ Upstream commit 9e72a55a3c9d54b38a704bb7292d984574a81d9d ]

Routes with nexthop objects is currently not supported by multipath offload
and any attempts to use it is blocked, however this also block adding SW
routes with nexthop.

Resolve this by returning NOTIFY_DONE instead of an error which will allow such
a route to be created in SW but not offloaded.

This fix also solve an issue which block adding such routes on different devices
due to missing check if the route FIB device is one of multipath devices.

Fixes: 6a87afc072c3 ("mlx5: Fail attempts to use routes with nexthop objects")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
index bdc7f915d80e3..101667c6b5843 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
@@ -265,10 +265,8 @@ static int mlx5_lag_fib_event(struct notifier_block *nb,
 		fen_info = container_of(info, struct fib_entry_notifier_info,
 					info);
 		fi = fen_info->fi;
-		if (fi->nh) {
-			NL_SET_ERR_MSG_MOD(info->extack, "IPv4 route with nexthop objects is not supported");
-			return notifier_from_errno(-EINVAL);
-		}
+		if (fi->nh)
+			return NOTIFY_DONE;
 		fib_dev = fib_info_nh(fen_info->fi, 0)->fib_nh_dev;
 		if (fib_dev != ldev->pf[0].netdev &&
 		    fib_dev != ldev->pf[1].netdev) {
-- 
2.34.1



