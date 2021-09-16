Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97F1840E4A5
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242150AbhIPRFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:05:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:51938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347353AbhIPQ6v (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:58:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1F1F61AE3;
        Thu, 16 Sep 2021 16:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809929;
        bh=20N7xoLr4PRRg/0ghZb/xVzS0Tot4rz49UzpNxcUcFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=prVUKXmCZgbz04S6L/HpvIXcZ3llKmWSKPBqz2Gl7u28sntTKD8dX5g9fme8zc2kO
         mu+krB3r2JVH6obPjb8nmPR3eVdcw3rC1FWVHM4909/5T7MYtZtcFD/cf/wwZLLTDD
         z6ctp04JYB/bxTlP3OwAqhEPhNrZy354KVCH4bO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 335/380] net/mlx5: DR, Enable QP retransmission
Date:   Thu, 16 Sep 2021 18:01:32 +0200
Message-Id: <20210916155815.442218488@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

[ Upstream commit ec449ed8230cd30769de3cb70ee0fce293047372 ]

Under high stress, SW steering might get stuck on polling for completion
that never comes.
For such cases QP needs to have protocol retransmission mechanism enabled.
Currently the retransmission timeout is defined as 0 (unlimited). Fix this
by defining a real timeout.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index 9df0e73d1c35..69b49deb66b2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -620,6 +620,7 @@ static int dr_cmd_modify_qp_rtr2rts(struct mlx5_core_dev *mdev,
 
 	MLX5_SET(qpc, qpc, retry_count, attr->retry_cnt);
 	MLX5_SET(qpc, qpc, rnr_retry, attr->rnr_retry);
+	MLX5_SET(qpc, qpc, primary_address_path.ack_timeout, 0x8); /* ~1ms */
 
 	MLX5_SET(rtr2rts_qp_in, in, opcode, MLX5_CMD_OP_RTR2RTS_QP);
 	MLX5_SET(rtr2rts_qp_in, in, qpn, dr_qp->qpn);
-- 
2.30.2



