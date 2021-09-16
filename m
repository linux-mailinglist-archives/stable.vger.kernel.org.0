Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A18F40E0BF
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237251AbhIPQXu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:23:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:59314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241604AbhIPQVu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:21:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8575F61452;
        Thu, 16 Sep 2021 16:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808910;
        bh=AzYyWIvTFUu7ICwG/e78kzaZiT+m17+3Ake8DT55j8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MR86ZyDHxmD+t8z54MYPSymFw6QjcIZCi/jsw4Ipomr2YPwiZfd2/ULTwBwl7wIhs
         LxRLKeJ+CaO0jBPbQheujU7GF6WlFmDiv+AtJUCL+REbbIY1FwbOwy6wJYnBaEKZpD
         LAS5vaH3E3xMBk2t/iDwNi3aEzgWNjCF5n22H6R8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wentao_Liang <Wentao_Liang_g@163.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 267/306] net/mlx5: DR, fix a potential use-after-free bug
Date:   Thu, 16 Sep 2021 18:00:12 +0200
Message-Id: <20210916155803.177798682@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wentao_Liang <Wentao_Liang_g@163.com>

[ Upstream commit 6cc64770fb386b10a64a1fe09328396de7bb5262 ]

In line 849 (#1), "mlx5dr_htbl_put(cur_htbl);" drops the reference to
cur_htbl and may cause cur_htbl to be freed.

However, cur_htbl is subsequently used in the next line, which may result
in an use-after-free bug.

Fix this by calling mlx5dr_err() before the cur_htbl is put.

Signed-off-by: Wentao_Liang <Wentao_Liang_g@163.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index b3c9dc032026..478de5ded7c2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -824,9 +824,9 @@ dr_rule_handle_ste_branch(struct mlx5dr_rule *rule,
 			new_htbl = dr_rule_rehash(rule, nic_rule, cur_htbl,
 						  ste_location, send_ste_list);
 			if (!new_htbl) {
-				mlx5dr_htbl_put(cur_htbl);
 				mlx5dr_err(dmn, "Failed creating rehash table, htbl-log_size: %d\n",
 					   cur_htbl->chunk_size);
+				mlx5dr_htbl_put(cur_htbl);
 			} else {
 				cur_htbl = new_htbl;
 			}
-- 
2.30.2



