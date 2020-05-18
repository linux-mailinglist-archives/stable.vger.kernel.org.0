Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2E121D80CB
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729374AbgERRmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:42:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:38852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729370AbgERRmE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:42:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0269020715;
        Mon, 18 May 2020 17:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823724;
        bh=kSGimb+ixLcWpqRq3vja2t1RahAYDLXqog2awjJRwbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gbV44PJeS1VDm59EZHgGwnV0s62e3FZjaPdkNZvOWRvNM1UxSYKrz4yABmpDXoaXe
         ZJxdbwgG6M47G2BvbmCxBI6Xk+xYLzdPAutNiIuLDUE1wiOr5WSKofc1oywAOmoNiw
         a/gaWZxPk60d4N/CCBIoIP91xwLwt6FBAE5U0z8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 4.9 11/90] net/mlx5: Fix command entry leak in Internal Error State
Date:   Mon, 18 May 2020 19:35:49 +0200
Message-Id: <20200518173453.520115348@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.930655662@linuxfoundation.org>
References: <20200518173450.930655662@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Moshe Shemesh <moshe@mellanox.com>

[ Upstream commit cece6f432cca9f18900463ed01b97a152a03600a ]

Processing commands by cmd_work_handler() while already in Internal
Error State will result in entry leak, since the handler process force
completion without doorbell. Forced completion doesn't release the entry
and event completion will never arrive, so entry should be released.

Fixes: 73dd3a4839c1 ("net/mlx5: Avoid using pending command interface slots")
Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -847,6 +847,10 @@ static void cmd_work_handler(struct work
 		MLX5_SET(mbox_out, ent->out, syndrome, drv_synd);
 
 		mlx5_cmd_comp_handler(dev, 1UL << ent->idx, true);
+		/* no doorbell, no need to keep the entry */
+		free_ent(cmd, ent->idx);
+		if (ent->callback)
+			free_cmd(ent);
 		return;
 	}
 


