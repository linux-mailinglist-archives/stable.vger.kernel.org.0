Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1D6F541853
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379425AbiFGVJ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379347AbiFGVJa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:09:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B473214428;
        Tue,  7 Jun 2022 11:51:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B0ACB82182;
        Tue,  7 Jun 2022 18:51:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DACFC385A2;
        Tue,  7 Jun 2022 18:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627882;
        bh=KIXhqxSYoKrP4kKBC0eYCNhdJSzSYEi5MBaoOve82dc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z822kWUn45WJah36MuZSbXHpAb7GGoWePrMH6RZyxRo5TvzNes5rq2IQJRxQQJjGC
         10R/1L7CnC5MNOsZ7COceuEGR3dP8lMONXoIV8cxkoA0GLyuUT8DOwneY8TQplTcFR
         dBSGahZwQhUtgujv61be9QgJom0NLzOCIIOsRXI4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 127/879] net/mlx5: fs, delete the FTE when there are no rules attached to it
Date:   Tue,  7 Jun 2022 18:54:05 +0200
Message-Id: <20220607165006.388275159@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

[ Upstream commit 7b0c6338597613f465d131bd939a51844a00455a ]

When an FTE has no children is means all the rules where removed
and the FTE can be deleted regardless of the dests_size value.
While dests_size should be 0 when there are no children
be extra careful not to leak memory or get firmware syndrome
if the proper bookkeeping of dests_size wasn't done.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 3ad67e6b5586..89ba72e8d109 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2071,16 +2071,16 @@ void mlx5_del_flow_rules(struct mlx5_flow_handle *handle)
 	down_write_ref_node(&fte->node, false);
 	for (i = handle->num_rules - 1; i >= 0; i--)
 		tree_remove_node(&handle->rule[i]->node, true);
-	if (fte->dests_size) {
-		if (fte->modify_mask)
-			modify_fte(fte);
-		up_write_ref_node(&fte->node, false);
-	} else if (list_empty(&fte->node.children)) {
+	if (list_empty(&fte->node.children)) {
 		del_hw_fte(&fte->node);
 		/* Avoid double call to del_hw_fte */
 		fte->node.del_hw_func = NULL;
 		up_write_ref_node(&fte->node, false);
 		tree_put_node(&fte->node, false);
+	} else if (fte->dests_size) {
+		if (fte->modify_mask)
+			modify_fte(fte);
+		up_write_ref_node(&fte->node, false);
 	} else {
 		up_write_ref_node(&fte->node, false);
 	}
-- 
2.35.1



