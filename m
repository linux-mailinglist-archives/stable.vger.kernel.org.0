Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB80856F9D1
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbiGKJJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbiGKJIx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:08:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB31C237D7;
        Mon, 11 Jul 2022 02:07:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 701CCB80E7A;
        Mon, 11 Jul 2022 09:07:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A17C341C0;
        Mon, 11 Jul 2022 09:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530474;
        bh=eAlf2ThEJ0oh3s9MfqamQLqIhi0NIAtmAN9WqohRE7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LitSIO2iQuiK8VsBtaD2VuAEkrxruJng/Op+1h9tOlEZ7zJel2LNKeOKwavPXJMOF
         IM7XD3u+mtzsjM8dMgDeZpE+hxg+DL+LEWFWwdl8AdiV6KPRKEFCACQO4wv236jT0q
         7HEhh6QJ0R5TJ5Cy+0+hiatIZysYlm7JrDG6TNvs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 4.14 17/17] dmaengine: ti: Add missing put_device in ti_dra7_xbar_route_allocate
Date:   Mon, 11 Jul 2022 11:06:42 +0200
Message-Id: <20220711090536.776114629@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090536.245939953@linuxfoundation.org>
References: <20220711090536.245939953@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

commit 615a4bfc426e11dba05c2cf343f9ac752fb381d2 upstream.

of_find_device_by_node() takes reference, we should use put_device()
to release it when not need anymore.

Fixes: a074ae38f859 ("dmaengine: Add driver for TI DMA crossbar on DRA7x")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Link: https://lore.kernel.org/r/20220605042723.17668-1-linmq006@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/ti-dma-crossbar.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/dma/ti-dma-crossbar.c
+++ b/drivers/dma/ti-dma-crossbar.c
@@ -251,6 +251,7 @@ static void *ti_dra7_xbar_route_allocate
 	if (dma_spec->args[0] >= xbar->xbar_requests) {
 		dev_err(&pdev->dev, "Invalid XBAR request number: %d\n",
 			dma_spec->args[0]);
+		put_device(&pdev->dev);
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -258,12 +259,14 @@ static void *ti_dra7_xbar_route_allocate
 	dma_spec->np = of_parse_phandle(ofdma->of_node, "dma-masters", 0);
 	if (!dma_spec->np) {
 		dev_err(&pdev->dev, "Can't get DMA master\n");
+		put_device(&pdev->dev);
 		return ERR_PTR(-EINVAL);
 	}
 
 	map = kzalloc(sizeof(*map), GFP_KERNEL);
 	if (!map) {
 		of_node_put(dma_spec->np);
+		put_device(&pdev->dev);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -275,6 +278,7 @@ static void *ti_dra7_xbar_route_allocate
 		dev_err(&pdev->dev, "Run out of free DMA requests\n");
 		kfree(map);
 		of_node_put(dma_spec->np);
+		put_device(&pdev->dev);
 		return ERR_PTR(-ENOMEM);
 	}
 	set_bit(map->xbar_out, xbar->dma_inuse);


