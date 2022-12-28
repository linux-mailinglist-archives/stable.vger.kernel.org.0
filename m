Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D31DB6580F1
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233216AbiL1QXL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:23:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234785AbiL1QVv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:21:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F60C1B9D1
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:19:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A6D66157A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:19:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3128CC433D2;
        Wed, 28 Dec 2022 16:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244388;
        bh=L3+CR/NM0ZeTpMq0OUP3T1WXjWvtv1KoHfVZQBBe4q8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vsrdeD0a+fcJO1WDEqqoUwP1MAdOhr2CprPBWyDGVFsgg5k+4+QdLGCjpy/gBh7qz
         T31/usDDY5F6nTPyp1Jxy461ZPmTXCD0zyc0tEzJcIdjyhPa9lYH+KlFQT/BuvkPMV
         27JVL2zjnOXfynAlpLodD2cNfwkIMAnXxr1ADw80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mark Zhang <markzhang@nvidia.com>,
        Patrisious Haddad <phaddad@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0661/1146] RDMA/nldev: Fix failure to send large messages
Date:   Wed, 28 Dec 2022 15:36:40 +0100
Message-Id: <20221228144348.108493337@linuxfoundation.org>
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

From: Mark Zhang <markzhang@nvidia.com>

[ Upstream commit fc8f93ad3e5485d45c992233c96acd902992dfc4 ]

Return "-EMSGSIZE" instead of "-EINVAL" when filling a QP entry, so that
new SKBs will be allocated if there's not enough room in current SKB.

Fixes: 65959522f806 ("RDMA: Add support to dump resource tracker in RAW format")
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Reviewed-by: Patrisious Haddad <phaddad@nvidia.com>
Link: https://lore.kernel.org/r/b5e9c62f6b8369acab5648b661bf539cbceeffdc.1669636336.git.leonro@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/nldev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 54d4e693e03b..222733a83ddb 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -513,7 +513,7 @@ static int fill_res_qp_entry(struct sk_buff *msg, bool has_cap_net_admin,
 
 	/* In create_qp() port is not set yet */
 	if (qp->port && nla_put_u32(msg, RDMA_NLDEV_ATTR_PORT_INDEX, qp->port))
-		return -EINVAL;
+		return -EMSGSIZE;
 
 	ret = nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_LQPN, qp->qp_num);
 	if (ret)
-- 
2.35.1



