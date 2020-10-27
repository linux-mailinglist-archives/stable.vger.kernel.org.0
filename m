Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB3F929C04A
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1817144AbgJ0RNn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:13:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:60636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1784348AbgJ0O7F (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:59:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3541C20715;
        Tue, 27 Oct 2020 14:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810744;
        bh=g6662p8Edt5EtwqkbxwwpMysMMF690KW2qzmhtPxZgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qiLbMWJ5494Uus/qEnu2aMdB9Qqvm2GgqGHaCoLUy5XDZs8Vlz8joOfdOsm57WQH1
         h7U80Nkj5BtYOrgWa5HuP93D2LpLSLfkuLh+ECUc71SmR3z8MUQ3AlS4zK7Fig7WMN
         /oOyBZqR9bi1by7tb0SUJMD3CrLmNUKsLD9VpLFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moshe Tal <moshet@mellanox.com>,
        Aya Levin <ayal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 217/633] net/mlx5: Fix uninitialized variable warning
Date:   Tue, 27 Oct 2020 14:49:20 +0100
Message-Id: <20201027135532.864546324@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Moshe Tal <moshet@mellanox.com>

[ Upstream commit 19f5b63bc9932d51292d72c9dc3ec95e5dfa2289 ]

Add variable initialization to eliminate the warning
"variable may be used uninitialized".

Fixes: 5f29458b77d5 ("net/mlx5e: Support dump callback in TX reporter")
Signed-off-by: Moshe Tal <moshet@mellanox.com>
Reviewed-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/health.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
index 7283443868f3c..13c87ab50b267 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
@@ -212,8 +212,8 @@ static int mlx5e_health_rsc_fmsg_binary(struct devlink_fmsg *fmsg,
 
 {
 	u32 data_size;
+	int err = 0;
 	u32 offset;
-	int err;
 
 	for (offset = 0; offset < value_len; offset += data_size) {
 		data_size = value_len - offset;
-- 
2.25.1



