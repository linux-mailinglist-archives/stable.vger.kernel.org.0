Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E48D690674
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 12:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbjBILRU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 06:17:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbjBILQ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 06:16:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E92555E5D;
        Thu,  9 Feb 2023 03:16:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F19A861A21;
        Thu,  9 Feb 2023 11:16:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D01DC433D2;
        Thu,  9 Feb 2023 11:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675941364;
        bh=YbHyk0Yj5v83mAWPoPN0CrKwF2Uiw38KjLu6b9b2vaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mrcCgGetn1YAhUWf9vNo3XZJt7S0O9N+RsWrolMGTi4tDmWquJ0JhLSmz0gbBaTL6
         WwY+n/ThBrc/UnYi+Npn/QX39W1qHqrWfcPdPonr/Upk1eySplSdzykb5fDl7cwG4j
         XksI2BNnuiDN72TOk4SHKG1Ib2di27/88suV7oxaqwuApIu67TZH3wJzomRemRdoYx
         6kHlWqZPvOHqgZECe31aeApuZBtliPFcdj3AP1NK0LRafp8FKSZwhe8CglZe4eXgG3
         lGZhGjUphC+T96QwGM6iHa8xpnFvxtphZmHEQqzcvfwBtAZqN0Zh6NsdBYVmCIs/NA
         pQLMq0z3iloNg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tanmay Bhushan <007047221b@gmail.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Sasha Levin <sashal@kernel.org>, gautam.dawar@xilinx.com,
        trix@redhat.com, jiaming@nfschina.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 6.1 14/38] vdpa: ifcvf: Do proper cleanup if IFCVF init fails
Date:   Thu,  9 Feb 2023 06:14:33 -0500
Message-Id: <20230209111459.1891941-14-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209111459.1891941-1-sashal@kernel.org>
References: <20230209111459.1891941-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tanmay Bhushan <007047221b@gmail.com>

[ Upstream commit 6b04456e248761cf68f562f2fd7c04e591fcac94 ]

ifcvf_mgmt_dev leaks memory if it is not freed before
returning. Call is made to correct return statement
so memory does not leak. ifcvf_init_hw does not take
care of this so it is needed to do it here.

Signed-off-by: Tanmay Bhushan <007047221b@gmail.com>
Message-Id: <772e9fe133f21fa78fb98a2ebe8969efbbd58e3c.camel@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Acked-by: Zhu Lingshan <lingshan.zhu@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/ifcvf/ifcvf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index f9c0044c6442e..44b29289aa193 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -849,7 +849,7 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	ret = ifcvf_init_hw(vf, pdev);
 	if (ret) {
 		IFCVF_ERR(pdev, "Failed to init IFCVF hw\n");
-		return ret;
+		goto err;
 	}
 
 	for (i = 0; i < vf->nr_vring; i++)
-- 
2.39.0

