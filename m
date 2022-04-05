Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4D974F2F92
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239569AbiDEJyF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245722AbiDEJMM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:12:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 482FF31204;
        Tue,  5 Apr 2022 02:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 296A061003;
        Tue,  5 Apr 2022 09:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 332F3C385A1;
        Tue,  5 Apr 2022 09:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149213;
        bh=HNGI4In+9emjSe41kyPORwvUlyYnDXuBY4KQw+sNLoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LT42qelrjC0bi0+Ahjs6/2Q2aAV1lMgwRhHp7Xw+Y2D/l/o7Q+tk6LyU2nVamNH35
         uHvH1TolJ9OBzeRl7mCR7mTCCacHbKk+Gb3feUpDWL9WkQcElOhYWcaOFRBGuRA+8S
         WNRrKalDXcGseJTzBHfvHehFVczPFQpTDoFIsB6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yongzhi Liu <lyz_cs@pku.edu.cn>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0598/1017] RDMA/mlx5: Fix memory leak in error flow for subscribe event routine
Date:   Tue,  5 Apr 2022 09:25:11 +0200
Message-Id: <20220405070412.028510774@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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



