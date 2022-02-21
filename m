Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFB044BE6BD
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352401AbiBUKEO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 05:04:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353504AbiBUJ53 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:57:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 231D1F20;
        Mon, 21 Feb 2022 01:26:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB9C0B80EB9;
        Mon, 21 Feb 2022 09:26:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00ECDC340E9;
        Mon, 21 Feb 2022 09:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435591;
        bh=3klJNZS5cTv0/+dhcZrqlbPKPKUl1hoZQNAt892OVZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z1gAxmVCQiWhvSx9MtGMjMfX6GJFWy97nKK0P677n3QlCw9dwvs+Nt1gWnOksFl/M
         tXzO6TyKhsiQt7EbXOhPoNHU6X8r/ScVtqW/CzNvxNxggGtA4Of5/nw7q4tQ1rpf4l
         p2LQg9/NsqWYYZ2KNb/X0ba0Ef3H9mhh44Z+nb4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sanjay R Mehta <sanju.mehta@amd.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.16 185/227] dmaengine: ptdma: Fix the error handling path in pt_core_init()
Date:   Mon, 21 Feb 2022 09:50:04 +0100
Message-Id: <20220221084940.967470358@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 3c62fd3406e0b2277c76a6984d3979c7f3f1d129 upstream.

In order to free resources correctly in the error handling path of
pt_core_init(), 2 goto's have to be switched. Otherwise, some resources
will leak and we will try to release things that have not been allocated
yet.

Also move a dev_err() to a place where it is more meaningful.

Fixes: fa5d823b16a9 ("dmaengine: ptdma: Initial driver for the AMD PTDMA")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Sanjay R Mehta <sanju.mehta@amd.com>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/41a963a35173f89c874f5c44df5530dc09fea8da.1644044244.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/ptdma/ptdma-dev.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/drivers/dma/ptdma/ptdma-dev.c
+++ b/drivers/dma/ptdma/ptdma-dev.c
@@ -207,7 +207,7 @@ int pt_core_init(struct pt_device *pt)
 	if (!cmd_q->qbase) {
 		dev_err(dev, "unable to allocate command queue\n");
 		ret = -ENOMEM;
-		goto e_dma_alloc;
+		goto e_destroy_pool;
 	}
 
 	cmd_q->qidx = 0;
@@ -229,8 +229,10 @@ int pt_core_init(struct pt_device *pt)
 
 	/* Request an irq */
 	ret = request_irq(pt->pt_irq, pt_core_irq_handler, 0, dev_name(pt->dev), pt);
-	if (ret)
-		goto e_pool;
+	if (ret) {
+		dev_err(dev, "unable to allocate an IRQ\n");
+		goto e_free_dma;
+	}
 
 	/* Update the device registers with queue information. */
 	cmd_q->qcontrol &= ~CMD_Q_SIZE;
@@ -250,21 +252,20 @@ int pt_core_init(struct pt_device *pt)
 	/* Register the DMA engine support */
 	ret = pt_dmaengine_register(pt);
 	if (ret)
-		goto e_dmaengine;
+		goto e_free_irq;
 
 	/* Set up debugfs entries */
 	ptdma_debugfs_setup(pt);
 
 	return 0;
 
-e_dmaengine:
+e_free_irq:
 	free_irq(pt->pt_irq, pt);
 
-e_dma_alloc:
+e_free_dma:
 	dma_free_coherent(dev, cmd_q->qsize, cmd_q->qbase, cmd_q->qbase_dma);
 
-e_pool:
-	dev_err(dev, "unable to allocate an IRQ\n");
+e_destroy_pool:
 	dma_pool_destroy(pt->cmd_q.dma_pool);
 
 	return ret;


