Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF2C657B7B
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233319AbiL1PXD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:23:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233738AbiL1PWj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:22:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9DA140B4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:22:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 559BBB816D9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:22:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C64EEC433EF;
        Wed, 28 Dec 2022 15:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240930;
        bh=Z/toL6BcbxqcS1VXTJbOKRKvW8KybiSJWmyF8kXnYNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jxZCNjwjGJGuqHH7625hhLj3baJgFI/XnaDRXa5wB3xFAoJV387qnhxaFCkHNRq2L
         hbPG93OESA5h6a7xwZ6yIbtjHO+a0y2x/AgavstSgW2a9Yyw48T82ZVjsw1OScB7CE
         EyC4rit8bpaplSfxZbrkzxixeb16n068r5XCTANc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 418/731] RDMA/nldev: Add checks for nla_nest_start() in fill_stat_counter_qps()
Date:   Wed, 28 Dec 2022 15:38:45 +0100
Message-Id: <20221228144308.687995193@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index 6f3799698634..cefe12964f3e 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -892,6 +892,8 @@ static int fill_stat_counter_qps(struct sk_buff *msg,
 	int ret = 0;
 
 	table_attr = nla_nest_start(msg, RDMA_NLDEV_ATTR_RES_QP);
+	if (!table_attr)
+		return -EMSGSIZE;
 
 	rt = &counter->device->res[RDMA_RESTRACK_QP];
 	xa_lock(&rt->xa);
-- 
2.35.1



