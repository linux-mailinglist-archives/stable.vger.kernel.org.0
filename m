Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B375A5945A6
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348446AbiHOW2l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351020AbiHOW11 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:27:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF7E66CD21;
        Mon, 15 Aug 2022 12:46:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D5776122E;
        Mon, 15 Aug 2022 19:46:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 621A9C433D6;
        Mon, 15 Aug 2022 19:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592768;
        bh=1P0QJ7as0hYzhD5ijHWEvqmNPZKo7he6CYz7tYoqMF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c7ciNKPKhbMRdX4Rv3O235jKXhD1zp2ppVD8+QXasTfZE2tIcpDNjb0oIpOYytA+O
         njsNYqEUgXC805Ly/rxdk++oOtr2G0/j8wkOh5SCkzOusA+nMei/vjvx4CQqpUaUWh
         QiTNbLiyyGEmGFfi0ZJMg9GJk48iUNiZGsrmWNEk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Suman Anna <s-anna@ti.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0842/1095] remoteproc: k3-r5: Fix refcount leak in k3_r5_cluster_of_init
Date:   Mon, 15 Aug 2022 20:04:01 +0200
Message-Id: <20220815180504.180823954@linuxfoundation.org>
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
index 4840ad906018..0481926c6975 100644
--- a/drivers/remoteproc/ti_k3_r5_remoteproc.c
+++ b/drivers/remoteproc/ti_k3_r5_remoteproc.c
@@ -1655,6 +1655,7 @@ static int k3_r5_cluster_of_init(struct platform_device *pdev)
 		if (!cpdev) {
 			ret = -ENODEV;
 			dev_err(dev, "could not get R5 core platform device\n");
+			of_node_put(child);
 			goto fail;
 		}
 
@@ -1663,6 +1664,7 @@ static int k3_r5_cluster_of_init(struct platform_device *pdev)
 			dev_err(dev, "k3_r5_core_of_init failed, ret = %d\n",
 				ret);
 			put_device(&cpdev->dev);
+			of_node_put(child);
 			goto fail;
 		}
 
-- 
2.35.1



