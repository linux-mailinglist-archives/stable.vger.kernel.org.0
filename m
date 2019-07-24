Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B515C73F31
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388049AbfGXUam (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:30:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:52686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388501AbfGXTbh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:31:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E6A621951;
        Wed, 24 Jul 2019 19:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996696;
        bh=aPqXeDed3l9oxzwaouHlEQYupd50IJGT37oCZSo7CpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lje+LvEoCb8OGE5FWSyE12rGZhu0Ubg8BZULBV5XQ7s/ADF+SOShDtURPFygKca2c
         GnzdzjP0ng99LuGLyXrQmj/vgck/bG4O9CW2fO0KPdzW4v9QwtXmKFptePj4DAml1K
         BX0ITjBuEBag1rmypAaBQ8Y94Px5//a5c386QW3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 185/413] net/mlx5e: Attach/detach XDP program safely
Date:   Wed, 24 Jul 2019 21:17:56 +0200
Message-Id: <20190724191747.985210203@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e18953240de8b46360a67090c87ee1ef8160b35d ]

When an XDP program is set, a full reopen of all channels happens in two
cases:

1. When there was no program set, and a new one is being set.

2. When there was a program set, but it's being unset.

The full reopen is necessary, because the channel parameters may change
if XDP is enabled or disabled. However, it's performed in an unsafe way:
if the new channels fail to open, the old ones are already closed, and
the interface goes down. Use the safe way to switch channels instead.
The same way is already used for other configuration changes.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 31 ++++++++++++-------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index a8e8350b38aa..8db9fdbc03ea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4192,8 +4192,6 @@ static int mlx5e_xdp_set(struct net_device *netdev, struct bpf_prog *prog)
 	/* no need for full reset when exchanging programs */
 	reset = (!priv->channels.params.xdp_prog || !prog);
 
-	if (was_opened && reset)
-		mlx5e_close_locked(netdev);
 	if (was_opened && !reset) {
 		/* num_channels is invariant here, so we can take the
 		 * batched reference right upfront.
@@ -4205,20 +4203,31 @@ static int mlx5e_xdp_set(struct net_device *netdev, struct bpf_prog *prog)
 		}
 	}
 
-	/* exchange programs, extra prog reference we got from caller
-	 * as long as we don't fail from this point onwards.
-	 */
-	old_prog = xchg(&priv->channels.params.xdp_prog, prog);
+	if (was_opened && reset) {
+		struct mlx5e_channels new_channels = {};
+
+		new_channels.params = priv->channels.params;
+		new_channels.params.xdp_prog = prog;
+		mlx5e_set_rq_type(priv->mdev, &new_channels.params);
+		old_prog = priv->channels.params.xdp_prog;
+
+		err = mlx5e_safe_switch_channels(priv, &new_channels, NULL);
+		if (err)
+			goto unlock;
+	} else {
+		/* exchange programs, extra prog reference we got from caller
+		 * as long as we don't fail from this point onwards.
+		 */
+		old_prog = xchg(&priv->channels.params.xdp_prog, prog);
+	}
+
 	if (old_prog)
 		bpf_prog_put(old_prog);
 
-	if (reset) /* change RQ type according to priv->xdp_prog */
+	if (!was_opened && reset) /* change RQ type according to priv->xdp_prog */
 		mlx5e_set_rq_type(priv->mdev, &priv->channels.params);
 
-	if (was_opened && reset)
-		err = mlx5e_open_locked(netdev);
-
-	if (!test_bit(MLX5E_STATE_OPENED, &priv->state) || reset)
+	if (!was_opened || reset)
 		goto unlock;
 
 	/* exchanging programs w/o reset, we update ref counts on behalf
-- 
2.20.1



