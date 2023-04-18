Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 341F46E6496
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232158AbjDRMua (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232148AbjDRMuY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:50:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B91A16DDF
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:50:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0065C63417
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:50:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F225C433EF;
        Tue, 18 Apr 2023 12:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822222;
        bh=aQCxiU54ViB6yPe5ndGrw1c7D57TOdde4wWqORNaCpU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0LHeIGJp+bpmmBgLkl7FuUOMqcJ5NNox/MNir0vbUQFJkZLBh5JgcZNUxy/05L+ob
         TvzhOnDQrk8vhbSAKp27gaVdXMGqTKVOeCVvHRDSsDDgsVymu2vmHMQQuLJyR6rzjI
         pk6lKT1n3Hva2I/ji1AYZZ4x6sELZlCFSJ4lvX98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Cheng Xu <chengyou@linux.alibaba.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 039/139] RDMA/erdma: Defer probing if netdevice can not be found
Date:   Tue, 18 Apr 2023 14:21:44 +0200
Message-Id: <20230418120315.121174560@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cheng Xu <chengyou@linux.alibaba.com>

[ Upstream commit 6bd1bca858f1734a75572a788213d1e1143f2f0a ]

ERDMA device may be probed before its associated netdevice, returning
-EPROBE_DEFER allows OS try to probe erdma device later.

Fixes: d55e6fb4803c ("RDMA/erdma: Add the erdma module")
Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>
Link: https://lore.kernel.org/r/20230320084652.16807-5-chengyou@linux.alibaba.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/erdma/erdma_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/erdma/erdma_main.c b/drivers/infiniband/hw/erdma/erdma_main.c
index 5dc31e5df5cba..4a29a53a6652e 100644
--- a/drivers/infiniband/hw/erdma/erdma_main.c
+++ b/drivers/infiniband/hw/erdma/erdma_main.c
@@ -56,7 +56,7 @@ static int erdma_netdev_event(struct notifier_block *nb, unsigned long event,
 static int erdma_enum_and_get_netdev(struct erdma_dev *dev)
 {
 	struct net_device *netdev;
-	int ret = -ENODEV;
+	int ret = -EPROBE_DEFER;
 
 	/* Already binded to a net_device, so we skip. */
 	if (dev->netdev)
-- 
2.39.2



