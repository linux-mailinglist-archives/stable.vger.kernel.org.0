Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25A666580EC
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233255AbiL1QXA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:23:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234603AbiL1QV3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:21:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1671C1A05E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:19:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A02EF6157A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:19:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1EEAC433F0;
        Wed, 28 Dec 2022 16:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244364;
        bh=wRClq7SGljjCXZoLOyDzzzCHYBZoHBsHr568OPeKIwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=INv5sXMYibXlbe8PdA5ORYgOAYsBjtMdT3aPpJbiUzNxO0g5zcDFPUC4DMeFodS9S
         ECDwF507kIw6gr67OBTbl+knl32XMrMALKZd7CGNf7WNJWWouGMi8n1M+LINC/SgDR
         KNx/zTlNGBW6OTN9cDWqWHNM2agKVwXAzT+g+gMA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0657/1146] RDMA/nldev: Add checks for nla_nest_start() in fill_stat_counter_qps()
Date:   Wed, 28 Dec 2022 15:36:36 +0100
Message-Id: <20221228144348.003622357@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit ea5ef136e215fdef35f14010bc51fcd6686e6922 ]

As the nla_nest_start() may fail with NULL returned, the return value needs
to be checked.

Fixes: c4ffee7c9bdb ("RDMA/netlink: Implement counter dumpit calback")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Link: https://lore.kernel.org/r/20221126043410.85632-1-yuancan@huawei.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/nldev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index f1e0755cd56e..54d4e693e03b 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -894,6 +894,8 @@ static int fill_stat_counter_qps(struct sk_buff *msg,
 	int ret = 0;
 
 	table_attr = nla_nest_start(msg, RDMA_NLDEV_ATTR_RES_QP);
+	if (!table_attr)
+		return -EMSGSIZE;
 
 	rt = &counter->device->res[RDMA_RESTRACK_QP];
 	xa_lock(&rt->xa);
-- 
2.35.1



