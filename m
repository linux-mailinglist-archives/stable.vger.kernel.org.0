Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AACAA3290CD
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242255AbhCAUP1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:15:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:37636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242835AbhCAUEo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:04:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B617B64EAE;
        Mon,  1 Mar 2021 17:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621502;
        bh=VEAU1DBYYKwJ8k/rQt6OGf+BLS02UkotgzCagmef5Sc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i4q9MqZlf+FVvYBBlJB1/BfLX6rTUR++2D5LDVjSyEqART/WbxKXyKc2rnRD8fZ44
         iQOVmhYEpKrizavnaC8OvDyEKg76uUTBJsxty6ZULpqOitdWD/XzOjN4h0nrAQwFL1
         Z1es81kscUJeR1kJvTCG+LIwiSWDPl1aVhigWhqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 540/775] net/mlx4_core: Add missed mlx4_free_cmd_mailbox()
Date:   Mon,  1 Mar 2021 17:11:48 +0100
Message-Id: <20210301161228.170960203@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

[ Upstream commit 8eb65fda4a6dbd59cd5de24b106a10b6ee0d2176 ]

mlx4_do_mirror_rule() forgets to call mlx4_free_cmd_mailbox() to
free the memory region allocated by mlx4_alloc_cmd_mailbox() before
an exit.
Add the missed call to fix it.

Fixes: 78efed275117 ("net/mlx4_core: Support mirroring VF DMFS rules on both ports")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://lore.kernel.org/r/20210221143559.390277-1-hslester96@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx4/resource_tracker.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
index 394f43add85cf..a99e71bc7b3c9 100644
--- a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
+++ b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
@@ -4986,6 +4986,7 @@ static int mlx4_do_mirror_rule(struct mlx4_dev *dev, struct res_fs_rule *fs_rule
 
 	if (!fs_rule->mirr_mbox) {
 		mlx4_err(dev, "rule mirroring mailbox is null\n");
+		mlx4_free_cmd_mailbox(dev, mailbox);
 		return -EINVAL;
 	}
 	memcpy(mailbox->buf, fs_rule->mirr_mbox, fs_rule->mirr_mbox_size);
-- 
2.27.0



