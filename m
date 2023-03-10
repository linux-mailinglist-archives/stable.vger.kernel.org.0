Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6D726B4A90
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234185AbjCJPY0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:24:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233181AbjCJPYC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:24:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E7F116B80
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:13:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E069AB822F4
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:13:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EFFAC433D2;
        Fri, 10 Mar 2023 15:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678461181;
        bh=JHShmRp3tRLXch88m4N/oZrTogVoNcn63idwjNH2u4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qXUtkTyD209j1VnJcZAg6HSi/UHZWpGJ1Y4N50YJD3BRV8/6NVuGBbM9oNUcx8YKa
         ousTzhfc9w57ZBmkWqQ8WXSwnaa3aTl1n3ewY5SKk5odOMLCd2QdJdnnHVOjgrAiGa
         iM7AfhneMaeMPV/rPXk8NrAeq/HQg69RJscj78Jc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Maor Dickman <maord@nvidia.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 052/136] net/mlx5: Geneve, Fix handling of Geneve object id as error code
Date:   Fri, 10 Mar 2023 14:42:54 +0100
Message-Id: <20230310133708.687650273@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

[ Upstream commit d28a06d7dbedc598a06bd1e53a28125f87ca5d0c ]

On success, mlx5_geneve_tlv_option_create returns non negative
Geneve object id. In case the object id is positive value the
caller functions will handle it as an error (non zero) and
will fail to offload the Geneve rule.

Fix this by changing caller function ,mlx5_geneve_tlv_option_add,
to return 0 in case valid non negative object id was provided.

Fixes: 0ccc171ea6a2 ("net/mlx5: Geneve, Manage Geneve TLV options")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/geneve.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/geneve.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/geneve.c
index 23361a9ae4fa0..6dc83e871cd76 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/geneve.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/geneve.c
@@ -105,6 +105,7 @@ int mlx5_geneve_tlv_option_add(struct mlx5_geneve *geneve, struct geneve_opt *op
 		geneve->opt_type = opt->type;
 		geneve->obj_id = res;
 		geneve->refcount++;
+		res = 0;
 	}
 
 unlock:
-- 
2.39.2



