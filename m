Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 169791C8F8A
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 16:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728958AbgEGOcu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 10:32:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:57852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728657AbgEGO3p (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 10:29:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 462192083B;
        Thu,  7 May 2020 14:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861785;
        bh=PjgHZ2CfhfHertRK0wT0BKyG9NZkRI5FcJ6OuwK+rxw=;
        h=From:To:Cc:Subject:Date:From;
        b=T0pyd/5Mb9dYItZqUeNnLJ4Or4oGcnX2NQlCl4+flXqQbuQL+w3I4+p7ltTDSVVN+
         8YIw5fcyoesZoLRuVmqiBsLPze8F9IOkOv392KeENq19GLAw/+UMb4iMpABbJMTDBY
         dI0vaPYWh2+D10QaWnIXSTvcAQL/gZ/KXzkz0ww0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alaa Hleihel <alaa@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 01/16] RDMA/mlx4: Initialize ib_spec on the stack
Date:   Thu,  7 May 2020 10:29:28 -0400
Message-Id: <20200507142943.26848-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alaa Hleihel <alaa@mellanox.com>

[ Upstream commit c08cfb2d8d78bfe81b37cc6ba84f0875bddd0d5c ]

Initialize ib_spec on the stack before using it, otherwise we will have
garbage values that will break creating default rules with invalid parsing
error.

Fixes: a37a1a428431 ("IB/mlx4: Add mechanism to support flow steering over IB links")
Link: https://lore.kernel.org/r/20200413132235.930642-1-leon@kernel.org
Signed-off-by: Alaa Hleihel <alaa@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx4/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 7e73a1a6cb671..3f8511104c5b6 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1614,8 +1614,9 @@ static int __mlx4_ib_create_default_rules(
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(pdefault_rules->rules_create_list); i++) {
+		union ib_flow_spec ib_spec = {};
 		int ret;
-		union ib_flow_spec ib_spec;
+
 		switch (pdefault_rules->rules_create_list[i]) {
 		case 0:
 			/* no rule */
-- 
2.20.1

