Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD0B84F2A4C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 12:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242353AbiDEIh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238619AbiDEITO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:19:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E6B10FDD;
        Tue,  5 Apr 2022 01:09:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C893B81B18;
        Tue,  5 Apr 2022 08:09:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5801C385A1;
        Tue,  5 Apr 2022 08:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146149;
        bh=HNGI4In+9emjSe41kyPORwvUlyYnDXuBY4KQw+sNLoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i0fjCUAQciEQmHRjGlTyChHrqvQWS+7GpM/uJmq363cigXrRyMYaDMNRLiw0AY4Mx
         PvxZKOpCzPn1cTdC83Y+H5Aat5aEcinT4UzSeED4tOd86lw78YbbxwY5uPEAFY8TZc
         6dy5nLdilkY5kOlf5LJszKQUdjXtMuiJMOxi5KhI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yongzhi Liu <lyz_cs@pku.edu.cn>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0659/1126] RDMA/mlx5: Fix memory leak in error flow for subscribe event routine
Date:   Tue,  5 Apr 2022 09:23:26 +0200
Message-Id: <20220405070426.972565560@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Yongzhi Liu <lyz_cs@pku.edu.cn>

[ Upstream commit 087f9c3f2309ed183f7e4b85ae57121d8663224d ]

In case the second xa_insert() fails, the obj_event is not released.  Fix
the error unwind flow to free that memory to avoid a memory leak.

Fixes: 759738537142 ("IB/mlx5: Enable subscription for device events over DEVX")
Link: https://lore.kernel.org/r/1647018361-18266-1-git-send-email-lyz_cs@pku.edu.cn
Signed-off-by: Yongzhi Liu <lyz_cs@pku.edu.cn>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/devx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 08b7f6bc56c3..15c0884d1f49 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -1886,8 +1886,10 @@ subscribe_event_xa_alloc(struct mlx5_devx_event_table *devx_event_table,
 				key_level2,
 				obj_event,
 				GFP_KERNEL);
-		if (err)
+		if (err) {
+			kfree(obj_event);
 			return err;
+		}
 		INIT_LIST_HEAD(&obj_event->obj_sub_list);
 	}
 
-- 
2.34.1



