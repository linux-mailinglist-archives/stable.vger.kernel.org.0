Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C14EF6E63C2
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbjDRMnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231961AbjDRMnF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:43:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E18BD167D2
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:42:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F6D0629B0
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:42:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856A7C433D2;
        Tue, 18 Apr 2023 12:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821775;
        bh=zF0TRIS5/mPlNJ5EOn1mhFtxFdxX35Tea4Ekx3lTj1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CZ35hHoAVzmYAHtUbevMwwV784Rb0y4MpJ7ZPxo0vyfeqXKVS4ZXmE67zxJLkJRM9
         uS+iBT6SWbgsJDe/8oNDxJSBUvcgo4DQizgnt2WLYOa7GxOjPvqYAAehj2muGtcNzZ
         se7cYMHOGnZLhxdiDujxJFzznOTpzQhS+X1k+rnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Cheng Xu <chengyou@linux.alibaba.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 036/134] RDMA/erdma: Defer probing if netdevice can not be found
Date:   Tue, 18 Apr 2023 14:21:32 +0200
Message-Id: <20230418120314.217875242@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
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
index 49778bb294ae4..49d9319217414 100644
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



