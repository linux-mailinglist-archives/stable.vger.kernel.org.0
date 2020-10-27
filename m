Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E714729B8C7
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1801973AbgJ0PpR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:45:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:50950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799801AbgJ0Pd0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:33:26 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0D0220728;
        Tue, 27 Oct 2020 15:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812806;
        bh=6exmvv24Fw1hTJU2vCCViY2Mbn6vNEO8CK2HmvC1JzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oDKcR6BEZzghhalXQeMmPBXISvttiXyriObqUBtnW8BFg4gSuFMAVdFLrAKY+bNaq
         ThhWPoi34xVq1SC9sEPz2c9/PHz/BWUA7eDBwsfq1/sGBd+In7lopuAOjewL7+dxx6
         fp9ZGYzwkOs7L2/CmIYDd0FkaLNZ6FzhXXprzVMY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Denis Efremov <efremov@linux.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 309/757] net/mlx5e: IPsec: Use kvfree() for memory allocated with kvzalloc()
Date:   Tue, 27 Oct 2020 14:49:19 +0100
Message-Id: <20201027135505.042062755@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Denis Efremov <efremov@linux.com>

[ Upstream commit 22db4c24452a6681c7e99c6a06b38b5418395bec ]

Variables flow_group_in, spec in rx_fs_create() are allocated with
kvzalloc(). It's incorrect to free them with kfree(). Use kvfree()
instead.

Fixes: 5e466345291a ("net/mlx5e: IPsec: Add IPsec steering in local NIC RX")
Signed-off-by: Denis Efremov <efremov@linux.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 429428bbc903c..b974f3cd10058 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -228,8 +228,8 @@ static int rx_fs_create(struct mlx5e_priv *priv,
 	fs_prot->miss_rule = miss_rule;
 
 out:
-	kfree(flow_group_in);
-	kfree(spec);
+	kvfree(flow_group_in);
+	kvfree(spec);
 	return err;
 }
 
-- 
2.25.1



