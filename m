Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1C564332C
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234340AbiLETep (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:34:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234339AbiLETeS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:34:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7484F25E98
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:29:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3553BB81151
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:29:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E4C3C433D6;
        Mon,  5 Dec 2022 19:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268587;
        bh=BM63kgZNPWqQiJ30RJdjUvQwuqOutHTr7IhxROV+cbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kKNwvi8OFNE25hQSCmJpYiBGn0xGZYeKMfgAXr20KqTHbcnHRMsqEFJPhCRlMGzBz
         LJ2z8A5rB0HIZgKULLP3E2AfAPvyJLYXTM2zMma8ygjGddHt0ebdLM2zdM8SVNVzSl
         8tahu1xg0FG/AkEmNmsUxm0d+4TM5QPgDfjTDo6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 31/92] net/mlx5e: Fix use-after-free when reverting termination table
Date:   Mon,  5 Dec 2022 20:09:44 +0100
Message-Id: <20221205190804.497815784@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.464934752@linuxfoundation.org>
References: <20221205190803.464934752@linuxfoundation.org>
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

From: Roi Dayan <roid@nvidia.com>

[ Upstream commit 52c795af04441d76f565c4634f893e5b553df2ae ]

When having multiple dests with termination tables and second one
or afterwards fails the driver reverts usage of term tables but
doesn't reset the assignment in attr->dests[num_vport_dests].termtbl
which case a use-after-free when releasing the rule.
Fix by resetting the assignment of termtbl to null.

Fixes: 10caabdaad5a ("net/mlx5e: Use termination table for VLAN push actions")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c  | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
index 6c865cb7f445..132ea9997676 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
@@ -308,6 +308,8 @@ mlx5_eswitch_add_termtbl_rule(struct mlx5_eswitch *esw,
 	for (curr_dest = 0; curr_dest < num_vport_dests; curr_dest++) {
 		struct mlx5_termtbl_handle *tt = attr->dests[curr_dest].termtbl;
 
+		attr->dests[curr_dest].termtbl = NULL;
+
 		/* search for the destination associated with the
 		 * current term table
 		 */
-- 
2.35.1



