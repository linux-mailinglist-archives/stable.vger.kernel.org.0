Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60610121281
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 18:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727704AbfLPRxO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:53:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:46342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726587AbfLPRxH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:53:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1A402176D;
        Mon, 16 Dec 2019 17:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518787;
        bh=OgBV3uZboKY7VS0dIaO/DQcdbWFS5IWy4G5k6+2p64w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GcZ0bCdhBn5GieRuxiR8B2+l9z2Qlb+3uOem/bvhcn851Zb1/anOXrt/GfxhWINn6
         ExIXS6fyaCcTk8o7NSKnY6dEf5JNt4Pgnbtb+0Br62zE6masUxUYXr3NEbS1I/MU0G
         d/4C/E5PUzy8+71lF2kuYOq0BxZjD2L/+GucOXIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moni Shoua <monis@mellanox.com>,
        Majd Dibbiny <majd@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 027/267] net/mlx5: Release resource on error flow
Date:   Mon, 16 Dec 2019 18:45:53 +0100
Message-Id: <20191216174851.886549015@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Moni Shoua <monis@mellanox.com>

[ Upstream commit 698114968a22f6c0c9f42e983ba033cc36bb7217 ]

Fix reference counting leakage when the event handler aborts due to an
unsupported event for the resource type.

Fixes: a14c2d4beee5 ("net/mlx5_core: Warn on unsupported events of QP/RQ/SQ")
Signed-off-by: Moni Shoua <monis@mellanox.com>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/qp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/qp.c b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
index 889130edb7152..5f091c6ea049d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
@@ -124,7 +124,7 @@ void mlx5_rsc_event(struct mlx5_core_dev *dev, u32 rsn, int event_type)
 	if (!is_event_type_allowed((rsn >> MLX5_USER_INDEX_LEN), event_type)) {
 		mlx5_core_warn(dev, "event 0x%.2x is not allowed on resource 0x%.8x\n",
 			       event_type, rsn);
-		return;
+		goto out;
 	}
 
 	switch (common->res) {
@@ -138,7 +138,7 @@ void mlx5_rsc_event(struct mlx5_core_dev *dev, u32 rsn, int event_type)
 	default:
 		mlx5_core_warn(dev, "invalid resource type for 0x%x\n", rsn);
 	}
-
+out:
 	mlx5_core_put_rsc(common);
 }
 
-- 
2.20.1



