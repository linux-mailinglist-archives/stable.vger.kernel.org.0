Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C65A576E04
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388447AbfGZP2c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:28:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:43054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387488AbfGZP2b (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:28:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98B6A22BF5;
        Fri, 26 Jul 2019 15:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564154910;
        bh=H4bYtcX4KBFMY4k2unPJ0XBiCn+ryDfEoLsz+eJJ37M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O/AZEeR8qs5UHoLTCWuL7msSOk3VvVjuAbf+KGTB8CZ1X1b7s2KM1XsZL5UzwYjrX
         d7BRAom9I5Gi4NnUAvhbSd5IQGQo/f5amN4cYYfDmGhVZWUhGVI3gyOAdQVAVa6Nn0
         ZufLDbRVf4YTyHf9vQ5kvnKHyO7wUK5/fb4Pjx5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.2 42/66] net/mlx5e: Fix error flow in tx reporter diagnose
Date:   Fri, 26 Jul 2019 17:24:41 +0200
Message-Id: <20190726152306.549741724@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152301.936055394@linuxfoundation.org>
References: <20190726152301.936055394@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

[ Upstream commit 99d31cbd8953c6929da978bf049ab0f0b4e503d9 ]

Fix tx reporter's diagnose callback. Propagate error when failing to
gather diagnostics information or failing to print diagnostic data per
queue.

Fixes: de8650a82071 ("net/mlx5e: Add tx reporter support")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -262,13 +262,13 @@ static int mlx5e_tx_reporter_diagnose(st
 
 		err = mlx5_core_query_sq_state(priv->mdev, sq->sqn, &state);
 		if (err)
-			break;
+			goto unlock;
 
 		err = mlx5e_tx_reporter_build_diagnose_output(fmsg, sq->sqn,
 							      state,
 							      netif_xmit_stopped(sq->txq));
 		if (err)
-			break;
+			goto unlock;
 	}
 	err = devlink_fmsg_arr_pair_nest_end(fmsg);
 	if (err)


