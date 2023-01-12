Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 434256675D6
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236990AbjALO0Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:26:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbjALOZj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:25:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E7CF5C1CE
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:16:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0043B81DCC
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:16:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C21EC433D2;
        Thu, 12 Jan 2023 14:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533007;
        bh=RmiDtniIOZGkzK47RB09aJTqecnNbwloawVvrICQDaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QdD1AbtH1xh9oN+YD2/su7cV6VahLZvyVo2hQtBGJuz07bC9XHKI50uPcQ/azHdRF
         as5j9l/te/klIgeP48Q/3EKOg6cJYmeJSJUCz1I/uX4vZ5c9I77j4KAIJlnl6adYfc
         cyzyOiOz+O8zk3H0NScteYrQzQqOG5acYbvKGIR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 308/783] RDMA/hfi: Decrease PCI device reference count in error path
Date:   Thu, 12 Jan 2023 14:50:24 +0100
Message-Id: <20230112135538.603424335@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

[ Upstream commit 9b51d072da1d27e1193e84708201c48e385ad912 ]

pci_get_device() will increase the reference count for the returned
pci_dev, and also decrease the reference count for the input parameter
*from* if it is not NULL.

If we break out the loop in node_affinity_init() with 'dev' not NULL, we
need to call pci_dev_put() to decrease the reference count. Add missing
pci_dev_put() in error path.

Fixes: c513de490f80 ("IB/hfi1: Invalid NUMA node information can cause a divide by zero")
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Link: https://lore.kernel.org/r/20221117131546.113280-1-wangxiongfeng2@huawei.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/affinity.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/hfi1/affinity.c b/drivers/infiniband/hw/hfi1/affinity.c
index 04b1e8f021f6..d5a8d0173709 100644
--- a/drivers/infiniband/hw/hfi1/affinity.c
+++ b/drivers/infiniband/hw/hfi1/affinity.c
@@ -219,6 +219,8 @@ int node_affinity_init(void)
 	for (node = 0; node < node_affinity.num_possible_nodes; node++)
 		hfi1_per_node_cntr[node] = 1;
 
+	pci_dev_put(dev);
+
 	return 0;
 }
 
-- 
2.35.1



