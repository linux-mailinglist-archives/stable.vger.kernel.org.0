Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B52A766C7AA
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233368AbjAPQdL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:33:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233321AbjAPQcl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:32:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B772301AA
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:20:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B640AB80DC7
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:20:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19557C433F0;
        Mon, 16 Jan 2023 16:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886043;
        bh=Aqzm1KWORN7E0eTLNCo64Adar1vNIwOiUWfy42C8bLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j/REm3wkCLGaupH0qlMxuZilRnT3f/hfQaqxW5kdPxsemqNT13FS/CAr0Gao6qdqH
         j6IRXzJvPkAm53gqLlPG/SUJQ9OqKjn1VZUNvXn3+dfvkUeN5fIzMInMMP1Y0XKXuE
         Zr66Yaphv2q52jve/PcJzARU2xsVc3T/2/dp8HM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 253/658] RDMA/hfi: Decrease PCI device reference count in error path
Date:   Mon, 16 Jan 2023 16:45:41 +0100
Message-Id: <20230116154921.136477666@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index 1aeea5d65c01..832b878fa67e 100644
--- a/drivers/infiniband/hw/hfi1/affinity.c
+++ b/drivers/infiniband/hw/hfi1/affinity.c
@@ -218,6 +218,8 @@ int node_affinity_init(void)
 	for (node = 0; node < node_affinity.num_possible_nodes; node++)
 		hfi1_per_node_cntr[node] = 1;
 
+	pci_dev_put(dev);
+
 	return 0;
 }
 
-- 
2.35.1



