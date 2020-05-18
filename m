Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 384F31D8744
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728515AbgERRic (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:38:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:60858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727938AbgERRib (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:38:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC777207C4;
        Mon, 18 May 2020 17:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823511;
        bh=ZL8lslyctz/kDmXfJgaIWutcSn67k4/dSk8Ze4W515A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Birvz4Oo9eTlXcDjvpId7JtyARkDCYn2g2393ULrB4WW6R/lkTfn5jebplw3a/Fli
         6BggMqWbyvhFzoEim1lIMuwjuW4LoyYBaYIIJLeqTUHw3gZhy6yMP3KnoiVe1vKqm3
         iCxxb+QIuUtORxVRCer5TiRGWn9rUtgatbWWGYaQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 04/86] net/mlx4_core: Fix use of ENOSPC around mlx4_counter_alloc()
Date:   Mon, 18 May 2020 19:35:35 +0200
Message-Id: <20200518173451.158442606@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.254571947@linuxfoundation.org>
References: <20200518173450.254571947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

[ Upstream commit 40e473071dbad04316ddc3613c3a3d1c75458299 ]

When ENOSPC is set the idx is still valid and gets set to the global
MLX4_SINK_COUNTER_INDEX.  However gcc's static analysis cannot tell that
ENOSPC is impossible from mlx4_cmd_imm() and gives this warning:

drivers/net/ethernet/mellanox/mlx4/main.c:2552:28: warning: 'idx' may be
used uninitialized in this function [-Wmaybe-uninitialized]
 2552 |    priv->def_counter[port] = idx;

Also, when ENOSPC is returned mlx4_allocate_default_counters should not
fail.

Fixes: 6de5f7f6a1fa ("net/mlx4_core: Allocate default counter per port")
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx4/main.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -2295,6 +2295,7 @@ static int mlx4_allocate_default_counter
 
 		if (!err || err == -ENOSPC) {
 			priv->def_counter[port] = idx;
+			err = 0;
 		} else if (err == -ENOENT) {
 			err = 0;
 			continue;
@@ -2344,7 +2345,8 @@ int mlx4_counter_alloc(struct mlx4_dev *
 				   MLX4_CMD_TIME_CLASS_A, MLX4_CMD_WRAPPED);
 		if (!err)
 			*idx = get_param_l(&out_param);
-
+		if (WARN_ON(err == -ENOSPC))
+			err = -EINVAL;
 		return err;
 	}
 	return __mlx4_counter_alloc(dev, idx);


