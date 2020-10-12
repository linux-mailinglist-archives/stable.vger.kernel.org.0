Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D88828B7DA
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728821AbgJLNrJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:47:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:52990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389867AbgJLNqV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:46:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C53320678;
        Mon, 12 Oct 2020 13:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510380;
        bh=GKeVcOfAMkzJRX+7fYt5nwdM+QYiTgSMsKh5qT03mus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mq0HVctTf+ojuviFMoVQkcekf+kenoHQNfxW5ka0TaAh5eL+MkSu7nXbswU843JCa
         CSacrygc+/IjCiJGKaMM8c0/fFjzoZN4B9X9OnhHrj4g1A70/4dbOpkRD9wmDj13hi
         8MO/jjNtZO1ydLKq7mB5Tjp/txvZwcc2nnnRnH9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 074/124] mlxsw: spectrum_acl: Fix mlxsw_sp_acl_tcam_group_add()s error path
Date:   Mon, 12 Oct 2020 15:31:18 +0200
Message-Id: <20201012133150.438070466@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 72865028582a678be1e05240e55d452e5c258eca ]

If mlxsw_sp_acl_tcam_group_id_get() fails, the mutex initialized earlier
is not destroyed.

Fix this by initializing the mutex after calling the function. This is
symmetric to mlxsw_sp_acl_tcam_group_del().

Fixes: 5ec2ee28d27b ("mlxsw: spectrum_acl: Introduce a mutex to guard region list updates")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
index 5c020403342f9..7cccc41dd69c9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
@@ -292,13 +292,14 @@ mlxsw_sp_acl_tcam_group_add(struct mlxsw_sp_acl_tcam *tcam,
 	int err;
 
 	group->tcam = tcam;
-	mutex_init(&group->lock);
 	INIT_LIST_HEAD(&group->region_list);
 
 	err = mlxsw_sp_acl_tcam_group_id_get(tcam, &group->id);
 	if (err)
 		return err;
 
+	mutex_init(&group->lock);
+
 	return 0;
 }
 
-- 
2.25.1



