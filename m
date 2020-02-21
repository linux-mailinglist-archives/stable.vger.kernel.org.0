Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31A671675AA
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387462AbgBUIQD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:16:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:52952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387459AbgBUIQC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:16:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2792124670;
        Fri, 21 Feb 2020 08:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272961;
        bh=8nF09Mx0R0VykZIsatHCLOID3H5n0MCFoFllwCAnXoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v9yvAlbPDKqSvcbG+8MrXmq/nKZ6ajRhxpC8Hiv9fLNv/ItubrCSx6qWWUb5cKIDz
         wknzFC93eSK0waWZGXxuYFyFuv2Sg+iissC3kruE3H0OOnUNdDnDpnUY/vJqisXSHN
         kjX3kmD0sjmLdTEzOCHYmKBvHSpCz1/9n+uUPYHE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 341/344] mlxsw: spectrum_dpipe: Add missing error path
Date:   Fri, 21 Feb 2020 08:42:20 +0100
Message-Id: <20200221072421.422703601@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

[ Upstream commit 3a99cbb6fa7bca1995586ec2dc21b0368aad4937 ]

In case devlink_dpipe_entry_ctx_prepare() failed, release RTNL that was
previously taken and free the memory allocated by
mlxsw_sp_erif_entry_prepare().

Fixes: 2ba5999f009d ("mlxsw: spectrum: Add Support for erif table entries access")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c
index 49933818c6f59..2dc0978428e64 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c
@@ -215,7 +215,7 @@ mlxsw_sp_dpipe_table_erif_entries_dump(void *priv, bool counters_enabled,
 start_again:
 	err = devlink_dpipe_entry_ctx_prepare(dump_ctx);
 	if (err)
-		return err;
+		goto err_ctx_prepare;
 	j = 0;
 	for (; i < rif_count; i++) {
 		struct mlxsw_sp_rif *rif = mlxsw_sp_rif_by_index(mlxsw_sp, i);
@@ -247,6 +247,7 @@ start_again:
 	return 0;
 err_entry_append:
 err_entry_get:
+err_ctx_prepare:
 	rtnl_unlock();
 	devlink_dpipe_entry_clear(&entry);
 	return err;
-- 
2.20.1



