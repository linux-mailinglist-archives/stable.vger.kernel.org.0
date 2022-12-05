Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1916432C2
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234220AbiLET3T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:29:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234017AbiLET2x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:28:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 732962A25A
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:25:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 190B6B81201
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:25:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 585B3C433D6;
        Mon,  5 Dec 2022 19:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268328;
        bh=1V9y3eQGPqosHHCZ6qMxnjxfGFSip1lh/vt3p0y6i+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ybCblZ2urtToNEmRy7+K79pbVs83pKR9lSlRbC9a4HaXL9VKmJhfK5Z4SqaJkwRlr
         lpPxYvzzn4g1uvKDauITLKThz0AL1L06W/bSbLMkJ0HP0xKhmCuEj+SmqELDOOWW7O
         Efwtyt0OdRdduIYdniqxktUiFCJ0x3J+5r3yKEo8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, YueHaibing <yuehaibing@huawei.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 034/124] net/mlx5: DR, Fix uninitialized var warning
Date:   Mon,  5 Dec 2022 20:09:00 +0100
Message-Id: <20221205190809.416821411@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 52f7cf70eb8fac6111786c59ae9dfc5cf2bee710 ]

Smatch warns this:

drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c:81
 mlx5dr_table_set_miss_action() error: uninitialized symbol 'ret'.

Initializing ret with -EOPNOTSUPP and fix missing action case.

Fixes: 7838e1725394 ("net/mlx5: DR, Expose steering table functionality")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
index 31d443dd8386..f68461b13391 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
@@ -46,7 +46,7 @@ static int dr_table_set_miss_action_nic(struct mlx5dr_domain *dmn,
 int mlx5dr_table_set_miss_action(struct mlx5dr_table *tbl,
 				 struct mlx5dr_action *action)
 {
-	int ret;
+	int ret = -EOPNOTSUPP;
 
 	if (action && action->action_type != DR_ACTION_TYP_FT)
 		return -EOPNOTSUPP;
@@ -67,6 +67,9 @@ int mlx5dr_table_set_miss_action(struct mlx5dr_table *tbl,
 			goto out;
 	}
 
+	if (ret)
+		goto out;
+
 	/* Release old action */
 	if (tbl->miss_action)
 		refcount_dec(&tbl->miss_action->refcount);
-- 
2.35.1



