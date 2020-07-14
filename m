Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A296E21FB6F
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731243AbgGNS6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:58:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:57246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730271AbgGNS6o (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:58:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FF3E207F5;
        Tue, 14 Jul 2020 18:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753124;
        bh=mb6AWRCses7PESJHExIvHSgznp6bZTKBUHQZAMr8PII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SUExUP22Ni/7NMvSjcZz0vLFEkOaPZb2nityAzBYhNfn4xhLgRCeH7WXwMufWvaWz
         FvJc1imZQcgJoBAcXU21LIKigalkCHLlL30GuM3onxEmbjPF+sPYsie0vR6Wvbl0A0
         goLLymSDK8EEEieTKMkzQdpIvLsQ/PWeZ0KaPOR4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eli Britstein <elibr@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 098/166] net/mlx5e: CT: Fix memory leak in cleanup
Date:   Tue, 14 Jul 2020 20:44:23 +0200
Message-Id: <20200714184120.539053575@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eli Britstein <elibr@mellanox.com>

[ Upstream commit eb32b3f53d283e8d68b6d86c3a6ed859b24dacae ]

CT entries are deleted via a workqueue from netfilter. If removing the
module before that, the rules are cleaned by the driver itself, but the
memory entries for them are not freed. Fix that.

Fixes: ac991b48d43c ("net/mlx5e: CT: Offload established flows")
Signed-off-by: Eli Britstein <elibr@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 470282daed198..369a037714356 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -849,6 +849,7 @@ mlx5_tc_ct_flush_ft_entry(void *ptr, void *arg)
 	struct mlx5_ct_entry *entry = ptr;
 
 	mlx5_tc_ct_entry_del_rules(ct_priv, entry);
+	kfree(entry);
 }
 
 static void
-- 
2.25.1



