Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6951062802F
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237664AbiKNNDm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:03:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237737AbiKNNDl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:03:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16DE4275D4
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:03:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8A746117E
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:03:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D1EC433C1;
        Mon, 14 Nov 2022 13:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431020;
        bh=So4KTSjvUEcYg2qnLK1G4EkNRdS8THM5K746TjcZe/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ECfoINibQoi5o0yAAbYdOYPGK4HI5gqHlfApEejkwFAb2Gv1dxOKuBXc/a4j8Xl/7
         bM75fHQxA5RtCNJzXjOBxm13WTPakYvgDyGASVdhUEt4VumS3gc8UE9PnIxXMxJuMC
         2fkpFz9k464zyuE2+LtI0WfzJnjRb6B7IVmP4mkA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 069/190] dmaengine: ti: k3-udma-glue: fix memory leak when register device fail
Date:   Mon, 14 Nov 2022 13:44:53 +0100
Message-Id: <20221114124501.719268667@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit ac2b9f34f02052709aea7b34bb2a165e1853eb41 ]

If device_register() fails, it should call put_device() to give
up reference, the name allocated in dev_set_name() can be freed
in callback function kobject_cleanup().

Fixes: 5b65781d06ea ("dmaengine: ti: k3-udma-glue: Add support for K3 PKTDMA")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Link: https://lore.kernel.org/r/20221020062827.2914148-1-yangyingliang@huawei.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti/k3-udma-glue.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dma/ti/k3-udma-glue.c b/drivers/dma/ti/k3-udma-glue.c
index 4fdd9f06b723..4f1aeb81e9c7 100644
--- a/drivers/dma/ti/k3-udma-glue.c
+++ b/drivers/dma/ti/k3-udma-glue.c
@@ -299,6 +299,7 @@ struct k3_udma_glue_tx_channel *k3_udma_glue_request_tx_chn(struct device *dev,
 	ret = device_register(&tx_chn->common.chan_dev);
 	if (ret) {
 		dev_err(dev, "Channel Device registration failed %d\n", ret);
+		put_device(&tx_chn->common.chan_dev);
 		tx_chn->common.chan_dev.parent = NULL;
 		goto err;
 	}
@@ -917,6 +918,7 @@ k3_udma_glue_request_rx_chn_priv(struct device *dev, const char *name,
 	ret = device_register(&rx_chn->common.chan_dev);
 	if (ret) {
 		dev_err(dev, "Channel Device registration failed %d\n", ret);
+		put_device(&rx_chn->common.chan_dev);
 		rx_chn->common.chan_dev.parent = NULL;
 		goto err;
 	}
@@ -1048,6 +1050,7 @@ k3_udma_glue_request_remote_rx_chn(struct device *dev, const char *name,
 	ret = device_register(&rx_chn->common.chan_dev);
 	if (ret) {
 		dev_err(dev, "Channel Device registration failed %d\n", ret);
+		put_device(&rx_chn->common.chan_dev);
 		rx_chn->common.chan_dev.parent = NULL;
 		goto err;
 	}
-- 
2.35.1



