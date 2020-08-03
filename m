Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5E8723A491
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728758AbgHCM2g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:28:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:54750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728754AbgHCM2e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:28:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F03C2083B;
        Mon,  3 Aug 2020 12:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457713;
        bh=Q/WErorfwQmavjrNJC3/0nwL753dymrid//mUfxcNUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KcD9G0dWDbExJwJbRzLEGoNaW3nRD0qshprHYZOOXQJQpf/yKlsYG2iBiTb2kSlbu
         O/a5pwuX22qZ63NnPYp6IgqT209tPHuaW6nNk4wD/AuOezSwwfaSRPE2zS+Hv4voH3
         66700Rp9FnWKj5iu4x2xWnWoq3tsXsPiAmO/cBmE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 47/90] net/mlx5: E-switch, Destroy TSAR when fail to enable the mode
Date:   Mon,  3 Aug 2020 14:19:09 +0200
Message-Id: <20200803121859.898505363@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121857.546052424@linuxfoundation.org>
References: <20200803121857.546052424@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

[ Upstream commit 2b8e9c7c3fd0e31091edb1c66cc06ffe4988ca21 ]

When either esw_legacy_enable() or esw_offloads_enable() fails,
code missed to destroy the created TSAR.

Hence, add the missing call to destroy the TSAR.

Fixes: 610090ebce92 ("net/mlx5: E-switch, Initialize TSAR Qos hardware block before its user vports")
Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index c6ed4b7f4f972..422a57404407d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1919,7 +1919,7 @@ abort:
 		mlx5_reload_interface(esw->dev, MLX5_INTERFACE_PROTOCOL_IB);
 		mlx5_reload_interface(esw->dev, MLX5_INTERFACE_PROTOCOL_ETH);
 	}
-
+	esw_destroy_tsar(esw);
 	return err;
 }
 
-- 
2.25.1



