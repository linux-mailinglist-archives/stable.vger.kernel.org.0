Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF5F24C7370
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238199AbiB1Rfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:35:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238207AbiB1RfS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:35:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7679688798;
        Mon, 28 Feb 2022 09:31:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18D7361357;
        Mon, 28 Feb 2022 17:31:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22CB0C340E7;
        Mon, 28 Feb 2022 17:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069478;
        bh=epMXXlbGNSFUVnUKm1TddebGD0G60b9EZdMjrNxAv0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=buag19bilsKR2bMb+hwsM4X7vlJ1XfBkgJJWd6Uj9ntGc39++DL/ZbfCgtpsYUyKG
         LM09qR31Vi2v//61xrcW3hx/EvDe8jnBQr6LAURw+ijWEJw0W+BY20oynoBlOVfUgm
         BGGjn11e2hOIaHJRNLE+o24qt5tNKmwuQMDvFrrY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.4 27/53] net/mlx5: Fix possible deadlock on rule deletion
Date:   Mon, 28 Feb 2022 18:24:25 +0100
Message-Id: <20220228172250.254197486@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172248.232273337@linuxfoundation.org>
References: <20220228172248.232273337@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

commit b645e57debca846f51b3209907546ea857ddd3f5 upstream.

Add missing call to up_write_ref_node() which releases the semaphore
in case the FTE doesn't have destinations, such in drop rule case.

Fixes: 465e7baab6d9 ("net/mlx5: Fix deletion of duplicate rules")
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1947,6 +1947,8 @@ void mlx5_del_flow_rules(struct mlx5_flo
 		fte->node.del_hw_func = NULL;
 		up_write_ref_node(&fte->node, false);
 		tree_put_node(&fte->node, false);
+	} else {
+		up_write_ref_node(&fte->node, false);
 	}
 	kfree(handle);
 }


