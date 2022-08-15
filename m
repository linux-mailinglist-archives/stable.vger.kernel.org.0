Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A86C5594544
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244143AbiHOWV6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347284AbiHOWTX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:19:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE6036AA30;
        Mon, 15 Aug 2022 12:43:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6287B80EAB;
        Mon, 15 Aug 2022 19:43:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27582C433C1;
        Mon, 15 Aug 2022 19:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592595;
        bh=+mp64Pr/EQHtTObpXJCI/YKDDO+OrIRtCHdSi07jgfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MRv+ou73clbv2kF5coHX0LeUUSbnDsfgrpoGx/Vbxc5S/abIx/cohGbZz2kQAsW91
         1/YmKkzGIg4s6o3tzKMDcQ2aFQRrMCkXesz1Vz94q88CP/plmoxP6hFn/bgEab0P2W
         RUQ3jjHKrN6dhIA4pPhWCzd15mcXRW9XVeO+Zbvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Itay Aveksis <itayav@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0813/1095] RDMA/mlx5: Add missing check for return value in get namespace flow
Date:   Mon, 15 Aug 2022 20:03:32 +0200
Message-Id: <20220815180502.902176457@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

[ Upstream commit c9776457bd5eaad4ce4ecb17af8d8f3cc6957c0b ]

Add missing check for return value when calling to
mlx5_ib_ft_type_to_namespace, even though it can't really fail in this
specific call.

Fixes: 52438be44112 ("RDMA/mlx5: Allow inserting a steering rule to the FDB")
Link: https://lore.kernel.org/r/7b9ceda217d9368a51dc47a46b769bad4af9ac92.1659256069.git.leonro@nvidia.com
Reviewed-by: Itay Aveksis <itayav@nvidia.com>
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/fs.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/fs.c b/drivers/infiniband/hw/mlx5/fs.c
index 661ed2b44508..6092118de672 100644
--- a/drivers/infiniband/hw/mlx5/fs.c
+++ b/drivers/infiniband/hw/mlx5/fs.c
@@ -2265,12 +2265,10 @@ static int mlx5_ib_matcher_ns(struct uverbs_attr_bundle *attrs,
 		if (err)
 			return err;
 
-		if (flags) {
-			mlx5_ib_ft_type_to_namespace(
+		if (flags)
+			return mlx5_ib_ft_type_to_namespace(
 				MLX5_IB_UAPI_FLOW_TABLE_TYPE_NIC_TX,
 				&obj->ns_type);
-			return 0;
-		}
 	}
 
 	obj->ns_type = MLX5_FLOW_NAMESPACE_BYPASS;
-- 
2.35.1



