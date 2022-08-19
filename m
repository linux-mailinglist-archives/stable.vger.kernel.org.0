Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 024C559A220
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352844AbiHSQcp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353090AbiHSQag (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:30:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB8B11CF2E;
        Fri, 19 Aug 2022 09:05:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD7896181B;
        Fri, 19 Aug 2022 16:04:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC35C433D6;
        Fri, 19 Aug 2022 16:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925097;
        bh=NMz5bkiyceK17gwcgM64mJ3m0Z5uzM7pL/+PsOwAaHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OCKOmeiT6OP3Uy7c5J+D7JM6iG8FFoWD6juc5Mo8AShNLjAZR0+5UlZqL0gTORAao
         94c1PI9H2zsJVK7fSHYlkpS0BVSS56J+cB18ZtOYlDUG7obJFlp0pSohve3S0FLUMW
         HGi/UntzdiRKwQOYlVtgOteGkTdzheePX+JDomQE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Suman Anna <s-anna@ti.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 375/545] remoteproc: k3-r5: Fix refcount leak in k3_r5_cluster_of_init
Date:   Fri, 19 Aug 2022 17:42:25 +0200
Message-Id: <20220819153846.201020549@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit fa220c05d282e7479abe08b54e3bdffd06c25e97 ]

Every iteration of for_each_available_child_of_node() decrements
the reference count of the previous node.
When breaking early from a for_each_available_child_of_node() loop,
we need to explicitly call of_node_put() on the child node.
Add missing of_node_put() to avoid refcount leak.

Fixes: 6dedbd1d5443 ("remoteproc: k3-r5: Add a remoteproc driver for R5F subsystem")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Acked-by: Suman Anna <s-anna@ti.com>
Link: https://lore.kernel.org/r/20220605083334.23942-1-linmq006@gmail.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/ti_k3_r5_remoteproc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/remoteproc/ti_k3_r5_remoteproc.c b/drivers/remoteproc/ti_k3_r5_remoteproc.c
index afeb9d6e4313..f92a18c06d80 100644
--- a/drivers/remoteproc/ti_k3_r5_remoteproc.c
+++ b/drivers/remoteproc/ti_k3_r5_remoteproc.c
@@ -1283,6 +1283,7 @@ static int k3_r5_cluster_of_init(struct platform_device *pdev)
 		if (!cpdev) {
 			ret = -ENODEV;
 			dev_err(dev, "could not get R5 core platform device\n");
+			of_node_put(child);
 			goto fail;
 		}
 
@@ -1291,6 +1292,7 @@ static int k3_r5_cluster_of_init(struct platform_device *pdev)
 			dev_err(dev, "k3_r5_core_of_init failed, ret = %d\n",
 				ret);
 			put_device(&cpdev->dev);
+			of_node_put(child);
 			goto fail;
 		}
 
-- 
2.35.1



