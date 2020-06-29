Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA1520E50F
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728769AbgF2Vb5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:31:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:60654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728716AbgF2SlK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:41:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9A1223EF5;
        Mon, 29 Jun 2020 15:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443908;
        bh=xpClRmG+Ihfwp71EU0kLzMCSVxYC4LHRRu1oX53w1nM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zq7ejhvGH9NCD0RNdYeAkJZNlanYb0/mu69rtoP5HeKVo2bPUx2PG7sXBHF4Mv2xX
         +x/oNJJ82tqW6wej/R+ay6bhw+ypvuTcFr7566eBe1UzCYz4y4sjdYsF7JpAKDHZFU
         jI5kxTCAg5+b69ti24SWiOJLuCpRn2sqLQ/yfypg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ido Schimmel <idosch@mellanox.com>,
        Colin Ian King <colin.king@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 008/265] mlxsw: spectrum: Do not rely on machine endianness
Date:   Mon, 29 Jun 2020 11:14:01 -0400
Message-Id: <20200629151818.2493727-9-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

[ Upstream commit f3fe412b0a634286a6a3753c3f9ff201e6bec716 ]

The second commit cited below performed a cast of 'u32 buffsize' to
'(u16 *)' when calling mlxsw_sp_port_headroom_8x_adjust():

mlxsw_sp_port_headroom_8x_adjust(mlxsw_sp_port, (u16 *) &buffsize);

Colin noted that this will behave differently on big endian
architectures compared to little endian architectures.

Fix this by following Colin's suggestion and have the function accept
and return 'u32' instead of passing the current size by reference.

Fixes: da382875c616 ("mlxsw: spectrum: Extend to support Spectrum-3 ASIC")
Fixes: 60833d54d56c ("mlxsw: spectrum: Adjust headroom buffers for 8x ports")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reported-by: Colin Ian King <colin.king@canonical.com>
Suggested-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c         | 4 ++--
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h         | 8 +++-----
 drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c    | 2 +-
 4 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 3e4199246a18d..d9a2267aeaea2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -990,10 +990,10 @@ int __mlxsw_sp_port_headroom_set(struct mlxsw_sp_port *mlxsw_sp_port, int mtu,
 
 		lossy = !(pfc || pause_en);
 		thres_cells = mlxsw_sp_pg_buf_threshold_get(mlxsw_sp, mtu);
-		mlxsw_sp_port_headroom_8x_adjust(mlxsw_sp_port, &thres_cells);
+		thres_cells = mlxsw_sp_port_headroom_8x_adjust(mlxsw_sp_port, thres_cells);
 		delay_cells = mlxsw_sp_pg_buf_delay_get(mlxsw_sp, mtu, delay,
 							pfc, pause_en);
-		mlxsw_sp_port_headroom_8x_adjust(mlxsw_sp_port, &delay_cells);
+		delay_cells = mlxsw_sp_port_headroom_8x_adjust(mlxsw_sp_port, delay_cells);
 		total_cells = thres_cells + delay_cells;
 
 		taken_headroom_cells += total_cells;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index e28ecb84b8164..6b2e4e730b189 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -395,17 +395,15 @@ mlxsw_sp_port_vlan_find_by_vid(const struct mlxsw_sp_port *mlxsw_sp_port,
 	return NULL;
 }
 
-static inline void
+static inline u32
 mlxsw_sp_port_headroom_8x_adjust(const struct mlxsw_sp_port *mlxsw_sp_port,
-				 u16 *p_size)
+				 u32 size_cells)
 {
 	/* Ports with eight lanes use two headroom buffers between which the
 	 * configured headroom size is split. Therefore, multiply the calculated
 	 * headroom size by two.
 	 */
-	if (mlxsw_sp_port->mapping.width != 8)
-		return;
-	*p_size *= 2;
+	return mlxsw_sp_port->mapping.width == 8 ? 2 * size_cells : size_cells;
 }
 
 enum mlxsw_sp_flood_type {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
index 19bf0768ed788..2fb2cbd4f229e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
@@ -312,7 +312,7 @@ static int mlxsw_sp_port_pb_init(struct mlxsw_sp_port *mlxsw_sp_port)
 
 		if (i == MLXSW_SP_PB_UNUSED)
 			continue;
-		mlxsw_sp_port_headroom_8x_adjust(mlxsw_sp_port, &size);
+		size = mlxsw_sp_port_headroom_8x_adjust(mlxsw_sp_port, size);
 		mlxsw_reg_pbmc_lossy_buffer_pack(pbmc_pl, i, size);
 	}
 	mlxsw_reg_pbmc_lossy_buffer_pack(pbmc_pl,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index 7c5032f9c8fff..76242c70d41ad 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -776,7 +776,7 @@ mlxsw_sp_span_port_buffsize_update(struct mlxsw_sp_port *mlxsw_sp_port, u16 mtu)
 		speed = 0;
 
 	buffsize = mlxsw_sp_span_buffsize_get(mlxsw_sp, speed, mtu);
-	mlxsw_sp_port_headroom_8x_adjust(mlxsw_sp_port, (u16 *) &buffsize);
+	buffsize = mlxsw_sp_port_headroom_8x_adjust(mlxsw_sp_port, buffsize);
 	mlxsw_reg_sbib_pack(sbib_pl, mlxsw_sp_port->local_port, buffsize);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sbib), sbib_pl);
 }
-- 
2.25.1

