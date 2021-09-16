Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDD740E7A3
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243531AbhIPRfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:35:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:50286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348347AbhIPRcU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:32:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBFDC61250;
        Thu, 16 Sep 2021 16:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810860;
        bh=sYydYxRyDsnWxhv0ACQkOPeeGjMFpExS/qG7QDvFyBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r8AYGHpRg3bV61d3hvipn6jfiyM46udVzn55GBcWdn2fbcpyRrcmIVZMKNvb/3ex7
         Y7D7PF3N2Y4WR9dTD96d6gws/Jt9GFtr6+V9XfawZbH7ux4O0qfB5qC1KZaTe+dLgp
         BBw8dcvVLxegilSpFz/2FzOblj8fMXXkgsvfYzvc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 294/432] net/mlx5: Fix variable type to match 64bit
Date:   Thu, 16 Sep 2021 18:00:43 +0200
Message-Id: <20210916155820.799501097@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eran Ben Elisha <eranbe@nvidia.com>

[ Upstream commit 979aa51967add26b37f9d77e01729d44a2da8e5f ]

Fix the following smatch warning:
wait_func_handle_exec_timeout() warn: should '1 << ent->idx' be a 64 bit type?

Use 1ULL, to have a 64 bit type variable.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Eran Ben Elisha <eranbe@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 9d79c5ec31e9..db5dfff585c9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -877,7 +877,7 @@ static void cb_timeout_handler(struct work_struct *work)
 	ent->ret = -ETIMEDOUT;
 	mlx5_core_warn(dev, "cmd[%d]: %s(0x%x) Async, timeout. Will cause a leak of a command resource\n",
 		       ent->idx, mlx5_command_str(msg_to_opcode(ent->in)), msg_to_opcode(ent->in));
-	mlx5_cmd_comp_handler(dev, 1UL << ent->idx, true);
+	mlx5_cmd_comp_handler(dev, 1ULL << ent->idx, true);
 
 out:
 	cmd_ent_put(ent); /* for the cmd_ent_get() took on schedule delayed work */
@@ -994,7 +994,7 @@ static void cmd_work_handler(struct work_struct *work)
 		MLX5_SET(mbox_out, ent->out, status, status);
 		MLX5_SET(mbox_out, ent->out, syndrome, drv_synd);
 
-		mlx5_cmd_comp_handler(dev, 1UL << ent->idx, true);
+		mlx5_cmd_comp_handler(dev, 1ULL << ent->idx, true);
 		return;
 	}
 
@@ -1008,7 +1008,7 @@ static void cmd_work_handler(struct work_struct *work)
 		poll_timeout(ent);
 		/* make sure we read the descriptor after ownership is SW */
 		rmb();
-		mlx5_cmd_comp_handler(dev, 1UL << ent->idx, (ent->ret == -ETIMEDOUT));
+		mlx5_cmd_comp_handler(dev, 1ULL << ent->idx, (ent->ret == -ETIMEDOUT));
 	}
 }
 
@@ -1068,7 +1068,7 @@ static void wait_func_handle_exec_timeout(struct mlx5_core_dev *dev,
 		       mlx5_command_str(msg_to_opcode(ent->in)), msg_to_opcode(ent->in));
 
 	ent->ret = -ETIMEDOUT;
-	mlx5_cmd_comp_handler(dev, 1UL << ent->idx, true);
+	mlx5_cmd_comp_handler(dev, 1ULL << ent->idx, true);
 }
 
 static int wait_func(struct mlx5_core_dev *dev, struct mlx5_cmd_work_ent *ent)
-- 
2.30.2



