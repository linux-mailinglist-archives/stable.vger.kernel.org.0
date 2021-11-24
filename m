Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7CF545C370
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346850AbhKXNjV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:39:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:51988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352468AbhKXNgL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:36:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DED50611CB;
        Wed, 24 Nov 2021 12:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758515;
        bh=Hlx9kIDEkvycsPblvHgkmQnomQeSuR1bdpXIzR/P1ZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O8BALyWtV3CLciqqVnE3LDIdPaTZM+hzSxLlRbut9UzoGeWSNmiv8Eb04ZxXyobN7
         /CWerY7OFX6vKVEIqMgCJ8E0yW28bqvDrMKmB3dX515n1bb+NzNsAV7+kn+eMHc7Nk
         n3b6I42rCXBmOMOyvjS28np8dMW05YUQ/Z+Al4KE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 095/154] net/mlx5: E-Switch, return error if encap isnt supported
Date:   Wed, 24 Nov 2021 12:58:11 +0100
Message-Id: <20211124115705.373929123@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raed Salem <raeds@nvidia.com>

[ Upstream commit c4c3176739dfa6efcc5b1d1de4b3fd2b51b048c7 ]

On regular ConnectX HCAs getting encap mode isn't supported when the
E-Switch is in NONE mode. Current code would return no error code when
trying to get encap mode in such case which is wrong.

Fix by returning error value to indicate failure to caller in such case.

Fixes: 8e0aa4bc959c ("net/mlx5: E-switch, Protect eswitch mode changes")
Signed-off-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 164e8cd9ad4ad..e06b1ba7d2349 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2714,7 +2714,7 @@ int mlx5_devlink_eswitch_encap_mode_get(struct devlink *devlink,
 	*encap = esw->offloads.encap;
 unlock:
 	up_write(&esw->mode_lock);
-	return 0;
+	return err;
 }
 
 static bool
-- 
2.33.0



